# ADR 0001: Repository Structure

## Status

Accepted; implementation-layout clauses superseded by ADR 0005

## Context

The template needs a predictable structure for durable project knowledge, AI-assisted maintenance, repository automation, delivery state, and future implementation without forcing technology choices or duplicate sources of truth.

Earlier versions also reserved generic root implementation folders such as `src/`, `tests/`, `samples/`, and `tools/`. Experience with framework-owned and polyglot repositories showed that this part of the decision created unnecessary structural conflict. ADR 0005 now owns the implementation-boundary decision.

## Decision

- Use `docs/` as the single root for authoritative detailed project documentation.
- Keep `README.md` as the concise repository introduction/navigation entry point.
- Use `docs/project/` for vision, roadmap, status, and capabilities.
- Use `docs/architecture/` for structural boundaries and important flows.
- Use `docs/standards/` for recurring engineering/documentation conventions.
- Use `docs/decisions/adr/` for accepted durable decisions and `docs/decisions/rfc/` for proposals requiring structured discussion.
- Use `docs/ai/` for canonical AI workflow/collaboration/review guidance.
- Use `docs/tooling/` for engineering-tool policy and focused setup mechanics.
- Use `docs/guides/` for developer/user procedures and `docs/modules/` only for complex subsystem context whose rediscovery cost justifies maintenance.
- Keep `AGENTS.md` as the shared agent discovery pointer and `CLAUDE.md` as a thin Claude Code adapter.
- Allow tool-specific/generated integration files only as mechanics; they must not become parallel stores of architecture, standards, state, or workflow rules.
- Load AI context progressively rather than requiring all documentation, decisions, modules, or history to be read by default.
- Delegate the physical product implementation boundary and all internal implementation topology to ADR 0005. The generic repository no longer defines root `src/`, `tests/`, `samples/`, or `tools/` directories.

## Consequences

### Positive

- Durable project knowledge has one predictable authority root.
- Codex, Claude Code, Cursor, and humans share the same repository context.
- The documentation/governance structure remains stable while application topology can vary by framework or language.
- Progressive loading reduces irrelevant exploration and token use.

### Negative

- Readers may follow links across several focused documents.
- The repository contract still requires maintenance as project state and tooling evolve.
- Implementation layout is intentionally not discoverable from generic folder names alone; projects rely on `mk.json`, actual implementation, and project-specific architecture when needed.

## Alternatives Considered

- **Keep all knowledge in README:** Rejected because it becomes difficult to navigate and route selectively.
- **Maintain independent AI instructions per tool:** Rejected because copies drift.
- **Create multiple documentation roots:** Rejected because authority fragments.
- **Keep generic root source/test/tool folders:** Superseded by ADR 0005 because framework-native and polyglot projects need different structures.

## Review Conditions

Review this decision if documentation authority becomes unclear, task-specific routing stops scaling, or a recurring repository-wide concern cannot fit the current governance areas without ambiguity.
