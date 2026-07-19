# Workflow rule

The production automation is separated into five visible workflows:

- `flutter_ci.yml` — analysis and tests.
- `apk.yml` — independent Android APK artifact on pushes to `main` or manual runs.
- `aab.yml` — independent Google Play App Bundle artifact on pushes to `main` or manual runs.
- `web.yml` — independent Flutter Web artifact without deployment.
- `pages.yml` — manual GitHub Pages deployment after Pages is enabled.

The project is Flutter, not a standalone Dart package. Do not create GitHub's
starter Dart workflow. Dependency resolution must use `flutter pub get`.

APK, AAB, and Web are intentionally not gated by `workflow_run`. Each workflow
checks out and builds the pushed commit by itself, so a failed CI test does not
turn the build workflows into one-second skipped runs.

If an older repository already contains `build.yml` or `dart.yml`, delete them
before copying this release, or run `APPLY_LINGONEXA_FIX_WINDOWS.bat` once.
