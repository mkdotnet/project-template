# Template Adoption and Synchronization Guide

## Purpose

This guide explains how to create and adopt a project repository from this template and how to review later template updates deliberately. Initial adoption establishes project identity, durable state, shared AI context, code intelligence, repository assurance, and audience-focused documentation. Template synchronization remains deliberate maintenance after adoption.

## Adoption Principles

- Treat the template as a starting point, not as a framework or permanent runtime layer.
- Replace template statements with verified project context; do not copy them blindly into a real project.
- Keep one canonical repository contract across Codex, Claude Code, Cursor, and humans.
- Keep only files and directories that communicate a current need, except baseline project-state, AI/tooling, and repository-validation files that establish the shared contract.
- Add dependencies, runtime tooling, and automation only when actual project requirements justify them.
- Prefer clear focused guidance over comprehensive-looking documents.
- Keep AI context progressively loaded rather than forcing every assistant to read every document.
- Treat regulated/government projects as validation use cases, not as reasons to make this generic template government-specific or .NET-specific.

## Step 1: Create the Project Repository

Create a new repository from the template using the repository hosting or copying method appropriate to the team. Preserve the initial structure long enough to review each area, but do not assume every runtime placeholder must remain.

Native template generation may require a repository-level setting to be enabled on the source repository, and that setting may not be represented by tracked files. Confirm the prerequisite before attempting native generation. When native template generation is explicitly required, do not silently substitute cloning or copying Git history. If the prerequisite is missing, stop and report it rather than modifying the source repository without authorization.

Before implementation begins:

- Confirm the new repository has its own version-control history and access controls.
- Review tracked files for template-specific names, links, and assumptions.
- Decide which implementation placeholder areas represent real project needs.

## Step 2: Replace Repository Identity and Metadata

Update [README.md](../../README.md) with the adopting project's name, concise purpose, primary documentation entry points, and basic usage direction.

Update [mk.json](../../mk.json):

- Replace `name`, `description`, and `repository` with project-specific values.
- Confirm every entry point describes a file the project actually uses.
- Keep AI assistant entry points aligned with the project's actual Codex, Claude Code, and Cursor workflow.
- Keep `codeIntelligence.primary` as `graphify` unless an explicit project decision records an exception.
- Keep Sourcegraph optional unless the project deliberately adopts it.
- Keep the repository-validation metadata aligned with the workflow/script if the project retains the baseline checks.
- `templateVersion` records the template version used to initialize, or most recently synchronize, the repository. It is not the application or product release version.

Review the copied [LICENSE](../../LICENSE), replace the template copyright holder with the correct copyright holder for the adopting project, and confirm that the MIT License is appropriate. Do not publish the repository without reviewing its license and copyright notice.

## Step 3: Replace Project Context and Delivery State

Rewrite [project vision](../project/vision.md), [roadmap](../project/roadmap.md), [status](../project/status.md), and [capabilities](../project/capabilities.md) for the adopting project.

- Vision describes mission, scope boundaries, goals, constraints, assumptions, and risks.
- Roadmap describes milestone-level intended delivery order.
- Status describes verified current delivery state.
- Capabilities describe what the system can currently do at a meaningful capability level.

Keep fine-grained execution tasks in the project's issue or project tracker rather than turning these documents into task logs.

## Step 4: Refine Architecture, Engineering Standards, and Security Triggers

Refine the [architecture overview](../architecture/overview.md) so it describes the project's actual context, boundaries, dependency direction, important flows, extension rules, trade-offs, and current limitations.

After technologies are selected, refine the [coding standards](../standards/coding.md) with justified language, platform, or domain conventions. Follow the [documentation standard](../standards/documentation.md) when changing the documentation model.

Review the [AI bootstrap](../ai/bootstrap.md), [collaboration contract](../ai/collaboration.md), and [AI review checklist](../ai/review-checklist.md) so their routing, validation, and reporting rules match the project without duplicating project rules in assistant-specific files.

Determine whether the project has actual security, privacy, contractual, regulatory, or compliance requirements that trigger the conditional `docs/security/` contract. If yes, create focused security/compliance documentation from authoritative project requirements. If not, do not create empty security files for symmetry.

## Step 5: Establish Shared AI and Code-Intelligence Tooling

Keep the assistant model simple:

- Codex and Cursor discover the repository through `AGENTS.md`.
- Claude Code uses `CLAUDE.md` as a thin adapter to the same shared contract.
- `docs/ai/bootstrap.md` remains the canonical project-wide AI workflow.

Initialize Graphify for the adopting repository using the current supported project-level integration appropriate to the team's tools. Follow the [code-intelligence policy](../tooling/code-intelligence.md). Keep Graphify-generated files owned by Graphify and version them only when the installed workflow expects that and the files contain no secrets or machine-specific sensitive data.

After `graphify-out/graph.json` exists, configure Claude Code, Cursor, and Codex project-scoped MCP access using the [Graphify MCP setup](../tooling/mcp-setup.md). Verify each client can see Graphify and invoke `graph_stats` before relying on MCP for structural work.

The generic template intentionally does not pre-create active MCP files because it does not ship a generated graph. Create those project-scoped configs only after Graphify is initialized.

Do not copy vendor-generated rules into `AGENTS.md`, `CLAUDE.md`, or repository standards. The repository defines policy; the tool owns its integration mechanics.

Do not configure Sourcegraph merely because the template names it. Adopt it only after a project-specific evaluation demonstrates value.

## Step 6: Establish Human-Facing Documentation

Use [developer guides](../guides/developer/README.md) for practical build, run, test, debug, deploy, and extension procedures.

Use [user guides](../guides/user/README.md) for operator, administrator, customer, and end-user workflows. User-facing documentation may use the language appropriate to its audience.

