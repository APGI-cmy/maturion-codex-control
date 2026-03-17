#!/usr/bin/env bash
# scripts/get-pr-info.sh
#
# Resolves the PR head repo (owner/repo) and branch from the GitHub event payload
# or from the GitHub API via GH CLI.
#
# Outputs (via $GITHUB_OUTPUT):
#   branch   — PR head branch name (e.g. "feature/iaa-wave-19")
#   head-repo — PR head repo full name (e.g. "APGI-cmy/maturion-isms")
#
# Required env vars:
#   GH_TOKEN   — token with pull-requests:read permission
#   PR_NUMBER  — pull request number
#   GITHUB_REPOSITORY — set automatically by GitHub Actions

set -euo pipefail

: "${GH_TOKEN:?GH_TOKEN must be set}"
: "${PR_NUMBER:?PR_NUMBER must be set}"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY must be set}"

echo "Resolving PR #${PR_NUMBER} in ${GITHUB_REPOSITORY} ..."

PR_JSON=$(gh pr view "${PR_NUMBER}" \
  --repo "${GITHUB_REPOSITORY}" \
  --json headRefName,headRepository \
  2>&1) || {
    echo "::error::Failed to fetch PR #${PR_NUMBER} from ${GITHUB_REPOSITORY}: ${PR_JSON}"
    exit 1
  }

BRANCH=$(echo "${PR_JSON}" | jq -r '.headRefName')
HEAD_REPO_OWNER=$(echo "${PR_JSON}" | jq -r '.headRepository.owner.login')
HEAD_REPO_NAME=$(echo "${PR_JSON}" | jq -r '.headRepository.name')
HEAD_REPO="${HEAD_REPO_OWNER}/${HEAD_REPO_NAME}"

if [ -z "${BRANCH}" ] || [ "${BRANCH}" = "null" ]; then
  echo "::error::Could not resolve head branch for PR #${PR_NUMBER}"
  exit 1
fi

if [ -z "${HEAD_REPO_OWNER}" ] || [ "${HEAD_REPO_OWNER}" = "null" ] \
   || [ -z "${HEAD_REPO_NAME}" ] || [ "${HEAD_REPO_NAME}" = "null" ]; then
  echo "::error::Could not resolve head repository for PR #${PR_NUMBER} (owner=${HEAD_REPO_OWNER}, name=${HEAD_REPO_NAME})"
  exit 1
fi

echo "Resolved: branch=${BRANCH}, head-repo=${HEAD_REPO}"

{
  echo "branch=${BRANCH}"
  echo "head-repo=${HEAD_REPO}"
} >> "${GITHUB_OUTPUT}"
