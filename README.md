# maturion-codex-control

Overall Codex control-plane and governance guidance repository.

---

## Role of This Repository

This repository is a **Codex control-plane and governance guidance repository**.

It defines **how Codex is used**, **what Codex may observe**, and **how Codex is constrained** within the Maturion ecosystem.

This repository is **normative, not operative**.

### This repository does NOT:
- Execute agents
- Run builds or workflows
- Review or merge PRs
- Act as Foreman or Builder
- Contain runtime logic
- Host execution authority of any kind

### This repository exists solely to:
- Define Codex usage doctrine
- Define escalation rules
- Define task-framing requirements
- Define advisory boundaries
- Ensure Codex operates under Maturion governance

> **Important:**  
> No `.agent` files MUST exist in this repository.

---

## Codex Visibility Scope

Codex operates as **CodexAdvisor** and may inspect the following repositories.
When Johan explicitly requests implementation, Codex may assist with local file
changes while remaining under governance constraints and without approval,
merge, release, or autonomous execution authority.

### Governed Repositories

- **maturion-foreman-governance**  
  Canonical governance, policies, agent schemas, and runbooks  
  https://github.com/MaturionISMS/maturion-foreman-governance

- **maturion-foreman-office-app**  
  Foreman runtime responsible for planning, orchestration, and execution delegation  
  https://github.com/MaturionISMS/maturion-foreman-office-app

- **maturion-codex-control**  
  Codex control-plane and usage governance (this repository)  
  https://github.com/MaturionISMS/maturion-codex-control

- **maturion-copilot-builders**  
  Builder agent definitions and constrained execution logic  
  https://github.com/MaturionISMS/maturion-copilot-builders

- **maturion-isms**  
  Primary monorepo containing shared logic, patterns, and system artifacts  
  https://github.com/MaturionISMS/maturion-isms

- **SlotMaster**  
  Analytical application (domain-specific workload)  
  https://github.com/MaturionISMS/SlotMaster

- **PartPulse**  
  Part distribution application (domain-specific workload)  
  https://github.com/MaturionISMS/PartPulse

- **maturion-local-builder**  
  Local desktop builder environment  
  https://github.com/MaturionISMS/maturion-local-builder

---

## Codex Authority Model

Codex operates as **CodexAdvisor**.

- Advisory by default
- Local implementation support when Johan explicitly requests it
- No autonomous approvals
- No autonomous merge or release decisions
- No protected agent contract changes unless Johan acts as CS2
- No weakening of QA, merge, governance, or evidence gates

All execution authority remains governed by **Foreman**, Builder agents, and CS2
authority. Codex may assist with local repository work, but it does not acquire
Foreman, Builder, governance-liaison, governance-repo-administrator, or CS2
authority.

Any ambiguity, risk, or uncertainty identified by Codex **must be escalated**
according to governance policy before governance-sensitive edits continue.

The CodexAdvisor workspace alignment profile is defined in:

- `docs/CODEXADVISOR_ALIGNMENT_PROFILE.md`
- `docs/JOHAN_WORKING_CONTRACT.md`

CodexAdvisor also follows Johan's one-job assurance pipeline:

`Intent → Specialist Build → QP Review → ECAP Reconciliation → IAA Assurance → CI Confirmation`

The pipeline is risk-scaled. Low-risk work may use a lightweight builder plus QP pass, while
protected-path, governance, workflow, agent, schema, migration, or CI-related work requires
ECAP before IAA unless CS2 grants a waiver.

---

## Relationship to Agent Contracts

- Codex **agent contracts** (`CodexAdvisor-agent.md`) live **only** in governed execution repositories
- This repository **does not recruit agents**
- This repository **does not define agent identity**
- This repository defines **usage rules**, not agent behavior
- Consumer repo `.agent` files are local role bindings, not canonical governance authority

---

## Governance Note

This repository is part of a **proactive, governance-first system** designed to prevent:
- Authority drift
- Implicit execution
- Silent decision-making
- AI overreach

Codex is treated as a **constrained advisor**, not a participant in execution.

---

_End of document_