Do not populate every possible guide page in advance. Add focused pages when real procedures and audiences exist.

## Step 7: Record Material Decisions and Module Context

Use the [ADR template](templates/adr.md) for a material accepted architectural decision. Use the [RFC template](templates/rfc.md) only for a proposal that genuinely requires structured discussion before acceptance.

The copied `docs/decisions/adr/0001-repository-structure.md` records a decision made for the template repository; remove it if the adopting project does not explicitly adopt that structural decision, or replace it with a project-specific ADR. Likewise, template ADRs about validation, conditional security documentation, and Graphify MCP setup should be retained only when the adopting project deliberately keeps those decisions.

Create focused module documents under `docs/modules/` only when subsystem complexity creates repeated rediscovery cost. Do not create one document per code directory for structural symmetry.

## Step 8: Remove Unused Runtime Placeholder Areas Without Breaking Baseline Tooling

The placeholder directories `src/`, `tests/`, `samples/`, `tools/`, `docs/assets/`, and empty decision areas are not mandatory. Remove a placeholder and its `.gitkeep` when the area does not communicate a real project need.

`scripts/` is no longer an empty placeholder in the generic template: it contains the baseline repository-validation script used by `.github/workflows/repository-validation.yml`. Retain both while using that decision. If the project deliberately replaces or removes the validation mechanism, update documentation, metadata, and the corresponding ADR together rather than leaving a broken workflow.

Do not remove baseline project-state, AI collaboration, tooling-policy, MCP-setup, or guide-index documents merely because the project is still small; they define the shared long-lived repository contract and can remain concise until the project evolves.

## Ongoing Definition of Done

For a material change, completion normally means the smallest applicable set of:

- source/configuration updated;
- tests or relevant validation updated and run;
- affected architecture, guide, security, or module documentation updated;
- project status or capability state updated when it materially changed;
- Graphify refreshed after material source changes according to the project's integration workflow;
- repository-contract validation passed and non-blocking warnings were reviewed;
- unresolved follow-up work recorded durably rather than left only in an assistant chat.

## Template Sync

`templateVersion` records the template version used to initialize the repository or the version most recently applied through a deliberate synchronization.

When the upstream template version increases, review the upstream template's `CHANGELOG.md`, evaluate each change, and apply only changes that fit the project. Do not automatically overwrite project-specific documentation, architecture, standards, decisions, metadata, AI adapters, code-intelligence configuration, validation workflow, security/compliance context, or project state.

Update `templateVersion` only after selected changes have been reviewed and applied. Synchronization is deliberate maintenance, not an automatic upgrade mechanism.

The template changelog records template history, not application or product releases. An adopting project may remove the copied `CHANGELOG.md` and its `changelog` entry point from `mk.json`, then consult the upstream template changelog for future synchronization reviews. It may retain the copied changelog only when that purpose remains explicit.

After initial adoption, make an explicit project decision about retaining this copied guide. If removed, also remove its README link and `adoptionGuide` entry point. Do not leave stale files, broken links, or stale metadata.

## Validation Checklist

- [ ] `README.md` identifies the adopting project and links to current entry points.
- [ ] `mk.json` contains project-specific metadata and valid paths.
- [ ] `vision.md`, `roadmap.md`, `status.md`, and `capabilities.md` describe the adopting project rather than the template.
- [ ] `architecture/overview.md` reflects current boundaries and limitations.
- [ ] Coding and documentation standards match the project's selected technologies and audiences.
- [ ] The conditional `docs/security/` area exists only when verified requirements justify it, and contains no invented compliance claims.
- [ ] `AGENTS.md`, `CLAUDE.md`, and tool-specific adapters do not contain divergent copies of project rules.
- [ ] AI context routing remains progressive and task-specific.
- [ ] Graphify is initialized and the project has a documented refresh/versioning workflow, or an explicit exception is recorded.
- [ ] Claude Code, Cursor, and Codex project-scoped Graphify MCP setup is verified when those tools are used for structural work.
- [ ] Sourcegraph is absent unless deliberately adopted.
- [ ] Developer and user guide indexes point to current practical documentation.
- [ ] Module documents exist only for subsystems whose complexity justifies them.
- [ ] Fine-grained tasks remain in the tracker rather than bloating status documents.
- [ ] Unused runtime placeholders and obsolete `.gitkeep` files are removed.
- [ ] Material decisions are recorded and unresolved proposals are clearly identified.
- [ ] Repository-contract validation passes; any warning is reviewed rather than blindly silenced.
- [ ] Repository-relative Markdown links resolve.
- [ ] Text files use the project's documented language policy, UTF-8, and LF-only line endings.
- [ ] Guidance is internally consistent and contains no secrets or sensitive data.
- [ ] Every added runtime dependency, tool, directory, and automation has a current requirement.

## Common Adoption Mistakes

- Leaving the template's identity, mission, roadmap, status, or capabilities in project documentation.
- Treating every placeholder or conditional directory as mandatory.
- Duplicating AI rules independently across Codex, Claude Code, and Cursor.
- Treating a green validation workflow as proof that tool-specific configuration cannot contradict canonical guidance.
- Letting Graphify or other derived indexes replace exact source verification.
- Configuring active MCP files before Graphify and the project graph exist.
- Adding Sourcegraph before a project-specific need is demonstrated.
- Inventing security/compliance content because a regulated project is expected later.
- Reading all documentation or history for every AI task instead of routing context.
- Turning `status.md` into a ticket log.
- Creating a module document for every code directory.
- Mixing developer-only procedures into user guides or internal implementation detail into user-facing documentation.
- Hiding assumptions, blockers, or handoff state in an assistant conversation instead of a durable repository location.
