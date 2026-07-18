#!/usr/bin/env python3
"""Dependency-free structural checks for the LingoNexa source bundle."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REQUIRED = [
    "pubspec.yaml",
    "lib/main.dart",
    "lib/app.dart",
    "lib/data/language_catalog.dart",
    "lib/data/course_repository.dart",
    "lib/screens/admin_screen.dart",
    "lib/screens/onboarding_screen.dart",
    "lib/screens/phrasebook_screen.dart",
    "lib/screens/grammar_screen.dart",
    "lib/screens/alphabet_screen.dart",
    "lib/screens/specialized_paths_screen.dart",
    "lib/screens/learning_plan_screen.dart",
    "lib/screens/achievements_screen.dart",
    "lib/screens/downloads_screen.dart",
    "lib/screens/certificates_screen.dart",
    ".github/workflows/build.yml",
    "android/app/src/main/AndroidManifest.xml",
    "README_AR.md",
]


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


for relative in REQUIRED:
    if not (ROOT / relative).is_file():
        fail(f"missing {relative}")

catalog = (ROOT / "lib/data/language_catalog.dart").read_text(encoding="utf-8")
codes = re.findall(r"LanguageOption\(code: '([^']+)'", catalog)
if len(codes) < 50:
    fail(f"only {len(codes)} languages found")
if len(codes) != len(set(codes)):
    fail("duplicate language codes")

repository = (ROOT / "lib/data/course_repository.dart").read_text(encoding="utf-8")
lexicon_codes = set(re.findall(r"^\s*'([^']+)': \[", repository, flags=re.MULTILINE))
missing = sorted(set(codes) - lexicon_codes)
if missing:
    fail(f"missing starter lexicon for: {', '.join(missing)}")

for file in (ROOT / "assets").rglob("*.json"):
    try:
        json.loads(file.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON in {file.relative_to(ROOT)}: {exc}")

for file in (ROOT / "lib").rglob("*.dart"):
    text = file.read_text(encoding="utf-8")
    for forbidden in ("TODO", "FIXME", "Icons.mult "):
        if forbidden in text:
            fail(f"forbidden marker {forbidden!r} in {file.relative_to(ROOT)}")

workflow_files = list((ROOT / ".github/workflows").glob("*.y*ml"))
if [file.name for file in workflow_files] != ["build.yml"]:
    fail("build.yml must be the only executable workflow file")
workflow = workflow_files[0].read_text(encoding="utf-8")
if "dart pub get" in workflow:
    fail("Flutter workflow must never use dart pub get")
if workflow.count("flutter pub get") < 2:
    fail("Flutter dependency setup is missing from one or more jobs")

print(f"PASS: {len(codes)} languages, expanded studio present, Flutter workflow valid, JSON valid")
