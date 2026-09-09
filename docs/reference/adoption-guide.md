# Template Adoption and Synchronization Guide

## Purpose

This guide explains how to apply the template as a governance/documentation/AI overlay while keeping application implementation independent and framework-native.

## Adoption Principles

- The template owns repository governance and durable context, not application topology.
- The complete product workspace lives under `implementation/`.
- The selected framework/generator owns everything inside that boundary.
- Do not reshape a framework-native solution merely to imitate another technology's folder conventions.
- Keep implementation able to restore, build, test, run, and package without depending on repository-governance artifacts as far as practical.
- Keep AI context progressive and durable knowledge in the repository rather than assistant chats.
- Treat regulated/government and .NET projects as validation use cases, not as reasons to make the generic template technology-specific.

## 1. Establish Repository Identity

Create the repository from this template or overlay the template onto an existing repository. Update `README.md` and `mk.json` with the real project identity. Review license/copyright before distribution.

Keep `mk.json` implementation metadata aligned with reality:

```json
"implementation": {
  "root": "implementation",
  "topology": "project-defined"
}
```

An adopting project may later record a more specific topology such as `abp-modular-monolith`, `clean-architecture`, `android`, or `polyglot`, but the generic template does not require those values.

## 2. Place the Complete Product Workspace Under `implementation/`

Generate or place the real project so its framework/project root is directly beneath `implementation/`.

Examples:

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
├── <framework-owned .NET roots>
├── ml/
├── contracts/
└── <project-specific support roots>
```

These are examples, not template-prescribed layouts. Keep tests, samples, implementation tools/scripts, project files, contracts, and implementation infrastructure with the owning project/framework. Do not recreate generic root `src/`, `tests/`, `samples/`, or `tools/`.

## 3. Replace Project Context

Rewrite project vision, roadmap, status, capabilities, and architecture overview for the adopting project. Document actual implementation topology only when it is useful; do not preserve template examples as if they were requirements.

Refine coding standards after technologies are chosen. Activate `docs/security/` only when verified security/compliance requirements justify it.

## 4. Establish Shared AI and Code Intelligence

Keep `AGENTS.md` and `CLAUDE.md` thin adapters to the canonical bootstrap. Initialize Graphify against the implementation boundary, not the governance/docs tree, unless a specific task requires repository-wide analysis.

From repository root, the intended baseline is to map `implementation/` and keep the resulting `graphify-out/` at repository level. Follow [code-intelligence policy](../tooling/code-intelligence.md) and [Graphify MCP setup](../tooling/mcp-setup.md), re-verifying vendor mechanics when tools change.

Do not activate Sourcegraph merely because the template names it.

## 5. Human Documentation and Decisions

Use developer guides for practical implementation procedures and user guides for operators/end users. Add module documents only when subsystem rediscovery becomes expensive. Use ADRs for durable decisions and RFCs only for proposals that need structured discussion.

Template ADRs may be removed or replaced when the adopting project does not retain those decisions; do not leave stale accepted decisions that contradict project reality.

## 6. Repository Validation

The baseline GitHub workflow and `.github/scripts/validate_repository.py` validate repository contracts. The validator reads the implementation root from `mk.json`; it does not assume `src/`.

Application-specific build/test/deployment CI remains project-defined and should execute against the framework/project inside `implementation/`.

## Ongoing Definition of Done

For a material change, apply the smallest relevant set:

- implementation/configuration changed;
- tests/validation changed and run;
- affected architecture, guide, module, or security documentation updated;
- status/capabilities updated when material delivery state changed;
- Graphify refreshed after material implementation changes when structural data is used;
- repository-contract validation passed and warnings were reviewed;
- unresolved follow-up work recorded durably.

## Template Sync

`templateVersion` records the template version last adopted/synchronized, not the product release. Review upstream changelog changes deliberately and never overwrite project-specific implementation, architecture, standards, decisions, security context, AI/tool config, or project state automatically.

## Validation Checklist

- [ ] Repository identity and `mk.json` describe the real project.
- [ ] `implementation/` contains the complete framework/project workspace and its real topology.
- [ ] Product build/test/run does not depend on template governance artifacts without an explicit documented exception.
- [ ] No generic root `src/`, `tests/`, `samples/`, or `tools/` was introduced by template convention.
- [ ] Project vision, roadmap, status, capabilities, and architecture reflect current reality.
- [ ] Graphify analyzes the intended implementation boundary and MCP is reachable when used.
- [ ] AI adapters remain thin and consistent.
- [ ] Conditional security documentation exists only when justified.
- [ ] Repository validation passes and warnings were reviewed.
- [ ] Fine-grained work remains in the tracker rather than status documents.
- [ ] No secrets or sensitive data were committed.
