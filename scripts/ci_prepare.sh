#!/usr/bin/env bash
set -euo pipefail

flutter create --platforms=android,web --org com.lingonexa .
git checkout -- android web

rm -f android/settings.gradle android/build.gradle android/app/build.gradle

test -f android/settings.gradle.kts
test ! -f android/settings.gradle
grep -q '8.11.1' android/settings.gradle.kts
grep -q '2.2.20' android/settings.gradle.kts
grep -q 'gradle-8.13-bin.zip' android/gradle/wrapper/gradle-wrapper.properties

python3 scripts/validate_project.py
flutter pub get
