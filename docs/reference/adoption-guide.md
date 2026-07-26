# Template Adoption and Synchronization Guide

## Purpose

This guide explains how to create and adopt a project repository from this template and how to review later template updates deliberately. Steps 1 through 6 cover initial adoption; the Template Sync section remains ongoing maintenance guidance after adoption.

## Adoption Principles

- Treat the template as a starting point, not as a framework or permanent layer.
- Replace template statements with verified project context; do not copy them blindly into a real project.
- Keep only files and directories that communicate a current need.
- Add documentation, directories, dependencies, tooling, and automation only when actual project requirements justify them.
- Prefer clear, focused guidance over comprehensive-looking documents.
- Do not add sections merely to make documentation look complete.

## Step 1: Create the Project Repository

Create a new repository from the template using the repository hosting or copying method appropriate to the team. Preserve the initial structure long enough to review each area, but do not assume every placeholder must remain.

Native template generation may require a repository-level setting to be enabled on the source repository, and that setting may not be represented by tracked files. Confirm the prerequisite before attempting native generation. When native template generation is explicitly required, do not silently substitute cloning or copying Git history. If the prerequisite is missing, stop and report it rather than modifying the source repository without authorization.

Before implementation begins:

- Confirm the new repository has its own version-control history and access controls.
- Review all tracked files for template-specific names, links, and assumptions.
- Decide which placeholder areas represent real project needs.

## Step 2: Replace Repository Identity and Metadata

Update [README.md](../../README.md) with the adopting project's name, concise purpose, primary documentation entry points, and basic usage direction.

Update [mk.json](../../mk.json):

- Replace `name`, `description`, and `repository` with project-specific values.
- Confirm `type`, `documentationRoot`, and every entry point describe files the project actually uses.
- `templateVersion` records the template version used to initialize, or most recently synchronize, the repository. It is not the application or product release version.

Review the copied [LICENSE](../../LICENSE), replace the template copyright holder with the correct copyright holder for the adopting project, and confirm that the MIT License is appropriate. Do not publish the repository without reviewing its license and copyright notice.

Remove links and metadata that no longer apply. Do not retain MKDotNet template identity as if it described the adopting project.

## Step 3: Replace Template Project Context

Rewrite the [project vision](../project/vision.md) for the adopting project. Replace the template mission, vision, problem statement, audience, goals, non-goals, success criteria, constraints, assumptions, risks, and out-of-scope statements with real project context.

Use known information. Report unresolved assumptions explicitly, and omit ceremonial content that adds no useful meaning.

## Step 4: Refine Architecture and Engineering Standards

Refine the [architecture overview](../architecture/overview.md) so it describes the project's actual context, boundaries, dependency direction, important flows, extension rules, trade-offs, and current limitations.

After technologies are selected, refine the [coding standards](../standards/coding.md) with justified language, platform, or domain conventions. Preserve technology-neutral guidance that remains useful and remove rules that do not apply.

Follow the [documentation standard](../standards/documentation.md) when changing the documentation model. Review the [AI bootstrap](../ai/bootstrap.md) and [AI review checklist](../ai/review-checklist.md) so their reading order, validation, and reporting rules match the project.

## Step 5: Record Material Decisions

Use the [ADR template](templates/adr.md) to record a material architectural decision under `docs/decisions/adr/`. Describe the context, selected decision, consequences, alternatives, and conditions that should trigger review.

The copied `docs/decisions/adr/0001-repository-structure.md` records a decision made for the template repository; do not automatically retain it as project decision history. Before normal project work begins, remove it if the decision does not represent the project, or replace it with a project-specific ADR if the project explicitly adopts that structural decision. Do not preserve template decision records merely to keep numbering or directory structure.

A proposal that genuinely requires discussion before acceptance may use the [RFC template](templates/rfc.md) under `docs/decisions/rfc/`. Do not create an RFC for routine implementation work or a decision that has already been made.

## Step 6: Remove Unused Placeholder Areas

The placeholder directories `.github/`, `src/`, `tests/`, `samples/`, `scripts/`, `tools/`, `docs/assets/`, and empty decision areas are not mandatory. Remove a placeholder and its `.gitkeep` when the area does not communicate a real project need.

Do not populate an empty directory merely to preserve the template structure. Add an area later when a demonstrated requirement gives it a clear responsibility.

## Template Sync

`templateVersion` records the template version used to initialize the repository or the version most recently applied through a deliberate synchronization.

When the upstream template version increases, review the upstream template's `CHANGELOG.md`, evaluate each change, and apply only the changes that fit the project. Do not automatically overwrite project-specific documentation, architecture, standards, decisions, metadata, or configuration.

Update `templateVersion` only after the selected changes have been reviewed and applied. Synchronization is deliberate maintenance, not an automatic upgrade mechanism.

The template changelog records template history, not application or product releases. An adopting project may remove the copied `CHANGELOG.md` and its `changelog` entry point from `mk.json`, then consult the upstream template changelog for future synchronization reviews. It may retain the copied changelog only when that purpose remains explicit.

After initial adoption, make an explicit project decision about this copied guide; retention is not mandatory. Retain it when it will remain the project's deliberate template synchronization reference. When retained, keep its title and Purpose aligned with that ongoing role, and keep its README link and `adoptionGuide` entry point in `mk.json`. Remove the guide when future template synchronization will not use it, and also remove its README link and `adoptionGuide` entry point. Do not leave stale files, broken links, or stale metadata.

## Validation Checklist

- [ ] `README.md` identifies the adopting project and links to current entry points.
- [ ] `mk.json` contains project-specific metadata and valid paths.
- [ ] Native template-generation prerequisites were confirmed before generation, or a missing prerequisite was reported without substituting Git history or modifying the source repository without authorization.
- [ ] Guide retention, its README link, and the `adoptionGuide` entry point match the project's template synchronization decision.
- [ ] `docs/project/vision.md` describes the adopting project, not the template.
- [ ] `docs/architecture/overview.md` reflects current boundaries and limitations.
- [ ] `docs/standards/coding.md` matches selected technologies where choices exist.
- [ ] `docs/ai/bootstrap.md` and `docs/ai/review-checklist.md` match the project context.
- [ ] Unused placeholders and obsolete `.gitkeep` files are removed.
- [ ] Material decisions are recorded and unresolved proposals are clearly identified.
- [ ] Repository-relative Markdown links resolve.
- [ ] Text files are English, UTF-8, and LF-only.
- [ ] Guidance is internally consistent and contains no secrets or sensitive data.
- [ ] Every added dependency, tool, directory, and automation has a current requirement.

## Common Adoption Mistakes

- Leaving the template's identity, mission, or constraints in project documentation.
- Treating every placeholder directory as mandatory.
- Adding tools, dependencies, workflows, or architecture for anticipated needs.
- Copying standards without checking whether they fit the selected technologies.
- Repeating detailed guidance across the README and focused documents.
- Creating ADRs for trivial choices or RFCs for proposals that need no discussion.
- Keeping empty sections, unused documents, or stale guidance to appear complete.
- Hiding assumptions or unresolved risks behind generic template language.
