# AI Review Checklist

Use this checklist before presenting or publishing an AI-assisted change. Mark an item not applicable only when its category genuinely does not affect the change.

## Scope

- [ ] The change addresses the requested outcome and no unrelated work.
- [ ] Modified files are the minimum reasonable set.
- [ ] Assumptions and unresolved requirements are reported.
- [ ] Existing unrelated work is preserved.

## Architecture

- [ ] The change follows the documented repository structure and dependency direction.
- [ ] New boundaries or structural concepts have a demonstrated need.
- [ ] Material architectural decisions are documented.
- [ ] No parallel source of project knowledge is introduced.

## Simplicity

- [ ] The implementation is the smallest clear solution for current requirements.
- [ ] No speculative abstraction, extension point, configuration, dependency, or automation is added.
- [ ] Names and control flow are conventional and understandable.
- [ ] Obsolete or duplicated guidance is not retained.

## Correctness

- [ ] Expected behavior and important failure paths are handled.
- [ ] Relevant edge cases and inputs are considered.
- [ ] Errors preserve useful context and are not silently ignored.
- [ ] Validation results support the stated outcome.

## Security

- [ ] Secrets, credentials, tokens, and sensitive data are not committed or logged.
- [ ] Inputs, authorization boundaries, and data exposure are considered where applicable.
- [ ] New dependencies and external interactions are justified and assessed.
- [ ] Failure messages do not expose unnecessary sensitive details.

## Testing

- [ ] Tests cover new or changed observable behavior where applicable.
- [ ] Relevant existing tests and checks pass.
- [ ] Tests are deterministic, isolated, and meaningful.
- [ ] Missing or unperformed validation is reported.

## Documentation

- [ ] Behavior, architecture, usage, and constraints are documented where affected.
- [ ] Relative links and referenced paths are valid.
- [ ] Guidance is concise, English-language, and internally consistent.
- [ ] The README remains an introduction rather than a duplicate knowledge source.

## Backward Compatibility

- [ ] Existing public behavior, data, and documented usage remain compatible.
- [ ] Any intentional breaking change is explicit, justified, and documented.
- [ ] Migration impact is addressed when applicable.

## AI-Context Consistency

- [ ] The change follows the [AI bootstrap](bootstrap.md).
- [ ] Project vision, architecture, standards, decisions, and implementation agree.
- [ ] New guidance does not contradict or unnecessarily duplicate existing context.
- [ ] Assumptions, unresolved risks, and follow-up needs are clearly reported.
