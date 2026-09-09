# Project Status

## Purpose

This document is the concise current-state snapshot of the project. It answers what is completed, in progress, blocked, planned, or intentionally deferred without requiring a reader to reconstruct state from Git history.

Adopting projects must replace this template-specific state with their verified project state.

## Current Template State

Last updated: 2026-09-09

| Area | State | Notes |
| --- | --- | --- |
| Documentation-first repository foundation | Completed | Core repository model is established. |
| Shared AI context for Codex, Claude Code, and Cursor | Completed | One canonical bootstrap with thin tool adapters. |
| Progressive AI context loading | Completed | Task-specific routing and stop rules are defined. |
| Graphify code-intelligence baseline | Completed | Required adopting-project policy is defined. |
| Graphify MCP consistency | Completed | Project-scoped stdio setup and reachability checks are documented for all three assistants. |
| Sourcegraph integration | Optional | Reserved as a deliberate project-level extension. |
| Repository-contract validation | Completed | Relative links hard-fail; project-state and tool-config drift use non-blocking advisories. |
| Security/compliance documentation model | Completed | Conditional contract is defined; `docs/security/` is created only when a project has real requirements. |
| Delivery-state visibility | Completed | Roadmap, status, and capabilities are defined. |
| Developer and user documentation model | Completed | Separate audience-focused guide roots are defined. |
| Module-context model | Completed | Created on demand for complex subsystems. |
| Runtime implementation | Not applicable | The template intentionally contains no application runtime. |

## State Vocabulary

Use a small stable vocabulary: `Planned`, `In Progress`, `Blocked`, `Completed`, `Deferred`, `Dropped`, or `Not applicable`.

## Maintenance Rules

- Keep this file summary-level; move fine-grained tasks to an issue or project tracker.
- Update it when a material capability, milestone, or deliverable changes state.
- Do not record routine commit history here.
- Link to a focused document or tracker when more detail is required.
- Prefer verified current state over estimated percentages.
