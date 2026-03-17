#!/usr/bin/env bash
# scripts/commit-artifacts.sh
#
# Commits NEW governance ceremony artifact files back to the PR branch.
# Applies strict safety checks before every push.
#
# Safety guardrails (all are enforced; violation causes non-zero exit):
#   1. Never pushes to 'main' or 'master'.
#   2. Only stages files under allowed path prefixes.
#   3. Only stages new (untracked/added) files — never force-overwrites tracked content.
#   4. Fails fast if no new artifacts were produced.
#   5. Never prints or commits the MATURION_BOT_TOKEN.
#
# Required env vars:
#   TARGET_BRANCH  — branch to commit to (must not be main/master)
#   ALLOWED_PATHS  — colon-separated list of allowed path prefixes
#   MATURION_MODE  — agent mode label used in commit message
#   MATURION_PR_NUMBER — PR number used in commit message
#   GH_TOKEN       — token used for git push (set as credential helper)
#
# Optional env vars:
#   GIT_AUTHOR_NAME   — defaults to "Maturion Bot"
#   GIT_AUTHOR_EMAIL  — defaults to "maturion-bot@users.noreply.github.com"

set -euo pipefail

: "${TARGET_BRANCH:?TARGET_BRANCH must be set}"
: "${ALLOWED_PATHS:?ALLOWED_PATHS must be set}"
: "${MATURION_MODE:?MATURION_MODE must be set}"
: "${MATURION_PR_NUMBER:?MATURION_PR_NUMBER must be set}"
: "${GH_TOKEN:?GH_TOKEN must be set}"

GIT_AUTHOR_NAME="${GIT_AUTHOR_NAME:-Maturion Bot}"
GIT_AUTHOR_EMAIL="${GIT_AUTHOR_EMAIL:-maturion-bot@users.noreply.github.com}"

# ── Guard 1: refuse to push to main / master ─────────────────────────────────
if [[ "${TARGET_BRANCH}" == "main" || "${TARGET_BRANCH}" == "master" ]]; then
  echo "::error::commit-artifacts.sh: refusing to push to protected branch '${TARGET_BRANCH}'. Governance artifacts must be committed to a PR feature branch only."
  exit 1
fi

echo "Target branch: ${TARGET_BRANCH}"

# ── Configure git identity ───────────────────────────────────────────────────
git config user.name  "${GIT_AUTHOR_NAME}"
git config user.email "${GIT_AUTHOR_EMAIL}"

# Configure credential helper using a secure token store (token is written to
# a temporary file readable only by this process, never printed to stdout).
_CRED_FILE=$(mktemp)
chmod 600 "${_CRED_FILE}"
REMOTE_URL=$(git remote get-url origin 2>/dev/null || true)
# Derive host from remote URL (handles both https:// and git@ forms)
REMOTE_HOST=$(echo "${REMOTE_URL}" | sed -E 's|^(https?://)?([^/:@]+).*|\2|')
printf 'protocol=https\nhost=%s\nusername=x-access-token\npassword=%s\n' \
  "${REMOTE_HOST}" "${GH_TOKEN}" > "${_CRED_FILE}"
git config credential.helper "store --file=${_CRED_FILE}"
# Ensure the credential file is removed when the script exits
trap 'rm -f "${_CRED_FILE}"' EXIT

# ── Collect new (untracked) files under allowed paths ────────────────────────
IFS=':' read -ra ALLOWED <<< "${ALLOWED_PATHS}"

NEW_FILES=()
while IFS= read -r line; do
  STATUS="${line:0:2}"
  FILEPATH="${line:3}"

  # Only process untracked (??) or newly added (A ) files
  if [[ "${STATUS}" != "??" && "${STATUS}" != "A " ]]; then
    continue
  fi

  # ── Guard 2 + 3: allowed-path filter ─────────────────────────────────────
  ALLOWED_FLAG=false
  for PREFIX in "${ALLOWED[@]}"; do
    if [[ "${FILEPATH}" == "${PREFIX}"* ]]; then
      ALLOWED_FLAG=true
      break
    fi
  done

  if [ "${ALLOWED_FLAG}" = false ]; then
    echo "::error::commit-artifacts.sh: file outside allowed paths: '${FILEPATH}'. Allowed prefixes: ${ALLOWED_PATHS}"
    exit 1
  fi

  NEW_FILES+=("${FILEPATH}")
done < <(git status --porcelain)

# ── Guard 4: fail fast on empty changeset ────────────────────────────────────
if [ ${#NEW_FILES[@]} -eq 0 ]; then
  echo "::error::commit-artifacts.sh: no new artifacts found under allowed paths (${ALLOWED_PATHS}). Agent produced no output."
  exit 1
fi

echo "New artifact files to commit (${#NEW_FILES[@]}):"
for F in "${NEW_FILES[@]}"; do
  echo "  + ${F}"
done

# ── Stage and commit ─────────────────────────────────────────────────────────
for F in "${NEW_FILES[@]}"; do
  git add -- "${F}"
done

COMMIT_MSG="chore(iaa): add ${MATURION_MODE} artifacts for PR #${MATURION_PR_NUMBER} [skip ci]"
git commit -m "${COMMIT_MSG}"

# ── Push to PR branch ────────────────────────────────────────────────────────
git push origin "HEAD:${TARGET_BRANCH}"

echo "artifacts-committed=true" >> "${GITHUB_OUTPUT}"
echo "Successfully committed ${#NEW_FILES[@]} artifact(s) to ${TARGET_BRANCH}."
