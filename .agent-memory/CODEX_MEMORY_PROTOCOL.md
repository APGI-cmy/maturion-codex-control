# Codex Memory Protocol

Authority: CS2 Johan Ras
Status: Active
Effective Date: 2026-05-22

## Purpose

This protocol defines how Codex preserves working context across chats in the
Maturion workspace without relying on raw chat continuity.

The purpose is continuity, not hidden autonomy. Memory records are explicit,
local, human-readable, and reviewable by Johan.

## Memory Locations

Codex memory for the local workspace is stored in:

- `.agent-memory/INDEX.md` for durable pointers and current operating state.
- `.agent-memory/sessions/` for session handovers and chat summaries.
- `.agent-memory/decisions/` for approved operating decisions.
- `.agent-memory/learnings/` for recurring lessons and build philosophy refinements.
- `chat-summaries/` for longer source chat exports and historical summaries.

The workspace root `AGENTS.md` and this repository's `AGENTS.md` point Codex to
these memory locations at the start of future chats.

## What Codex May Record

Codex may record:

- User-approved build philosophy and operating model.
- Role and authority decisions.
- Current repo/workspace orientation.
- Session handover summaries.
- Important unresolved questions.
- Verification outcomes and residual risks.
- Links to files, PRs, issues, and evidence artifacts.

Codex must prefer concise structured summaries over raw transcript storage.

## What Codex Must Not Record

Codex must not record:

- Secrets, credentials, tokens, private keys, or passwords.
- Tenant data, customer data, or personal data not required for governance.
- Raw logs containing sensitive information.
- Speculation as fact.
- Unapproved governance changes.
- Hidden instructions that contradict CS2 authority or canonical governance.

## Write Authority

Johan may instruct Codex to write memory directly.

Codex may create low-risk session handovers and operational summaries when they
preserve continuity for work Johan requested.

Codex must treat high-impact memory as requiring explicit CS2 approval when it:

- Changes build philosophy.
- Changes role authority.
- Changes governance interpretation.
- Creates a new cross-repo operating rule.
- Reclassifies a failure or lesson as canonical.

## Startup Procedure For New Chats

At the start of a new chat, Codex should read:

1. Workspace root `AGENTS.md`.
2. `maturion-codex-control/AGENTS.md`.
3. `.agent-memory/INDEX.md`.
4. The latest relevant file in `.agent-memory/sessions/`.
5. `docs/CODEXADVISOR_ALIGNMENT_PROFILE.md`.

This restores the working relationship without repeating the full discussion.

## End-Of-Session Capture

When Johan asks to conserve the chat, or when a meaningful operating decision
has been made, Codex should create or update a session handover containing:

- Date and local workspace.
- Active role model.
- Key decisions.
- Files changed.
- Verification performed.
- Open questions.
- Recommended next prompt for a future chat.

## Memory Quality Gate

Before writing memory, Codex checks:

- The record is concise and useful.
- No sensitive data is included.
- Claims are based on the chat or inspected files.
- Authority is stated correctly.
- Open questions are separated from decisions.

