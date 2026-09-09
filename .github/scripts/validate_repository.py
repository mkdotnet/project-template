#!/usr/bin/env python3
"""Validate lightweight repository contracts using only the Python standard library."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[2]
ENTRY_MARKDOWN = ("README.md", "AGENTS.md", "CLAUDE.md")
TOOL_ROOTS = (".cursor", ".claude", ".codex")
STATE_FILES = {"docs/project/status.md", "docs/project/capabilities.md"}

INLINE_LINK_RE = re.compile(r"!?\[[^\]]*]\(([^)\n]+)\)")
REFERENCE_LINK_RE = re.compile(r"^\s*\[[^\]]+]:\s*(\S+)", re.MULTILINE)
FENCE_RE = re.compile(r"```.*?```|~~~.*?~~~", re.DOTALL)

DUP_LINES = 6
DUP_CHARS = 300
LARGE_BYTES = 16 * 1024
LARGE_LINES = 200


def warning(message: str, path: Path | None = None) -> None:
    metadata = f" file={path.relative_to(ROOT)}" if path else ""
    print(f"::warning{metadata}::{message}")


def summary(lines: list[str]) -> None:
    target = os.environ.get("GITHUB_STEP_SUMMARY")
    if target and lines:
        with open(target, "a", encoding="utf-8") as handle:
            handle.write("\n".join(lines) + "\n")


def implementation_root() -> str:
    metadata = ROOT / "mk.json"
    if not metadata.is_file():
        return "implementation"
    try:
        payload = json.loads(metadata.read_text(encoding="utf-8"))
        value = payload.get("implementation", {}).get("root", "implementation")
    except (json.JSONDecodeError, OSError, AttributeError):
        return "implementation"
    value = str(value).strip().replace("\\", "/").strip("/")
    return value or "implementation"


def strip_fences(text: str) -> str:
    return FENCE_RE.sub("", text)


def markdown_files() -> list[Path]:
    files = [ROOT / name for name in ENTRY_MARKDOWN if (ROOT / name).is_file()]
    docs = ROOT / "docs"
    if docs.is_dir():
        files.extend(sorted(docs.rglob("*.md")))
    return files


def link_targets(text: str) -> list[str]:
    text = strip_fences(text)
    values = [match.group(1).strip() for match in INLINE_LINK_RE.finditer(text)]
    values.extend(match.group(1).strip() for match in REFERENCE_LINK_RE.finditer(text))
    return values


def relative_target(raw: str) -> str | None:
    value = raw.strip()
    if value.startswith("<") and value.endswith(">"):
        value = value[1:-1].strip()
    elif " " in value:
        value = value.split(maxsplit=1)[0]
    if not value or value.startswith(("#", "//", "/")):
        return None
    parsed = urlsplit(value)
    if parsed.scheme:
        return None
    path = unquote(parsed.path)
    return path or None


def broken_links() -> list[str]:
    failures: list[str] = []
    root = ROOT.resolve()
    for source in markdown_files():
        for raw in link_targets(source.read_text(encoding="utf-8")):
            target = relative_target(raw)
            if target is None:
                continue
            resolved = (source.parent / target).resolve()
            try:
                resolved.relative_to(root)
            except ValueError:
                failures.append(f"{source.relative_to(ROOT)} -> {raw!r} escapes the repository")
                continue
            if not resolved.exists():
                failures.append(f"{source.relative_to(ROOT)} -> {raw!r} does not resolve")
    return failures


def readable_files(root: Path) -> list[Path]:
    if not root.is_dir():
        return []
    result: list[Path] = []
    for path in root.rglob("*"):
        if not path.is_file() or path.is_symlink():
            continue
        relative = path.relative_to(ROOT).as_posix()
        if relative.startswith(".cursor/rules/graphify") or relative.startswith(".claude/skills/graphify/"):
            continue
        try:
            path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        result.append(path)
    return result


def normalized_lines(text: str) -> list[str]:
    lines: list[str] = []
    for raw in strip_fences(text).splitlines():
        line = " ".join(raw.strip().split())
        if line and not line.startswith("#"):
            lines.append(line)
    return lines


def windows(text: str) -> set[str]:
    lines = normalized_lines(text)
    result: set[str] = set()
    for index in range(len(lines) - DUP_LINES + 1):
        block = "\n".join(lines[index:index + DUP_LINES])
        if len(block) >= DUP_CHARS:
            result.add(block)
    return result


def canonical_windows() -> set[str]:
    paths: list[Path] = []
    for folder in ("docs/architecture", "docs/standards"):
        root = ROOT / folder
        if root.is_dir():
            paths.extend(sorted(root.rglob("*.md")))
    bootstrap = ROOT / "docs/ai/bootstrap.md"
    if bootstrap.is_file():
        paths.append(bootstrap)
    result: set[str] = set()
    for path in paths:
        result.update(windows(path.read_text(encoding="utf-8")))
    return result


def tool_config_warnings() -> list[str]:
    canonical = canonical_windows()
    messages: list[str] = []
    for folder in TOOL_ROOTS:
        for path in readable_files(ROOT / folder):
            text = path.read_text(encoding="utf-8")
            size = path.stat().st_size
            line_count = text.count("\n") + 1
            if size > LARGE_BYTES or line_count > LARGE_LINES:
                messages.append(
                    f"{path.relative_to(ROOT)} is unusually large for a tool-specific adapter/config "
                    f"({size} bytes, {line_count} lines); review it for copied project rules."
                )
            if canonical and windows(text).intersection(canonical):
                messages.append(
                    f"{path.relative_to(ROOT)} contains a substantial verbatim block also present in "
                    "canonical architecture/standards/bootstrap guidance; review it for duplicated authority."
                )
    return messages


def project_state_warning(base: str, head: str) -> str | None:
    result = subprocess.run(
        ["git", "diff", "--name-only", f"{base}...{head}"],
        cwd=ROOT,
        check=False,
        text=True,
        capture_output=True,
    )
    if result.returncode:
        raise RuntimeError(result.stderr.strip() or "git diff failed")
    changed = {line.strip().replace("\\", "/") for line in result.stdout.splitlines() if line.strip()}
    impl = implementation_root()
    implementation_changed = any(path == impl or path.startswith(f"{impl}/") for path in changed)
    state_changed = bool(changed.intersection(STATE_FILES))
    if implementation_changed and not state_changed:
        return (
            f"This PR changes {impl}/ but not docs/project/status.md or docs/project/capabilities.md. "
            "Confirm manually that no material deliverable or capability state changed; non-material "
            "implementation changes do not require a project-state edit."
        )
    return None


def arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--base", help="Base commit for the PR project-state advisory.")
    parser.add_argument("--head", help="Head commit for the PR project-state advisory.")
    args = parser.parse_args()
    if bool(args.base) != bool(args.head):
        parser.error("--base and --head must be supplied together")
    return args


def main() -> int:
    args = arguments()
    report = ["## Repository contract validation"]
    failures = broken_links()
    if failures:
        print("Broken repository-relative Markdown links:", file=sys.stderr)
        for item in failures:
            print(f"- {item}", file=sys.stderr)
        report.append(f"- ❌ Relative-link validation: {len(failures)} failure(s).")
    else:
        print("Relative-link validation passed.")
        report.append("- ✅ Relative-link validation passed.")
    heuristics = tool_config_warnings()
    for item in heuristics:
        warning(item)
    report.append(f"- {'⚠️' if heuristics else '✅'} Tool-config drift heuristics: {len(heuristics)} warning(s).")
    if args.base and args.head:
        try:
            advisory = project_state_warning(args.base, args.head)
        except RuntimeError as exc:
            print(f"Project-state advisory failed: {exc}", file=sys.stderr)
            report.append("- ❌ Project-state advisory could not run.")
            summary(report)
            return 1
        if advisory:
            warning(advisory)
            report.append(f"- ⚠️ Project-state advisory: {advisory}")
        else:
            report.append("- ✅ Project-state advisory passed.")
    report.append("- ℹ️ These checks do not prove semantic consistency between tool-specific config and canonical guidance.")
    summary(report)
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
