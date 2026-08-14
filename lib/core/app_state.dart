import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../data/adaptive_learning_engine.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage) : _auth = AuthService(_storage);

  final StorageService _storage;
  final AuthService _auth;

  bool initialized = false;
  bool onboardingCompleted = false;
  Locale locale = const Locale('en');
  String nativeLanguageCode = 'en';
  String targetLanguageCode = 'en';
  String themeId = 'snow';
  String brandName = 'LingoNexa';
  String currentLevel = 'A1';
  int xp = 1280;
  int streak = 7;
  int dailyMinutes = 12;
  int dailyGoalMinutes = 20;
  bool offlineMode = true;
  bool aiTutorEnabled = true;
  bool communityEnabled = true;
  bool voiceRoomsEnabled = true;
  bool sprintMode = true;
  bool examsEnabled = true;
  bool storiesEnabled = true;
  bool registrationEnabled = true;
  bool privacyFirstMode = true;
  bool anonymousAnalytics = false;
  bool privateCrashReports = false;
  bool onDevicePersonalization = true;
  bool saveVoiceRecordings = false;
  int sessionTimeoutMinutes = 30;
  double speechRate = .42;
  int lessonXp = 30;
  int weeklyXp = 0;
  String aiProvider = 'Local practice engine';
  String aiEndpoint = '';
  String learningReason = 'Travel';
  String countryCode = 'PS';
  AppUser? currentUser;
  bool authBusy = false;
  String? authError;
  final Set<String> downloadedPackCodes = {};
  final Set<String> completedLessonIds = {};
  final Set<String> reviewLessonIds = {};
  final Set<String> completedExamIds = {};
  final Map<String, ReviewRecord> reviewRecords = {};
  final Map<String, int> skillMastery = {
    'reading': 42,
    'listening': 36,
    'speaking': 31,
    'writing': 34,
    'grammar': 40,
    'vocabulary': 45,
  };
  final Map<String, String> _preferredVoices = {};

  Future<void> initialize() async {
    locale = Locale(await _storage.readString('locale') ?? 'en');
    nativeLanguageCode = await _storage.readString('native_language') ?? 'en';
    themeId = await _storage.readString('theme') ?? 'snow';
    brandName = await _storage.readString('brand_name') ?? 'LingoNexa';
    offlineMode = await _storage.readBool('offline') ?? true;
    aiTutorEnabled = await _storage.readBool('feature_ai') ?? true;
    communityEnabled = await _storage.readBool('feature_community') ?? true;
    voiceRoomsEnabled = await _storage.readBool('feature_voice') ?? true;
    examsEnabled = await _storage.readBool('feature_exams') ?? true;
    storiesEnabled = await _storage.readBool('feature_stories') ?? true;
    registrationEnabled =
        await _storage.readBool('feature_registration') ?? true;
    privacyFirstMode = await _storage.readBool('privacy_first') ?? true;
    anonymousAnalytics =
        await _storage.readBool('anonymous_analytics') ?? false;
    privateCrashReports =
        await _storage.readBool('private_crash_reports') ?? false;
    onDevicePersonalization =
        await _storage.readBool('device_personalization') ?? true;
    saveVoiceRecordings =
        await _storage.readBool('save_voice_recordings') ?? false;
    sessionTimeoutMinutes =
        await _storage.readInt('session_timeout_minutes') ?? 30;
    speechRate = await _storage.readDouble('speech_rate') ?? .42;
    lessonXp = await _storage.readInt('lesson_xp') ?? 30;
    aiProvider =
        await _storage.readString('ai_provider') ?? 'Local practice engine';
    aiEndpoint = await _storage.readString('ai_endpoint') ?? '';
    await _auth.initialize();
    currentUser = await _auth.restoreSession(
      sessionLifetime: Duration(minutes: sessionTimeoutMinutes),
    );
    if (currentUser != null) await _loadUserProgress();
    initialized = true;
    notifyListeners();
  }

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;
  int get registeredAccountCount => _auth.accountCount;
  bool get remoteBackendEnabled => _auth.remoteEnabled;
  String get apiBaseUrl => _auth.apiBaseUrl;

  String _userKey(String key) => 'user_${currentUser?.id ?? 'guest'}_$key';

  Future<void> _loadUserProgress() async {
    final userLocale = await _storage.readString(_userKey('interface_locale'));
    if (userLocale != null && userLocale.isNotEmpty) locale = Locale(userLocale);
    themeId = await _storage.readString(_userKey('theme')) ?? themeId;
    onboardingCompleted =
        await _storage.readBool(_userKey('onboarding_complete')) ?? false;
    targetLanguageCode =
        await _storage.readString(_userKey('target_language')) ?? 'en';
    currentLevel = await _storage.readString(_userKey('level')) ?? 'A1';
    xp = await _storage.readInt(_userKey('xp')) ?? 0;
    streak = await _storage.readInt(_userKey('streak')) ?? 1;
    dailyMinutes = await _storage.readInt(_userKey('daily_minutes')) ?? 0;
    dailyGoalMinutes = await _storage.readInt(_userKey('daily_goal')) ?? 15;
    learningReason =
        await _storage.readString(_userKey('learning_reason')) ?? 'Travel';
    countryCode = await _storage.readString(_userKey('country_code')) ?? 'PS';
    sprintMode = await _storage.readBool(_userKey('sprint_mode')) ?? true;
    downloadedPackCodes
      ..clear()
      ..addAll(
        await _storage.readStrings(_userKey('downloaded_packs')) ?? const [],
      );
    completedLessonIds
      ..clear()
      ..addAll(await _storage.readStrings(_userKey('completed')) ?? const []);
    reviewLessonIds
      ..clear()
      ..addAll(await _storage.readStrings(_userKey('review')) ?? const []);
    completedExamIds
      ..clear()
      ..addAll(
        await _storage.readStrings(_userKey('completed_exams')) ?? const [],
      );
    weeklyXp = await _storage.readInt(_userKey('weekly_xp')) ?? 0;
    reviewRecords
      ..clear()
      ..addAll(
        AdaptiveLearningEngine.decode(
          await _storage.readString(_userKey('adaptive_reviews')),
        ),
      );
    final savedMastery = await _storage.readString(_userKey('skill_mastery'));
    if (savedMastery != null) {
      try {
        final decoded = jsonDecode(savedMastery);
        if (decoded is Map) {
          for (final key in skillMastery.keys.toList()) {
            final value = decoded[key];
            if (value is num) skillMastery[key] = value.round().clamp(0, 100);
          }
        }
      } catch (_) {
        // Keep the safe starter profile if local progress was interrupted.
      }
    }
    final savedVoices = await _storage.readString(_userKey('voice_choices'));
    _preferredVoices.clear();
    if (savedVoices != null && savedVoices.isNotEmpty) {
      try {
        final decoded = jsonDecode(savedVoices);
        if (decoded is Map) {
          for (final entry in decoded.entries) {
            if (entry.key is String && entry.value is String) {
              _preferredVoices[entry.key as String] = entry.value as String;
            }
          }
        }
      } catch (_) {
        // Ignore a damaged local preference and let the device choose a voice.
      }
    }
    if (_auth.remoteEnabled && currentUser?.role != UserRole.guest) {
      try {
        final remote = await _auth.loadRemoteProgress();
        if (remote.isNotEmpty) {
          _applyRemoteProgress(remote);
          await _persistProgressSnapshot();
        }
      } catch (_) {
        // Keep the local snapshot available if the server is temporarily offline.
      }
    }
  }

  Map<String, Object?> _progressSnapshot() => {
        'interfaceLocale': locale.languageCode,
        'themeId': themeId,
        'onboardingCompleted': onboardingCompleted,
        'targetLanguageCode': targetLanguageCode,
        'currentLevel': currentLevel,
        'xp': xp,
        'streak': streak,
        'dailyMinutes': dailyMinutes,
        'dailyGoalMinutes': dailyGoalMinutes,
        'learningReason': learningReason,
        'countryCode': countryCode,
        'sprintMode': sprintMode,
        'downloadedPackCodes': downloadedPackCodes.toList(),
        'completedLessonIds': completedLessonIds.toList(),
        'reviewLessonIds': reviewLessonIds.toList(),
        'completedExamIds': completedExamIds.toList(),
        'weeklyXp': weeklyXp,
        'skillMastery': skillMastery,
        'adaptiveReviews': AdaptiveLearningEngine.encode(reviewRecords),
      };

  void _applyRemoteProgress(Map<String, Object?> value) {
    String stringValue(String key, String fallback) =>
        value[key]?.toString() ?? fallback;
    int intValue(String key, int fallback) =>
        value[key] is num ? (value[key] as num).round() : fallback;
    bool boolValue(String key, bool fallback) =>
        value[key] is bool ? value[key] as bool : fallback;
    List<String> strings(String key) {
      final raw = value[key];
      return raw is List ? raw.map((item) => item.toString()).toList() : const [];
    }

    final remoteLocale = stringValue('interfaceLocale', locale.languageCode);
    if (remoteLocale.isNotEmpty) locale = Locale(remoteLocale);
    themeId = stringValue('themeId', themeId);
    onboardingCompleted = boolValue('onboardingCompleted', onboardingCompleted);
    targetLanguageCode = stringValue('targetLanguageCode', targetLanguageCode);
    currentLevel = stringValue('currentLevel', currentLevel);
    xp = intValue('xp', xp);
    streak = intValue('streak', streak);
    dailyMinutes = intValue('dailyMinutes', dailyMinutes);
    dailyGoalMinutes = intValue('dailyGoalMinutes', dailyGoalMinutes);
    learningReason = stringValue('learningReason', learningReason);
    countryCode = stringValue('countryCode', countryCode);
    sprintMode = boolValue('sprintMode', sprintMode);
    weeklyXp = intValue('weeklyXp', weeklyXp);
    downloadedPackCodes
      ..clear()
      ..addAll(strings('downloadedPackCodes'));
    completedLessonIds
      ..clear()
      ..addAll(strings('completedLessonIds'));
    reviewLessonIds
      ..clear()
      ..addAll(strings('reviewLessonIds'));
    completedExamIds
      ..clear()
      ..addAll(strings('completedExamIds'));
    final remoteMastery = value['skillMastery'];
    if (remoteMastery is Map) {
      for (final key in skillMastery.keys.toList()) {
        final item = remoteMastery[key];
        if (item is num) skillMastery[key] = item.round().clamp(0, 100);
      }
    }
    final adaptive = value['adaptiveReviews']?.toString();
    if (adaptive != null && adaptive.isNotEmpty) {
      reviewRecords
        ..clear()
        ..addAll(AdaptiveLearningEngine.decode(adaptive));
    }
  }

  Future<void> _persistProgressSnapshot() async {
    await _storage.writeString(_userKey('interface_locale'), locale.languageCode);
    await _storage.writeString(_userKey('theme'), themeId);
    await _storage.writeString('locale', locale.languageCode);
    await _storage.writeString('theme', themeId);
    await _storage.writeBool(_userKey('onboarding_complete'), onboardingCompleted);
    await _storage.writeString(_userKey('target_language'), targetLanguageCode);
    await _storage.writeString(_userKey('level'), currentLevel);
    await _storage.writeInt(_userKey('xp'), xp);
    await _storage.writeInt(_userKey('streak'), streak);
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    await _storage.writeInt(_userKey('daily_goal'), dailyGoalMinutes);
    await _storage.writeString(_userKey('learning_reason'), learningReason);
    await _storage.writeString(_userKey('country_code'), countryCode);
    await _storage.writeBool(_userKey('sprint_mode'), sprintMode);
    await _storage.writeStrings(_userKey('downloaded_packs'), downloadedPackCodes.toList());
    await _storage.writeStrings(_userKey('completed'), completedLessonIds.toList());
    await _storage.writeStrings(_userKey('review'), reviewLessonIds.toList());
    await _storage.writeStrings(_userKey('completed_exams'), completedExamIds.toList());
    await _storage.writeInt(_userKey('weekly_xp'), weeklyXp);
    await _persistAdaptiveProgress();
  }

  Future<void> _syncRemoteProgress() async {
    if (!_auth.remoteEnabled || currentUser?.role == UserRole.guest) return;
    try {
      await _auth.saveRemoteProgress(_progressSnapshot());
    } catch (_) {
      // Local progress remains authoritative until the next successful sync.
    }
  }

  Future<bool> signIn(String identifier, String password) async {
    authBusy = true;
    authError = null;
    notifyListeners();
    final result = await _auth.signIn(identifier, password);
    authBusy = false;
    if (!result.success) {
      authError = result.error;
      notifyListeners();
      return false;
    }
    currentUser = result.user;
    await _loadUserProgress();
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String displayName,
    required String username,
    required String email,
    required String password,
  }) async {
    authBusy = true;
    authError = null;
    notifyListeners();
    final result = await _auth.register(
      displayName: displayName,
      username: username,
      email: email,
      password: password,
    );
    authBusy = false;
    if (!result.success) {
      authError = result.error;
      notifyListeners();
      return false;
    }
    currentUser = result.user;
    await _loadUserProgress();
    notifyListeners();
    return true;
  }

  Future<void> signInAsGuest() async {
    currentUser = await _auth.signInAsGuest();
    await _loadUserProgress();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    authError = null;
    completedLessonIds.clear();
    reviewLessonIds.clear();
    downloadedPackCodes.clear();
    completedExamIds.clear();
    reviewRecords.clear();
    _preferredVoices.clear();
    weeklyXp = 0;
    notifyListeners();
  }

  Future<void> setApiBaseUrl(String value) async {
    await _auth.setApiBaseUrl(value);
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    locale = Locale(code);
    await _storage.writeString('locale', code);
    if (currentUser != null) {
      await _storage.writeString(_userKey('interface_locale'), code);
      await _syncRemoteProgress();
    }
    notifyListeners();
  }

  Future<void> setTargetLanguage(String code) async {
    targetLanguageCode = code;
    currentLevel = 'A1';
    await _storage.writeString(_userKey('target_language'), code);
    await _storage.writeString(_userKey('level'), currentLevel);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String targetCode,
    required int goalMinutes,
    required String reason,
  }) async {
    targetLanguageCode = targetCode;
    dailyGoalMinutes = goalMinutes.clamp(5, 60).toInt();
    learningReason = reason;
    onboardingCompleted = true;
    await _storage.writeString(_userKey('target_language'), targetCode);
    await _storage.writeInt(_userKey('daily_goal'), dailyGoalMinutes);
    await _storage.writeString(_userKey('learning_reason'), reason);
    await _storage.writeBool(_userKey('onboarding_complete'), true);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> setCurrentLevel(String level) async {
    currentLevel = level;
    await _storage.writeString(_userKey('level'), level);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> setCountryCode(String code) async {
    countryCode = code.toUpperCase();
    await _storage.writeString(_userKey('country_code'), countryCode);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    onboardingCompleted = false;
    await _storage.writeBool(_userKey('onboarding_complete'), false);
    notifyListeners();
  }

  Future<void> toggleDownloadedPack(String code) async {
    if (!downloadedPackCodes.add(code)) downloadedPackCodes.remove(code);
    await _storage.writeStrings(
      _userKey('downloaded_packs'),
      downloadedPackCodes.toList(),
    );
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _storage.writeString('theme', id);
    if (currentUser != null) {
      await _storage.writeString(_userKey('theme'), id);
      await _syncRemoteProgress();
    }
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId, {int? earnedXp}) async {
    completedLessonIds.add(lessonId);
    reviewLessonIds.add(lessonId);
    final reward = earnedXp ?? lessonXp;
    xp += reward;
    weeklyXp += reward;
    dailyMinutes += 5;
    reviewRecords.putIfAbsent(
      lessonId,
      () => AdaptiveLearningEngine.firstReview(lessonId),
    );
    _raiseMasteryFor(lessonId, amount: 3);
    await _storage.writeStrings(
      _userKey('completed'),
      completedLessonIds.toList(),
    );
    await _storage.writeStrings(_userKey('review'), reviewLessonIds.toList());
    await _storage.writeInt(_userKey('xp'), xp);
    await _storage.writeInt(_userKey('weekly_xp'), weeklyXp);
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    await _persistAdaptiveProgress();
    await _syncRemoteProgress();
    notifyListeners();
  }

  List<ReviewRecord> dueReviews({DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    final due = reviewRecords.values
        .where((record) => record.isDueAt(timestamp))
        .toList()
      ..sort((a, b) => a.nextReview.compareTo(b.nextReview));
    return due;
  }

  int get masteryScore {
    if (skillMastery.isEmpty) return 0;
    return (skillMastery.values.reduce((a, b) => a + b) / skillMastery.length)
        .round();
  }

  String get strongestSkill =>
      skillMastery.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

  String get focusSkill =>
      skillMastery.entries.reduce((a, b) => a.value <= b.value ? a : b).key;

  Future<void> recordReview(String lessonId, int quality) async {
    final current = reviewRecords[lessonId] ??
        AdaptiveLearningEngine.firstReview(
          lessonId,
          now: DateTime.now().subtract(const Duration(days: 1)),
        );
    reviewRecords[lessonId] = AdaptiveLearningEngine.grade(current, quality);
    if (quality >= 3) _raiseMasteryFor(lessonId, amount: quality - 1);
    await _persistAdaptiveProgress();
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> recordSkillPractice(String skill, int score) async {
    if (!skillMastery.containsKey(skill)) return;
    final gain = score >= 85
        ? 3
        : score >= 65
            ? 2
            : 1;
    skillMastery[skill] = ((skillMastery[skill] ?? 0) + gain).clamp(0, 100);
    dailyMinutes += 3;
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    await _persistAdaptiveProgress();
    await _syncRemoteProgress();
    notifyListeners();
  }

  void _raiseMasteryFor(String lessonId, {required int amount}) {
    const skills = [
      'vocabulary',
      'listening',
      'speaking',
      'reading',
      'grammar',
      'writing',
    ];
    final skill = skills[lessonId.hashCode.abs() % skills.length];
    skillMastery[skill] = ((skillMastery[skill] ?? 0) + amount).clamp(0, 100);
  }

  Future<void> _persistAdaptiveProgress() async {
    await _storage.writeString(
      _userKey('adaptive_reviews'),
      AdaptiveLearningEngine.encode(reviewRecords),
    );
    await _storage.writeString(
      _userKey('skill_mastery'),
      jsonEncode(skillMastery),
    );
  }

  Future<void> completeLevelExam(String level, int score) async {
    final examId = '${targetLanguageCode}_$level';
    if (score >= 70) completedExamIds.add(examId);
    final reward = score >= 90
        ? 180
        : score >= 70
            ? 120
            : 35;
    xp += reward;
    weeklyXp += reward;
    dailyMinutes += 10;
    if (score >= 70) {
      const order = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
      final index = order.indexOf(level);
      if (index >= 0 && index < order.length - 1) {
        currentLevel = order[index + 1];
      }
    }
    await _storage.writeStrings(
      _userKey('completed_exams'),
      completedExamIds.toList(),
    );
    await _storage.writeInt(_userKey('xp'), xp);
    await _storage.writeInt(_userKey('weekly_xp'), weeklyXp);
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    await _storage.writeString(_userKey('level'), currentLevel);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> updateAdmin({
    required String name,
    required int goal,
    required bool ai,
    required bool community,
    required bool voiceRooms,
    String? provider,
    String? endpoint,
    bool? exams,
    bool? stories,
    bool? registration,
    double? voiceRate,
    int? xpPerLesson,
  }) async {
    if (!isAdmin) return;
    brandName = name.trim().isEmpty ? 'LingoNexa' : name.trim();
    dailyGoalMinutes = goal.clamp(5, 120).toInt();
    aiTutorEnabled = ai;
    communityEnabled = community;
    voiceRoomsEnabled = voiceRooms;
    aiProvider = provider?.trim().isNotEmpty == true
        ? provider!.trim()
        : 'Local practice engine';
    aiEndpoint = endpoint?.trim() ?? aiEndpoint;
    examsEnabled = exams ?? examsEnabled;
    storiesEnabled = stories ?? storiesEnabled;
    registrationEnabled = registration ?? registrationEnabled;
    speechRate = (voiceRate ?? speechRate).clamp(.25, .60).toDouble();
    lessonXp = (xpPerLesson ?? lessonXp).clamp(5, 100).toInt();
    await _storage.writeString('brand_name', brandName);
    await _storage.writeInt('daily_goal', dailyGoalMinutes);
    await _storage.writeInt(_userKey('daily_goal'), dailyGoalMinutes);
    await _storage.writeBool('feature_ai', ai);
    await _storage.writeBool('feature_community', community);
    await _storage.writeBool('feature_voice', voiceRooms);
    await _storage.writeString('ai_provider', aiProvider);
    await _storage.writeString('ai_endpoint', aiEndpoint);
    await _storage.writeBool('feature_exams', examsEnabled);
    await _storage.writeBool('feature_stories', storiesEnabled);
    await _storage.writeBool('feature_registration', registrationEnabled);
    await _storage.writeDouble('speech_rate', speechRate);
    await _storage.writeInt('lesson_xp', lessonXp);
    notifyListeners();
  }

  Future<void> setOfflineMode(bool value) async {
    offlineMode = value;
    await _storage.writeBool('offline', value);
    notifyListeners();
  }

  Future<void> setSpeechRate(double value) async {
    speechRate = value.clamp(.25, .60).toDouble();
    await _storage.writeDouble('speech_rate', speechRate);
    notifyListeners();
  }

  String? preferredVoiceFor(String languageCode) =>
      _preferredVoices[languageCode];

  Future<void> setPreferredVoice(String languageCode, String? voiceName) async {
    if (voiceName == null || voiceName.trim().isEmpty) {
      _preferredVoices.remove(languageCode);
    } else {
      _preferredVoices[languageCode] = voiceName.trim();
    }
    await _storage.writeString(
      _userKey('voice_choices'),
      jsonEncode(_preferredVoices),
    );
    notifyListeners();
  }

  Future<void> setSprintMode(bool value) async {
    sprintMode = value;
    await _storage.writeBool(_userKey('sprint_mode'), value);
    await _syncRemoteProgress();
    notifyListeners();
  }

  Future<void> updatePrivacy({
    bool? privacyFirst,
    bool? analytics,
    bool? crashReports,
    bool? personalization,
    bool? storeVoice,
    int? timeoutMinutes,
  }) async {
    privacyFirstMode = privacyFirst ?? privacyFirstMode;
    anonymousAnalytics = analytics ?? anonymousAnalytics;
    privateCrashReports = crashReports ?? privateCrashReports;
    onDevicePersonalization = personalization ?? onDevicePersonalization;
    saveVoiceRecordings = storeVoice ?? saveVoiceRecordings;
    sessionTimeoutMinutes =
        (timeoutMinutes ?? sessionTimeoutMinutes).clamp(5, 720);
    if (privacyFirstMode) {
      anonymousAnalytics = false;
      saveVoiceRecordings = false;
    }
    await _storage.writeBool('privacy_first', privacyFirstMode);
    await _storage.writeBool('anonymous_analytics', anonymousAnalytics);
    await _storage.writeBool('private_crash_reports', privateCrashReports);
    await _storage.writeBool(
      'device_personalization',
      onDevicePersonalization,
    );
    await _storage.writeBool('save_voice_recordings', saveVoiceRecordings);
    await _storage.writeInt('session_timeout_minutes', sessionTimeoutMinutes);
    notifyListeners();
  }

  Future<void> clearLearningHistory() async {
    for (final key in [
      'completed',
      'review',
      'completed_exams',
      'adaptive_reviews',
      'skill_mastery',
      'weekly_xp',
      'xp',
      'daily_minutes',
      'voice_choices',
    ]) {
      await _storage.remove(_userKey(key));
    }
    completedLessonIds.clear();
    reviewLessonIds.clear();
    completedExamIds.clear();
    reviewRecords.clear();
    _preferredVoices.clear();
    skillMastery
      ..clear()
      ..addAll({
        'reading': 42,
        'listening': 36,
        'speaking': 31,
        'writing': 34,
        'grammar': 40,
        'vocabulary': 45,
      });
    xp = 0;
    weeklyXp = 0;
    dailyMinutes = 0;
    notifyListeners();
  }

  String exportConfiguration() => const JsonEncoder.withIndent('  ').convert({
        'brandName': brandName,
        'user': currentUser?.toJson(),
        'locale': locale.languageCode,
        'nativeLanguage': nativeLanguageCode,
        'targetLanguage': targetLanguageCode,
        'theme': themeId,
        'level': currentLevel,
        'dailyGoalMinutes': dailyGoalMinutes,
        'learningReason': learningReason,
        'downloadedPacks': downloadedPackCodes.toList(),
        'completedExams': completedExamIds.toList(),
        'adaptiveReview': {
          'dueNow': dueReviews().length,
          'scheduledItems': reviewRecords.length,
          'mastery': masteryScore,
          'skills': skillMastery,
        },
        'features': {
          'aiTutor': aiTutorEnabled,
          'community': communityEnabled,
          'voiceRooms': voiceRoomsEnabled,
          'exams': examsEnabled,
          'stories': storiesEnabled,
          'registration': registrationEnabled,
          'offline': offlineMode,
          'sprintMode': sprintMode,
          'privacyFirst': privacyFirstMode,
          'anonymousAnalytics': anonymousAnalytics,
          'privateCrashReports': privateCrashReports,
          'onDevicePersonalization': onDevicePersonalization,
          'saveVoiceRecordings': saveVoiceRecordings,
        },
        'conversation': {
          'provider': aiProvider,
          'endpoint': aiEndpoint,
          'apiKeyStoredInApp': false,
          'speechRate': speechRate,
        },
      });
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    required AppState state,
    required super.child,
    super.key,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope is missing above this context.');
    return scope!.notifier!;
  }
}
