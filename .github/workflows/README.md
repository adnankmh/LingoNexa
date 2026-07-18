# Workflow rule

`build.yml` is the production workflow. `dart.yml` is a harmless manual-only
replacement for GitHub's obsolete Dart starter file, so copying this release
over an older repository neutralizes `dart pub get` automatically.

The project is Flutter, not a standalone Dart package. Do not create GitHub's
starter Dart workflow. Dependency resolution must use `flutter pub get`.
