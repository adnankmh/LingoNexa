# LingoNexa

Current release: **3.0.0+14 — Human-Crafted Learning OS**

An original Flutter foundation for a multilingual learning platform. Version 3.0 adds an adaptive spaced-repetition scheduler, six-skill mastery analytics, a working speech shadowing studio, privacy and content-trust centers, a four-stage daily quest, hardened local demo authentication, floating responsive navigation, and 24 lightweight Lottie assets. The six-book A1–C2 grammar library, 54 reading chapters, 67 learning languages, and 12 interface languages remain fully integrated.

Content integrity is explicit: 12 core languages include the expanded 84-concept aligned bank (1,008 localized entries and 4,032 generated drills). The remaining 55 languages use their verified starter lexicons and never receive English text disguised as target-language content. Expand them only through reviewed course packs.

Local demonstration accounts:

- Administrator: `admin` or `admin@lingonexa.local` / `LingoNexa!2026`
- Learners: `demo1` / `Demo-Learner!2026`, `demo2` / `Demo-Learner!2026`

These are offline demo credentials, not production authentication. Local passwords use salted PBKDF2-HMAC-SHA256, constant-time comparison, attempt throttling, and expiring sessions. Public deployment still requires a server-verified identity provider and platform secure storage. Google/Facebook buttons are integration-ready UI and require a configured OAuth backend before release.

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

GitHub Actions are separated into `Flutter CI`, `APK`, `AAB`, `Web`, and `Deploy GitHub Pages`. APK, AAB, and Web now build independently on every push to `main`; a failed quality check no longer marks the other workflows as skipped. See [REPLACE_INSTRUCTIONS_AR.md](REPLACE_INSTRUCTIONS_AR.md) for the GitHub Desktop replacement and one-time Pages setup steps.

This repository contains a production-oriented application foundation and starter curriculum. A commercial language product still requires expert-reviewed course packs, licensed native audio, secure server-side authentication, moderation, privacy/legal work, and store signing.
