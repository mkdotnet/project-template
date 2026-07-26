# AI Bootstrap

Use this sequence before planning or editing the repository.

## Required Context

1. Read the repository [README](../../README.md) for purpose and entry points.
2. Read the [project vision](../project/vision.md) for goals, constraints, and non-goals.
3. Read the [architecture overview](../architecture/overview.md) for structure, boundaries, and extension rules.
4. Read the standards relevant to the task, beginning with the [coding standards](../standards/coding.md).
5. Read relevant decisions under `docs/decisions/adr/` and proposals under `docs/decisions/rfc/`.

## Before Editing

- Inspect existing files, code, tests, and naming patterns related to the task.
- Check the working tree and preserve unrelated changes.
- Identify the smallest set of files needed for the requested outcome.
- Confirm that the change supports current requirements and does not conflict with documented non-goals.
- State any material assumption that cannot be verified from the repository.

## While Editing

- Follow existing patterns unless there is a documented reason to change them.
- Keep changes scoped to the requested outcome.
- Prefer clear, direct implementations and conventional names.
- Avoid speculative abstractions, extension points, dependencies, configuration, and automation.
- Do not introduce a new technology or structural area without a demonstrated need.
- Add or update tests when behavior changes.
- Update documentation in the same change when behavior, architecture, constraints, or public usage changes.

## Before Reporting Completion

- Review the change with the [AI review checklist](review-checklist.md).
- Run the relevant validation available in the repository.
- Verify that documentation and implementation agree.
- Report validation performed and any validation that could not be performed.
- Report assumptions, unresolved questions, and remaining risks explicitly.
- Summarize only the changes made; do not imply unrelated guarantees.
