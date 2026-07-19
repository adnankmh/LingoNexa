# LingoNexa

Current release: **1.3.0+7**

An original Flutter foundation for a multilingual learning platform. Version 1.3 adds local accounts and isolated per-user progress, administrator access, level exams, 36 dialogue-story activities per language path, fast six-step lessons, strict target-language TTS/STT locale selection, semantic pictograms, correct/incorrect Lottie feedback, compressed brand assets, English/light first-launch defaults, and a compact global language/theme control. The catalog contains 67 learning languages and 12 interface languages.

Content integrity is explicit: 12 core languages include the expanded 37-concept aligned bank (444 localized entries and 1,776 generated drills). The remaining 55 languages use their verified starter lexicons and never receive English text disguised as target-language content. Expand them only through reviewed course packs.

Local demonstration accounts:

- Administrator: `Adnan` or `adnanasd63@gmail.com` / `Adnan123`
- Learners: `demo1` / `Demo123`, `demo2` / `Demo123`

These are offline demo credentials, not production authentication. Google/Facebook buttons are integration-ready UI and require a configured Firebase/Auth backend before release.

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

This repository contains a production-oriented application foundation and starter curriculum. A commercial language product still requires expert-reviewed course packs, licensed native audio, secure server-side authentication, moderation, privacy/legal work, and store signing.
