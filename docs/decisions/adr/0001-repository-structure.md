# ADR 0001: Repository Structure

## Status

Accepted

## Context

The template needs a predictable structure for implementation, verification, supporting material, durable project knowledge, long-term delivery state, human-facing guides, and efficient AI-assisted maintenance.

The structure must work across Codex, Claude Code, Cursor, and human contributors without creating separate project truths for each tool. It must also support focused debugging and refactoring after the project has grown, while avoiding a requirement to load every document or scan the whole repository for routine work.

The repository README cannot remain the complete source of project knowledge as a project grows. A separate root AI documentation tree, duplicated tool-specific instruction sets, or product-specific directories such as `PMS` would fragment authority and reduce reuse.

## Decision

- Use `docs/` as the single root for authoritative and detailed project documentation. `README.md` remains the concise repository introduction and navigation entry point.
- Use `docs/project/` for project intent and durable delivery state: vision, roadmap, status, and capabilities.
- Use `docs/architecture/` for structural boundaries, dependency direction, and important system flows.
- Use `docs/standards/` for shared engineering and documentation conventions.
- Use `docs/decisions/adr/` for accepted durable decisions and `docs/decisions/rfc/` for proposals requiring structured discussion.
- Use `docs/ai/` for the canonical AI bootstrap, cross-agent collaboration contract, and AI review checklist.
- Use `docs/tooling/` for engineering-tool policy. Graphify is the adopting-project baseline structural code-intelligence layer; Sourcegraph is an optional deliberate extension.
- Use `docs/guides/developer/` for practical developer procedures and `docs/guides/user/` for audience-facing product documentation.
- Use `docs/modules/` only for focused subsystem context whose complexity makes repeated rediscovery expensive. Do not create a module document for every code directory.
- Keep `AGENTS.md` as the shared agent discovery pointer and `CLAUDE.md` as a thin Claude Code adapter to the same canonical repository contract.
- Allow tool-generated project integration files when a deliberately adopted tool requires them, but do not let generated or tool-specific files become independent stores of project architecture, standards, status, or workflow rules.
- Reserve `src/`, `tests/`, `samples/`, `scripts/`, and `tools/` for their conventional purposes, adding implementation content only when required.
- Do not create a `PMS` directory or other product-specific root in the generic template.
- Load AI context progressively: entry files route to task-specific context rather than requiring all documentation, decisions, modules, or history to be read by default.

## Consequences

### Positive

- Contributors have one predictable root for authoritative detailed documentation.
- Codex, Claude Code, and Cursor share one durable repository context instead of divergent instruction sets.
- Project delivery state remains recoverable after months of development without reconstructing it from commit history.
- Developer and user documentation have explicit audience-focused locations.
- Complex subsystems can gain focused maintenance context without forcing per-module documentation everywhere.
- Graphify provides a standard structural discovery path while source and tests remain authoritative for exact behavior.
- Progressive context loading reduces broad exploration, unnecessary token use, and speculative redesign.
- The repository can grow without adopting a runtime technology-specific layout prematurely.

### Negative

- The baseline contains more focused documents than the earlier minimal structure.
- Project-state documents and code-intelligence data require maintenance to remain trustworthy.
- Readers may need to follow links across several authoritative documents.
- Tool integrations can drift if generated adapters are manually copied into repository standards instead of remaining thin.
- Progressive context loading depends on contributors keeping documents focused and assigning clear read triggers.

## Alternatives Considered

- **Keep all knowledge in `README.md`:** Rejected because it becomes difficult to navigate, maintain, and route selectively as the repository grows.
- **Maintain independent Codex, Claude Code, and Cursor instruction sets:** Rejected because duplicated rules drift and create multiple sources of truth.
- **Create a root-level AI documentation directory:** Rejected because AI guidance belongs with authoritative project documentation under `docs/`.
- **Use assistant chat history as handoff state:** Rejected because it is not a durable repository artifact and is not reliably shared across tools or contributors.
- **Create a module document for every implementation area:** Rejected because it increases maintenance and context noise without demonstrated value.
- **Make Sourcegraph mandatory alongside Graphify:** Rejected until adopting projects demonstrate that the additional search or cross-repository context justifies another baseline tool.
- **Create a `PMS` directory:** Rejected because it is product-specific and would introduce an unnecessary structural concept.
- **Add technology-specific project directories now:** Rejected because no implementation technology has been selected.
- **Create multiple roots for detailed project documentation:** Rejected because it would fragment authority and make context discovery harder.

## Review Conditions

Review this decision if:

- A demonstrated project need cannot fit the structure without unclear placement.
- Documentation scale makes task-specific context routing difficult despite focused documents.
- Graphify no longer provides sufficient value as the baseline structural code-intelligence layer.
- Sourcegraph or another tool becomes consistently necessary across adopting projects.
- A selected technology imposes a conventional layout that materially improves maintainability.
- Contributors repeatedly misunderstand the authority hierarchy or dependency direction of top-level areas.
- Project-state documents repeatedly duplicate tracker data instead of remaining useful summaries.

Any revision must preserve a clear documentation authority, cross-agent durability, progressive context loading, and resistance to speculative structure.
