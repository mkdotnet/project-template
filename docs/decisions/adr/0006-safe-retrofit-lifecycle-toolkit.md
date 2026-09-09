# ADR 0006: Safe Retrofit and Lifecycle Toolkit

## Status

Accepted

## Context

The template is intended not only for new repositories but also for existing and partially implemented projects. Manually relocating a framework workspace under `implementation/`, copying governance files, configuring Graphify, installing repository validation, and remembering lifecycle checks creates avoidable error and is difficult to delegate to a junior developer.

A fully automatic migration is also unsafe. Some root items are repository metadata or durable governance, while Git submodules, secret-bearing environment files, symlinks, and path collisions require human judgment. Project-specific README, architecture, status, and capability documents must not be silently replaced with generic template content.

## Decision

- Add `Initialize.ps1` at repository root as the guided bootstrap for retrofitting an existing repository.
- Add `Initialize-MKProject.cmd` as a beginner-friendly Windows launcher.
- Keep canonical toolkit source under `.mk/toolkit/`; installing into an adopting project copies runnable tooling to `.mk/scripts/`.
- The bootstrap must preview migration before changing paths.
- Keep Git/repository/governance/tool roots outside `implementation/`, including `.git`, `.github`, `.mk`, `docs`, `graphify-out`, assistant configuration, repository-wide Git/editor configuration, root AI entry points, README, and `mk.json`.
- Treat other ordinary root framework/build/product content as migration candidates into `implementation/` when the destination does not already exist.
- Do not automatically move Git submodule roots or `.gitmodules`, likely credential/secret-bearing files, private key containers, symlinks/reparse points, or colliding paths. Report them as `MANUAL`.
- Keep root Markdown documents outside the automatic move so they can be deliberately consolidated into the documentation model instead of being mistaken for implementation source.
- Prefer a clean Git working tree before migration and clearly warn when existing changes make recovery less obvious.
- Download the selected template ref with Git so existing Git credentials can also work with non-public repository access.
- Apply missing governance/tooling files without blindly overwriting differing project-specific durable documents.
- Install Graphify integrations and MCP only as far as current state allows. Do not create active MCP configuration that assumes a graph exists when `graphify-out/graph.json` is absent.
- Provide start, during-work, completion, and template-sync scripts.
- Keep framework-specific build/test commands project-defined through `mk.json`; the generic toolkit does not infer the implementation technology.
- Write local machine-readable/human-readable follow-up reports under `.mk/reports/` and keep that path ignored by Git.

## Consequences

### Positive

- A junior developer can apply the standard workflow through one guided entry point.
- Existing projects gain the implementation boundary, AI/docs governance, Graphify path, and validation workflow with fewer manual steps.
- Migration is conservative around Git metadata, secrets, submodules, links, and collisions.
- Project-specific knowledge is preserved instead of being overwritten by template defaults.
- Start/middle/end lifecycle checks reduce drift after initial adoption.
- The toolkit remains technology-neutral.

### Negative

- The template contains additional maintenance tooling under `.mk/toolkit/`.
- Migration classification is intentionally conservative and can leave some items for manual review.
- Windows convenience uses PowerShell and a CMD launcher; non-Windows users run the PowerShell scripts directly with an available PowerShell runtime.
- The toolkit cannot prove a framework continues to work after its root moves; the project's own restore/build/test validation remains necessary.

## Alternatives Considered

- **Require manual adoption only:** Rejected because the process is repeatable enough to automate safely in large part.
- **Move every non-template root item automatically:** Rejected because submodules, secrets, links, and ambiguous repository files can be damaged or misplaced.
- **Detect the framework and run guessed build/test commands:** Rejected because the template is intentionally technology-neutral and guesses can be destructive or misleading.
- **Overwrite all template-managed documentation on retrofit:** Rejected because adopting repositories own their project-specific durable context.
- **Use a single large one-off script with no lifecycle tools:** Rejected because ongoing start/check/complete/sync behavior provides recurring value after migration.

## Review Conditions

Review this decision if migration heuristics create recurring false classifications, supported projects need additional protected root categories, Graphify setup mechanics change materially, or a cross-platform bootstrap mechanism becomes substantially simpler and safer than the current PowerShell-based workflow.
