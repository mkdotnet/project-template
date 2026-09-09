# Template Changelog

This file tracks changes to the MKDotNet project template itself, not application or product releases in adopting repositories.

## 0.7.0 - 2026-09-09

- Reframed the template as a technology-neutral governance/documentation/AI overlay rather than an application source skeleton.
- Added `implementation/` as the single physical boundary for the complete product implementation while leaving its internal topology project-defined.
- Removed generic root `src/`, `tests/`, `samples/`, and `tools/` placeholders so framework-native layouts such as ABP, Android, Clean Architecture, Python/ML, Unity, and polyglot repositories can remain intact.
- Moved repository-contract validation under `.github/scripts/` so repository support does not compete with product implementation structure.
- Made the project-state advisory read the implementation root from `mk.json` instead of hard-coding `src/`.
- Defined a one-way dependency rule: repository governance may inspect implementation, while implementation must not depend on governance artifacts to restore, build, test, run, or package the product.
- Scoped Graphify structural analysis to the implementation boundary by default while retaining repository-local graph output and MCP access.
- Added ADR 0005 and marked earlier implementation-layout clauses as superseded where applicable.

## 0.6.0 - 2026-09-09

- Added lightweight GitHub Actions repository-contract validation with no third-party Python package dependency.
- Added hard validation for repository-relative Markdown links across root agent/readme entry points and `docs/`.
- Added non-blocking PR advisories when implementation changes may have missed a material project-state update.
- Added warning-only heuristics for oversized or substantially duplicated tool-specific configuration while keeping semantic contradiction a review responsibility.
- Defined `docs/security/` as a conditional, uncreated security/compliance documentation area.
- Added project-scoped Graphify MCP setup for Claude Code, Cursor, and Codex.

## 0.5.0 - 2026-09-09

- Added one canonical context contract for Codex, Claude Code, and Cursor.
- Added progressive context loading, project-state documents, developer/user guides, module context, and Graphify baseline policy.

## 0.4.0 - 2026-07-26

- Clarified template creation and synchronization lifecycle.

## 0.3.0 - 2026-07-26

- Added root agent discovery, template version history, MIT license, and pull-request template.
