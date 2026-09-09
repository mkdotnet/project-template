# Architecture Overview

## Purpose

This document defines the repository-level architecture of the template. The template owns governance, durable knowledge, AI context, repository assurance, lifecycle tooling, and code-intelligence policy. It does not own application source topology.

## Repository Architecture

```text
.
├── .github/
│   ├── scripts/
│   │   └── validate_repository.py
│   ├── workflows/
│   │   └── repository-validation.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── .mk/
│   └── toolkit/                # canonical distributable lifecycle toolkit source
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
├── implementation/             # complete product workspace; internal topology is project-defined
├── Initialize.ps1              # guided retrofit/bootstrap
├── Initialize-MKProject.cmd    # Windows beginner launcher
├── AGENTS.md
├── CLAUDE.md
├── CHANGELOG.md
├── LICENSE
├── README.md
└── mk.json
```

`docs/security/` remains conditional. Tool-specific roots such as `.cursor/`, `.claude/`, `.codex/`, active MCP configuration, and `graphify-out/` may appear during adoption but are not separate sources of project truth.

In an adopting repository, the toolkit is normally installed under `.mk/scripts/` and writes local reports under `.mk/reports/`. Those installed scripts are repository lifecycle tooling, not product implementation.

## Implementation Boundary

`implementation/` is the single physical boundary for the complete product implementation. The generic template intentionally does not define any directory below it.

Depending on the project, its contents may be an ABP Modular Monolith (`main/`, `modules/`, `etc/`), .NET Clean Architecture (`src/`, `tests/`), Android/Gradle project, Python/ML project, Unity project, polyglot layout, microservice workspace, or another deliberate structure.

Place inside the implementation boundary, according to framework/project conventions:

- production source and configuration;
- tests and test infrastructure;
- product samples;
- implementation-specific tools/scripts;
- solution/workspace/project files and framework metadata;
- language-neutral contracts;
- implementation deployment/support files required to restore, build, test, run, package, or operate the product.

Do not create generic root `src/`, `tests/`, `samples/`, or `tools/` merely because the template exists.

## Governance and Bootstrap Boundary

Repository-level Git metadata, durable docs, AI entry points, repository CI, Graphify output, assistant configuration, and MK lifecycle tooling remain outside `implementation/`.

The guided bootstrap may move ordinary existing framework/build/product files into `implementation/`, but must not blindly move Git submodules, likely secret-bearing environment/key files, symlinks/reparse points, destination collisions, or ambiguous project documentation. Those require manual review.

The implementation should remain portable as a product workspace. Governance may inspect or automate implementation, but implementation must not require `docs/`, AI files, `mk.json`, Graphify output, or MK repository-validation/lifecycle scripts to restore, build, test, run, or package the product.

## Authority Model

1. Files inside the implementation boundary define actual implemented behavior and framework-owned structure.
2. Tests inside the appropriate implementation areas provide evidence of expected behavior.
3. Focused docs/decisions explain intent, contracts, state, requirements, and usage.
4. Graphify provides derived structural context over implementation.
5. Optional Sourcegraph provides broader search/context when deliberately adopted.
6. Git history and collaboration records explain historical context when current evidence is insufficient.

Derived tooling output and green repository validation do not replace exact implementation evidence or semantic review.

## AI Context Architecture

`AGENTS.md` and `CLAUDE.md` route assistants to `docs/ai/bootstrap.md`. The bootstrap reads `mk.json` to discover the implementation boundary and relevant repository entry points rather than assuming `src/` or root-level tests.

For structural work, Graphify should map the implementation boundary rather than the governance/documentation tree unless a task explicitly needs repository-wide analysis.

## Lifecycle Tooling

The canonical lifecycle toolkit source lives in `.mk/toolkit/`. `Initialize.ps1` downloads the selected upstream template ref and installs runnable tooling into an adopting project's `.mk/scripts/`.

The lifecycle provides safe retrofit, Graphify/MCP setup, start-of-work, health, completion, and template-sync checks. Build/test commands remain technology-specific and are only run when the project defines them explicitly in `mk.json`.

## Extension Rules

- The template owns repository governance, not application topology.
- The selected framework/generator or explicit project ADR owns structure below `implementation/`.
- Do not reorganize framework-generated implementation merely to match generic template examples.
- Add root-level directories only for repository-wide concerns that cannot live under `docs/`, `.github/`, `.mk/`, tool-specific config, or `implementation/`.
- Record material architecture decisions as ADRs.
- Keep project state/documentation current when material behavior or delivery state changes.

## Trade-offs and Limitations

The additional implementation path segment and lifecycle tooling add small repository overhead, but remove collisions with framework-native roots and make retrofit/recovery more repeatable. The generic template still does not prescribe application architecture, programming language, build commands, deployment strategy, or internal implementation topology.
