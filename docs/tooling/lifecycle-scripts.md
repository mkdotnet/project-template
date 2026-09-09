# MK Project Lifecycle Toolkit

## Purpose

The lifecycle toolkit applies and maintains the MK repository-governance overlay without assuming .NET, ABP, Android, Python, Unity, or another implementation technology. The product remains under the implementation root declared by `mk.json`; framework-specific topology and validation commands remain project-owned.

## Bootstrap entry points

`Initialize.ps1` is the guided repository-root bootstrap for an existing or half-built project. `Initialize-MKProject.cmd` is a Windows launcher intended for less experienced developers and invokes the PowerShell bootstrap with an execution-policy bypass for that process only.

The bootstrap presents a migration preview before moving files. It keeps repository/governance concerns at root, including `.git`, `.github`, `.mk`, `docs`, Graphify output, assistant configuration, repository-wide editor/Git configuration, README/AI entry points, and `mk.json`. Ordinary framework/build/product content is moved under `implementation/` when safe.

The bootstrap intentionally leaves the following for manual review rather than guessing:

- Git submodule metadata and submodule roots;
- real `.env` or other likely credential-bearing files;
- private key/certificate containers;
- symlinks/reparse points;
- destination collisions;
- project-specific root Markdown that may need consolidation into `docs/`.

A clean Git working tree is strongly preferred before migration because it provides the clearest recovery point.

## Toolkit source and installation

The canonical toolkit source is `.mk/toolkit/` in this repository. During retrofit the bootstrap clones the selected template ref and installs runnable copies into the target repository at `.mk/scripts/`. Local reports are written under `.mk/reports/` and should not be committed.

## Script set

| Script | When | Responsibility |
| --- | --- | --- |
| `Initialize-MKProject.ps1` | first adoption / repair | Apply missing governance files, align `mk.json`, install validator/workflow, preserve differing project-specific docs, and report manual work. |
| `Configure-MKGraphify.ps1` | initial Graphify setup | Register project-scoped Graphify integrations and create MCP config only after a real graph exists. |
| `Start-MKWork.ps1` | start of substantial work | Check working tree, metadata, repository validation, and Graphify readiness. |
| `Test-MKProject.ps1` | during work | Run health checks and optionally project-defined implementation validation commands. |
| `Complete-MKWork.ps1` | before commit/push/handoff | Run repository/implementation validation, `git diff --check`, state reminders, and Graphify freshness reminders. |
| `Sync-MKTemplate.ps1` | periodic maintenance | Compare/update template-owned tooling while leaving customized project guidance for deliberate review. |

## Technology-neutral implementation validation

The toolkit never guesses `dotnet test`, Gradle, pytest, npm, Unity, or another build system. A project can opt in through `mk.json`:

```json
{
  "implementation": {
    "root": "implementation",
    "topology": "project-defined",
    "validation": {
      "commands": [
        "dotnet test implementation/MyProject.slnx -c Release"
      ]
    }
  }
}
```

Commands execute from repository root. Define only commands that are valid for the actual project.

## Graphify lifecycle

The toolkit can install the MCP-enabled Graphify package and project-scoped assistant integrations. Initial graph construction remains an assistant workflow against the implementation boundary. If `graphify-out/graph.json` does not exist, MCP config is not created as though the graph were ready.

After graph creation, rerun `Configure-MKGraphify.ps1`. For structural work, confirm MCP reachability with `graph_stats`; reachability does not prove freshness.

## Daily usage

```powershell
.\.mk\scripts\Start-MKWork.ps1
.\.mk\scripts\Test-MKProject.ps1
.\.mk\scripts\Complete-MKWork.ps1
```

Use `Test-MKProject.ps1 -RunImplementationValidation` when project validation commands are configured. Use `Sync-MKTemplate.ps1` periodically to review newer template tooling/guidance.

`FAIL` is a mechanical blocker. `MANUAL` means the script intentionally refused to guess. `WARN` deserves review but is not automatically a failure.
