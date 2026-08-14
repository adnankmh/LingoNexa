# LingoNexa

Current release: **3.1.0+15 — Full-Stack Learning Edition**

LingoNexa is a Flutter + Laravel multilingual learning platform built from the existing 3.0 learning OS. The release keeps the 67-language catalog, 12 interface languages, A1–C2 path, exams, stories, speech tools, community foundation, and existing learning features, while adding a real account/backend path and a responsive Laravel web product.

## What changed in 3.1

- Grammar chapters are now deliberately clean: **complete connected explanation + extended examples**. The old chapter panels for “how the language works”, meaning/form/use, rule-choice steps, common mistakes, and guided recall are no longer displayed in chapter reading.
- Original textbook-style explanations are available in all 12 interface languages. Target-language profiles cover all 67 catalog languages.
- Nexa Learning Labs adds 12 learning modes: active retrieval, spaced review, interleaving, dictation, chunking, shadowing, comprehensible input, conversation missions, pronunciation focus, memory decks, error repair, and fluency sprints.
- 12 visual themes, expanded Lottie motion assets, 249 country/territory flags, and account country selection.
- Laravel 12 web/API source under `laravel-web/` with session-based web auth, Sanctum mobile tokens, account progress, responsive pages, and shared course/grammar data.
- Flutter can connect to Laravel from the login screen or through `--dart-define=LINGONEXA_API_URL=...`.
- Remote auth tokens use secure encrypted platform storage rather than ordinary preferences.

## Flutter quick start

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

Production build with backend:

```bash
flutter build apk --release --dart-define=LINGONEXA_API_URL=https://your-domain.example
flutter build appbundle --release --dart-define=LINGONEXA_API_URL=https://your-domain.example
flutter build web --release --dart-define=LINGONEXA_API_URL=https://your-domain.example
```

## Laravel web/API

Read `laravel-web/README_AR.md`. On Windows, run `laravel-web/SETUP_WINDOWS.bat` once, then `laravel-web/START_WINDOWS.bat`.

## Content integrity

The 12 core languages retain the large aligned content bank. The remaining 55 languages retain verified starter content and language-specific grammar profiles; the system does not fabricate English text as target-language material. New teaching prose is original and textbook-like, not copied from copyrighted commercial books.

See `RELEASE_MANIFEST_3.1.0_AR.md` and `README_AR.md` for more detail.
