# MCP Configuration Template for Copilot / Agent Environments

This directory provides the canonical `.mcp.json` configuration template that governed repos
must adopt to expose `agent_bootstrap` and related orchestration tools to the Copilot Coding
Agent (PR-driven tasks).

---

## What is provided

| File | Purpose |
|---|---|
| `.mcp.json` | Canonical MCP server configuration — copy to governed repo root |

---

## Quick-start adoption (2 steps)

### Step 1 — Copy `.mcp.json` to your governed repo root

```
<your-governed-repo>/
└── .mcp.json          ← copy from this directory
```

The file assumes your MCP server entrypoint is at `mcp-servers/agent-bootstrap/index.js`
relative to the repo root. Adjust `args` if your path differs.

### Step 2 — Ensure dependencies are installed before Copilot runs

The `agent-bootstrap` MCP server requires Node.js and its npm dependencies. Add a pre-flight
step to any workflow that starts the Copilot Coding Agent:

```yaml
- name: Install agent-bootstrap MCP server dependencies
  working-directory: mcp-servers/agent-bootstrap
  run: npm install --prefer-offline
```

Or vendor `node_modules` into the repo to avoid install-time failures in restricted environments.

---

## Tool inventory

After adoption, the following MCP tools will be available to the Copilot Coding Agent:

| Tool | Description | Required by contract |
|---|---|---|
| `agent_bootstrap` | Reads `.github/agents/<agentId>.md` and returns the agent contract | **MANDATORY — Step 0** |
| `agent_bootstrap_list_agents` | Lists all available agent IDs in `.github/agents/` | Strongly recommended |

---

## Environment support matrix

| Environment | `.mcp.json` used | Notes |
|---|---|---|
| Copilot Coding Agent (PR tasks) | ✅ Yes | Copy `.mcp.json` to repo root and install deps |
| Copilot Chat (browser / IDE) | ❌ Not yet | Platform limitation — use fallback protocol |
| GitHub Actions (IAA runner) | ✅ Yes (via composite action) | No `.mcp.json` needed; handled by `iaa-agent-runner.yml` |
| Local development | ✅ Yes (with MCP client) | Install deps; configure MCP client to use `.mcp.json` |

For Copilot Chat environments, see `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md`.

---

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `MCP error -32000: Connection closed` | Server crashes on startup | Run `npm install` in `mcp-servers/agent-bootstrap/` first |
| `MODULE_NOT_FOUND` on startup | Missing `node_modules` | Install or vendor npm deps |
| Tool not listed in agent's available tools | `.mcp.json` not at repo root | Confirm file is at `<repo-root>/.mcp.json` |
| `agent_bootstrap` returns empty content | Agent ID is wrong | Confirm `.github/agents/<agentId>.md` exists in the repo |

---

## References

- `docs/MCP_TOOLING_GAP_ANALYSIS.md` — root-cause analysis and platform configuration
- `runbooks/MCP_COPILOT_FALLBACK_PROTOCOL.md` — fallback ceremony for Chat environments
- `docs/MCP_QA_TRACEABILITY_PATTERN.md` — QA and traceability for all sessions
- `maturion-isms/mcp-servers/agent-bootstrap/index.js` — MCP server implementation

---

_Last updated: 2026-03-17 | Maintained by: Control-plane team_
