# Workflow rule

The production automation is separated into five visible workflows:

- `flutter_ci.yml` — analysis and tests.
- `apk.yml` — Android APK artifact.
- `aab.yml` — Google Play App Bundle artifact.
- `web.yml` — Flutter Web artifact without deployment.
- `pages.yml` — manual GitHub Pages deployment after Pages is enabled.

`build.yml` and `dart.yml` are harmless manual-only replacement guards. They
overwrite obsolete combined/Dart workflows when this release is copied over an
older repository. `APPLY_LINGONEXA_FIX_WINDOWS.bat` then removes both guards.

The project is Flutter, not a standalone Dart package. Do not create GitHub's
starter Dart workflow. Dependency resolution must use `flutter pub get`.
