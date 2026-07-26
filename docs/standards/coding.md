# Coding Standards

These baseline standards apply until an adopting project documents more specific rules. Established language and repository conventions take precedence where they are stricter and do not conflict with project decisions.

## Naming

- Use clear, conventional names that describe intent.
- Follow the chosen language's standard casing and file naming conventions.
- Avoid abbreviations unless they are widely understood in the domain.
- Name tests after observable behavior or the scenario they verify.
- Keep terminology consistent with project documentation and user-facing concepts.

## Formatting

- Use UTF-8, LF line endings, and a final newline.
- Follow `.editorconfig` and the standard formatter for the selected technology.
- Prefer automated, deterministic formatting once the project adopts suitable tooling.
- Do not mix formatting-only changes with behavioral changes unless required.

## Error Handling

- Handle errors at the layer that can add context, recover, or translate them meaningfully.
- Preserve the original cause when wrapping or translating an error.
- Do not silently ignore failures.
- Use explicit failure results for expected conditions and exceptions or equivalent mechanisms for exceptional conditions, following language conventions.
- Avoid exposing sensitive implementation details in user-facing errors.

## Logging

- Log information that supports diagnosis or operation, not routine noise.
- Use structured fields when the selected logging approach supports them.
- Choose severity consistently and avoid logging the same failure at multiple layers.
- Never log secrets, credentials, tokens, or unnecessary personal data.
- Keep logs actionable and include relevant context without duplicating payloads.

## Testing

- Test observable behavior and important boundaries.
- Add or update tests with behavior changes and defect fixes.
- Keep tests deterministic, isolated, and readable.
- Prefer small tests close to the behavior; add broader tests only where integration risk justifies them.
- Do not weaken assertions or remove coverage merely to make a change pass.

## Comments

- Explain why a non-obvious decision or constraint exists.
- Do not restate code that is already clear.
- Keep comments accurate when behavior changes.
- Prefer clearer code and focused documentation over lengthy inline explanation.
- Use TODO comments only with specific, actionable context.

## Dependency Management

- Add a dependency only for a demonstrated requirement.
- Prefer platform or existing project capabilities when they remain clear and maintainable.
- Evaluate maintenance, security, licensing, size, and operational impact before adoption.
- Pin or constrain versions according to the selected ecosystem's accepted practice.
- Remove unused dependencies and document dependencies that materially shape architecture.

## Review Rules

- Keep each change focused on one coherent purpose.
- Verify correctness, failure behavior, security implications, tests, and documentation.
- Require clear justification for new dependencies, public surface changes, and architectural boundaries.
- Preserve backward compatibility unless a breaking change is explicitly approved and documented.
- Resolve contradictory guidance instead of adding another rule.
- Review the change against the [AI review checklist](../ai/review-checklist.md) when AI assistance is used.

## Simplicity and Abstraction Rules

- Implement the smallest clear solution that meets current requirements.
- Prefer direct code and conventional structures over indirection.
- Introduce an abstraction only when repeated behavior or a stable boundary demonstrates its value.
- Do not design extension points, configuration, or generic layers for hypothetical use.
- Keep interfaces narrow and dependencies explicit.
- Remove obsolete paths rather than maintaining unused flexibility.
