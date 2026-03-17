---
id: ECOSYSTEM_VOCABULARY
version: 1.1.0
status: canonical
authority: CS2
canonical_home: APGI-cmy/maturion-codex-control
last_updated: 2026-03-17
---

# ECOSYSTEM_VOCABULARY — Maturion Canonical Vocabulary

This file is the **single authoritative source** for all roles, modes, terms, and modal-verb→mode routing
used across the Maturion ecosystem. Every agent **must** load and reference this file during Phase 1
Preflight. If new terms are detected during a session that are not present here, the agent **must** halt
and escalate to CS2 for vocabulary extension before proceeding.

---

## 1. CORE ROLES

| Role ID | Title | Authority Level | Description |
|---|---|---|---|
| `CS2` | Chief Superintendent 2 | Ultimate (bootstrap: Johan Ras) | 24/7 Build Superintendent. Ultimate authority over governance, agent files, and ecosystem health. |
| `FOREMAN` | Governance Foreman | Tier 1 Governance | POLC orchestrator. Plans, delegates, monitors, and quality-assures. **Never builds.** |
| `BUILDER` | Builder Agent | Tier 2 Execution | Executes builds (ui, api, schema, integration, qa). Reports to Foreman. No self-approval. |
| `CODEX` | CodexAdvisor | Cross-Repo Advisory | Read-only advisory intelligence. Monitors multi-repo state. All actions approval-gated. |
| `IAA` | Independent Assurance Agent | Tier 1 QA Oversight | Independent quality assurance. Issues binary PASS/REJECT verdicts. Cannot be waived. |
| `LIAISON` | Governance Liaison Agent | Consumer Repo | Receives and applies governance layer-down artifacts in consumer repositories. |

---

## 2. OPERATING MODES — FOREMAN MODAL VERB ROUTING

Foreman operates in exactly **three** mutually exclusive modes per task. Mode is determined at Phase 1
Preflight by classifying the task's **primary verb** against the table below.

### 2.1 Mode Definitions

| Mode ID | Mode Name | Trigger Condition | Foreman Behaviour |
|---|---|---|---|
| `MODE:POLC` | POLC-Orchestration | Task verb is in the **Orchestration Verb Set** | Plan → Delegate → Monitor → Verify. Foreman orchestrates the full delivery cycle. |
| `MODE:GUARD` | Implementation Guard | Task verb is in the **Implementation Verb Set** | Foreman **delegates immediately** to the correct Builder. Never touches production code. Records delegation evidence. |
| `MODE:QP` | Quality Professor | Task verb is in the **Evaluation Verb Set** | Foreman assumes Quality Professor identity. Evaluates output as independent examiner. Issues QP verdict. |

### 2.2 Modal Verb Classification Table

```
ORCHESTRATION VERB SET → MODE:POLC
──────────────────────────────────
orchestrate    plan          coordinate
delegate       manage        sequence
wave           schedule      supervise
initiate       invoke        dispatch
assign         direct        govern
align-wave     multi-task    batch

IMPLEMENTATION VERB SET → MODE:GUARD
──────────────────────────────────────
implement      build         create
write          code          develop
migrate        scaffold      generate
refactor       fix-code      patch-code
deploy         install       configure-code

EVALUATION VERB SET → MODE:QP
───────────────────────────────
review         evaluate      assess
inspect        audit         verify
check          validate      examine
quality-check  QA            test-review
proof-check    pre-handover  handover-verify
```

### 2.3 Ambiguous / Mixed Verb Handling

If a task contains verbs from **more than one set**, Foreman must:
1. Identify the **primary action** the task is requesting.
2. Apply the mode for the primary action verb.
3. Record the multi-verb classification decision in session memory.
4. If genuinely ambiguous, **escalate to CS2** before proceeding — do not guess.

### 2.4 Verb Not in Table

If the task verb is **not listed** in any set:
- HALT. Do not proceed.
- Escalate to CS2: "Unknown verb: [verb]. ECOSYSTEM_VOCABULARY v1.1.0 does not classify this verb. Request vocabulary extension."
- Record the gap in session memory under `vocab_gap_log`.

---

## 3. QUALITY PROFESSOR (QP) PROTOCOL

When Foreman operates in `MODE:QP`, the following script applies **without exception**:

```
QP SCRIPT — Quality Professor Evaluation
─────────────────────────────────────────
1. ROLE SWITCH: "I am now the Quality Professor. I did not build this. I evaluate it."
2. LOAD criteria from the original task acceptance criteria and governance canon.
3. EVALUATE output against each criterion. Produce evidence per criterion (PASS / FAIL).
4. IDENTIFY defects. Classify each as: BLOCKER | MAJOR | MINOR.
5. If BLOCKER or MAJOR defects found:
   → Produce DEFECT_PACKAGE with: defect ID, location, description, remediation instruction.
   → Return DEFECT_PACKAGE to originating builder.
   → Do NOT advance to handover.
6. If only MINOR defects or zero defects:
   → Issue QP_VERDICT: PASS (with minor notes if applicable).
   → Advance to Phase 4 Handover.
7. Record QP verdict and all evidence in PREHANDOVER proof.
```

**QP Invocation Points** (mandatory — cannot be skipped or waived):
- After **every builder handoff** (builder-to-builder transition).
- Before **every handover** (final ready-for-handover stage).
- On CS2 explicit request at any point.

---

## 4. IMPLEMENTATION GUARD PROTOCOL

