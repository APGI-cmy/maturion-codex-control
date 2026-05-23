# Session Handover — CodexAdvisor Alignment

Authority: CS2 Johan Ras
Date: 2026-05-22
Workspace: `D:\AI_Projects\Foreman true north and Qa files\All repos`
Status: Active handover

## Session Summary

Johan and Codex established Codex's operating relationship in the local Maturion
workspace. Codex is aligned as CodexAdvisor by default, with permission to assist
with local implementation when Johan explicitly requests it.

The working model preserves Maturion governance while accommodating Codex's
ability to build, coordinate specialist roles, run verification, and use
sub-agents for separation of duties where useful.

## Decisions Recorded

- Codex operates as CodexAdvisor by default.
- Johan Ras remains CS2.
- Johan is not a coder and is not expected to review code.
- Johan approves rules, governance changes, intent, and the final visible UI/product outcome.
- The AI workforce owns implementation, evidence, assurance, and technical verification.
- Codex may implement local file changes when explicitly asked.
- Codex does not become Foreman, Builder, governance-liaison, governance-repo-administrator, or CS2.
- Codex may assume named roles when asked, including specialist builder, QP, ECAP, and IAA modes.
- High-risk assurance should use separate sub-agents where independence matters.
- Protected-path, governance, workflow, agent, schema, migration, or CI work requires ECAP before IAA unless CS2 grants a waiver.
- Codex must not silently collapse builder, QP, ECAP, and IAA into a single unlabeled pass.
- 100 percent means 100 percent: no known in-scope defects, no test debt, no test dodging, and no hidden warnings.
- Codex must proactively advise Johan when it sees gaps, risks, contradictions, or improvements.
- Codex must apply CODEX_BUILD_COMPLETION_DEFINITION.md before asking Johan to evaluate a UI or product outcome.

## One-Job Assurance Pipeline

Johan's preferred build philosophy is one-time, fully functional, 100 percent builds.

The agreed pipeline is:

`Intent -> Specialist Build -> QP Review -> ECAP Reconciliation -> IAA Assurance -> CI Confirmation`

Risk scaling:

- Low-risk implementation: builder pass, QP review, practical verification.
- Medium-risk implementation: builder pass, QP review, ECAP summary, practical verification.
- High-risk or protected-path implementation: builder pass, QP review, ECAP, IAA, and CI.

## Files Updated

- `../../AGENTS.md`
- `../AGENTS.md`
- `../README.md`
- `../docs/CODEX_ADVISOR_ROLE.md`
- `../docs/CODEXADVISOR_ALIGNMENT_PROFILE.md`
- `../docs/JOHAN_WORKING_CONTRACT.md`
- `../../maturion-foreman-governance/maturion-foreman-governance/governance/canon/CODEX_BUILD_COMPLETION_DEFINITION.md`
- Consumer repo layer-down copies of `governance/canon/CODEX_BUILD_COMPLETION_DEFINITION.md`
- `.agent-memory/CODEX_MEMORY_PROTOCOL.md`
- `.agent-memory/INDEX.md`
- `.agent-memory/sessions/2026-05-22-codexadvisor-alignment-handover.md`

## Verification Performed

- Confirmed GitHub CLI authentication for account `APGI-cmy`.
- Confirmed canonical governance and consumer `.agent` files are discoverable.
- Confirmed existing ECAP and IAA canon files exist in the workspace.
- Confirmed prohibited draft-marker scan passed for the alignment files.
- Confirmed `git diff --check` passed in `maturion-codex-control`, with only line-ending warnings.

## Open Questions

- Whether Johan wants raw chat exports saved manually in `chat-summaries/` in addition to concise session handovers.
- Whether Codex memory should later be wired into the existing memory fabric runtime or remain Markdown-first for now.
- Whether ECAP and IAA sub-agent usage should be mandatory for all medium-risk jobs or only high-risk jobs.

## Future Chat Bootstrap

At the start of a future chat, instruct Codex:

```text
Load the workspace AGENTS.md and maturion-codex-control/.agent-memory/INDEX.md. Operate as CodexAdvisor under Johan's one-job assurance pipeline.
```
