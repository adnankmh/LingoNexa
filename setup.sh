#!/usr/bin/env sh
set -eu
command -v flutter >/dev/null 2>&1 || {
  echo "Flutter Stable was not found in PATH."
  exit 1
}
backup_dir="$(mktemp -d)"
trap 'rm -rf "$backup_dir"' EXIT
cp -R android "$backup_dir/android"
cp -R web "$backup_dir/web"
flutter create --platforms=android,web --org com.lingonexa .
cp -R "$backup_dir/android/." android/
cp -R "$backup_dir/web/." web/
rm -f android/settings.gradle android/build.gradle android/app/build.gradle
flutter pub get
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
echo "LingoNexa is ready. Run: flutter run"
