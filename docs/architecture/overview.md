# Architecture Overview

## Purpose

This document explains the repository-level architecture of the template. It describes where durable knowledge, delivery state, human-facing guides, AI context, code intelligence, and future implementation belong without prescribing an application architecture.

## Repository Architecture

```text
.
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
├── docs/
│   ├── project/
│   │   ├── vision.md
│   │   ├── roadmap.md
│   │   ├── status.md
│   │   └── capabilities.md
│   ├── architecture/
│   ├── standards/
│   ├── decisions/
│   │   ├── adr/
│   │   └── rfc/
│   ├── ai/
│   │   ├── bootstrap.md
│   │   ├── collaboration.md
│   │   └── review-checklist.md
│   ├── tooling/
│   │   └── code-intelligence.md
│   ├── guides/
│   │   ├── developer/
│   │   └── user/
│   ├── modules/
│   ├── reference/
│   └── assets/
├── src/
├── tests/
├── samples/
├── scripts/
├── tools/
├── AGENTS.md
├── CLAUDE.md
├── CHANGELOG.md
├── LICENSE
├── README.md
└── mk.json
```

Repository convention files at the root define baseline editing, Git, and ignore behavior. Tool-generated integration files may appear when an adopting project initializes Graphify or another approved engineering tool; generated vendor configuration must not become a parallel source of project rules.

## Main Areas

- `README.md` is the concise repository introduction and navigation entry point.
- `docs/` is the single root for authoritative and detailed project documentation.
- `docs/project/` owns mission, roadmap, current state, and capability-level delivery knowledge.
- `docs/architecture/` owns structural boundaries, dependency direction, and important system flows.
- `docs/standards/` owns recurring engineering and documentation conventions.
- `docs/decisions/` owns durable accepted decisions and unresolved structured proposals.
- `docs/ai/` owns the canonical assistant bootstrap, cross-agent collaboration rules, and review contract.
- `docs/tooling/` owns repository policy for engineering tools such as Graphify and optional Sourcegraph.
- `docs/guides/developer/` owns practical instructions for developers operating and extending the project.
- `docs/guides/user/` owns documentation intended for operators, administrators, customers, or other end users.
- `docs/modules/` contains focused context only for subsystems whose complexity justifies it.
- `AGENTS.md` is the shared agent discovery pointer; `CLAUDE.md` is a thin Claude Code adapter.
- `src/`, `tests/`, `samples/`, `scripts/`, and `tools/` keep their conventional implementation and repository-support responsibilities.
- `mk.json` provides machine-readable template metadata and entry points.

## Knowledge and Evidence Hierarchy

Different repository artifacts answer different questions and must not be confused:

1. Source code and configuration are authoritative for actual implemented behavior.
2. Tests are evidence of expected and validated behavior.
3. Focused project, architecture, standard, decision, module, and guide documents explain intent, contracts, state, and usage.
4. Graphify provides derived structural context for navigation, callers, dependencies, and impact discovery.
5. Sourcegraph, when adopted, may provide broader code search or cross-repository context.
6. Git history, old pull requests, and old issues are historical evidence and should be consulted when current evidence is insufficient.

Derived code-intelligence data must be verified against exact source before a behavioral change is made.

## Dependency Direction

Production code must not depend on tests, samples, scripts, documentation, repository tools, or code-intelligence output. Tests and samples may depend on public production behavior. Scripts and tools may support repository work but must not become hidden runtime dependencies.

Documentation and AI context describe the repository; they do not create runtime dependencies. If an adopting project introduces multiple production components, it must document allowed dependency direction before cross-component coupling grows.

## AI Context Architecture

The repository uses progressive context loading rather than a universal reading list.

`AGENTS.md` and `CLAUDE.md` route assistants to `docs/ai/bootstrap.md`. The bootstrap provides task-specific context routes. An assistant reads only the project documents, module context, source, tests, and decisions required for the requested task. Graphify is preferred for structural discovery before broad repository search. Exploration stops when enough verified context exists to perform the task safely.

Tool-specific files are adapters or generated mechanics, not independent policy stores. Durable project knowledge must survive switching between Codex, Claude Code, Cursor, or a human developer.

## Project-State Model

- `vision.md` explains why the project exists and its boundaries.
- `roadmap.md` explains milestone-level intended delivery order.
- `status.md` explains current delivery state.
- `capabilities.md` explains what the product or system can currently do at a meaningful capability level.

Fine-grained tasks belong in an issue or project tracker. Git commits and pull requests record implementation history. These layers complement rather than duplicate each other.

## Module Context

Create a file under `docs/modules/` only when a subsystem has enough complexity, integration surface, failure modes, or maintenance cost that focused context materially reduces rediscovery. Module documents explain purpose, boundaries, entry points, dependencies, contracts, important flows, constraints, failure modes, and relevant decisions. They do not document code line by line.

## Extension Rules

- Add a file or directory only for a current, explainable need.
- Prefer conventional names and the nearest existing authoritative area.
- Keep implementation under `src/` and corresponding verification under `tests/`.
- Record material durable architecture decisions as ADRs.
- Use an RFC for a proposal that genuinely requires discussion before acceptance.
- Update affected documentation and project state in the same change when behavior, architecture, capabilities, or delivery state changes materially.
- Keep tool-specific adapters thin and keep generated tool configuration owned by the tool that generated it.
- Avoid root-level documentation directories or parallel sources of project knowledge.

## Trade-offs

The fixed top-level structure improves discoverability but includes some placeholder areas before implementation exists. Technology neutrality keeps the template broadly reusable, while the explicit Graphify baseline introduces an engineering-tool convention without becoming a runtime dependency. Project-state documents improve long-term recoverability but require disciplined summary-level maintenance. Progressive context loading reduces token use and irrelevant exploration but depends on focused documents remaining concise and current.

## Current Limitations

- No runtime, application architecture, or technology stack is selected.
- No build, test, packaging, release, or deployment process exists.
- No runtime dependencies or implementation examples are included.
- No CI workflows are provided.
- Graphify is defined as an adopting-project baseline but its generated project artifacts are not pre-generated in the generic template.
- Sourcegraph is not configured by default.
