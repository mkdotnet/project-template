# Graphify MCP Setup

## Purpose

This document defines the current project-scoped mechanics for exposing one repository's Graphify graph to Claude Code, Cursor, and Codex through MCP. The durable policy remains in [code-intelligence.md](code-intelligence.md); this file contains vendor-specific setup details that must be re-verified when those tools change.

Configuration locations and commands below were verified against official documentation on 2026-09-09.

## Durable Rule

For adopting projects:

- build and maintain one authoritative repository graph at `graphify-out/graph.json`;
- use project-scoped MCP configuration for Claude Code, Cursor, and Codex;
- default to independent local stdio MCP processes;
- point all three clients at the same graph output;
- confirm Graphify is reachable before structural exploration;
- treat source and tests as authoritative for exact behavior;
- use shared HTTP only after a real multi-client or multi-machine need is demonstrated.

The rule above is durable. File locations and CLI syntax below are vendor mechanics and may change.

## Prerequisites

1. Install Graphify with its MCP support using the currently supported Graphify installation method. Graphify currently documents:

   `uv tool install "graphifyy[mcp]"`

2. Register Graphify's project-level skill/rules for the assistants you actually use, following current Graphify integration guidance.
3. Build the project graph before enabling required MCP startup behavior. The default output is `graphify-out/graph.json`.
4. Confirm the Graphify MCP console command is on `PATH`:

   `graphify-mcp graphify-out/graph.json`

Do not put credentials or machine-specific secrets in committed MCP configuration.

## Current Project-Scoped Configuration Locations

| Client | Project-scoped MCP location | Current verification surface |
| --- | --- | --- |
| Claude Code | `.mcp.json` at repository root | `claude mcp get graphify`, `claude mcp list`, or `/mcp` |
| Cursor | `.cursor/mcp.json` | Cursor MCP settings/status UI |
| Codex | `.codex/config.toml` for trusted projects | `codex mcp list` or `/mcp` |

Official references:

- Claude Code MCP: https://docs.anthropic.com/en/docs/claude-code/mcp
- Cursor MCP: https://cursor.com/docs/mcp
- Codex MCP: https://developers.openai.com/codex/mcp
- Graphify MCP tools: https://graphify.com/docs/mcp-tools
- Graphify MCP overview: https://graphify.com/mcp

## Claude Code

After the graph exists, add the project-scoped server to `.mcp.json`:

```json
{
  "mcpServers": {
    "graphify": {
      "command": "graphify-mcp",
      "args": ["graphify-out/graph.json"]
    }
  }
}
```

Claude Code currently requires approval before first use of a project-scoped MCP server. Preserve that trust boundary.

## Cursor

Add the same stdio server to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "graphify": {
      "command": "graphify-mcp",
      "args": ["graphify-out/graph.json"]
    }
  }
}
```

Keep Graphify-owned Cursor rules separate from this MCP config. The rules guide when Graphify is used; MCP exposes the common native tool surface.

## Codex

For a trusted project, add this to `.codex/config.toml` after Graphify is initialized:

```toml
[mcp_servers.graphify]
command = "graphify-mcp"
args = ["graphify-out/graph.json"]
required = true
```

`required = true` is intentional for an initialized adopting project because Graphify is a baseline. During initial bootstrap, configure it only after the command and graph are available.

## Lightweight Session Check

When the session will perform structural exploration, dependency tracing, impact analysis, debugging, or refactoring:

1. Confirm the client lists `graphify` as configured/active using the client-specific status surface above.
2. Invoke Graphify's `graph_stats` MCP tool.
3. If the tool cannot be called, report Graphify MCP as unavailable instead of silently continuing as though the integration exists.
4. If MCP is unavailable but urgent work must continue, follow the fallback rules in [code-intelligence.md](code-intelligence.md).

Do not run this probe for a trivial task that does not need structural discovery. Context-efficiency rules still apply.

`graph_stats` proves that the expected graph server is reachable. It does not prove freshness. If material source changes have occurred since the graph was last refreshed, or source and graph disagree, run the project's normal `graphify update .` workflow before relying on structural results.

## Shared HTTP Is a Future Alternative

Graphify also supports streamable HTTP for one process serving several clients. Do not make that the default for a solo or single-machine repository.

Consider shared HTTP only when a real need appears, such as multiple simultaneous machines or several clients that should share one long-running process. If the server is exposed beyond localhost, require explicit authentication, network binding, and security review before adoption.

## Maintenance

When Claude Code, Cursor, Codex, or Graphify is upgraded materially:

- re-check the official documentation links above;
- verify project-scoped configuration locations and syntax;
- verify `graphify-mcp` and `graph_stats` still exist and behave as expected;
- update this focused mechanics document if vendor behavior changed;
- keep the policy in `code-intelligence.md` stable unless the underlying engineering decision changed.
