# LingoNexa

Current release: **1.2.0+6**

An original Flutter foundation for a multilingual learning platform. Version 1.2 includes a 67-language catalog, CEFR A1–C2 paths, 12 interface languages, the official LingoNexa brand/icon system, Nexa Live voice conversation with scenarios and local feedback, 444 aligned localized phrase pairs, 1,776 sentence drills, more than 120,000 generated lesson steps, speech practice, spaced review, a phrasebook, grammar atlas, alphabet lab, goal-based courses, weekly planning, achievements, offline packs, eight themes, an expanded admin studio, and automated Android/Web builds.

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

GitHub Actions are separated into `Flutter CI`, `APK`, `AAB`, `Web`, and `Deploy GitHub Pages`. See [REPLACE_INSTRUCTIONS_AR.md](REPLACE_INSTRUCTIONS_AR.md) for the GitHub Desktop replacement and one-time Pages setup steps.

This repository contains a production-oriented application foundation and starter curriculum. A commercial language product still requires expert-reviewed course packs, licensed native audio, secure backend services, moderation, privacy/legal work, and store signing.
