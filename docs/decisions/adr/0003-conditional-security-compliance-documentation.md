# ADR 0003: Conditional Security and Compliance Documentation Area

## Status

Accepted

## Context

The generic template is intended to seed long-lived projects, including regulated or government-sector systems, but it must not become government-specific, .NET-specific, or tied to a particular regulation.

The current documentation model allows focused architecture documents when security complexity appears, but data classification, access-control policy, audit-trail requirements, regulatory constraints, exceptions, and compliance traceability often span more than architecture alone. Placing all of that material under `docs/architecture/` would blur the authority boundary between system structure and security/compliance requirements.

At the same time, creating populated security documents for every new repository would violate the template's rule against speculative structure and ceremonial documentation.

## Decision

- Define `docs/security/` as a conditional documentation area under the existing authoritative `docs/` root.
- Do not create or populate `docs/security/` in the generic template. An adopting project creates the area only when verified security, privacy, contractual, regulatory, or compliance requirements justify durable focused documentation.
- When activated, begin with a focused security/compliance overview and add narrower documents only when their scope and maintenance value are demonstrated.
- Define the security/compliance document contract in `docs/standards/documentation.md`. The contract must address, as applicable:
  - scope, audience, ownership, and authoritative requirement sources;
  - data classification and handling constraints;
  - identities, roles, privileged boundaries, and the access-control model;
  - audit-trail, security-event, retention, integrity, and traceability requirements;
  - security-relevant trust boundaries and data flows, linking to architecture rather than duplicating it;
  - secrets, key, and credential-management expectations without recording secret values;
  - contractual, regulatory, policy, or client constraints and traceability to their source requirements;
  - monitoring, incident, exception, accepted-risk, and review requirements when applicable.
- Do not invent regulatory requirements in the template. Project-specific obligations must come from the actual client, contract, law, policy, threat model, or approved requirement source.
- Keep implementation details in source/configuration and structural security design in architecture documents. The security area owns durable security/compliance requirements, control expectations, exceptions, and traceability.
- Record material security architecture decisions as ADRs rather than duplicating decision rationale inside the security area.

## Consequences

### Positive

- Regulated projects gain a clear durable home for security and compliance knowledge without creating another documentation root.
- Architecture remains focused on system structure instead of becoming a catch-all for policy, data classification, and regulatory traceability.
- The generic template remains neutral about specific governments, regulations, technologies, and control frameworks.
- Projects without a real security/compliance documentation need do not inherit empty ceremonial files.

### Negative

- Projects with security requirements gain another focused documentation area to maintain.
- Contributors must distinguish security/compliance requirements from security architecture and coding guidance, using links instead of duplication.
- Because the area is conditional, project adoption must explicitly recognize when the trigger has been reached.

## Alternatives Considered

- **Keep all security/compliance material under `docs/architecture/`:** Rejected because data classification, audit requirements, regulatory traceability, and access-control policy are broader than architecture and would make architecture a mixed-authority document store.
- **Make `docs/security/` a mandatory populated baseline:** Rejected because many projects will not yet have verified requirements and empty placeholder documentation creates stale or invented content.
- **Put security requirements into `docs/standards/coding.md`:** Rejected because coding standards cover recurring implementation practices, not the system's security model, data obligations, or regulatory traceability.
- **Create a new top-level `security/` root:** Rejected because `docs/` remains the single root for authoritative detailed project documentation under ADR 0001.

## Review Conditions

Review this decision if:

- security/compliance documents repeatedly duplicate architecture or coding standards;
- adopting projects cannot determine when the conditional area should be activated;
- a recurring organization-wide compliance model justifies a separate reusable template or overlay rather than expanding this generic template;
- security documentation grows enough to require a more explicit internal structure.
