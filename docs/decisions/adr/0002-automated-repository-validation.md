# ADR 0002: Automated Repository Contract Validation

## Status

Accepted

## Context

The repository defines durable collaboration, documentation, project-state, and AI-context rules, but most of those rules have so far depended entirely on contributors and AI assistants remembering to follow them.

For a repository that moves between Codex, Claude Code, Cursor, and human maintenance, a small amount of deterministic automation can catch mechanical drift early without turning the template into a heavy governance framework.

Not every rule can be proved mechanically. Relative-link existence is deterministic. Whether a source change materially changes project status is contextual. Semantic contradiction between a tool-specific adapter and canonical architecture or standards is a meaning-level review problem and cannot be reliably established by a lightweight script.

## Decision

- Add a GitHub Actions workflow at `.github/workflows/repository-validation.yml`.
- Add `scripts/validate_repository.py`, implemented with the Python standard library and no third-party package dependency.
- Run validation on pull requests, pushes to `main`, and manual workflow dispatch.
- Hard-fail when a repository-relative Markdown link does not resolve in `README.md`, `AGENTS.md`, `CLAUDE.md`, or any Markdown file under `docs/`.
- On pull requests, emit a non-blocking GitHub Actions warning and job-summary notice when `src/` changes without a change to either `docs/project/status.md` or `docs/project/capabilities.md`. The warning requires manual confirmation; it does not imply those documents must change for every source edit.
- Scan text files under `.cursor/`, `.claude/`, and `.codex/` with two deliberately limited heuristics: unusually large tool-specific files and substantial verbatim multi-line blocks copied from `docs/architecture/`, `docs/standards/`, or `docs/ai/bootstrap.md`.
- Keep tool-config drift heuristics warning-only. Exact or substantial copied text can be signaled mechanically, but semantic contradiction, paraphrased duplication, stale intent, or a subtly divergent rule remains a human/AI review responsibility under `docs/ai/review-checklist.md`.
- Exclude clearly Graphify-owned generated skill/rule files from size-based drift noise; vendor-owned generated mechanics are reviewed through the code-intelligence policy rather than treated as project-authored rules.
- Use GitHub Actions warnings and the job summary instead of PR comments. This avoids write permissions, duplicate comments, and review-thread noise.
- Do not make a local pre-commit hook part of the baseline. Local hooks are not reliably installed or executed across different tools and machines.
- Keep the workflow limited to repository-contract validation. It does not prescribe application build, test, deployment, or runtime CI for adopting projects.

## Consequences

### Positive

- Broken internal documentation navigation fails early and deterministically.
- Source changes that may have missed a material status/capability update receive a visible reminder without creating false hard failures.
- Obvious copied project rules in tool-specific configuration can be surfaced before divergent instruction stores grow.
- The validation layer has no third-party Python dependency and remains separate from runtime technology choices.
- CI reinforces the repository contract without replacing focused human or AI review.

### Negative

- The template now includes one GitHub Actions workflow and therefore is no longer completely CI-free.
- The link checker intentionally validates target existence, not heading-anchor correctness or every edge case in the Markdown specification.
- Tool-config heuristics can miss paraphrased duplication and can still produce occasional false-positive warnings.
- The workflow assumes a GitHub-hosted Ubuntu runner with `python3` available; adopting projects using a different runner must preserve equivalent checks or deliberately revise this decision.

## Alternatives Considered

- **Rely only on the review checklist:** Rejected because deterministic link failures and change-shape warnings are cheap to automate and easy to forget manually.
- **Use local pre-commit hooks:** Rejected as the baseline because hook installation is not reliably shared across Codex, Claude Code, Cursor, and different machines.
- **Add a third-party Markdown/link-checking package:** Rejected because current requirements can be covered by a small standard-library script without another dependency or supply-chain surface.
- **Use an LLM in CI to detect semantic contradiction:** Rejected because it would add cost, nondeterminism, credentials, and false confidence without proving semantic consistency.
- **Hard-block every `src/` change that lacks a project-state edit:** Rejected because many bug fixes and refactors do not materially change roadmap or capability state.
- **Post a PR comment for every warning:** Rejected because GitHub Actions annotations and job summaries provide the signal without additional write permissions or comment churn.

## Review Conditions

Review this decision if:

- the script becomes noisy enough that warnings are routinely ignored;
- Markdown structure grows beyond the lightweight parser's reliable scope;
- adopting projects move away from GitHub Actions;
- a deterministic, low-dependency method becomes available for stronger tool-config consistency checks;
- project-state documents change location or semantics;
- the validation workflow begins accumulating unrelated build, release, or policy responsibilities.
