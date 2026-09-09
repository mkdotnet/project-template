# Module Context

## Purpose

This area is intentionally empty of subsystem documents until a project develops modules whose rediscovery cost justifies focused context.

Do not create a document for every directory, namespace, service, or component.

## When to Add a Module Document

Add `docs/modules/<module>.md` when one or more of these are true:

- the subsystem has non-obvious boundaries or dependencies;
- debugging repeatedly requires reconstructing the same execution path;
- refactoring has meaningful callers, contracts, persistence, messaging, or integration impact;
- the subsystem has important failure modes or operational constraints;
- multiple contributors or AI assistants repeatedly need the same focused context.

## Suggested Contract

A useful module document is concise and may address:

- purpose and responsibility;
- boundary and ownership;
- main entry points;
- important dependencies and dependents;
- data or control flow;
- public, persistence, message, or integration contracts;
- known constraints and failure modes;
- relevant tests;
- relevant ADRs/RFCs;
- explicit limitations or known maintenance risks.

Do not document implementation line by line. Source and tests remain authoritative for exact behavior.

## Debug/Refactor Read Trigger

When a focused module document exists, read it after Graphify has identified the affected subsystem and before broad source exploration. If it is stale, correct it as part of the change rather than adding a competing document.
