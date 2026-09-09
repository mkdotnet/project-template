# ADR 0004: Project-Scoped Graphify MCP Configuration

## Status

Accepted

## Context

Graphify is the required structural code-intelligence baseline for adopting projects, and work commonly moves between Cursor, Claude Code, and Codex. The existing code-intelligence policy defines how Graphify should be used and refreshed, but it does not define a common MCP setup or a lightweight way to detect that one assistant is silently operating without Graphify.

Vendor-specific MCP paths and commands can change. The durable template decision therefore must separate the stable policy from configuration mechanics that are verified against current official documentation and revisited when tool versions change.

As of 2026-09-09, official documentation confirms project-scoped MCP configuration at `.mcp.json` for Claude Code, `.cursor/mcp.json` for Cursor, and `.codex/config.toml` for trusted Codex projects. Graphify's own MCP documentation defines `graphify-out/graph.json` as the default graph and recommends stdio for a local single-assistant process, with streamable HTTP intended for shared multi-client/team scenarios.

## Decision

- Add `docs/tooling/mcp-setup.md` as the focused operational document for Graphify MCP mechanics across Claude Code, Cursor, and Codex.
- Keep `docs/tooling/code-intelligence.md` authoritative for policy. `mcp-setup.md` owns current vendor-specific configuration locations, example snippets, and verification steps.
- For an adopting project, default to three independent project-scoped stdio MCP client configurations that all point to the same repository-local authoritative graph output: `graphify-out/graph.json`.
- Prefer the Graphify-provided `graphify-mcp` console entry point after installing the MCP-enabled Graphify package, so all three client configurations use the same command shape and avoid interpreter-environment ambiguity.
- Do not pre-create active `.mcp.json`, `.cursor/mcp.json`, or `.codex/config.toml` files in the generic template because the template does not ship a generated `graphify-out/graph.json`. Active configuration that points to a nonexistent graph would create a broken baseline.
- During project adoption, build the graph first, then create the project-scoped MCP configurations using the current official tool documentation and the focused setup guide.
- For Codex, recommend `required = true` after Graphify and the graph are initialized, because Graphify is a project baseline and Codex currently supports failing startup when a required enabled MCP server cannot initialize.
- At the first structural/code-exploration use in a session, confirm Graphify is configured and reachable, then call the lightweight `graph_stats` MCP tool. Do not spend session-start work probing MCP for trivial tasks that do not require structural discovery.
- Treat `graph_stats` as a reachability/identity check, not proof that the graph is fresh. Freshness remains governed by the code-intelligence policy and `graphify update .` after material source changes.
- If Graphify MCP is unavailable, report that condition rather than silently behaving as if MCP were present. Use the smallest supported Graphify CLI/source-search fallback necessary and restore the expected integration when practical.
- Keep shared streamable HTTP as a future alternative only when a demonstrated need exists, such as several simultaneous clients or machines sharing one process. If exposed beyond localhost, authentication and network-security requirements must be addressed explicitly.
- Re-verify vendor-specific paths and commands against current official Claude Code, Cursor, Codex, and Graphify documentation when upgrading those tools or when configuration behavior changes.

## Consequences

### Positive

- All three assistants have one documented path to the same graph and the same native Graphify MCP tool surface.
- Project-scoped configuration keeps Graphify behavior tied to the repository rather than a maintainer's global machine state.
- The lightweight `graph_stats` probe reduces the chance of silent structural work without Graphify.
- Separate stdio processes avoid an unnecessary persistent server and network surface for a solo or single-machine workflow.
- Vendor mechanics can evolve without moving policy into tool-specific config files.

### Negative

- Adopting projects must perform one explicit MCP setup step after the graph is generated.
- Three configuration files still exist in different vendor formats and must remain semantically aligned.
- Vendor-specific paths in the setup document can become stale and therefore require re-verification during tool upgrades.
- `required = true` in Codex can intentionally block startup when Graphify is missing; it should be enabled only after project setup is complete.

## Alternatives Considered

- **Run one persistent shared HTTP Graphify MCP server by default:** Rejected because it adds process lifecycle, network configuration, and security surface without a demonstrated need for a solo/single-machine workflow.
- **Rely only on each tool's native Graphify skill/rule and omit MCP consistency:** Rejected for this baseline because the project deliberately wants a common native MCP tool surface across all three assistants.
- **Use only global user-level MCP configuration:** Rejected because one machine can silently diverge from the repository's expected tooling and the configuration is not carried with project adoption.
- **Commit active MCP config files in the generic template:** Rejected because the generic template does not contain a generated graph and would begin in a broken state.
- **Write one custom MCP proxy or wrapper:** Rejected as speculative infrastructure when Graphify already exposes a standard stdio server understood by all three clients.

## Review Conditions

Review this decision if:

- official MCP configuration paths or formats change;
- Graphify changes its preferred MCP command or graph location;
- several machines or simultaneous clients make shared HTTP materially simpler than independent stdio processes;
- project-scoped configuration becomes unsupported by one of the required assistants;
- MCP startup checks become noisy enough to increase context cost without improving reliability.
