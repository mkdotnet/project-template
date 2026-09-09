# ADR 0002: Automated Repository Contract Validation

## Status

Accepted; source-change scope updated by ADR 0005

## Context

The repository defines durable collaboration, documentation, project-state, and AI-context rules, but deterministic automation can catch selected mechanical drift. Relative-link existence is deterministic. Whether an implementation change materially changes project status is contextual. Semantic contradiction between tool-specific config and canonical guidance remains a review problem.

## Decision

- Use `.github/workflows/repository-validation.yml` with the standard-library validator at `.github/scripts/validate_repository.py`.
- Run validation on pull requests, pushes to `main`, and manual dispatch.
- Hard-fail unresolved repository-relative Markdown links in `README.md`, `AGENTS.md`, `CLAUDE.md`, and `docs/**/*.md`.
- Read the implementation root from `mk.json` (default `implementation`). On pull requests, emit a non-blocking warning when that boundary changes without a change to `docs/project/status.md` or `docs/project/capabilities.md`.
- The warning requires manual confirmation; it does not imply every implementation edit requires a project-state edit.
- Keep tool-config drift heuristics warning-only: unusually large tool-specific files and substantial verbatim copied blocks may be signaled, but semantic contradiction and paraphrased drift remain human/AI review responsibilities.
- Use GitHub Actions warnings/job summaries rather than PR comments.
- Do not require local pre-commit hooks.
- Keep repository-contract validation separate from application-specific build, test, deployment, and release CI.

## Consequences

### Positive

- Broken documentation links fail early.
- Material-state omissions receive a low-noise reminder independent of framework source layout.
- The validator has no third-party Python dependency.
- Renaming or explicitly changing the implementation boundary in metadata does not require hard-coded CI logic.

### Negative

- The workflow assumes GitHub Actions and `python3` on the runner.
- Link validation checks target existence, not all Markdown anchor semantics.
- Heuristics can miss semantic drift and may occasionally warn unnecessarily.

## Alternatives Considered

- **Hard-code `src/` as the source root:** Superseded by ADR 0005 because implementation topology is framework-owned.
- **Use local pre-commit hooks:** Rejected because installation is not reliable across tools and machines.
- **Use a third-party link checker:** Rejected because the current requirement is small enough for the standard library.
- **Use an LLM in CI for contradiction detection:** Rejected because of cost, nondeterminism, credentials, and false confidence.
- **Hard-block implementation changes without project-state edits:** Rejected because bug fixes and refactors may not change capability state.

## Review Conditions

Review this decision if the validator becomes noisy, Markdown needs exceed the lightweight parser, repository hosting changes, project-state semantics change, or unrelated policy/build concerns begin accumulating in this workflow.
