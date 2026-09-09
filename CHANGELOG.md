# Template Changelog

This file tracks changes to the MKDotNet project template itself, not application or product releases in adopting repositories.

## 0.6.0 - 2026-09-09

- Added lightweight GitHub Actions repository-contract validation with no third-party Python package dependency.
- Added hard validation for repository-relative Markdown links across root agent/readme entry points and `docs/`.
- Added non-blocking PR advisories when source changes may have missed a material project-state update.
- Added warning-only heuristics for oversized or substantially duplicated tool-specific configuration while keeping semantic contradiction a review responsibility.
- Defined `docs/security/` as a conditional, uncreated security/compliance documentation area with a formal document contract for projects that actually require it.
- Added a focused Graphify MCP setup contract for Claude Code, Cursor, and Codex using project-scoped stdio configurations over the same `graphify-out/graph.json`.
- Added lightweight MCP reachability verification using Graphify `graph_stats` while preserving separate freshness rules.
- Kept shared Graphify HTTP transport as a future alternative gated on demonstrated multi-client or multi-machine need.
- Updated adoption, architecture, AI routing, review, project-state, and machine-readable metadata to reflect the new repository-assurance baseline.

## 0.5.0 - 2026-09-09

- Made Codex, Claude Code, and Cursor first-class participants in one canonical AI context contract.
- Added a cross-agent collaboration and durable-handoff model.
- Established Graphify as the baseline structural code-intelligence layer for adopting projects.
- Reserved Sourcegraph as an optional code-intelligence extension rather than a required dependency.
- Added progressive context loading and explicit anti-overthinking/context-efficiency rules for AI-assisted work.
- Added task-specific routing for implementation, debugging, refactoring, planning, documentation, and architecture work.
- Added project roadmap, status, and capability documents for long-lived delivery-state visibility.
- Added on-demand module-context guidance for mature or complex subsystems.
- Added separate developer-facing and user-facing documentation areas.
- Relaxed the English-only rule for user-facing documentation so projects can document for their actual audience.
- Extended machine-readable metadata for AI entry points, code intelligence, progress documents, and documentation audiences.

## 0.4.0 - 2026-07-26

- Clarified repository-host prerequisites for native template generation.
- Clarified whether the copied adoption and synchronization guide should be
  retained or removed after initial adoption.

## 0.3.0 - 2026-07-26

- Added a root agent discovery pointer.
- Added template version history and synchronization guidance.
- Added the MIT License.
- Added a lightweight pull request content template.
