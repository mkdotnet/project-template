# Project Vision

## Mission

Provide a small, reusable repository foundation that helps teams begin and maintain software projects with clear documentation, intentional structure, durable delivery state, and efficient context for people and AI coding assistants.

## Vision

Projects created from this template should remain easy to understand, extend, debug, refactor, review, and maintain as they grow, without inheriting unnecessary runtime technology choices or speculative abstractions.

## Problem Statement

New repositories often begin with inconsistent structure, missing decisions, undocumented assumptions, and tool-specific AI instructions. As projects age, teams can also lose a reliable view of what has been completed, what remains, why a subsystem looks the way it does, and which context an engineer or AI assistant actually needs for a focused change.

## Target Audience

- Teams starting or maintaining a software repository.
- Maintainers who value explicit decisions and documentation-first development.
- Contributors working interchangeably with Codex, Claude Code, Cursor, and human development workflows.
- Long-lived projects that need recoverable architecture, delivery state, developer guidance, and user guidance.

## Goals

- Establish a clear, conventional repository structure.
- Make project intent, architecture, standards, decisions, progress, and capabilities discoverable.
- Provide one canonical AI context contract across supported coding assistants.
- Make Graphify the baseline structural code-intelligence layer for adopting projects.
- Leave an explicit optional place for Sourcegraph when its broader search or cross-repository context is justified.
- Load AI context progressively to reduce unnecessary token use, broad exploration, and speculative redesign.
- Support focused debugging and refactoring months or years after project start.
- Separate durable engineering knowledge from developer instructions and end-user documentation.
- Encourage scoped changes, simple designs, and evidence-based evolution.
- Remain neutral about runtime, language, framework, application architecture, and build tooling.

## Non-Goals

- Provide an SDK, framework, CLI, package, or build system.
- Prescribe a programming language or application architecture.
- Include runtime dependencies, generated application projects, or deployment infrastructure.
- Duplicate vendor documentation or maintain parallel AI rule sets for each assistant.
- Use documentation as a replacement for issue tracking, source code, tests, or Git history.
- Anticipate every directory or abstraction a future project might need.

## Success Criteria

- A new contributor can identify the project's purpose and main guidance quickly.
- After months of development, a maintainer can identify current milestones and capabilities without reconstructing state from commit history.
- AI coding assistants bootstrap from stable entry points and read only task-relevant context.
- Codex, Claude Code, and Cursor operate from the same durable repository knowledge.
- Structural code exploration starts with Graphify and is verified against exact source and tests before changes are made.
- Focused debugging and refactoring can identify subsystem boundaries, callers, contracts, tests, and relevant decisions without reading the whole repository.
- Projects can adopt the template without first removing unwanted runtime technology.
- New structure and dependencies are added only in response to demonstrated needs.

## Constraints

- The template must remain minimal and runtime-technology-neutral.
- Repository guidance must avoid duplicate or contradictory rules.
- AI context must be progressively loaded rather than globally preloaded.
- Graphify is a required adopting-project engineering baseline unless an explicit project decision records an exception.
- Sourcegraph remains optional until a project adopts it deliberately.
- User-facing documentation may use the language appropriate to its audience; engineering documentation should use the project's agreed engineering language.
- Empty directories are preserved only when they communicate intentional structure.
- No runtime dependency, CI workflow, or application implementation is included in the foundation.

## Assumptions

- Adopting projects will replace template metadata and refine project-state documentation.
- Teams will select runtime technology based on project requirements.
- Contributors and AI assistants will read the relevant guidance before making material changes.
- Architecture decisions will be recorded when they become necessary.
- Fine-grained execution tasks will normally live in an issue or project tracker rather than expanding summary status documents indefinitely.

## Risks

- Template guidance may become stale if projects change without updating it.
- Teams may treat suggested directories as mandatory even when unnecessary.
- Excessive documentation could obscure rather than clarify project knowledge.
- Generated code-intelligence data may become stale if project workflows do not refresh it.
- Tool-specific adapter files may drift if they contain copied project rules instead of pointers.
- Generic standards may need careful refinement for a chosen technology.

## Out of Scope

- Product requirements for projects created from the template.
- Runtime implementation and sample applications.
- Package, release, deployment, and operational strategies.
- Organization-specific governance and compliance controls.
- Duplicated vendor-specific AI prompts or generated integration internals.
