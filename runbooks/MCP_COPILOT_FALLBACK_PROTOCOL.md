# MCP Copilot Chat Bootstrap Fallback Protocol

**Document class:** Runbook — fallback ceremony  
**Trigger:** Any Copilot Chat session where MCP `agent_bootstrap` tool is NOT available  
**Status:** Active — mandatory until MCP Chat support is confirmed available

---

## Overview

This runbook defines the mandatory fallback ceremony for governed agents operating in
**GitHub Copilot Chat** (or any environment where MCP tools are unavailable). It replaces the
standard MCP `agent_bootstrap` call with an equivalent manual bootstrap sequence that preserves
governance compliance and session traceability.

See `docs/MCP_TOOLING_GAP_ANALYSIS.md` for root-cause analysis and platform limitations.

---

## When This Protocol Applies

Execute this protocol when **all** of the following are true:

1. The agent is operating in Copilot Chat (not as a PR-assigned Coding Agent).
2. The MCP `agent_bootstrap` tool is not listed in the available tools for the session.
3. The session involves a governed action (any write, review, decision, or execution step).

If operating as a PR-assigned Coding Agent with `.mcp.json` in scope, use the standard MCP
`agent_bootstrap` call instead of this protocol.

---

## Fallback Bootstrap Ceremony (Step-by-Step)

### Step F-0: Acknowledge the Tooling Gap

At the very start of the session, before any other action, state:

```
[GOVERNANCE NOTICE]
MCP tool 'agent_bootstrap' is not available in this environment (Copilot Chat).
Executing fallback bootstrap ceremony per runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md.
Governance exception GOV-EXC-MCP-001 is in force for this session.
```

### Step F-1: Read Agent Contract Manually

Manually read the agent contract file for the active agent:

- File: `.github/agents/<agentId>.md` in the governed repo
- Confirm the file has been read and the agent identity, scope, and prohibitions are understood.

If the file cannot be read (access denied, file missing), **HALT** and escalate:
```
[HALT — GOVERNANCE GATE]
Agent contract file cannot be read: .github/agents/<agentId>.md
Cannot proceed without contract. Escalating to CS2.
```

### Step F-2: Declare Session Identity

State the following at the start of each response or at session start:

```
[SESSION BOOTSTRAP — FALLBACK MODE]
Agent ID:     <agentId>
Contract:     .github/agents/<agentId>.md (read manually)
Session time: <ISO8601 timestamp>
Bootstrap:    FALLBACK (MCP unavailable) — GOV-EXC-MCP-001
Governance:   LIVING_AGENT_SYSTEM | CONSTITUTION.md
```

### Step F-3: Commit Traceability Artifact

At the end of the session, commit (or instruct the human operator to commit) a traceability
artifact to the PR branch or a governance-approved path:

```
.agent-admin/assurance/mcp-fallback-session-<sessionId>.md
```

where `<sessionId>` follows the format `YYYYMMDD-<agentId>-<short-slug>`
(e.g., `20260317-CodexAdvisor-agent-mcp-gap-review`).

The artifact must contain at minimum:
- Session ID (date + agent ID)
- Timestamp
- Agent contract file read (confirmed or not)
- Bootstrap method: FALLBACK
- Governance exception reference: GOV-EXC-MCP-001
- Summary of actions taken
- Human operator who approved session start

See `docs/MCP_QA_TRACEABILITY_PATTERN.md` for the artifact template.

---

## Fallback Decision Tree

```
Session start
    │
    ▼
Is MCP 'agent_bootstrap' available?
    │
    ├── YES → Call agent_bootstrap normally. This protocol does NOT apply.
    │
    └── NO  → Is this a governed action?
                  │
                  ├── NO  → Proceed with caution; no formal ceremony required.
                  │         Record informally if any decisions are made.
                  │
                  └── YES → Execute Steps F-0 through F-3 (this runbook).
                             Commit traceability artifact before session close.
```

---

## Escalation Triggers (HALT conditions)

The following conditions require an immediate HALT and escalation to CS2:

| Condition | Action |
|---|---|
| Agent contract file is missing or inaccessible | HALT — escalate to CS2 |
| Agent contract file content is ambiguous or contradictory | HALT — escalate to CS2 |
| Operator refuses to allow traceability artifact commit | HALT — decline the session |
| Session involves governance constitution modification | HALT — not permitted via Chat |
| Session involves merging to `main` without human approval | HALT — not permitted |

---

## Evidence Preservation

All fallback sessions must produce evidence that is preserved in the governed repo. Evidence must:

1. Be committed to the PR branch (not `main`) or filed under `.agent-admin/assurance/`.
2. Be traceable to the originating session (session ID, timestamp, operator).
3. Reference this runbook and governance exception GOV-EXC-MCP-001.
4. Be reviewed by a human operator before the PR is merged.

---

## Resolution Criteria

This runbook becomes **inactive** when:

- GitHub Copilot Chat confirms first-class MCP server invocation support, AND
- The `agent-bootstrap` MCP server is verified to start successfully in Chat sessions, AND
- A test call to `agent_bootstrap` from Copilot Chat succeeds end-to-end.

When resolved, update `docs/MCP_TOOLING_GAP_ANALYSIS.md` (Section 4.3) and revoke
exception GOV-EXC-MCP-001.

---

## References

- `docs/MCP_TOOLING_GAP_ANALYSIS.md` — root-cause analysis
- `docs/MCP_QA_TRACEABILITY_PATTERN.md` — traceability artifact template
- `governance/CONSTITUTION.md` — non-negotiables
- `ai-usage-policy/ESCALATION_POLICY.md` — escalation rules
- Governance exception: `GOV-EXC-MCP-001`

---

_Last updated: 2026-03-17 | Maintained by: Control-plane team_
