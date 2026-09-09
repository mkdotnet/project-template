# ADR 0001: Repository Structure

## Status

Accepted; implementation-layout clauses superseded by ADR 0005; lifecycle-tooling extension added by ADR 0006

## Context

The template needs a predictable structure for durable project knowledge, AI-assisted maintenance, repository automation, delivery state, lifecycle tooling, and future implementation without forcing technology choices or duplicate sources of truth.

Earlier versions reserved generic root implementation folders such as `src/`, `tests/`, `samples/`, and `tools/`. ADR 0005 superseded that part with one framework-owned `implementation/` boundary. ADR 0006 adds a repository-level `.mk/` area for safe retrofit and lifecycle tooling without changing application topology.

## Decision

- Use `docs/` as the single root for authoritative detailed project documentation.
- Keep `README.md` as the concise repository introduction/navigation entry point.
- Use `docs/project/` for vision, roadmap, status, and capabilities.
- Use `docs/architecture/` for structural boundaries and important flows.
- Use `docs/standards/` for recurring engineering/documentation conventions.
- Use `docs/decisions/adr/` for accepted durable decisions and `docs/decisions/rfc/` for proposals requiring structured discussion.
- Use `docs/ai/` for canonical AI workflow/collaboration/review guidance.
- Use `docs/tooling/` for engineering-tool and lifecycle-tool policy/setup documentation.
- Use `docs/guides/` for developer/user procedures and `docs/modules/` only for complex subsystem context whose rediscovery cost justifies maintenance.
- Use `.mk/` only for MK template lifecycle tooling and local lifecycle reports. It is a repository-governance concern, not product implementation or a second documentation authority.
- Keep `.github/` for repository-host automation such as workflows and pull-request templates.
- Keep `AGENTS.md` as the shared agent discovery pointer and `CLAUDE.md` as a thin Claude Code adapter.
- Allow tool-specific/generated integration files only as mechanics; they must not become parallel stores of architecture, standards, state, or workflow rules.
- Load AI context progressively rather than requiring all documentation, decisions, modules, or history to be read by default.
- Delegate the physical product implementation boundary and all internal implementation topology to ADR 0005. The generic repository does not define root `src/`, `tests/`, `samples/`, or `tools/` directories.
- Delegate safe retrofit and lifecycle behavior to ADR 0006.

## Consequences

### Positive

- Durable project knowledge has one predictable authority root.
- Codex, Claude Code, Cursor, and humans share the same repository context.
- Repository lifecycle automation has a dedicated non-product location.
- The documentation/governance structure remains stable while application topology varies by framework or language.
- Progressive loading reduces irrelevant exploration and token use.

### Negative

- Readers may follow links across several focused documents.
- `.mk/` adds one repository-level tooling area that must remain narrowly scoped.
- The repository contract still requires maintenance as project state and tooling evolve.
- Implementation layout is intentionally project-defined; projects rely on `mk.json`, actual implementation, and focused architecture when needed.

## Alternatives Considered

- **Keep all knowledge in README:** Rejected because it becomes difficult to navigate and route selectively.
- **Maintain independent AI instructions per tool:** Rejected because copies drift.
- **Create multiple documentation roots:** Rejected because authority fragments.
- **Keep generic root source/test/tool folders:** Superseded by ADR 0005.
- **Put MK lifecycle scripts inside `implementation/`:** Rejected because product implementation must remain independent of repository-governance tooling.
- **Put all lifecycle scripts under `.github/`:** Rejected because start/check/sync scripts are not GitHub-specific automation.

## Review Conditions

Review this decision if documentation authority becomes unclear, `.mk/` accumulates unrelated concerns, task-specific routing stops scaling, or a recurring repository-wide concern cannot fit the current governance areas without ambiguity.
