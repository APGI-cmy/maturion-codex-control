# Maturion Agent Bootstrap — Adoption Guide

This directory provides a **reusable bootstrap library** for governed repositories (e.g., `APGI-cmy/maturion-isms`) to run Maturion agents (Foreman v2 + Independent Assurance Agent) via GitHub Actions in a fully automated, non-human-in-the-loop way.

---

## What is provided

| Path | Purpose |
|---|---|
| `action.yml` | Composite action: checks out the PR branch, runs the agent, commits new artifacts back. |
| `scripts/get-pr-info.sh` | Resolves PR head repo and branch from the GitHub event payload. |
| `scripts/commit-artifacts.sh` | Commits **new files only** under allowed paths back to the PR branch (with safety checks). |
| `governed-repo/.github/workflows/maturion-iaa-bootstrap.yml` | Template workflow for governed repos — copy this file into your repo. |
| *(this repo)* `.github/workflows/iaa-agent-runner.yml` | Reusable `workflow_call` workflow that governed repos can call. |

---

## Quick-start adoption (3 steps)

### Step 1 — Copy the template workflow

Copy `governed-repo/.github/workflows/maturion-iaa-bootstrap.yml` into your repo at:

```
.github/workflows/maturion-iaa-bootstrap.yml
```

No other bespoke edits are required for the default setup.

### Step 2 — Add the required secret

In your governed repo's GitHub UI go to  
**Settings → Secrets and variables → Actions** and add:

| Secret name | Value |
|---|---|
| `MATURION_BOT_TOKEN` | A fine-grained PAT (or GitHub App installation token) with `contents: write` permission on the governed repo. |

This token is used to commit governance ceremony artifacts back to PR branches.

### Step 3 — Trigger the agents

Comment the appropriate trigger phrase on any open pull request:

| Phase | Trigger comment | What happens |
|---|---|---|
| Phase 0 — IAA Pre-Brief | `IAA_PRE_BRIEF_PROTOCOL.md §Trigger` | IAA agent runs pre-brief and commits `.agent-admin/assurance/iaa-prebrief-wave<N>.md`. |
| Phase 4.3a/b — Final Audit + Token | `IAA_FINAL_AUDIT_PROTOCOL.md §Trigger` | IAA agent runs final audit and issues token file at `.agent-admin/assurance/iaa-token-session-<ID>.md`. |

---

## Required permissions

The workflow requires the following GitHub Actions permissions on the **governed repo**:

```yaml
permissions:
  contents: write   # to commit artifacts to the PR branch
  pull-requests: read
```

The `MATURION_BOT_TOKEN` secret must carry these same permissions for the target repo.

---

## Artifact paths

All agent output files must be written under one of these allowed paths:

```
.agent-admin/assurance/**
.agent-workspace/**
```

The `commit-artifacts.sh` script enforces this allowlist and will fail fast if an agent attempts to write outside these paths.

---

## Canonical trigger strings

These strings are fixed for governed repos.  They match the literal phrases in the IAA/Foreman contracts and must not be changed:

```
IAA_PRE_BRIEF_PROTOCOL.md §Trigger
IAA_FINAL_AUDIT_PROTOCOL.md §Trigger
```

---

## How artifacts are committed

`scripts/commit-artifacts.sh` applies these guardrails before every commit:

1. **Never pushes to `main`** — aborts if the target branch is `main` or `master`.
2. **Allowed-path filter** — only stages files under `.agent-admin/assurance/` and `.agent-workspace/`.
3. **New files only** — stages only `git status --porcelain` entries marked `??` (untracked) or `A` (added); never overwrites tracked files unless explicitly configured.
4. **Fail-fast on empty changeset** — exits non-zero if no new artifacts were produced, so downstream steps can detect missing output.
5. **No secrets in commits** — the script accepts no secret values as arguments and does not echo the `MATURION_BOT_TOKEN`.

---

## Configuring the agent runner command

The composite action accepts an `agent-command` input so governed repos can specify the exact runtime invocation without modifying shared workflow files:

```yaml
- uses: APGI-cmy/maturion-codex-control/templates/agent-bootstrap@main
  with:
    agent-command: "python -m maturion.iaa --mode pre-brief --pr ${{ env.PR_NUMBER }}"
    maturion-bot-token: ${{ secrets.MATURION_BOT_TOKEN }}
```

If `agent-command` is omitted, the action falls back to the `MATURION_AGENT_COMMAND` environment variable.

---

## Using the reusable workflow (advanced)

Instead of the composite action, governed repos can call the reusable workflow directly:

```yaml
# .github/workflows/maturion-iaa-bootstrap.yml  (in governed repo)
jobs:
  iaa-pre-brief:
    uses: APGI-cmy/maturion-codex-control/.github/workflows/iaa-agent-runner.yml@main
    with:
      mode: pre-brief
      pr-number: ${{ github.event.issue.number }}
    secrets:
      maturion-bot-token: ${{ secrets.MATURION_BOT_TOKEN }}
```

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Workflow does not trigger | Trigger phrase has wrong spacing or casing | Copy the exact phrase from the table above — it is case-sensitive. |
| `commit-artifacts.sh: no new artifacts found` | Agent ran but produced no output files | Check agent logs; ensure agent writes under `.agent-admin/assurance/` or `.agent-workspace/`. |
| `commit-artifacts.sh: refusing to push to main` | PR branch is set to `main` | IAA must run on a feature/GOV branch, not `main`. |
| `403` when pushing artifacts | `MATURION_BOT_TOKEN` missing or lacks `contents: write` | Re-check secret and token scopes (see Step 2). |
| `commit-artifacts.sh: file outside allowed paths` | Agent wrote to an unexpected path | Update agent configuration to write only under `.agent-admin/assurance/` or `.agent-workspace/`. |
