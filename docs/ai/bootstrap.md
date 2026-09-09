# AI Bootstrap

Use this contract before planning or editing the repository. The goal is enough verified context to complete the task safely, not maximum context.

## Minimal Entry Context

1. Read the repository [README](../../README.md) for purpose and entry points.
2. Identify the requested task and its affected area.
3. Read only the additional context required by the routing rules below.

Do not read the complete documentation tree, all ADRs/RFCs, all modules, or Git history by default.

## Context Routing

### Implementation or Feature Work

Read the relevant coding standards, architecture or module context when the change crosses a boundary, and the exact source/tests involved. Use Graphify first for structural discovery when the affected area is not already known.

### Debugging

1. Reproduce or establish concrete evidence of the failure when possible.
2. Use Graphify to locate the execution path, callers, dependencies, and likely impact area.
3. Read the focused module document when one exists.
4. Read the exact source and relevant tests.
5. Read only the architecture decisions required to understand surprising constraints.
6. Inspect logs, runtime evidence, or external contracts relevant to the failure.
7. Identify the root cause before changing behavior.
8. Add or update a regression test when practical.
9. Apply the smallest safe fix and validate it.

Do not rewrite suspicious code merely because it looks unusual.

### Refactoring

Before refactoring:

1. Identify the current responsibility and intended observable behavior.
2. Use Graphify to identify callers, dependencies, and impact radius.
3. Identify public, persistence, message, API, and other external contracts that must remain compatible.
4. Read relevant tests and focused module context.
5. Read only the ADRs/RFCs relevant to the boundary being changed.
6. Prefer incremental refactoring over broad redesign.
7. Preserve observable behavior unless the request explicitly changes it.

Do not introduce abstractions, mediators, factories, eventing, interfaces, or new layers without a demonstrated requirement.

### Architecture Work

Read the architecture overview, relevant module documents, applicable ADRs/RFCs, and the source needed to verify current reality. Record a material durable decision when the outcome changes architecture.

### Planning or Delivery-State Work

Read the project vision, roadmap, status, and capabilities. Use the issue/project tracker for fine-grained tasks rather than expanding summary documents.

### Documentation Work

Read the documentation standard and the target authoritative document or guide. Read implementation only when needed to verify documented behavior.

### Security or Compliance Work

If the project has activated `docs/security/`, read only the relevant security/compliance document, linked architecture/decisions, and exact implementation evidence needed for the request. Do not infer regulatory requirements from the generic template. If the area has not been activated, establish the authoritative project requirement before creating it.

### User-Guide Work

Read the user-guide index, actual product behavior, and audience-specific requirements. Do not expose internal implementation detail unless it helps the user perform a supported workflow.

## Code Intelligence

Follow the [code-intelligence policy](../tooling/code-intelligence.md) and, for adopting projects using the shared MCP surface, the [Graphify MCP setup](../tooling/mcp-setup.md).

Graphify is the baseline structural discovery layer for adopting projects. Use it before broad source traversal when locating dependencies, callers, execution paths, or impact areas. Treat Graphify output as derived context: verify exact behavior in source and tests before editing.

When a session will perform structural exploration, verify Graphify at the first structural use: confirm the client sees the configured MCP server and call `graph_stats`. Do not spend context or startup work probing MCP for a trivial task that does not require structural discovery.

`graph_stats` establishes reachability, not freshness. If material source changes occurred after the graph was last refreshed, or graph output conflicts with source, refresh the graph according to the project workflow before relying on it.

Sourcegraph is optional and should be used only when the project has adopted it and its broader search or cross-repository context materially helps the task.

If Graphify is unavailable or clearly stale, report that condition, use the smallest source-search fallback necessary to proceed, and restore or refresh the structural index as part of normal project maintenance when possible.

## Context Efficiency and Stop Rules

- Start with the minimum required context and expand only when a concrete uncertainty requires it.
- Prefer structural discovery over reading directories file by file.
- Do not inspect unrelated modules.
- Do not read all project documentation, ADRs, RFCs, issues, pull requests, or Git history by default.
- Stop exploration once enough verified context exists to implement or evaluate the requested change safely.
- Prefer repository evidence over speculative reasoning.
- Do not redesign architecture unless the requested outcome or verified constraint requires it.
- Avoid re-analyzing a documented decision unless new evidence conflicts with it.
- Use Git history, blame, old pull requests, and old issues only when current source, tests, documentation, and decisions do not explain an important behavior or constraint.

## Before Editing

- Inspect existing source, tests, configuration, and naming patterns related to the task.
- Check the working tree and preserve unrelated changes.
- Identify the smallest set of files needed for the requested outcome.
- Confirm the change supports current requirements and does not conflict with documented non-goals or contracts.
- State any material assumption that cannot be verified from the repository.

## While Editing

- Follow existing patterns unless there is a documented reason to change them.
- Keep changes scoped to the requested outcome.
- Prefer clear, direct implementations and conventional names.
- Avoid speculative abstractions, extension points, dependencies, configuration, and automation.
- Do not introduce a new runtime technology or structural area without demonstrated need.
- Add or update tests when observable behavior changes.
- Update documentation in the same change when behavior, architecture, constraints, or public usage changes.
- Update `docs/project/status.md` or `docs/project/capabilities.md` when a material deliverable or capability actually changes state.
- Create or update focused module context only when the subsystem complexity justifies it.
- Update activated security/compliance documentation when the change materially affects an authoritative requirement, control expectation, audit obligation, exception, or accepted risk.

## Cross-Agent Durability

Follow the [AI collaboration contract](collaboration.md). Do not leave project-critical decisions, unresolved constraints, progress state, or handoff information only in an assistant chat or private memory. Put durable knowledge in the appropriate repository document, issue, decision record, source, test, or commit.

## Before Reporting Completion

- Review the change with the [AI review checklist](review-checklist.md).
- Run the relevant validation available in the repository.
- When repository documentation or agent/tooling configuration changed, run `python scripts/validate_repository.py` when the script is available.
- Treat CI warnings as prompts for review, not as proof that a documentation change is required.
- Verify documentation, project state, and implementation agree where affected.
- Refresh Graphify after material source changes when the adopting project's integration requires it.
- Report validation performed and any validation that could not be performed.
- Report assumptions, unresolved questions, and remaining risks explicitly.
- Summarize only the changes made; do not imply unrelated guarantees.
