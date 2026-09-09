# Documentation Standard

## Purpose

This standard defines the lightweight documentation contract for the template and adopting repositories. Durable project knowledge lives under `docs/`; the complete technical implementation lives under the project-defined boundary recorded in `mk.json`.

## Authority Model

- `README.md` is the concise repository introduction and navigation entry point.
- `docs/` is the single root for authoritative detailed project documentation.
- `implementation/` is authoritative for actual implemented product behavior and framework-owned structure.
- Tests live within the appropriate implementation area and provide evidence of expected/validated behavior.
- Focused documents explain intent, requirements, contracts, state, decisions, and usage without duplicating implementation.
- Link to authoritative guidance instead of copying it.
- Git history is document change history; do not maintain manual revision sections without a real need.

## Baseline Documents

The baseline documentation set is `README.md`, project vision/roadmap/status/capabilities, architecture overview, coding/documentation standards, AI bootstrap/collaboration/review checklist, code-intelligence/MCP guidance, developer/user guide indexes, and module-context guidance. ADRs and RFCs exist only when material decisions or proposals exist. `docs/security/` remains conditional.

## Document Contracts

### Project Vision
Mission, problem, audience, goals, non-goals, success criteria, constraints, assumptions, risks, and boundaries.

### Roadmap
Milestone-level delivery order and outcomes; not a task tracker.

### Project Status
Concise verified current state using a small stable vocabulary.

### Capabilities
Stable capability-level view of what the system currently provides.

### Architecture Overview
Repository/system boundaries, dependency direction, implementation boundary, important flows, extension rules, trade-offs, and limitations.

### Coding Standards
Recurring implementation conventions after technologies are selected; they do not redefine framework source topology.

### AI Bootstrap
Minimal entry context, task routing, implementation-boundary discovery, Graphify use, stop rules, debug/refactor rules, validation, and reporting.

### AI Collaboration
Durable knowledge ownership and handoff rules across humans, Codex, Claude Code, and Cursor.

### Code Intelligence / MCP Setup
Graphify authority/freshness/fallback policy plus current project-scoped MCP mechanics. Vendor-specific details must be re-verified when tools change.

### Developer Guides
Practical configure/build/run/test/debug/deploy/operate/extend procedures. Paths should begin from the project's implementation boundary rather than assume root `src/` or `tests/`.

### User Guides
Audience-appropriate operator, administrator, customer, or end-user workflows.

### Module Context
Focused subsystem purpose, boundaries, entry points, dependencies, contracts, flows, constraints, failure modes, and relevant decisions when rediscovery cost justifies maintenance.

### Security and Compliance
Conditional documentation under `docs/security/` only when authoritative project requirements justify it. Address applicable data classification, access-control expectations, audit requirements, trust/data boundaries, secrets/key expectations, regulatory/client traceability, monitoring/incidents, exceptions, and accepted risks without inventing requirements.

## Implementation Documentation Rule

Do not document a generic internal layout for `implementation/`. The framework, generator, or project-specific architecture owns it. Documentation may describe actual project roots such as ABP `main/modules/etc`, Android modules, Python packages, or polyglot components only after they exist.

When a project's implementation topology is complex enough to justify a durable map, add a focused architecture document rather than changing the generic template contract.

## Project-State Maintenance

Keep roadmap, status, and capabilities summary-level. Fine-grained execution belongs in the tracker. Update state documents only when a material deliverable or capability changes.

## Linking, Language, and Freshness

- Use repository-relative links for repository files.
- Engineering documentation uses the project's agreed engineering language; user documentation uses the audience language.
- Store text as UTF-8 with LF and a final newline.
- Remove stale or contradictory guidance rather than layering new rules beside it.
- Never store secrets, credentials, unnecessary personal data, or invented compliance claims.

## Context Efficiency

Every document needs a clear audience, purpose, read trigger, and maintenance value. AI assistants must not load the entire documentation tree by default. Prefer focused documents that are cheaper to read than rediscovering the same context from implementation or history.

## Automated Validation Boundary

The baseline validator automates only deterministic or deliberately heuristic checks:

- unresolved relative links in `README.md`, `AGENTS.md`, `CLAUDE.md`, and `docs/**/*.md` are hard failures;
- a pull request changing the implementation root from `mk.json` without changing status/capabilities receives a non-blocking manual-confirmation warning;
- unusually large tool-specific config files and substantial verbatim copied blocks may produce drift warnings.

Automation does not prove semantic consistency or substantive project-state correctness. Silence from CI is not evidence that tool-specific configuration agrees with architecture, standards, or AI guidance.

## Avoiding Over-Documentation

- Add a document only for a current need.
- Prefer improving an existing authoritative document over creating a parallel source.
- Do not create empty ceremonial sections, hypothetical components, or speculative implementation topology.
- Let framework/project structure evolve from real requirements.