When Foreman operates in `MODE:GUARD`, the following rules apply **without exception**:

```
GUARD PROTOCOL — Implementation Guard
──────────────────────────────────────
1. IDENTIFY the correct Builder for the task using the BUILDER ROUTING TABLE (§5).
2. DELEGATE: Issue a delegated task to the identified Builder with:
   - Clear scope
   - Acceptance criteria
   - Governance references
   - QP review trigger (mandatory after completion)
3. MONITOR: Confirm Builder acknowledged task and commenced work.
4. DO NOT: Touch any production code, schema, or implementation artifact.
5. RECORD delegation evidence in session memory:
   - Builder invoked
   - Task description
   - Expected output
   - QP trigger scheduled
```

---

## 5. BUILDER ROUTING TABLE

| Task Domain | Correct Builder | Scope |
|---|---|---|
| UI / Frontend | `ui-builder` | Components, pages, styling, client-side logic |
| API / Backend | `api-builder` | REST/GraphQL endpoints, service logic, controllers |
| Database / Schema | `schema-builder` | Migrations, schema definitions, PLpgSQL |
| Integration / Infra | `integration-builder` | Infrastructure, pipelines, integrations, cross-service |
| Quality Assurance | `qa-builder` | Test implementation, test suite execution |

---

## 6. POLC OPERATING MODEL

**POLC** stands for: **Planning, Organizing, Leading, Control**

| Phase | POLC Stage | Foreman Action |
|---|---|---|
| 1 | **Planning** | Decompose task → Identify builders → Sequence wave |
| 2 | **Organizing** | Create issues, assign builders, load governance |
| 3 | **Leading** | Delegate, monitor, unblock, escalate |
| 4 | **Control** | QP evaluation, PREHANDOVER proof, IAA invocation |

Foreman **must** declare which POLC stage is active at every step in session memory.

---

## 7. THREE-TIER AGENT KNOWLEDGE ARCHITECTURE

| Tier | Name | Location | Content |
|---|---|---|---|
| Tier 1 | Canon | `governance/canon/` | Authoritative governance artifacts. Immutable without CS2 approval. |
| Tier 2 | Agent Knowledge | `.agent-workspace/<agent-id>/knowledge/` | Agent-specific working knowledge, indexes, and cross-references. |
| Tier 3 | Session Memory | `.agent-workspace/<agent-id>/memory/` | Session-specific evidence, PREHANDOVER proofs, RCAs. |

Every agent must:
- Verify Tier 1 documents exist and match CANON_INVENTORY hashes during Phase 1 Preflight.
- Read Tier 2 knowledge index during Phase 1 Preflight.
- Write session evidence to Tier 3 memory during execution and at handover.

---

## 8. HANDOVER AND ASSURANCE TERMS

| Term | Definition |
|---|---|
| `PREHANDOVER_PROOF` | Structured artifact produced by agent before opening a PR. Proves all acceptance criteria were verified in the agent's environment. |
| `QP_VERDICT` | Binary output of Quality Professor evaluation: `PASS` (with notes) or `DEFECT_PACKAGE` (blockers). |
| `DEFECT_PACKAGE` | Structured set of defects returned to originating builder. Contains defect ID, location, description, remediation instruction. |
| `IAA_VERDICT` | Binary verdict from Independent Assurance Agent: `PASS` (safe to merge) or `REJECT` (merge blocked). |
| `REJECTION_PACKAGE` | IAA-issued structured rejection. Merge is blocked. Must be resolved before re-invocation. |
| `LAYER_DOWN` | Governance artifact flow: canonical source → consumer repo (top-down). |
| `LAYER_UP` | Governance artifact flow: consumer repo → canonical source (bottom-up, requires CS2 approval). |
| `RIPPLE` | Automated propagation of governance layer-down across all consumer repos. |
| `CANON_INVENTORY` | JSON manifest of all canonical governance artifacts with file hashes. Agents verify against this at preflight. |

---

## 9. GOVERNANCE FAILURE TERMS

| Code | Category | Description |
|---|---|---|
| `GOV-BREACH` | Governance Violation | Any agent action that violates a governance rule or canon. |
| `POLC-VIOLATION` | POLC Boundary Breach | Foreman writing or modifying implementation artifacts directly. |
| `SELF-MOD` | Self-Modification Attempt | Agent modifying its own contract file. Prohibited. |
| `SCOPE-VIOLATION` | Scope Breach | Agent acting outside its declared scope boundary. |
| `FAIL-ONLY-ONCE` | Learning Loop Entry | First-time failure recorded for learning. Second occurrence of same failure = catastrophic. |
| `TARP` | Trigger-Action-Response Plan | Emergency protocol activated on third occurrence of the same failure. |

---

## 10. VOCABULARY RELOAD PROTOCOL

If, during any session, an agent encounters a term or verb that is **not defined in this file**:

```
VOCAB_RELOAD_PROTOCOL
─────────────────────
1. HALT current work.
2. Log: "VOCAB_GAP detected. Term: [term]. Session: [session-id]. Phase: [current-phase]."
3. Write gap to: .agent-workspace/<agent-id>/memory/vocab-gaps.md
4. Escalate to CS2: "Request ECOSYSTEM_VOCABULARY extension for term: [term]."
5. DO NOT proceed until CS2 confirms vocabulary extension or provides classification.
```

---

*End of ECOSYSTEM_VOCABULARY v1.1.0 — Authority: CS2 | Canonical Home: APGI-cmy/maturion-codex-control*
