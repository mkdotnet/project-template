# ADR 0001: Repository Structure

## Status

Accepted

## Context

The template needs a predictable structure for implementation, verification, supporting material, and durable project knowledge. The initial structure must help contributors and AI coding assistants find authoritative context without introducing technology choices or duplicate documentation roots.

The repository README cannot remain the complete source of project knowledge as a project grows. A separate root AI directory or a product-specific `PMS` directory would fragment knowledge and imply concerns that do not belong to this reusable template.

## Decision

- Use `docs/` as the single documentation root.
- Store AI bootstrap and review guidance in `docs/ai/`, not in a root-level AI directory.
- Do not create a `PMS` directory.
- Use `README.md` as the concise repository introduction and navigation point, not as the complete source of project knowledge.
- Store project intent in focused documents under `docs/project/`.
- Store architecture knowledge in focused documents under `docs/architecture/`.
- Store shared standards under `docs/standards/`.
- Store accepted decisions under `docs/decisions/adr/` and proposals under `docs/decisions/rfc/`.
- Reserve `src/`, `tests/`, `samples/`, `scripts/`, and `tools/` for their conventional purposes, adding content only when required.

## Consequences

### Positive

- Contributors have one predictable documentation root.
- Project, architecture, standards, decisions, and AI guidance remain discoverable and focused.
- The README stays concise while linking to deeper knowledge.
- The repository can grow without adopting a technology-specific layout prematurely.

### Negative

- Readers may need to follow links across several documents.
- Focused documents require deliberate cross-linking and maintenance.
- Placeholder directories make intended future areas visible before they contain implementation.

## Alternatives Considered

- **Keep all knowledge in `README.md`:** Rejected because it would become difficult to navigate and maintain as the repository evolves.
- **Create a root-level AI directory:** Rejected because AI guidance is documentation and belongs under the single documentation root.
- **Create a `PMS` directory:** Rejected because it is product-specific, unclear in this template, and would introduce an unnecessary structural concept.
- **Add technology-specific project directories now:** Rejected because no implementation technology has been selected.
- **Create multiple documentation roots:** Rejected because it would fragment authority and make context discovery harder.

## Review Conditions

Review this decision if:

- A demonstrated project need cannot fit the structure without unclear placement.
- Documentation scale makes the current organization difficult to navigate.
- A selected technology imposes a conventional layout that materially improves maintainability.
- Contributors repeatedly misunderstand the role or dependency direction of top-level areas.

Any revision must preserve a clear documentation authority and avoid speculative structure.
