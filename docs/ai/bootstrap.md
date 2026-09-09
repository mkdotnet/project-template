# AI Bootstrap

Use this contract before planning or editing the repository. The goal is enough verified context to complete the task safely, not maximum context.

## Minimal Entry Context

1. Read the repository [README](../../README.md).
2. Read `mk.json` only as needed to identify the implementation root and repository entry points.
3. Identify the requested task and affected area.
4. Load only the additional context required below.

Do not read the complete documentation tree, all ADRs/RFCs, all modules, or Git history by default.

## Implementation Boundary

The complete product implementation is under the root declared by `mk.json` (`implementation/` in the template). Treat everything below that boundary as framework/project-owned. Do not assume internal names such as `src/`, `tests/`, `main/`, `modules/`, `app/`, or `ml/` until the actual implementation proves they exist.

Repository governance may inspect implementation, but do not introduce product build/run/test dependencies on `docs/`, AI instruction files, Graphify output, or repository-validation tooling.

## Context Routing

### Implementation or Feature Work
Read relevant coding/architecture/module context only when needed, then inspect the exact implementation source and tests. Use Graphify first for structural discovery when the affected area is not already known.

### Debugging
1. Reproduce or establish concrete failure evidence.
2. Use Graphify to locate execution path, callers, dependencies, and impact area.
3. Read focused module context if it exists.
4. Read exact implementation source/tests and relevant runtime evidence.
5. Read only decisions needed to explain surprising constraints.
6. Identify root cause before editing.
7. Add/update regression coverage when practical.
8. Apply the smallest safe fix and validate it.

### Refactoring
Identify responsibility, observable behavior, callers/dependencies, public/persistence/message/API contracts, relevant tests, and only the decisions needed for the affected boundary. Preserve behavior unless change is requested and prefer incremental refactoring over broad redesign.

Do not add abstractions, mediators, factories, eventing, interfaces, or layers without a demonstrated need.

### Architecture Work
Read architecture overview, relevant module/decision context, and enough implementation to verify current reality. Record material durable decisions.

### Planning or Delivery-State Work
Read vision, roadmap, status, and capabilities. Keep fine-grained tasks in the tracker.

### Documentation Work
Read the documentation standard and target authoritative document; inspect implementation only when needed to verify behavior.

### Security or Compliance Work
If `docs/security/` is active, read only relevant requirements, linked architecture/decisions, and exact implementation evidence. Never infer regulatory requirements from the generic template.

## Code Intelligence

Follow the [code-intelligence policy](../tooling/code-intelligence.md) and [Graphify MCP setup](../tooling/mcp-setup.md).

Graphify should normally map the implementation boundary rather than the entire governance/documentation tree. Treat graph output as derived context and verify exact behavior in implementation source/tests before editing.

At the first structural use in a session, confirm the expected MCP server and call `graph_stats`. Reachability is not freshness. Refresh the implementation graph after material implementation changes before relying on stale structural results.

Sourcegraph remains optional.

## Context Efficiency and Stop Rules

- Start with minimum context and expand only for a concrete uncertainty.
- Prefer structural discovery over directory-by-directory reading.
- Do not inspect unrelated implementation areas.
- Stop exploration once enough verified context exists for a safe change.
- Prefer repository evidence over speculation.
- Do not redesign architecture unless the requested outcome or verified constraint requires it.
- Use Git history/old PRs/issues only when current implementation, tests, docs, and decisions do not explain an important constraint.

## Before Editing

- Inspect actual implementation conventions before choosing file locations.
- Preserve unrelated work.
- Identify the smallest file set needed.
- Confirm current requirements/non-goals/contracts.
- State material assumptions that cannot be verified.

## While Editing

- Follow the owning framework/project conventions inside `implementation/`.
- Keep changes scoped and direct.
- Avoid speculative dependencies, configuration, automation, and structure.
- Add/update tests when observable behavior changes.
- Update affected docs and project state when material behavior/capabilities change.
- Update module or security context only when maintained/justified.

## Cross-Agent Durability

Follow the [AI collaboration contract](collaboration.md). Do not leave project-critical decisions, state, or handoff knowledge only in an assistant chat.

## Before Reporting Completion

- Review with the [AI review checklist](review-checklist.md).
- Run relevant implementation validation.
- When repository docs/agent/tooling config changed, run `python .github/scripts/validate_repository.py` when available.
- Review CI warnings rather than mechanically editing state docs.
- Verify documentation, project state, and implementation agree where affected.
- Refresh Graphify after material implementation changes when required.
- Report performed/unperformed validation, assumptions, unresolved questions, and remaining risks.
