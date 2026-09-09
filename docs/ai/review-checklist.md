# AI Review Checklist

Use this checklist before presenting or publishing an AI-assisted change. Mark an item not applicable only when its category genuinely does not affect the change.

## Scope and Context Efficiency

- [ ] The change addresses the requested outcome and no unrelated work.
- [ ] Modified files are the minimum reasonable set.
- [ ] Context was expanded only when a concrete uncertainty required it.
- [ ] Unrelated modules, all-document scans, and broad history searches were avoided unless justified.
- [ ] Assumptions and unresolved requirements are reported.
- [ ] Existing unrelated work is preserved.

## Architecture

- [ ] The change follows documented structure, boundaries, and dependency direction.
- [ ] New boundaries or structural concepts have a demonstrated need.
- [ ] Material architectural decisions are documented.
- [ ] No parallel source of project knowledge or tool-specific rule set is introduced.

## Simplicity

- [ ] The implementation is the smallest clear solution for current requirements.
- [ ] No speculative abstraction, extension point, configuration, dependency, or automation is added.
- [ ] Refactoring preserves observable behavior unless behavior change was requested.
- [ ] Names and control flow are conventional and understandable.
- [ ] Obsolete or duplicated guidance is not retained.

## Correctness

- [ ] Expected behavior and important failure paths are handled.
- [ ] Relevant edge cases and inputs are considered.
- [ ] For bug fixes, available evidence supports the identified root cause.
- [ ] Errors preserve useful context and are not silently ignored.
- [ ] Validation results support the stated outcome.

## Code Intelligence

- [ ] Graphify was used for structural discovery when caller/dependency/impact knowledge was needed and the project integration was available.
- [ ] Derived Graphify or Sourcegraph context was verified against exact source before behavioral changes.
- [ ] Material source changes were followed by the project's required Graphify refresh/update step when applicable.
- [ ] Stale or unavailable structural-index conditions are reported rather than hidden.

## Security

- [ ] Secrets, credentials, tokens, and sensitive data are not committed or logged.
- [ ] Inputs, authorization boundaries, and data exposure are considered where applicable.
- [ ] New dependencies and external interactions are justified and assessed.
- [ ] Failure messages do not expose unnecessary sensitive details.

## Testing

- [ ] Tests cover new or changed observable behavior where applicable.
- [ ] Bug fixes add or update regression coverage when practical.
- [ ] Relevant existing tests and checks pass.
- [ ] Tests are deterministic, isolated, and meaningful.
- [ ] Missing or unperformed validation is reported.

## Documentation and Project State

- [ ] Behavior, architecture, usage, and constraints are documented where affected.
- [ ] Material milestone/deliverable state changes are reflected in `docs/project/status.md`.
- [ ] Material capability changes are reflected in `docs/project/capabilities.md`.
- [ ] Complex subsystem context is updated only when a maintained module document exists or is now justified.
- [ ] Relative links and referenced paths are valid.
- [ ] The README remains an introduction rather than a duplicate knowledge source.

## Backward Compatibility

- [ ] Existing public behavior, data, message, API, persistence, and documented usage remain compatible when required.
- [ ] Any intentional breaking change is explicit, justified, and documented.
- [ ] Migration impact is addressed when applicable.

## AI-Context Consistency

- [ ] The change follows the [AI bootstrap](bootstrap.md).
- [ ] Cross-agent durable knowledge follows the [collaboration contract](collaboration.md).
- [ ] Project vision, architecture, standards, decisions, project state, module context, and implementation agree where relevant.
- [ ] New guidance does not contradict or unnecessarily duplicate existing context.
- [ ] Assumptions, unresolved risks, and follow-up needs are clearly reported in durable form when another contributor will need them.
