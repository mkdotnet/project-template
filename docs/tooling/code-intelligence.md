# Code Intelligence Policy

## Purpose

This document defines how adopting projects use structural and search-oriented code-intelligence tools without confusing derived indexes with authoritative source or creating tool-specific project knowledge silos.

## Baseline

Graphify is the required structural code-intelligence baseline for projects created from this template unless the project records an explicit justified exception.

Sourcegraph is optional. Adopt it only when broader search, large-codebase navigation, or cross-repository context provides demonstrated value beyond the project's existing workflow.

Neither tool is a runtime application dependency.

## Authority Hierarchy

1. Source code and configuration define actual implemented behavior.
2. Tests provide evidence of expected and validated behavior.
3. Project documentation and decision records explain intent, contracts, boundaries, requirements, and state.
4. Graphify provides derived structural context such as relationships, callers, dependencies, and impact paths.
5. Sourcegraph, when adopted, provides additional search and code-context capabilities.
6. Git history and historical collaboration records explain prior change context when current evidence is insufficient.

Never treat generated graph or search output as proof of exact current behavior without checking relevant source.

## Graphify Workflow

Use Graphify when a task requires structural discovery, including:

- locating a subsystem or implementation entry point;
- identifying callers and dependencies;
- tracing likely execution paths;
- estimating refactor impact radius;
- locating related tests or connected components;
- reducing broad file-by-file repository exploration.

A normal focused workflow is:

1. Use Graphify to identify the relevant area.
2. Read the exact source and tests for that area.
3. Read focused architecture, module, security, or decision context only when needed.
4. Implement and validate the smallest safe change.
5. Refresh/update the project's Graphify data after material source changes according to the installed integration.

Keep Graphify-generated project integration files and data under the ownership of Graphify. Do not manually duplicate generated vendor rules into repository standards. Commit generated artifacts only when the adopted Graphify workflow expects them to be versioned and they contain no secrets or machine-specific sensitive data.

## MCP Consistency

The repository's common Graphify MCP mechanics are defined in [mcp-setup.md](mcp-setup.md).

For adopting projects that use Claude Code, Cursor, and Codex, configure each client at project scope and point every client at the same repository-local `graphify-out/graph.json`. Independent local stdio processes are the default. Do not introduce a persistent shared HTTP server without a demonstrated multi-client or multi-machine need.

At the first structural use in a session, confirm the expected Graphify MCP server is visible and invoke `graph_stats`. This is a lightweight reachability check, not a freshness guarantee. Skip the probe for trivial work that does not require structural discovery.

Vendor-specific configuration paths and commands belong in the focused setup document, not in this policy. Re-verify those mechanics when tool versions change.

## Sourcegraph

Sourcegraph is an explicit optional extension, not a dormant mandatory dependency. When adopted, document project-specific setup or usage here or in a focused tooling document and record a material architecture/engineering decision if the adoption changes team workflow significantly.

Use Sourcegraph when it materially improves tasks such as broad code search, multi-repository navigation, or context retrieval that Graphify and local source inspection do not address efficiently.

## Freshness and Failure Handling

Derived indexes can be stale.

- Prefer a current Graphify index before structural analysis.
- `graph_stats` proves MCP reachability and graph identity, not freshness.
- If Graphify output conflicts with source, source wins and the index should be refreshed.
- If material source changes occurred after the graph was last refreshed, update the graph before relying on structural analysis.
- If Graphify is unavailable during a focused task, do not perform an unlimited repository scan. Use the smallest practical Graphify CLI or source-search fallback, report the limitation, and restore the structural integration when practical.
- Do not block urgent diagnosis solely because optional Sourcegraph is unavailable.

## Context-Efficiency Rules

- Prefer Graphify before broad `grep`, recursive file reading, or directory-by-directory exploration when structure is the question.
- Stop structural exploration when the affected code, contracts, and tests are sufficiently identified.
- Do not query unrelated subsystems for completeness.
- Do not spend session-start tokens proving Graphify availability when the task does not require structural discovery.
- Use Git history only when current evidence leaves an important reason or constraint unexplained.

## Security

- Do not commit tool credentials, access tokens, private endpoints, or machine-specific secrets.
- Review generated integration files before versioning them.
- Apply repository access and data-handling requirements equally to code-intelligence services.
- If a shared HTTP Graphify MCP server is ever exposed beyond localhost, require explicit authentication and network-security review.
