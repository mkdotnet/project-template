# ADR 0004: Project-Scoped Graphify MCP Configuration

## Status

Accepted; analysis scope aligned with ADR 0005

## Context

Graphify is the structural code-intelligence baseline and work moves between Cursor, Claude Code, and Codex. The project needs one consistent graph/MCP surface without turning vendor mechanics into a second source of project truth.

ADR 0005 separates product implementation from repository governance. Structural code intelligence should therefore focus on the implementation boundary by default while keeping derived Graphify output outside that boundary.

Vendor-specific MCP paths and commands can change, so stable policy and current setup mechanics remain separate.

## Decision

- Keep `docs/tooling/code-intelligence.md` authoritative for Graphify policy and `docs/tooling/mcp-setup.md` authoritative for current vendor-specific MCP mechanics.
- Build the default structural graph from the implementation root declared by `mk.json`; the template default is `implementation/`.
- Keep the common derived output at repository-level `graphify-out/graph.json`, outside the product implementation boundary.
- Use three independent project-scoped stdio MCP configurations for Claude Code, Cursor, and Codex, all pointing at the same graph.
- Do not pre-create active MCP files in the generic template because no graph exists until a real implementation is mapped.
- At the first structural use in a session, confirm Graphify is reachable and invoke `graph_stats`; this proves reachability/identity, not freshness.
- Refresh the implementation graph after material implementation changes before relying on structural results. Current Graphify skill syntax is documented in the setup guide and must be re-verified when Graphify changes.
- If Graphify is unavailable, report the condition and use the smallest practical fallback rather than silently performing unlimited repository exploration.
- Keep shared HTTP as a future alternative only when a demonstrated multi-client or multi-machine need exists.
- Re-verify Claude Code, Cursor, Codex, and Graphify mechanics when those tools are upgraded materially.

## Consequences

### Positive

- All three assistants use the same implementation-focused structural map.
- Governance/docs no longer dominate the code graph by default.
- Project-scoped configuration travels with the repository rather than depending only on global machine state.
- Local stdio avoids unnecessary persistent network infrastructure.

### Negative

- Adopting projects perform an explicit graph/MCP initialization step.
- Vendor config formats remain different and can become stale.
- Projects needing repository-wide graph analysis must request it deliberately rather than receive it by default.

## Alternatives Considered

- **Graph the entire repository by default:** Rejected after ADR 0005 because governance/documentation noise is not normally part of structural product-code analysis.
- **Run one persistent shared HTTP server by default:** Rejected as unnecessary infrastructure for solo/single-machine workflows.
- **Use global-only MCP configuration:** Rejected because machines can silently diverge.
- **Commit active MCP configs before a graph exists:** Rejected because the generic template would start broken.

## Review Conditions

Review this decision if official MCP formats change, Graphify changes mapping/output semantics, shared HTTP becomes materially simpler for real usage, or implementation-focused mapping omits repository information that repeatedly proves necessary for structural work.
