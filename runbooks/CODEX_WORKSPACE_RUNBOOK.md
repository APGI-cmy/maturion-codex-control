# Copilot Workspace Runbook (Codex Execution)

## Goal
Use Copilot Workspace as the execution engine, governed by this control repo.

## How to Run a Task
1. Open Copilot Workspace
2. Select target repo(s)
3. Attach/Reference this repo as the operating manual:
   - Read: /governance/CONSTITUTION.md
   - Read: /ai-usage-policy/ESCALATION_POLICY.md
   - Read: /operating-contracts/CHATGPT_OPERATING_CONTRACT.md
4. Provide the task with acceptance criteria and rollback requirement.

## Mandatory Task Prompt Footer
Include this in every task:
- Follow the Codex Control Constitution
- No weakening QA or governance gates
- Provide file list, risks, rollback, and verification steps

## MCP Tool Availability

When running tasks via the **Copilot Coding Agent** (PR-assigned):
- MCP tools (`agent_bootstrap`, etc.) are available if `.mcp.json` is present in the repo root.
- See `templates/copilot-mcp-config/` for the canonical `.mcp.json` template and adoption guide.

When running tasks via **Copilot Chat** (browser/IDE):
- MCP tools are **not** available — a fallback ceremony is required.
- See `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md` for the mandatory fallback protocol.
- See `docs/MCP_TOOLING_GAP_ANALYSIS.md` for the full platform analysis.
- See `docs/MCP_QA_TRACEABILITY_PATTERN.md` for QA and traceability requirements.
