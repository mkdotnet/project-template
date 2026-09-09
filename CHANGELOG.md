# Template Changelog

This file tracks changes to the MKDotNet project template itself, not application or product releases in adopting repositories.

## 0.8.0 - 2026-09-09

- Added a guided repository-root `Initialize.ps1` for applying the template to existing/partial projects.
- Added `Initialize-MKProject.cmd` as a beginner-friendly Windows launcher.
- Added canonical lifecycle toolkit source under `.mk/toolkit/`, installed into adopting projects under `.mk/scripts/`.
- Added safe migration preview and automatic movement of ordinary framework/build/product roots into `implementation/`.
- Protected Git metadata, governance/docs, AI/tool configuration, Graphify output, and repository-wide configuration from automatic migration.
- Added manual-review handling for submodules, likely secret-bearing environment/key files, symlinks/reparse points, and destination collisions.
- Added Graphify/MCP guided setup, start-of-work, health-check, completion, and template-sync scripts.
- Kept project-specific build/test commands technology-neutral and opt-in through `mk.json`.
- Added lifecycle documentation and ADR 0006.

## 0.7.0 - 2026-09-09

- Reframed the template as a technology-neutral governance/documentation/AI overlay rather than an application source skeleton.
- Added `implementation/` as the single physical boundary for the complete product implementation while leaving its internal topology project-defined.
- Removed generic root `src/`, `tests/`, `samples`, and `tools` placeholders.
- Moved repository-contract validation under `.github/scripts/`.
- Made CI and Graphify implementation-root aware.
- Added ADR 0005.

## 0.6.0 - 2026-09-09

- Added lightweight GitHub Actions repository-contract validation.
- Added conditional security/compliance documentation contract.
- Added project-scoped Graphify MCP setup for Claude Code, Cursor, and Codex.

## 0.5.0 - 2026-09-09

- Added one canonical context contract for Codex, Claude Code, and Cursor.
- Added progressive context loading, project-state documents, developer/user guides, module context, and Graphify baseline policy.

## 0.4.0 - 2026-07-26

- Clarified template creation and synchronization lifecycle.

## 0.3.0 - 2026-07-26

- Added root agent discovery, template version history, MIT license, and pull-request template.
