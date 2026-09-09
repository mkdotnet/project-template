# Template Adoption and Synchronization Guide

## Purpose

This guide explains how to apply the template as a governance/documentation/AI overlay while keeping application implementation independent and framework-native.

## Preferred path for an existing project

For an existing or half-built repository, use the repository-root `Initialize.ps1` guided bootstrap. On Windows, `Initialize-MKProject.cmd` provides the simplest launcher for a less experienced developer.

The bootstrap previews migration before moving anything, creates `implementation/`, moves ordinary framework/build/product roots there when safe, downloads the current `.mk/toolkit/` from this repository, installs runnable scripts under `.mk/scripts/`, applies missing governance files without blindly overwriting differing project-specific docs, guides Graphify/MCP setup, and runs a health check.

Prefer a clean Git commit/stash before migration so the pre-migration state is easy to recover.

## Adoption Principles

- The template owns repository governance and durable context, not application topology.
- The complete product workspace lives under the implementation root recorded in `mk.json` (`implementation/` by default).
- The selected framework/generator owns everything inside that boundary.
- Keep implementation able to restore, build, test, run, and package without depending on repository-governance artifacts as far as practical.
- Keep AI context progressive and durable knowledge in the repository rather than assistant chats.
- The template is technology-neutral; .NET/ABP, Android, Python/ML, Unity, and regulated projects are use cases rather than hard-coded assumptions.

## Migration classification

The guided bootstrap keeps repository/governance items at root, including Git metadata, `.github`, `.mk`, `docs`, Graphify output, assistant configuration, repository-wide Git/editor settings, README/AI entry points, and `mk.json`.

Other ordinary root framework/build/product items become candidates for `implementation/`. The bootstrap refuses to guess for:

- `.gitmodules` and submodule roots;
- real `.env`/likely credential files;
- private key/certificate containers;
- symlinks/reparse points;
- destination collisions;
- root Markdown that may be durable project documentation rather than implementation.

Review every `MANUAL` result after the run.

## Implementation examples

These are examples only:

```text
# ABP Modular Monolith
implementation/
├── main/
├── modules/
├── etc/
└── <solution/framework files>

# .NET Clean Architecture
implementation/
├── src/
├── tests/
└── <solution files>

# Android
implementation/
├── app/
├── gradle/
├── build.gradle.kts
└── settings.gradle.kts

# Polyglot
implementation/
├── <framework-owned roots>
├── ml/
├── contracts/
└── <project support roots>
```

## Project context

Rewrite project vision, roadmap, status, capabilities, and architecture for the adopting project. Existing differing project-specific documents are not overwritten automatically; merge upstream guidance deliberately.

Refine coding standards after technologies are chosen. Activate `docs/security/` only when verified requirements justify it.

## Shared AI and Graphify

Keep `AGENTS.md` and `CLAUDE.md` as thin adapters to the canonical bootstrap. Initialize Graphify against the implementation boundary rather than the governance tree. Follow the [code-intelligence policy](../tooling/code-intelligence.md), [Graphify MCP setup](../tooling/mcp-setup.md), and [lifecycle toolkit](../tooling/lifecycle-scripts.md).

Do not create active Graphify MCP configuration that points to a missing graph. Build the graph first, then configure/reload clients and verify `graph_stats` when structural work begins.

## Repository and implementation validation

Repository-contract validation is template-owned. The exact local validator path is recorded in `mk.json.validation.script`; the template repository itself uses `.github/scripts/validate_repository.py`, while toolkit-installed adopting projects normally use `.mk/scripts/validate_repository.py`.

Application build/test/deployment checks remain project-defined. Add `implementation.validation.commands` only after the project's real commands are known.

## Daily lifecycle

```powershell
.\.mk\scripts\Start-MKWork.ps1
.\.mk\scripts\Test-MKProject.ps1
.\.mk\scripts\Complete-MKWork.ps1
```

Use `Sync-MKTemplate.ps1` periodically to compare with upstream and update template-owned tooling deliberately.

## Ongoing Definition of Done

For a material change, apply the smallest relevant set: implementation/config updated; relevant tests/validation run; docs/state updated when materially affected; Graphify refreshed when structural data is used; repository validation passed; and unresolved follow-up recorded durably.

## Validation Checklist

- [ ] Repository identity and `mk.json` describe the real project.
- [ ] `implementation/` contains the complete real product workspace.
- [ ] Product build/test/run does not depend on governance files without an explicit exception.
- [ ] No generic root `src/`, `tests/`, `samples/`, or `tools/` was introduced by template convention.
- [ ] `MANUAL` migration items were reviewed.
- [ ] Project vision, roadmap, status, capabilities, and architecture reflect reality.
- [ ] Graphify analyzes the intended implementation boundary and MCP is reachable when used.
- [ ] AI adapters remain thin and consistent.
- [ ] Repository validation passes and warnings were reviewed.
- [ ] No secrets or sensitive data were committed.
