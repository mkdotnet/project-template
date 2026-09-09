# AI Bootstrap

Use this contract before planning or editing the repository. The goal is enough verified context to complete the task safely, not maximum context.

## Minimal Entry Context

1. Read the repository [README](../../README.md).
2. Read `mk.json` only as needed to identify the implementation root, validation path, and repository entry points.
3. Identify the requested task and affected area.
4. Load only the additional context required below.

Do not read the complete documentation tree, all ADRs/RFCs, all modules, or Git history by default.

## Implementation Boundary

The complete product implementation is under the root declared by `mk.json` (`implementation/` in the template). Treat everything below that boundary as framework/project-owned. Do not assume internal names such as `src/`, `tests/`, `main/`, `modules/`, `app/`, or `ml/` until actual implementation proves they exist.

Repository governance may inspect implementation, but do not introduce product restore/build/run/test dependencies on `docs/`, AI files, Graphify output, or MK lifecycle/validation tooling.

## Context Routing

### Implementation or Feature Work
Read relevant coding/architecture/module context only when needed, then inspect exact implementation source/tests. Use Graphify first for structural discovery when the affected area is not already known.

### Debugging
1. Establish concrete failure evidence.
2. Use Graphify to locate execution path, callers, dependencies, and impact area.
3. Read focused module context if maintained.
4. Read exact implementation source/tests and relevant runtime evidence.
5. Read only decisions needed to explain surprising constraints.
6. Identify root cause before editing.
7. Add/update regression coverage when practical.
8. Apply the smallest safe fix and validate it.

### Refactoring
Identify responsibility, observable behavior, callers/dependencies, external contracts, relevant tests, and only decisions needed for the affected boundary. Preserve behavior unless change is requested and prefer incremental refactoring over broad redesign.

Do not add abstractions, mediators, factories, eventing, interfaces, or layers without demonstrated need.

### Architecture Work
Read architecture overview, relevant module/decision context, and enough implementation to verify reality. Record material durable decisions.

### Planning or Delivery-State Work
Read vision, roadmap, status, and capabilities. Keep fine-grained tasks in the tracker.

### Documentation Work
Read the documentation standard and target authoritative document; inspect implementation only when needed to verify behavior.

### Security or Compliance Work
If `docs/security/` is active, read only relevant requirements, linked architecture/decisions, and exact implementation evidence. Never infer regulatory requirements from the generic template.

## Code Intelligence

Follow the [code-intelligence policy](../tooling/code-intelligence.md) and [Graphify MCP setup](../tooling/mcp-setup.md).

Graphify should normally map the implementation boundary rather than the governance/documentation tree. Treat graph output as derived context and verify exact behavior in implementation source/tests before editing.

At first structural use, confirm expected MCP availability and call `graph_stats`. Reachability is not freshness. Refresh the implementation graph after material implementation changes before relying on stale structural results.

Sourcegraph remains optional.

## Context Efficiency and Stop Rules

- Start with minimum context and expand only for concrete uncertainty.
- Prefer structural discovery over directory-by-directory reading.
- Do not inspect unrelated implementation areas.
- Stop once enough verified context exists for a safe change.
- Prefer repository evidence over speculation.
- Do not redesign architecture unless the requested outcome or verified constraint requires it.
- Use history/old PRs/issues only when current evidence cannot explain an important constraint.

## Before Editing

- Inspect actual implementation conventions before choosing file locations.
- Preserve unrelated work.
- Identify the smallest file set needed.
- Confirm current requirements/non-goals/contracts.
- State material assumptions that cannot be verified.

## While Editing

- Follow the owning framework/project conventions inside the implementation boundary.
- Keep changes scoped and direct.
- Avoid speculative dependencies, configuration, automation, and structure.
- Add/update tests when observable behavior changes.
- Update affected docs/project state only when materially affected.

## Lifecycle Tooling

When `.mk/scripts/` is installed, use [lifecycle tooling](../tooling/lifecycle-scripts.md) rather than duplicating session checks manually:

- `Start-MKWork.ps1` before substantial work;
- `Test-MKProject.ps1` during work;
- `Complete-MKWork.ps1` before commit/push/handoff.

The validator path is metadata-driven (`mk.json.validation.script`); do not hard-code `.github/scripts/` or `.mk/scripts/` in project-specific guidance.

## Cross-Agent Durability

Follow the [AI collaboration contract](collaboration.md). Do not leave project-critical decisions, state, or handoff knowledge only in assistant chat.

## Before Reporting Completion

- Review with the [AI review checklist](review-checklist.md).
- Run relevant implementation validation.
- Run the repository validator or `Complete-MKWork.ps1` when available.
- Review warnings rather than mechanically editing state docs.
- Verify docs/state/implementation agree where affected.
- Refresh Graphify after material implementation changes when required.
- Report performed/unperformed validation, assumptions, unresolved questions, and remaining risks.
