# Code Intelligence Policy

## Purpose

This document defines how adopting projects use structural/search code-intelligence tools without confusing derived indexes with authoritative implementation or creating tool-specific knowledge silos.

## Baseline

Graphify is the required structural code-intelligence baseline unless a project records an explicit exception. Sourcegraph is optional. Neither is a runtime product dependency.

## Analysis Boundary

By default, structural code analysis targets the implementation root declared in `mk.json` (`implementation/` in the template), not the governance/documentation tree. This keeps architecture reports and queries focused on the product workspace while allowing repository-wide analysis when a task explicitly needs it.

Graphify output remains repository-local under `graphify-out/` and outside `implementation/` because it is derived engineering context, not product implementation.

## Authority Hierarchy

1. Implementation source/configuration defines actual behavior.
2. Tests in their owning implementation areas provide behavior evidence.
3. Project documentation/decisions explain intent, contracts, requirements, and state.
4. Graphify provides derived relationships, callers, dependencies, and impact paths.
5. Optional Sourcegraph provides broader search/context.
6. Git history explains prior change context when current evidence is insufficient.

Never treat generated graph/search output as proof of exact current behavior without checking implementation.

## Graphify Workflow

For structural work:

1. Map/query the implementation boundary.
2. Identify the relevant implementation files and tests.
3. Read focused architecture/module/security/decision context only when needed.
4. Implement and validate the smallest safe change.
5. Refresh the implementation graph after material changes when structural data will be relied on.

Current Graphify skill syntax supports mapping a path. From repository root, use `/graphify implementation` (Codex uses its corresponding skill invocation) and `/graphify implementation --update` for incremental refresh. Re-verify vendor syntax when Graphify changes.

## MCP Consistency

Use [mcp-setup.md](mcp-setup.md). Claude Code, Cursor, and Codex should point at the same repository-local `graphify-out/graph.json`, normally through independent local stdio processes.

At the first structural use in a session, confirm Graphify is visible and call `graph_stats`. This proves reachability/identity, not freshness.

## Freshness and Failure Handling

- Prefer a current implementation graph before structural analysis.
- If graph output conflicts with implementation, implementation wins and the graph should be refreshed.
- If Graphify is unavailable, report it and use the smallest practical source-search fallback; do not perform an unlimited repository scan.
- Do not block urgent diagnosis solely because optional Sourcegraph is unavailable.

## Context Efficiency

Prefer Graphify before broad recursive search when structure is the question. Stop once affected implementation, contracts, and tests are sufficiently identified. Do not query unrelated subsystems for completeness or probe Graphify when the task does not need structural discovery.

## Security

Do not commit tool credentials, tokens, private endpoints, or machine-specific secrets. Review generated integrations before versioning. Apply project data-handling requirements to code-intelligence services. Shared HTTP Graphify outside localhost requires explicit authentication/network-security review.
