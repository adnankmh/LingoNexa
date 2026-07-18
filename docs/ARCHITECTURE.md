# Architecture

```text
UI screens
  ├─ AppStateScope (brand, progress, settings, feature flags)
  ├─ CourseRepository (starter course generation)
  ├─ LanguageCatalog (67 languages, scripts, direction)
  ├─ StorageService (offline preferences and progress)
  └─ SpeechService (device TTS and speech recognition)

Production adapters to add
  ├─ AuthService
  ├─ CourseCmsService
  ├─ SyncService
  ├─ AiTutorApi (server-side key only)
  ├─ CommunityService + ModerationService
  ├─ VoiceRoomService (WebRTC/managed provider)
  ├─ AnalyticsService
  └─ BillingService
```

## Design principles

- Offline-first learning state.
- Server authority for identity, entitlements, moderation, and admin roles.
- Immutable versioned course packs with schema validation.
- No API secret in Flutter assets or source code.
- Feature flags let incomplete cloud modules remain disabled.
- RTL and responsive behavior are first-class, not post-launch patches.

## Suggested production backend

- Firebase Auth or Supabase Auth.
- Firestore/Postgres for profiles, progress, courses, and community metadata.
- Cloud Storage/S3-compatible storage for licensed audio and video.
- Cloud Functions/Edge Functions for AI proxy, moderation, and billing webhooks.
- FCM/APNs for reminders and social notifications.
- WebRTC service for voice rooms.

