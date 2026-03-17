# MCP Tooling Gap Analysis
## Exposure of `agent_bootstrap` and Orchestration Tools to Copilot Chat / Agent Environments

**Document class:** Platform analysis & governance record  
**Status:** Active — gap confirmed, fallback in force  
**Tracking issue:** MCP Tooling Gap (maturion-codex-control)

---

## 1. Problem Statement

Maturion governance agent contracts (Foreman, IAA) require every governed agent to call the MCP
`agent_bootstrap` tool **as the absolute first action** in every session, before any repo-file
read, issue-body read, or other operation. Failure to do so is a documented governance breach
(`GOV-BREACH-AIMC-W5-002 POLC`).

**The gap:** GitHub Copilot Chat and the Copilot Coding Agent (as of the time of this writing)
do **not** have reliable, first-class access to MCP tools defined in a repo's `.mcp.json`. As a
result, agents operating via Copilot Chat **cannot** call `agent_bootstrap`, `agent_bootstrap_list_agents`,
or related orchestration tools at session start — causing halt/standby scenarios and governance
breach risk.

---

## 2. MCP Tool Inventory

The following tools are defined in the `agent-bootstrap` MCP server
(`maturion-isms/mcp-servers/agent-bootstrap/index.js`):

| Tool name | Purpose | Required by contract |
|---|---|---|
| `agent_bootstrap` | Reads `.github/agents/<agentId>.md` and returns agent contract | **MANDATORY – Step 0** |
| `agent_bootstrap_list_agents` | Lists all available agent IDs in `.github/agents/` | Strongly recommended |

The MCP server is configured via `maturion-isms/.mcp.json`:

```json
{
  "mcpServers": {
    "agent-bootstrap": {
      "type": "stdio",
      "command": "node",
      "args": ["mcp-servers/agent-bootstrap/index.js"]
    }
  }
}
```

---

## 3. Platform Configuration & Limitations

### 3.1 Where MCP tools are available

| Environment | MCP tool access | Notes |
|---|---|---|
| GitHub Copilot Coding Agent (PR-driven tasks) | ✅ Available when `.mcp.json` is present in the repo | Requires npm install in `mcp-servers/agent-bootstrap` |
| GitHub Copilot Chat (browser / IDE) | ❌ Not available — MCP servers are NOT invoked | Platform limitation as of 2026-Q1 |
| GitHub Actions (IAA runner) | ✅ Available via composite action | Uses `templates/agent-bootstrap/action.yml` |
| Local developer environment | ✅ Available if MCP client configured | Developer must install deps and set up client |

### 3.2 Root cause

GitHub Copilot Chat does not spawn MCP server processes defined in `.mcp.json`. Tool invocations
from within a chat session are routed through GitHub's hosted model endpoint, which does not have
a local process execution pathway for stdio-mode MCP servers. This is a **platform-side
constraint**, not a configuration error in the governed repos.

### 3.3 Known failure modes

1. **`MCP error -32000: Connection closed`** — MCP server process crashes on startup due to
   missing `node_modules` (deps not installed). Fix: ensure `npm install` is run in
   `mcp-servers/agent-bootstrap/` as part of CI/pre-flight.
2. **Tool call silently skipped** — Agent proceeds without calling `agent_bootstrap` because the
   tool is not in scope in the chat environment. This is the primary governance breach vector.
3. **MODULE_NOT_FOUND on startup** — MCP SDK or `zod` dependency missing from `node_modules`.
   Fix: vendor dependencies or add install step to workflow.

---

## 4. Mechanism to Expose MCP Tools

### 4.1 Copilot Coding Agent (recommended path)

The Copilot Coding Agent (invoked via PR assignment) **does** support `.mcp.json`. To ensure
`agent_bootstrap` is available:

1. Ensure `maturion-isms/.mcp.json` is present and correctly configured.
2. Ensure `npm install` runs in `mcp-servers/agent-bootstrap/` before the agent starts work
   (add a CI pre-flight step or vendor `node_modules`).
3. The agent contract (`.github/agents/<agentId>.md`) must include an explicit instruction to
   call `agent_bootstrap` as the first action.
4. Use the `iaa-agent-runner.yml` reusable workflow for automated IAA/Foreman runs — this
   bypasses the Copilot Chat limitation entirely.

See `templates/copilot-mcp-config/` in this repo for the canonical `.mcp.json` template and
adoption guide.

### 4.2 Copilot Chat (current limitation)

Because Copilot Chat cannot invoke stdio MCP servers, a **manual fallback ceremony** is required.
Agents operating in Copilot Chat must:

1. Acknowledge the MCP tooling gap explicitly at session start.
2. Execute the **Copilot Chat Bootstrap Fallback Protocol** (see
   `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md`).
3. Record a traceability artifact documenting the fallback execution.

### 4.3 Future platform path

When GitHub releases first-class MCP support for Copilot Chat sessions:

- Enable MCP server connection in Copilot Chat settings (organization/repo level).
- Point to the `agent-bootstrap` server config in `.mcp.json`.
- Remove the fallback ceremony requirement and revert to standard bootstrap protocol.
- Update this document to reflect the resolved gap.

---

## 5. Governance Impact & Exception

Until Copilot Chat gains MCP tool support, the following **governance exception** is in force:

> **Exception GOV-EXC-MCP-001**  
> Agents operating exclusively in Copilot Chat (without Coding Agent PR assignment) are **exempt**
> from the strict MCP `agent_bootstrap` call requirement **if and only if** they execute the full
> Copilot Chat Bootstrap Fallback Protocol (see `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md`) and
> commit a traceability artifact per the QA pattern in `docs/MCP_QA_TRACEABILITY_PATTERN.md`.  
> All other governance obligations remain fully in force.

This exception must be reviewed whenever GitHub updates Copilot Chat's MCP capabilities.

---

## 6. Action Items & Status

| # | Action | Owner | Status |
|---|---|---|---|
| 1 | Publish `.mcp.json` template and adoption guide | Control-plane team | ✅ Done — see `templates/copilot-mcp-config/` |
| 2 | Publish fallback ceremony runbook | Control-plane team | ✅ Done — see `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md` |
| 3 | Publish QA/traceability pattern | Control-plane team | ✅ Done — see `docs/MCP_QA_TRACEABILITY_PATTERN.md` |
| 4 | Add npm install pre-flight to CI for MCP server | maturion-isms team | 📋 Backlog |
| 5 | Monitor GitHub Copilot MCP roadmap for Chat support | Control-plane team | 🔄 Ongoing |
| 6 | Vendor `node_modules` for agent-bootstrap MCP server | maturion-isms team | 📋 Backlog |

---

## 7. References

- `maturion-isms/mcp-servers/agent-bootstrap/index.js` — MCP server implementation
- `maturion-isms/.mcp.json` — MCP server configuration
- `templates/copilot-mcp-config/` — Canonical `.mcp.json` template and adoption guide
- `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md` — Fallback ceremony protocol
- `docs/MCP_QA_TRACEABILITY_PATTERN.md` — QA and traceability pattern
- `templates/agent-bootstrap/` — IAA/Foreman composite action (CI path)
- Foreman/IAA agent contracts — bootstrapping and Step 0 halt triggers
- `GOV-BREACH-AIMC-W5-002 POLC` — governance breach classification for skipped bootstrap

---

_Last updated: 2026-03-17 | Maintained by: Control-plane team_
