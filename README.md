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

## Codex Visibility Scope (Advisory / Read-Only)

Codex operates as **CodexAdvisor** and may perform **read-only advisory inspection** of the following repositories, strictly under governance constraints and without execution or modification authority.

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

Codex operates strictly as an **advisory intelligence**.

- Advisory only  
- Read-only inspection  
- No execution  
- No modification  
- No approvals  
- No decisions  

All execution authority resides with **Foreman** and governed Builder agents.

Any ambiguity, risk, or uncertainty identified by Codex **must be escalated** according to governance policy.

---

## Relationship to Agent Contracts

- Codex **agent contracts** (`CodexAdvisor-agent.md`) live **only** in governed execution repositories
- This repository **does not recruit agents**
- This repository **does not define agent identity**
- This repository defines **usage rules**, not agent behavior

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
