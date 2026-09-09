# ADR 0005: Isolate Product Implementation Behind a Framework-Owned Boundary

## Status

Accepted

## Context

Earlier template versions reserved generic root directories such as `src/`, `tests/`, `samples/`, and `tools/`. That works for simple repositories but conflicts with framework-native structures. ABP solutions already own source/test conventions and modern ABP Modular Monolith solutions use their own solution topology; Android, Python, Unity, Clean Architecture, and polyglot repositories have different conventions again.

A generic source skeleton therefore makes the template noisier and can force developers or AI assistants to choose between the template's layout and the framework's layout. The repository still needs a stable physical boundary separating project governance and durable context from the complete product implementation.

## Decision

- Use lowercase `implementation/` as the single product-implementation boundary in repositories adopting this template.
- The generic template creates only the boundary; it does not prescribe any internal folders.
- The selected framework, project generator, or explicit project architecture owns everything below `implementation/`.
- Production code, implementation configuration, tests, samples, implementation-specific tools/scripts, solution/workspace files, contracts, and implementation support files belong under this boundary according to their natural framework conventions.
- Do not create generic root `src/`, `tests/`, `samples/`, or `tools/` directories.
- Tests remain close to their owning code/framework. A shared `implementation/tests/` is used only when cross-cutting tests have no more natural owner.
- Repository governance, durable documentation, AI adapters, code-intelligence policy, and repository CI remain outside `implementation/`.
- Repository governance may inspect or automate implementation. The implementation must not depend on governance artifacts such as `docs/`, AI instruction files, `mk.json`, Graphify output, or repository-validation tooling to restore, build, test, run, or package the product.
- Record the implementation root in `mk.json`; its internal topology remains `project-defined` unless an adopting project deliberately records a more specific topology.
- Graphify should use the implementation boundary as its default structural analysis root so governance/documentation content does not dominate code exploration.
- Keep generated Graphify output repository-local and outside the implementation boundary because it is derived engineering context, not product implementation.

This decision supersedes the implementation-layout portions of ADR 0001 and updates the source-change assumption in ADR 0002. Other repository-structure decisions remain in force.

## Consequences

### Positive

- ABP, Android, .NET Clean Architecture, Python/ML, Unity, and other frameworks can retain their native layouts.
- Polyglot projects gain one clear boundary without forcing all languages into a generic `src/` hierarchy.
- Developers immediately know that the complete product workspace is under one directory.
- AI routing and CI no longer assume a specific source/test folder name.
- Governance can evolve independently from implementation topology.
- The implementation workspace is easier to move, archive, inspect, or open independently.

### Negative

- Product paths gain one additional `implementation/` segment.
- Some IDEs or framework tools may need to be opened from a solution/workspace file inside `implementation/` rather than repository root.
- Projects that intentionally require build configuration at repository root need an explicit exception and must document why the portability boundary cannot be maintained.

## Alternatives Considered

- **Keep generic root `src/` and `tests/`:** Rejected because those names collide with or compete with framework-native structures.
- **Put framework-specific roots such as `main/`, `modules/`, `ml/`, and `contracts/` directly at repository root:** Rejected because the generic template would become noisy and still expose implementation topology beside governance concerns.
- **Use `code/`:** Rejected because tests, contracts, project files, and implementation support are broader than code alone.
- **Use `solution/`:** Rejected because it is biased toward .NET terminology and is less natural for Android, Python, Unity, and polyglot projects.
- **Use `product/`:** Viable, but `implementation/` more precisely describes the full technical workspace without implying user-facing product assets only.
- **Maintain separate framework-specific base templates:** Rejected as the baseline because it would duplicate governance and AI contracts that should remain technology-neutral.

## Review Conditions

Review this decision if:

- a commonly adopted framework cannot operate reliably when its project root is one level below the repository root;
- repository-level build requirements repeatedly force implementation dependencies outside the boundary;
- the additional path segment creates measurable tooling friction across several adopting projects;
- a different boundary name proves substantially clearer across the project's supported technology mix.
