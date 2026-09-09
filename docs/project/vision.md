# Project Vision

## Mission

Provide a reusable repository-governance foundation that keeps durable project knowledge and AI collaboration consistent while allowing each software project to preserve its natural implementation structure.

## Vision

Projects created from this template should remain easy to understand, extend, debug, refactor, review, and maintain without inheriting a framework, programming language, source-folder convention, or application architecture from the template itself.

## Problem

Generic repository templates often mix governance with application skeletons. That becomes confusing when real frameworks already own their topology, especially in ABP Modular Monoliths, Android/Gradle projects, Clean Architecture solutions, Python/ML systems, Unity projects, and polyglot repositories. AI assistants can also waste context when they must infer which root actually contains product code.

## Goals

- Keep governance/documentation/AI context technology-neutral.
- Provide one obvious `implementation/` boundary for the complete product workspace.
- Let the selected framework/project own all topology below that boundary.
- Keep implementation portable and independent from governance artifacts for restore/build/test/run/package operations as far as practical.
- Provide one canonical AI context across Codex, Claude Code, and Cursor.
- Use Graphify for implementation-focused structural discovery while verifying exact behavior against source/tests.
- Preserve project state, architecture, decisions, developer guidance, and user guidance over long project lifetimes.
- Add structure and automation only in response to demonstrated needs.

## Non-Goals

- Prescribe .NET, ABP, Android, Python, Unity, or any other runtime/framework.
- Prescribe internal implementation names such as `src`, `tests`, `main`, `modules`, `app`, or `ml`.
- Provide an SDK, CLI, application build system, deployment stack, or sample application.
- Replace source/tests, issue tracking, or Git history with documentation.

## Success Criteria

- A developer can identify the complete product workspace immediately.
- A framework-generated project can be placed under `implementation/` without being reorganized to satisfy the template.
- AI assistants discover implementation location from stable metadata instead of guessing source roots.
- A polyglot project can add multiple technology roots inside implementation without changing repository governance.
- After months of work, current architecture, delivery state, and relevant decisions are recoverable without scanning the whole repository.

## Constraints

- `docs/` remains the single authoritative detailed documentation root.
- `implementation/` remains the default product boundary; deviations require a deliberate project decision.
- Governance must not become a runtime/build dependency of implementation.
- Graphify is the baseline code-intelligence layer unless explicitly excepted; Sourcegraph remains optional.
- AI context is progressively loaded rather than globally preloaded.

## Risks

- Some tools may assume their project file is at repository root and need to be opened explicitly from inside `implementation/`.
- Teams may accidentally place product support files back at repository root, weakening portability.
- Documentation or generated code-intelligence data can become stale without maintenance.
- Over-documentation can obscure rather than clarify project knowledge.
