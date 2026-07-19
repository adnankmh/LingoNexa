# Workflow rule

The production automation is separated into five visible workflows:

- `flutter_ci.yml` — analysis and tests.
- `apk.yml` — Android APK artifact.
- `aab.yml` — Google Play App Bundle artifact.
- `web.yml` — Flutter Web artifact without deployment.
- `pages.yml` — manual GitHub Pages deployment after Pages is enabled.

The project is Flutter, not a standalone Dart package. Do not create GitHub's
starter Dart workflow. Dependency resolution must use `flutter pub get`.

If an older repository already contains `build.yml` or `dart.yml`, delete them
before copying this release, or run `APPLY_LINGONEXA_FIX_WINDOWS.bat` once.
