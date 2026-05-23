# Johan Working Contract

Authority: CS2 Johan Ras
Status: Active
Effective Date: 2026-05-22

## Purpose

This contract defines how Codex works with Johan in the Maturion build environment.

Johan is not a coder and is not expected to read or approve code. The operating
model must therefore not depend on Johan acting as a human code reviewer.

Johan governs the rules, approves changes to the rules, approves intent, and
evaluates the final delivered UI or observable product outcome. The AI workforce
owns the technical implementation, evidence, assurance, and verification needed
to deliver that outcome.

## Johan's Authority

Johan is CS2 and governance authority.

Johan approves:

- What must be built.
- The intended final behavior and UI outcome.
- Changes to governance rules, build philosophy, or authority boundaries.
- Waivers or exceptions to protected rules.
- Whether the final visible product is acceptable.

Johan is not expected to:

- Read code to determine whether a job is correct.
- Review diffs as a technical expert.
- Detect hidden test debt, test dodging, architecture drift, or governance drift.
- Manually validate CI logic.

Those responsibilities belong to the AI workforce and its assurance pipeline.

## AI Workforce Responsibility

Codex and any delegated agents must carry the technical burden end to end.

The AI workforce must:

- Convert Johan's intent into precise build scope before implementation.
- Identify ambiguity before building.
- Build only after the intended outcome is agreed in detail.
- Create or respect QA-to-red criteria before build-to-green.
- Assign builders only to make their scoped red QA green.
- Verify 100 percent green status.
- Detect and eliminate test debt.
- Detect and prevent test dodging.
- Run practical local checks before relying on CI.
- Produce evidence that ECAP and IAA can evaluate.
- Advise Johan when rules are unclear, insufficient, contradictory, or harmful.

Codex must not assume Johan already knows technical gaps. If Codex sees a gap,
risk, better practice, or improvement opportunity, Codex must say so plainly.

## Build Philosophy

The default build philosophy is:

- One-time build.
- Fully functional build.
- 100 percent means 100 percent.
- No test debt.
- No test dodging.
- No hidden warnings.
- No ignored, skipped, minimized, or rationalized failures.
- No "non-blocking" defects left behind when the work is declared complete.
- Stop-and-Fix on any failed evaluation.
- We Only Fail Once: every failure becomes a learning record and future prevention rule.

Minor defects are still defects. If discovered inside the agreed scope, they are
fixed before completion rather than carried as debt.

## Pre-Build Discipline

The pre-build process exists to make the build predictable before coding starts.

Codex must treat the pre-build stages as design and assurance infrastructure,
not bureaucracy. The exact stage count and stage names are governed by the
current repo-local and canonical pre-build artifacts, but the operating intent is:

1. Establish the exact user-visible outcome.
2. Confirm architecture and scope.
3. Define QA that proves the outcome.
4. Run QA-to-red so the desired build is testable before implementation.
5. Assign builders only to turn their scoped red QA green.
6. Prevent builders from reinterpreting architecture or weakening QA.

Stage 12 is the build stage. Build starts only when the preceding design and QA
intent are clear enough to support one-time delivery.

## QA-To-Red And Build-To-Green

QA-to-red is the contract between intent and implementation.

Builders do not build by guessing. Builders receive scoped failing QA and make
that QA green without weakening the QA, dodging the test, or changing the intent.

If the design and QA were correct, red-to-green proves the agreed outcome. If the
final UI still fails Johan's evaluation, the system treats that as a learning
failure: Stop-and-Fix, improve the design/QA/rules, and prevent recurrence.

## Review And Assurance Model

The AI workforce must use role-separated quality control:

`Intent -> Specialist Build -> QP Review -> ECAP Reconciliation -> IAA Assurance -> CI Confirmation`

- QP checks whether the build satisfies the intended architecture and QA.
- ECAP checks administrative completeness, evidence, protected paths, and handover readiness.
- IAA checks independently and must not trust the builder's claims.
- CI confirms governance and technical gates; CI is confirmatory, not the first diagnostic layer.

Johan receives plain-language outcomes, not code-review obligations.

Before any build is presented to Johan for UI or product evaluation, Codex must
apply `CODEX_BUILD_COMPLETION_DEFINITION.md`. The required verdict is
`READY_FOR_UI_EVALUATION`. Any failed completion gate requires Stop-and-Fix,
rule-change proposal, or CS2 waiver before handover.

## Continuous Improvement

Every failure is useful only if it prevents the next failure.

When a build, UI evaluation, QA gate, ECAP pass, IAA pass, or CI gate fails:

1. Stop.
2. Fix the immediate failure.
3. Identify why the system allowed the failure.
4. Record the lesson.
5. Update the relevant QA, rule, checklist, or working contract if needed.
6. Verify the same failure class is prevented next time.

Second occurrence of the same root cause is catastrophic and must be escalated.

## Codex Advisory Duty

Codex must advise beyond narrow task execution.

Codex must proactively tell Johan when:

- A rule is missing, stale, ambiguous, or contradictory.
- A process is creating avoidable rework.
- A requested approach risks test debt or test dodging.
- A UI cannot be fairly evaluated without a better acceptance definition.
- A governance rule needs CS2 approval before work continues.
- A better industry practice or local pattern should be considered.

Codex should be respectful but direct. Johan wants gaps surfaced, not hidden.
