# Documentation Standard

## Purpose

This standard defines a lightweight documentation contract for this template and repositories created from it. It establishes where durable project knowledge belongs, which documents are baseline or conditional, how different audiences are separated, and how documentation remains useful without overloading humans or AI assistants with unnecessary context.

## Documentation Authority Model

- `README.md` is the concise repository introduction and navigation entry point.
- `docs/` is the single root for authoritative and detailed project documentation.
- Focused documents are authoritative for their subject.
- Source code remains authoritative for implemented behavior; documentation explains intent, state, contracts, requirements, and usage.
- Link to authoritative guidance instead of duplicating it in multiple files.
- Git history is document change history; do not require a manual revision-history section in every document.

## Baseline Documents

The baseline documentation set is:

- `README.md`
- `docs/project/vision.md`
- `docs/project/roadmap.md`
- `docs/project/status.md`
- `docs/project/capabilities.md`
- `docs/architecture/overview.md`
- `docs/standards/coding.md`
- `docs/standards/documentation.md`
- `docs/ai/bootstrap.md`
- `docs/ai/collaboration.md`
- `docs/ai/review-checklist.md`
- `docs/tooling/code-intelligence.md`
- `docs/tooling/mcp-setup.md`
- `docs/guides/developer/README.md`
- `docs/guides/user/README.md`
- `docs/modules/README.md`

ADRs are required only when a material decision exists. RFCs are appropriate only when a proposal genuinely requires discussion before acceptance. Focused module documents are created only when demonstrated subsystem complexity justifies them. `docs/security/` is conditional and is created only when verified security/compliance requirements justify it.

## Document Contracts

A document contract defines the information that must be addressed, not mandatory heading text. Exact headings may be adapted when clarity improves. Do not add empty ceremonial sections or duplicate detail owned by another authoritative document.

### README

Repository identity, concise purpose, primary documentation entry points, and basic usage or adoption direction.

### Project Vision

Mission, problem, audience, goals, non-goals, success criteria, constraints, assumptions, risks, and out-of-scope boundaries.

### Roadmap

Milestone-level delivery order and intended outcomes. It must not duplicate fine-grained issue tracking.

### Project Status

Concise current state using a small stable vocabulary such as Planned, In Progress, Blocked, Completed, Deferred, Dropped, and Not applicable.

### Capabilities

A stable capability-level view of what the product or system can currently provide. Avoid class-level or ticket-level detail.

### Architecture Overview

System or repository context, major boundaries, dependency direction, important flows, extension rules, trade-offs, and current limitations.

### Coding Standards

Naming and formatting, error handling and logging, testing, comments, dependency management, review rules, and simplicity/abstraction rules.

### AI Bootstrap

Minimal entry context, task-specific context routing, checks before editing, Graphify usage, context-efficiency stop rules, debug/refactor rules, validation, and reporting before completion.

### AI Collaboration

Canonical cross-agent knowledge ownership, handoff rules, tool-adapter boundaries, and durable-state requirements across Codex, Claude Code, Cursor, and humans.

### AI Review Checklist

Scope, architecture, simplicity, correctness, security, testing, documentation, project state, backward compatibility, code-intelligence freshness, repository-validation warnings, and AI-context consistency.

### Code Intelligence

Authority hierarchy and repository policy for Graphify, optional Sourcegraph, source verification, freshness, fallback behavior, and the boundary between policy and tool-specific setup mechanics.

### Graphify MCP Setup

Current project-scoped MCP configuration locations for Claude Code, Cursor, and Codex; the common graph target; minimal stdio configuration; reachability verification; freshness boundary; shared-HTTP trigger; and a clear reminder that vendor-specific mechanics must be re-verified when tool versions change.

### Developer Guides

Practical instructions required by a developer to configure, build, run, test, debug, deploy, operate, or extend the project. Add focused files only when the project needs them.

### User Guides

Audience-appropriate instructions for operators, administrators, customers, or end users. Organize by role, workflow, feature, or locale only when real usage requires it.

### Module Context

Focused subsystem purpose, boundaries, entry points, dependencies, contracts, flows, constraints, failure modes, and relevant decisions. Create only when rediscovery cost justifies maintenance cost.

### Security and Compliance

This is a conditional contract for documents created under `docs/security/` only when the project has verified security, privacy, contractual, regulatory, or compliance requirements that need focused durable treatment.

Address, as applicable:

- scope, audience, owner, and authoritative requirement sources;
- data classification and handling constraints;
- identities, roles, privileged boundaries, and access-control model;
- audit trail and security-event requirements, including required retention, integrity, or traceability properties;
- security-relevant trust boundaries and data flows, linking to architecture rather than duplicating structural descriptions;
- secrets, key, and credential-management expectations without storing secret values;
- contractual, regulatory, policy, or client constraints and traceability to their source requirements;
- monitoring, incident, exception, accepted-risk, and review requirements when applicable.

