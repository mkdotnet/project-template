# MKDotNet Project Template

A technology-neutral repository governance, documentation, and AI-context foundation for maintainable software projects.

This template does **not** define application source topology. The complete product implementation lives under [`implementation/`](implementation/), while the framework or project generator owns everything inside that boundary. A .NET Clean Architecture solution, ABP Modular Monolith, Android application, Python/ML project, Unity project, or polyglot system can therefore keep its native structure without competing with the template.

## Repository model

```text
repository/
├── .github/          repository automation
├── docs/             durable project knowledge
├── implementation/   complete product implementation; internal topology is project-defined
├── AGENTS.md          shared AI discovery entry point
├── CLAUDE.md          Claude Code adapter
├── README.md
└── mk.json            machine-readable repository contract
```

Product source, tests, samples, implementation-specific tools, solution files, framework metadata, and implementation infrastructure belong inside `implementation/` according to the conventions of the selected technology. Repository governance must not require the implementation to depend on `docs/`, AI files, Graphify output, or repository-validation tooling in order to restore, build, test, run, or package the product.

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
- [Graphify MCP setup](docs/tooling/mcp-setup.md)
- [Developer guides](docs/guides/developer/README.md)
- [User guides](docs/guides/user/README.md)
- [Module-context guidance](docs/modules/README.md)

AI assistants should load context progressively, treat `implementation/` as the product boundary, use Graphify for structural discovery when needed, and verify exact behavior against implementation source and tests before editing.

Licensed under the [MIT License](LICENSE).
