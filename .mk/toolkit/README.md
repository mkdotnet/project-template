# MK Project Toolkit

PowerShell toolkit for retrofitting and maintaining repositories that use the MKDotNet `project-template` governance overlay.

## Recommended entry point

For an existing or half-built repository, run the repository-root `Initialize.ps1` bootstrap. It previews and safely migrates product/framework content under `implementation/`, downloads this toolkit from GitHub, applies the governance overlay, guides Graphify/MCP setup, and runs a final health check.

The toolkit source lives upstream under `.mk/toolkit/`. The bootstrap installs runnable copies into an adopting project under `.mk/scripts/`.

## Files

- `Initialize-MKProject.ps1` — apply/complete the governance overlay after migration.
- `Configure-MKGraphify.ps1` — install/register Graphify integrations and configure MCP after a graph exists.
- `Start-MKWork.ps1` — start-of-session checks.
- `Test-MKProject.ps1` — health checks during work and optional project validation.
- `Complete-MKWork.ps1` — end-of-work checks before commit/push/handoff.
- `Sync-MKTemplate.ps1` — compare with upstream and refresh template-owned tooling deliberately.
- `MK.Common.psm1` — shared helpers.
- `repository-validation.yml` — workflow payload for adopting projects.

## Safety model

The bootstrap keeps Git/repository/governance/tool-specific roots outside the product boundary, including `.git`, `.github`, `.mk`, `docs`, Graphify output, assistant configuration, README/AI entry points, `mk.json`, Git ignore/attributes, and repository-wide editor configuration.

Ordinary framework/build/product roots and files are moved under `implementation/` when there is no destination collision. Git submodules, real `.env` files, key/certificate files, symlinks/reparse points, and collisions are reported as `MANUAL` instead of being moved blindly.

The retrofit never blindly overwrites project-specific README, architecture, project-state, or similar durable context.

## Technology-neutral validation

The toolkit does not guess `dotnet`, Gradle, pytest, npm, Unity, or other commands. A project may define `implementation.validation.commands` in `mk.json`; those commands execute from repository root.
