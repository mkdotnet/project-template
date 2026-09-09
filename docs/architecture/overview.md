# Architecture Overview

## Purpose

This document defines the repository-level architecture of the template. The template owns governance, durable knowledge, AI context, repository assurance, and code-intelligence policy. It does not own application source topology.

## Repository Architecture

```text
.
├── .github/
│   ├── scripts/
│   │   └── validate_repository.py
│   ├── workflows/
│   │   └── repository-validation.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── ai/
│   ├── architecture/
│   ├── decisions/
│   ├── guides/
│   ├── modules/
│   ├── project/
│   ├── reference/
│   ├── standards/
│   └── tooling/
├── implementation/
├── AGENTS.md
├── CLAUDE.md
├── CHANGELOG.md
├── LICENSE
├── README.md
└── mk.json
```

`docs/security/` remains conditional and is created only when verified project requirements justify it. Tool-specific directories such as `.cursor/`, `.claude/`, `.codex/`, active MCP configuration, and `graphify-out/` may appear during project adoption but are not separate sources of project truth.

## Implementation Boundary

`implementation/` is the single physical boundary for the complete product implementation. The generic template intentionally does not define any directory below it.

Depending on the project, its contents may be an ABP Modular Monolith (`main/`, `modules/`, `etc/`), .NET Clean Architecture (`src/`, `tests/`), Android/Gradle project, Python/ML project, Unity project, polyglot layout, microservice workspace, or another deliberate structure.

Place inside `implementation/`, according to the owning framework/project conventions:

- production source and configuration;
- tests and test infrastructure;
- samples that belong to the product implementation;
- implementation-specific tools and scripts;
- solution/workspace/project files and framework metadata;
- language-neutral contracts shared by implementation components;
- implementation deployment/support files required to build, test, run, package, or operate the product.

Do not create generic `src/`, `tests/`, `samples/`, or `tools/` at repository root. Tests should follow the conventions of the code root that owns them; a shared `implementation/tests/` is appropriate only when cross-cutting tests have no more natural owner.

## Portability and Dependency Direction

The implementation boundary should be portable as a product workspace. As far as practical, everything required to restore, build, test, run, and package the product belongs within `implementation/`.

Repository-governance artifacts may inspect or automate the implementation, but the implementation must not require `docs/`, `AGENTS.md`, `CLAUDE.md`, `mk.json`, Graphify output, or repository-validation scripts to function as a product workspace.

```text
Governance / Docs / AI / CI
            │
            └── may inspect and automate ──> implementation/

implementation/
            └── must not depend on governance artifacts for product execution
```

External services, credentials, infrastructure, and environment dependencies remain project concerns; portability does not mean the product has no external runtime dependencies.

## Authority Model

1. Files inside `implementation/` define actual implemented behavior and its framework-owned structure.
2. Tests inside the appropriate implementation areas provide evidence of expected behavior.
3. Focused documentation and decisions explain intent, contracts, state, requirements, and usage.
4. Graphify provides derived structural context over implementation.
5. Optional Sourcegraph provides broader search/context when deliberately adopted.
6. Git history and collaboration records explain historical change context when current evidence is insufficient.

Derived tooling output and green repository validation do not replace exact implementation evidence or semantic review.

## AI Context Architecture

`AGENTS.md` and `CLAUDE.md` route assistants to `docs/ai/bootstrap.md`. The bootstrap identifies `implementation/` from `mk.json`, then loads only the context required for the task. Agents must not infer that source lives in `src/` or that tests live at repository root.

For structural work, Graphify should map the implementation boundary rather than the governance/documentation tree unless a task explicitly requires repository-wide analysis.

## Extension Rules

- The template owns repository governance, not application topology.
- The selected framework, generator, or explicit project ADR owns the structure below `implementation/`.
- Do not reorganize framework-generated implementation merely to match this generic template.
- Add root-level directories only for repository-wide concerns that cannot live under `docs/`, `.github/`, tool-specific config, or `implementation/`.
- Record material durable architecture decisions as ADRs.
- Use RFCs only for proposals that genuinely require discussion.
- Keep project-state and affected documentation current when material behavior or delivery state changes.

## Trade-offs

A single implementation boundary adds one path segment when opening product files, but it removes naming collisions between generic template folders and framework-native layouts. It also makes technology changes and polyglot projects easier to reason about because the repository boundary stays stable while the implementation topology can evolve independently.

## Current Limitations

- The template does not prescribe application architecture, framework, programming language, or implementation topology.
- The generic `implementation/` directory is intentionally empty.
- Application-specific build/test/deployment CI is not provided.
- Graphify is a baseline policy but its graph is generated only after a real implementation exists.
- Sourcegraph remains optional.
