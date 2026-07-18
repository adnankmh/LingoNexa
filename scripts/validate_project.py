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
    ".github/workflows/flutter_ci.yml",
    ".github/workflows/apk.yml",
    ".github/workflows/aab.yml",
    ".github/workflows/web.yml",
    ".github/workflows/pages.yml",
    "scripts/ci_prepare.sh",
    "android/app/src/main/AndroidManifest.xml",
    "android/settings.gradle.kts",
    "android/gradle/wrapper/gradle-wrapper.properties",
    "APPLY_LINGONEXA_FIX_WINDOWS.bat",
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

workflow_files = sorted((ROOT / ".github/workflows").glob("*.y*ml"))
workflow_names = [file.name for file in workflow_files]
required_workflows = {"aab.yml", "apk.yml", "flutter_ci.yml", "pages.yml", "web.yml"}
optional_guards = {"build.yml", "dart.yml"}
if not required_workflows.issubset(workflow_names):
    fail("one or more separated workflows are missing")
if set(workflow_names) - required_workflows - optional_guards:
    fail("unexpected workflow file found")

for workflow_path in workflow_files:
    workflow = workflow_path.read_text(encoding="utf-8")
    if "dart pub get" in workflow:
        fail(f"Flutter workflow must never use dart pub get: {workflow_path.name}")

prepare_script = (ROOT / "scripts/ci_prepare.sh").read_text(encoding="utf-8")
if "flutter pub get" not in prepare_script:
    fail("shared Flutter dependency setup is missing")

expected_names = {
    "flutter_ci.yml": "Flutter CI",
    "apk.yml": "APK",
    "aab.yml": "AAB",
    "web.yml": "Web",
    "pages.yml": "Deploy GitHub Pages",
}
for filename, display_name in expected_names.items():
    workflow = (ROOT / ".github/workflows" / filename).read_text(encoding="utf-8")
    if f"name: {display_name}" not in workflow:
        fail(f"incorrect display name in {filename}")

for filename in ("flutter_ci.yml", "apk.yml", "aab.yml", "web.yml", "pages.yml"):
    workflow = (ROOT / ".github/workflows" / filename).read_text(encoding="utf-8")
    if "actions/checkout@v6" not in workflow:
        fail(f"{filename} must use Node 24 compatible checkout@v6")

if "actions/upload-artifact@v7" not in (ROOT / ".github/workflows/apk.yml").read_text(encoding="utf-8"):
    fail("APK workflow must use Node 24 compatible upload-artifact@v7")
if "actions/upload-artifact@v7" not in (ROOT / ".github/workflows/aab.yml").read_text(encoding="utf-8"):
    fail("AAB workflow must use Node 24 compatible upload-artifact@v7")
if "actions/upload-artifact@v7" not in (ROOT / ".github/workflows/web.yml").read_text(encoding="utf-8"):
    fail("Web workflow must use Node 24 compatible upload-artifact@v7")

legacy_path = ROOT / ".github/workflows/dart.yml"
if legacy_path.exists():
    legacy_workflow = legacy_path.read_text(encoding="utf-8")
    if "dart pub get" in legacy_workflow or "push:" in legacy_workflow:
        fail("legacy Dart workflow guard must be manual-only and harmless")

combined_path = ROOT / ".github/workflows/build.yml"
if combined_path.exists():
    combined_workflow = combined_path.read_text(encoding="utf-8")
    if "push:" in combined_workflow or "pull_request:" in combined_workflow:
        fail("legacy combined workflow guard must be manual-only")

settings = (ROOT / "android/settings.gradle.kts").read_text(encoding="utf-8")
wrapper = (ROOT / "android/gradle/wrapper/gradle-wrapper.properties").read_text(encoding="utf-8")
if 'version "8.11.1"' not in settings:
    fail("Android Gradle Plugin must be 8.11.1")
if 'version "2.2.20"' not in settings:
    fail("Kotlin Gradle Plugin must be 2.2.20")
if "gradle-8.13-bin.zip" not in wrapper:
    fail("Gradle wrapper must be 8.13")

for stale in ("android/settings.gradle", "android/build.gradle", "android/app/build.gradle"):
    if (ROOT / stale).exists():
        fail(f"stale Groovy Android file conflicts with Kotlin DSL: {stale}")

print(f"PASS: {len(codes)} languages, five separated workflows safe, Android toolchain pinned, JSON valid")
