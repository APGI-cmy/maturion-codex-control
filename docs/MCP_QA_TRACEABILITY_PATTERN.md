# MCP Session QA and Traceability Pattern

**Document class:** QA pattern & traceability guide  
**Scope:** All governed agent sessions — standard (MCP) and fallback (Chat)  
**Status:** Active

---

## Purpose

This document defines the QA and traceability pattern for governed agent sessions, covering both:

1. **Standard sessions** — Copilot Coding Agent with MCP `agent_bootstrap` available.
2. **Fallback sessions** — Copilot Chat or any environment where MCP tools are unavailable
   (governed by exception `GOV-EXC-MCP-001`; see `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md`).

Every governed session must produce a traceable artifact that can be audited to confirm governance
compliance, bootstrap method, and session outcomes.

---

## Session Classification

| Session type | Bootstrap method | Artifact path |
|---|---|---|
| Standard — MCP available | `agent_bootstrap` tool call | `.agent-admin/assurance/session-<id>.md` |
| Fallback — MCP unavailable | Manual contract read + this pattern | `.agent-admin/assurance/mcp-fallback-session-<id>.md` |
| CI/automated — IAA runner | `iaa-agent-runner.yml` workflow | `.agent-admin/assurance/iaa-<mode>-wave<N>.md` |

---

## Traceability Artifact Template

All sessions must produce an artifact matching this template. Copy and fill in the required fields.

```markdown
# Session Traceability Record

## Session Identity
- **Session ID:**      <YYYYMMDD>-<agentId>-<short-slug>
                      (e.g., `20260317-CodexAdvisor-agent-mcp-gap-review`
                       where `short-slug` is a brief kebab-case description)
- **Agent ID:**        <agentId>
- **Timestamp (UTC):** <ISO8601>
- **Operator:**        <GitHub username of human who initiated / supervised>
- **PR / Issue:**      <link or N/A>

## Bootstrap
- **Method:**         MCP (standard) | FALLBACK (GOV-EXC-MCP-001) | CI-automated
- **MCP tool called:** agent_bootstrap: YES | NO | N/A
- **Contract file:**  .github/agents/<agentId>.md — READ: YES | NO | FAILED
- **Exception ref:**  GOV-EXC-MCP-001 (if fallback) | N/A

## Governance Checks
- [ ] Agent contract read and acknowledged
- [ ] Agent scope confirmed (repos, permissions)
- [ ] Prohibitions confirmed (no self-governance, no silent edits, etc.)
- [ ] CONSTITUTION.md non-negotiables reviewed
- [ ] Session mandate defined

## Actions Taken
<!-- List each governed action. Be specific: file changed, issue created, PR commented, etc. -->
1. 
2. 
3. 

## Approvals
<!-- Record any explicit human approvals received during this session -->
- 

## Outcome
- [ ] ✅ COMPLETE — all mandate items done, artifacts committed
- [ ] ⚠️ PARTIAL — describe what remains
- [ ] ❌ ESCALATED — describe escalation target and reason
- [ ] 🚫 HALTED — describe halt condition

## Evidence
<!-- List files committed or produced as evidence of this session -->
- 

## QA Checklist
- [ ] Traceability artifact committed to PR branch (not `main`)
- [ ] No governance non-negotiables breached
- [ ] No execution without approval (if overseer class)
- [ ] Artifact path under `.agent-admin/assurance/` or `.agent-workspace/`
- [ ] Human operator reviewed artifact before merge

---
Authority: LIVING_AGENT_SYSTEM.md | Pattern: MCP_QA_TRACEABILITY_PATTERN.md
```

---

## QA Validation Checklist (per session)

Before a session's PR is merged, a human reviewer must verify:

| Check | How to verify |
|---|---|
| Bootstrap method is recorded | Artifact `## Bootstrap` section is complete |
| Contract file was read | `Contract file: READ: YES` in artifact |
| Exception reference is present (fallback only) | `Exception ref: GOV-EXC-MCP-001` if MCP unavailable |
| All governed actions are listed | `## Actions Taken` section is non-empty |
| At least one approval is recorded (overseer class) | `## Approvals` section is non-empty |
| Outcome is declared | `## Outcome` checkboxes completed |
| Artifact committed to allowed path | File is under `.agent-admin/assurance/` |
| QA checklist completed | All `## QA Checklist` boxes checked |

---

## Governance Exception Record

The following exception is active for Copilot Chat sessions:

| Exception ID | Scope | Condition | Expiry |
|---|---|---|---|
| GOV-EXC-MCP-001 | Copilot Chat agents | MCP `agent_bootstrap` not available in Chat | Until MCP Chat support confirmed |

Exception conditions:
- Agent must execute the full Fallback Protocol (`runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md`).
- Agent must produce a traceability artifact per this pattern.
- Human operator must review the artifact before merge.

---

## Audit Trail Requirements

All traceability artifacts must be:

1. Committed to the PR branch (not `main` or `master`).
2. Stored under `.agent-admin/assurance/` or `.agent-workspace/`.
3. Referenced in the PR description or a PR comment.
4. Retained for the lifetime of the repo (not deleted after merge).

The `scripts/commit-artifacts.sh` script in `templates/agent-bootstrap/` enforces the path
allowlist and commit safety rules for CI-automated sessions.

---

## References

- `docs/MCP_TOOLING_GAP_ANALYSIS.md` — platform analysis
- `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md` — fallback ceremony
- `governance/CONSTITUTION.md` — non-negotiables
- `templates/agent-bootstrap/scripts/commit-artifacts.sh` — artifact commit enforcement
- Governance exception: `GOV-EXC-MCP-001`

---

_Last updated: 2026-03-17 | Maintained by: Control-plane team_
