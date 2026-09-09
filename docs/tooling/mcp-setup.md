# Graphify MCP Setup

## Purpose

This document defines current project-scoped mechanics for exposing one project's Graphify implementation graph to Claude Code, Cursor, and Codex. Durable policy remains in [code-intelligence.md](code-intelligence.md). Vendor mechanics must be re-verified when tools change.

Configuration locations below were last verified on 2026-09-09.

## Durable Rule

- Map the product implementation root from `mk.json`; the template default is `implementation/`.
- Keep one authoritative repository-local graph at `graphify-out/graph.json`.
- Use project-scoped MCP configuration for Claude Code, Cursor, and Codex.
- Default to independent local stdio processes pointing at the same graph.
- Confirm MCP reachability before structural exploration; treat freshness separately.
- Use shared HTTP only after a real multi-client/multi-machine need exists.

## Build and Refresh

From repository root, map only the implementation boundary by default:

```text
/graphify implementation
```

For an incremental refresh after material implementation changes:

```text
/graphify implementation --update
```

Graphify currently writes its derived files to repository-local `graphify-out/`. Re-check current Graphify documentation if command/output behavior changes.

## Current Project-Scoped MCP Locations

| Client | Project-scoped MCP location | Verification surface |
| --- | --- | --- |
| Claude Code | `.mcp.json` at repository root | `claude mcp get graphify`, `claude mcp list`, or `/mcp` |
| Cursor | `.cursor/mcp.json` | Cursor MCP settings/status UI |
| Codex | `.codex/config.toml` for trusted projects | `codex mcp list` or `/mcp` |

The generic template does not pre-create active MCP config because no graph exists before a real implementation is mapped.

## Common stdio target

After Graphify MCP support is installed and `graphify-out/graph.json` exists, configure each client to run `graphify-mcp graphify-out/graph.json` using its current project-scoped format. For Codex, `required = true` is appropriate only after Graphify is initialized and intentionally required by the project.

## Lightweight Session Check

When structural exploration, dependency tracing, debugging, impact analysis, or refactoring is needed:

1. Confirm the client lists `graphify` as configured/active.
2. Invoke `graph_stats`.
3. If unavailable, report the limitation rather than silently acting as if Graphify exists.
4. If graph freshness is doubtful, refresh the implementation graph before relying on it.

Do not probe MCP for trivial work that does not require structural discovery.

## Shared HTTP Is a Future Alternative

Do not run a persistent shared HTTP MCP server by default. Consider it only for a demonstrated need such as several simultaneous clients or machines. Exposure beyond localhost requires authentication and network-security review.

## Maintenance

When Claude Code, Cursor, Codex, or Graphify changes materially, re-check current official configuration locations, command syntax, `graphify-mcp`, `graph_stats`, mapping syntax, and graph output behavior. Keep vendor mechanics here rather than duplicating them into canonical AI/project policy.