Do not invent regulatory requirements or copy an external framework into the repository without a verified project requirement. Keep security architecture in architecture documents, recurring implementation rules in engineering standards, and durable decisions in ADRs; link between them instead of creating parallel authority.

### Architecture Decision Record

Title and number, status, context, decision, consequences, alternatives, and review conditions.

### Request for Comments

Title and number, status, summary, motivation, goals, non-goals, proposal, impact, alternatives, risks, rollout or migration when applicable, open questions, and final outcome when decided.

## Optional Documents and Addition Triggers

Add an optional document only when a current need cannot be expressed clearly in an existing authoritative document:

- Add focused architecture documents when system context, components, deployment, security architecture, or data flows require dedicated treatment.
- Create `docs/security/` when verified security/compliance requirements span durable concerns such as data classification, access-control expectations, audit obligations, regulatory traceability, or accepted risks that should not be mixed into architecture or coding standards.
- Add a module document when subsystem rediscovery is repeatedly expensive or its boundaries/contracts are not obvious from local source.
- Add engineering standards when a selected technology or domain creates recurring decisions.
- Add developer-guide pages when practical development or operational procedures exceed the guide index.
- Add user-guide pages when real user roles or workflows need durable instructions.
- Add reference material when information is durable and repeatedly useful.
- Add a glossary when specialized terminology causes recurring confusion.

The trigger is demonstrated value, not structural symmetry.

## Project-State Maintenance

- Keep roadmap, status, and capabilities summary-level.
- Store fine-grained work items in the project's issue or project tracker.
- Update status when a material deliverable changes state.
- Update capabilities when a meaningful system capability becomes available, limited, deprecated, or removed.
- Do not turn project-state documents into chronological journals.

## Maintenance and Freshness

- Update documentation in the same change as affected behavior or architecture.
- Update relevant project-state documents when a material milestone, deliverable, or capability changes.
- Update security/compliance documentation when an authoritative requirement, control expectation, exception, or accepted risk materially changes.
- Remove or revise stale guidance instead of adding contradictory guidance.
- Report assumptions and unresolved questions explicitly.
- Prefer concise, durable guidance over meeting notes or temporary discussion.
- Remove documents that no longer have a clear audience, owner, or purpose.

## Linking and Duplication

Use relative links for files in the repository. Link directly to the focused authoritative document and provide only enough local context for the link to be understandable.

Avoid copying definitions, rules, decisions, or AI instructions across documents. If two documents conflict, correct the authoritative source and update references to it.

## Language and Writing Style

- Engineering and architecture documentation should use the project's agreed primary engineering language.
- User-facing documentation should use the language appropriate to its target audience.
- When multiple user-documentation languages are required, organize them by locale only when the project can maintain those variants.
- Write clearly, concisely, and directly.
- Explain project-specific reasoning and constraints.
- Distinguish confirmed decisions from assumptions and proposals.
- Do not include secrets, credentials, personal data, or other sensitive information.
- Avoid vendor-specific language outside focused tooling documentation unless the project has deliberately adopted that vendor.

## Context Efficiency

Every durable document must have a clear audience, purpose, and read trigger. AI assistants must not read the complete documentation tree by default. The bootstrap routes tasks to relevant documents, and focused documents should be concise enough that reading them is cheaper than rediscovering the same context from source or history.

If a document grows into mixed concerns, split by authority or audience. If a document becomes a task log, move the task detail to the project tracker and keep only the durable summary.

## Automated Validation Boundary

The baseline repository validation script intentionally automates only checks that can be made deterministic or clearly heuristic:

- unresolved repository-relative Markdown links in `README.md`, `AGENTS.md`, `CLAUDE.md`, and `docs/**/*.md` are hard failures;
- a pull request that changes `src/` without changing status/capabilities receives a non-blocking manual-confirmation warning;
- unusually large tool-specific config files and substantial verbatim copied blocks can produce drift warnings.

Automation does not prove semantic consistency, detect every paraphrased duplicate, or establish that project-state documents are substantively correct. Silence from CI must not be interpreted as proof that tool-specific configuration agrees with architecture, standards, or the AI bootstrap. Those remain review responsibilities.

## Validation Rules

- Store text as UTF-8 without a byte-order mark.
- Use LF line endings and a final newline.
- Verify repository-relative links resolve.
- Keep terminology consistent across authoritative documents.
- Confirm each document satisfies its contract without unnecessary sections.
- Confirm documentation matches current behavior and architecture.
- Confirm project-state documents reflect verified current state.
- Check that examples contain no secrets or sensitive data.
- Run the repository validation script when changing documentation, agent adapters, or repository support configuration, when available.

## Avoiding Over-Documentation

- Write a document only when it has a clear audience, purpose, read trigger, and maintenance value.
- Prefer improving an existing focused document over adding a parallel source.
- Do not preserve empty sections, speculative guidance, or temporary discussion as durable documentation.
- Do not document hypothetical components, workflows, controls, or extension points.
- Let the repository evolve when real complexity appears rather than anticipating it.
