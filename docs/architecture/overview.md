# Architecture Overview

## Purpose

This document explains the repository-level architecture of the template. It describes where knowledge and future implementation belong without prescribing an application architecture.

## Repository Architecture

The repository separates durable project knowledge from implementation and supporting material:

```text
.
├── .github/
├── docs/
│   ├── project/
│   ├── architecture/
│   ├── standards/
│   ├── decisions/
│   │   ├── adr/
│   │   └── rfc/
│   ├── ai/
│   ├── reference/
│   └── assets/
├── src/
├── tests/
├── samples/
├── scripts/
├── tools/
├── README.md
└── mk.json
```

Repository convention files at the root define baseline editing, Git, and ignore behavior.

## Main Areas

- `README.md` is the concise repository introduction and navigation entry point.
- `docs/` is the single root for authoritative and detailed project documentation.
- `src/` contains production source code when implementation begins.
- `tests/` contains automated tests.
- `samples/` contains focused usage examples when they add value.
- `scripts/` contains small repository operations that cannot be expressed clearly through existing project tooling.
- `tools/` contains repository-local supporting tools when a demonstrated need exists.
- `.github/` contains GitHub-specific configuration, excluding CI workflows in this foundation.
- `mk.json` provides small, machine-readable template metadata and documentation entry points.

## Dependency Direction

Production code must not depend on tests, samples, scripts, documentation, or repository tools. Tests and samples may depend on public production behavior. Scripts and tools may support repository work but must not become hidden runtime dependencies.

Documentation describes the repository; it does not create a runtime dependency. If an adopting project introduces multiple production components, it must document their allowed dependency direction before cross-component coupling grows.

## Documentation Model

Authoritative and detailed project documentation lives under `docs/`, organized by purpose:

- `project/` defines mission, goals, constraints, and scope.
- `architecture/` describes structural boundaries and dependency decisions.
- `standards/` records shared engineering conventions.
- `decisions/adr/` stores accepted architectural decision records.
- `decisions/rfc/` stores proposals that need discussion before acceptance.
- `ai/` provides stable context and review guidance for AI-assisted work.
- `reference/` holds durable reference material when needed.
- `assets/` holds images and other files used by documentation.

Focused documents are authoritative for their subject. Links should connect related guidance instead of repeating it.

## AI Context Model

AI coding assistants begin with `README.md`, then read the project vision, architecture overview, relevant standards, and task-specific decisions. They must inspect existing code and patterns before editing. The bootstrap guide defines this sequence; the review checklist provides a final consistency check.

## Extension Rules

- Add a file or directory only for a current, explainable need.
- Prefer conventional names and the nearest existing area.
- Keep implementation under `src/` and corresponding verification under `tests/`.
- Record material, durable architecture decisions as ADRs.
- Use an RFC for a proposal that requires discussion and has not been accepted.
- Update affected documentation in the same change as architectural or behavioral changes.
- Avoid root-level documentation directories or parallel sources of project knowledge.

## Trade-offs

The fixed top-level structure improves discoverability but includes placeholder directories before implementation exists. Technology neutrality makes the template broadly reusable but leaves language-specific choices to adopting projects. Documentation-first practices require maintenance effort in exchange for clearer decisions and better onboarding.

## Current Limitations

- No runtime, application architecture, or technology stack is selected.
- No build, test, packaging, release, or deployment process exists.
- No dependencies or implementation examples are included.
- No CI workflows are provided.
- Standards remain intentionally general until an adopting project selects its technologies.
