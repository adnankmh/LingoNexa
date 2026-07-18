# LingoNexa

Current release: **1.1.1+3**

An original Flutter foundation for a multilingual learning platform. Version 1.1 includes a 67-language catalog, CEFR A1–C2 paths, onboarding and placement, interactive exercises, speech practice, spaced review, a phrasebook, grammar atlas, alphabet lab, goal-based courses, weekly planning, achievements and leagues, offline packs, progress records, stories, culture, community concepts, eight themes, Arabic RTL/English UI, an admin studio, and automated Android/Web builds.

Quick start:

```bash
flutter create --platforms=android,web --org com.lingonexa .
flutter pub get
flutter analyze
flutter test
flutter run
```

Build:

```bash
flutter build apk --release
flutter build appbundle --release
flutter build web --release
```

See [README_AR.md](README_AR.md) for the full Arabic setup guide and production requirements.

GitHub Actions must show `Flutter CI - APK - AAB - Web`. Keep `build.yml` as the only executable workflow file and never use GitHub's standalone Dart starter workflow. See [REPLACE_INSTRUCTIONS_AR.md](REPLACE_INSTRUCTIONS_AR.md) for the GitHub Desktop replacement steps.

This repository contains a production-oriented application foundation and starter curriculum. A commercial language product still requires expert-reviewed course packs, licensed native audio, secure backend services, moderation, privacy/legal work, and store signing.
