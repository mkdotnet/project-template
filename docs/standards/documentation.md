# Documentation Standard

## Purpose

This standard defines a lightweight documentation contract for this template and repositories created from it. It establishes where durable project knowledge belongs, the minimum concepts core documents address, and when additional documentation is justified.

## Documentation Authority Model

- `README.md` is the concise repository introduction and navigation entry point.
- `docs/` is the single root for authoritative and detailed project documentation.
- Focused documents are authoritative for their subject.
- Link to authoritative guidance instead of duplicating it in multiple files.
- Git history is the document change history; do not require a manual revision-history section in every document.

## Baseline Documents

The baseline documentation set is:

- `README.md`
- `docs/project/vision.md`
- `docs/architecture/overview.md`
- `docs/standards/coding.md`
- `docs/standards/documentation.md`
- `docs/ai/bootstrap.md`
- `docs/ai/review-checklist.md`

ADRs are required only when a material decision exists. RFCs are appropriate only when a proposal genuinely requires discussion before acceptance.

## Document Contracts

A document contract defines the information that must be addressed, not mandatory heading text. Exact headings may be adapted when clarity improves. Do not add empty ceremonial sections. Mark a concept not applicable only when that status is meaningful, and do not repeat detailed content owned by another authoritative document.

### README

- Repository identity.
- Concise purpose.
- Primary documentation entry points.
- Basic usage or adoption direction.

### Project Vision

- Mission and vision.
- Problem statement.
- Target audience or stakeholders.
- Goals and non-goals.
- Success criteria.
- Constraints and assumptions.
- Risks.
- Out of scope.

### Architecture Overview

- Purpose.
- System or repository context.
- Major boundaries or components when applicable.
- Dependency direction.
- Important data or control flow when applicable.
- Extension rules.
- Key trade-offs.
- Current limitations.

### Coding Standards

- Naming and formatting.
- Error handling and logging.
- Testing.
- Comments.
- Dependency management.
- Review rules.
- Simplicity and abstraction rules.

### AI Bootstrap

- Required reading sequence.
- Checks before editing.
- Rules while editing.
- Validation and reporting before completion.

### AI Review Checklist

- Scope.
- Architecture.
- Simplicity.
- Correctness.
- Security.
- Testing.
- Documentation.
- Backward compatibility.
- AI-context consistency.

### Architecture Decision Record

- Title and number.
- Status.
- Context.
- Decision.
- Positive and negative consequences.
- Alternatives considered.
- Review conditions.

### Request for Comments

- Title and number.
- Status.
- Summary and motivation.
- Goals and non-goals.
- Proposal.
- Expected impact.
- Alternatives considered.
- Risks.
- Rollout or migration when applicable.
- Open questions.
- Final outcome when decided.

## Optional Documents and Addition Triggers

Add an optional document only when a current need cannot be expressed clearly in an existing authoritative document:

- Add architecture documents when meaningful system context, container, component, deployment, or security complexity requires focused treatment.
- Add engineering standards when a selected technology or domain creates recurring decisions that shared guidance can resolve.
- Add reference material when information is durable and repeatedly useful.
- Add a glossary when specialized or ambiguous domain terminology causes recurring confusion.
- Add a roadmap when future commitments genuinely need repository-level visibility.

Do not create all possible documents in advance. The trigger is demonstrated value, not structural symmetry.

## Decision Records

Use an ADR for a material architectural decision whose context and consequences must remain discoverable. Use an RFC for a proposal that needs structured discussion before a decision.

Assign numbers consistently within each record type. Keep status current. When an RFC is decided, record its final outcome and create or update an ADR if the accepted proposal establishes a durable architectural decision.

Reusable record templates provide structure but do not contain project decisions and are not authoritative for a project's chosen outcome.

## Maintenance and Freshness

- Update documentation in the same change as affected behavior or architecture.
- Remove or revise stale guidance instead of adding contradictory guidance.
- Report assumptions and unresolved questions explicitly.
- Prefer concise, durable guidance over meeting notes or temporary discussion.
- Do not use manual revision histories as a substitute for Git history.
- Remove documents that no longer have a clear owner or purpose.

## Linking and Duplication

Use relative links for files in the repository. Link directly to the focused authoritative document and provide only enough local context for the link to be understandable.

Avoid copying definitions, rules, or decisions across documents. If two documents conflict, correct the authoritative source and update references to it.

## Writing Style

- Write in clear, concise English.
- Prefer direct statements and conventional terminology.
- Explain project-specific reasoning and constraints.
- Distinguish confirmed decisions from assumptions and proposals.
- Do not include secrets, credentials, personal data, or other sensitive information.
- Avoid vendor-specific language unless the project has made and documented that choice.

## Validation Rules

- Store text as UTF-8 without a byte-order mark.
- Use LF line endings and a final newline.
- Verify repository-relative links resolve.
- Keep terminology consistent across authoritative documents.
- Confirm each document satisfies its contract without unnecessary sections.
- Confirm documentation matches current behavior and architecture.
- Check that examples contain no secrets or sensitive data.

## Avoiding Over-Documentation

- Write a document only when it has a clear audience, purpose, and maintenance value.
- Prefer improving an existing focused document over adding a parallel source.
- Do not preserve empty sections, speculative guidance, or temporary discussion as durable documentation.
- Do not document hypothetical components, workflows, or extension points.
- Let the repository evolve when real complexity appears rather than anticipating it.
