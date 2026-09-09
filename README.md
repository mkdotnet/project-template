# MKDotNet Project Template

A technology-neutral repository governance, documentation, AI-context, and lifecycle foundation for maintainable software projects.

This template does **not** define application source topology. The complete product implementation lives under [`implementation/`](implementation/), while the framework or project generator owns everything inside that boundary. .NET Clean Architecture, ABP Modular Monolith, Android, Python/ML, Unity, or polyglot systems can therefore keep their native structure.

## Repository model

```text
repository/
├── .github/          repository automation
├── .mk/              MK bootstrap/toolkit source
├── docs/             durable project knowledge
├── implementation/   complete product implementation; internal topology is project-defined
├── Initialize.ps1    guided retrofit/bootstrap for an existing repository
├── Initialize-MKProject.cmd  beginner-friendly Windows launcher
├── AGENTS.md          shared AI discovery entry point
├── CLAUDE.md          Claude Code adapter
├── README.md
└── mk.json            machine-readable repository contract
```

Product source, tests, samples, implementation-specific tools, solution files, framework metadata, and implementation infrastructure belong inside `implementation/` according to the selected technology. Repository governance must not become a runtime/build dependency of the product.

## Apply to an existing or half-built project

Place `Initialize.ps1` (and optionally `Initialize-MKProject.cmd`) in the repository root and run it from there. For a beginner on Windows, `Initialize-MKProject.cmd` is the simplest entry point.

The guided setup:

1. inspects Git/repository state and previews migration;
2. creates `implementation/` and moves ordinary framework/build/product roots into it;
3. keeps Git, repository governance, docs, AI/tool config, and repository-wide config at root;
4. flags submodules, real environment/secret-bearing files, symlinks, and collisions for manual review instead of moving them blindly;
5. downloads the current toolkit from this repository and installs it under `.mk/scripts/`;
6. applies missing MK governance files without blindly overwriting existing project-specific documentation;
7. guides Graphify/MCP setup and runs a final project health check.

Advanced users can run `powershell -ExecutionPolicy Bypass -File .\Initialize.ps1 -FullSetup`.

## Start here

- [Template adoption and synchronization guide](docs/reference/adoption-guide.md)
- [Project vision](docs/project/vision.md)
- [Architecture overview](docs/architecture/overview.md)
- [Project roadmap](docs/project/roadmap.md)
- [Project status](docs/project/status.md)
- [Project capabilities](docs/project/capabilities.md)
- [AI bootstrap](docs/ai/bootstrap.md)
- [Code-intelligence policy](docs/tooling/code-intelligence.md)
- [Graphify MCP setup](docs/tooling/mcp-setup.md)
- [MK lifecycle toolkit](docs/tooling/lifecycle-scripts.md)

AI assistants should load context progressively, treat `implementation/` as the product boundary, use Graphify for structural discovery when needed, and verify behavior against exact implementation source/tests before editing.

Licensed under the [MIT License](LICENSE).
