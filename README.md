# MKDotNet Project Template

A minimal, documentation-first foundation for maintainable, AI-assisted software repositories.

This repository is a reusable project template. It is not a framework, SDK, CLI, package, or build system. Projects created from it should add only the technology and automation their actual requirements justify.

The template assumes a shared engineering workflow across Codex, Claude Code, and Cursor, with one canonical repository context. Graphify is the baseline structural code-intelligence layer for adopting projects; Sourcegraph has an explicit optional place when broader search or cross-repository context is justified.

## Start here

- [Template adoption and synchronization guide](docs/reference/adoption-guide.md)
- [Project vision](docs/project/vision.md)
- [Architecture overview](docs/architecture/overview.md)
- [Project roadmap](docs/project/roadmap.md)
- [Project status](docs/project/status.md)
- [Project capabilities](docs/project/capabilities.md)
- [Documentation standard](docs/standards/documentation.md)
- [Coding standards](docs/standards/coding.md)
- [AI bootstrap](docs/ai/bootstrap.md)
- [AI collaboration contract](docs/ai/collaboration.md)
- [AI review checklist](docs/ai/review-checklist.md)
- [Code-intelligence policy](docs/tooling/code-intelligence.md)
- [Developer guides](docs/guides/developer/README.md)
- [User guides](docs/guides/user/README.md)
- [Module-context guidance](docs/modules/README.md)
- [Repository structure decision](docs/decisions/adr/0001-repository-structure.md)

## Using the template

Keep the structure small, replace template metadata and project-state documents with verified project-specific information, and record material architectural decisions as the project evolves. The focused documents under `docs/` are the source of durable project knowledge; this README remains the concise repository introduction.

AI assistants should load context progressively rather than reading the whole repository. Start from `AGENTS.md` and `docs/ai/bootstrap.md`, use Graphify for structural discovery, then read only the source, tests, decisions, and module documentation relevant to the task.

Licensed under the [MIT License](LICENSE).
