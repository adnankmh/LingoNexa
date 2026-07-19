import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage);

  final StorageService _storage;

  bool initialized = false;
  bool onboardingCompleted = false;
  Locale locale = const Locale('ar');
  String nativeLanguageCode = 'ar';
  String targetLanguageCode = 'en';
  String themeId = 'midnight';
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
  String aiProvider = 'Local practice engine';
  String aiEndpoint = '';
  String learningReason = 'Travel';
  final Set<String> downloadedPackCodes = {};
  final Set<String> completedLessonIds = {};
  final Set<String> reviewLessonIds = {};

  Future<void> initialize() async {
    onboardingCompleted = await _storage.readBool('onboarding_complete') ?? false;
    locale = Locale(await _storage.readString('locale') ?? 'ar');
    nativeLanguageCode = await _storage.readString('native_language') ?? 'ar';
    targetLanguageCode = await _storage.readString('target_language') ?? 'en';
    themeId = await _storage.readString('theme') ?? 'midnight';
    brandName = await _storage.readString('brand_name') ?? 'LingoNexa';
    currentLevel = await _storage.readString('level') ?? 'A1';
    xp = await _storage.readInt('xp') ?? 1280;
    streak = await _storage.readInt('streak') ?? 7;
    dailyMinutes = await _storage.readInt('daily_minutes') ?? 12;
    dailyGoalMinutes = await _storage.readInt('daily_goal') ?? 20;
    offlineMode = await _storage.readBool('offline') ?? true;
    aiTutorEnabled = await _storage.readBool('feature_ai') ?? true;
    communityEnabled = await _storage.readBool('feature_community') ?? true;
    voiceRoomsEnabled = await _storage.readBool('feature_voice') ?? true;
    aiProvider = await _storage.readString('ai_provider') ?? 'Local practice engine';
    aiEndpoint = await _storage.readString('ai_endpoint') ?? '';
    learningReason = await _storage.readString('learning_reason') ?? 'Travel';
    downloadedPackCodes.addAll(await _storage.readStrings('downloaded_packs') ?? const []);
    completedLessonIds.addAll(await _storage.readStrings('completed') ?? const []);
    reviewLessonIds.addAll(await _storage.readStrings('review') ?? const []);
    initialized = true;
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    locale = Locale(code);
    await _storage.writeString('locale', code);
    notifyListeners();
  }

  Future<void> setTargetLanguage(String code) async {
    targetLanguageCode = code;
    currentLevel = 'A1';
    await _storage.writeString('target_language', code);
    await _storage.writeString('level', currentLevel);
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
    await _storage.writeString('target_language', targetCode);
    await _storage.writeInt('daily_goal', dailyGoalMinutes);
    await _storage.writeString('learning_reason', reason);
    await _storage.writeBool('onboarding_complete', true);
    notifyListeners();
  }

  Future<void> setCurrentLevel(String level) async {
    currentLevel = level;
    await _storage.writeString('level', level);
    notifyListeners();
  }

  Future<void> resetOnboarding() async {
    onboardingCompleted = false;
    await _storage.writeBool('onboarding_complete', false);
    notifyListeners();
  }

  Future<void> toggleDownloadedPack(String code) async {
    if (!downloadedPackCodes.add(code)) downloadedPackCodes.remove(code);
    await _storage.writeStrings('downloaded_packs', downloadedPackCodes.toList());
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _storage.writeString('theme', id);
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId, {int earnedXp = 25}) async {
    completedLessonIds.add(lessonId);
    reviewLessonIds.add(lessonId);
    xp += earnedXp;
    dailyMinutes += 5;
    await _storage.writeStrings('completed', completedLessonIds.toList());
    await _storage.writeStrings('review', reviewLessonIds.toList());
    await _storage.writeInt('xp', xp);
    await _storage.writeInt('daily_minutes', dailyMinutes);
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
  }) async {
    brandName = name.trim().isEmpty ? 'LingoNexa' : name.trim();
    dailyGoalMinutes = goal.clamp(5, 120).toInt();
    aiTutorEnabled = ai;
    communityEnabled = community;
    voiceRoomsEnabled = voiceRooms;
    aiProvider = provider?.trim().isNotEmpty == true ? provider!.trim() : 'Local practice engine';
    aiEndpoint = endpoint?.trim() ?? aiEndpoint;
    await _storage.writeString('brand_name', brandName);
    await _storage.writeInt('daily_goal', dailyGoalMinutes);
    await _storage.writeBool('feature_ai', ai);
    await _storage.writeBool('feature_community', community);
    await _storage.writeBool('feature_voice', voiceRooms);
    await _storage.writeString('ai_provider', aiProvider);
    await _storage.writeString('ai_endpoint', aiEndpoint);
    notifyListeners();
  }

  Future<void> setOfflineMode(bool value) async {
    offlineMode = value;
    await _storage.writeBool('offline', value);
    notifyListeners();
  }

  String exportConfiguration() => const JsonEncoder.withIndent('  ').convert({
        'brandName': brandName,
        'locale': locale.languageCode,
        'nativeLanguage': nativeLanguageCode,
        'targetLanguage': targetLanguageCode,
        'theme': themeId,
        'level': currentLevel,
        'dailyGoalMinutes': dailyGoalMinutes,
        'learningReason': learningReason,
        'downloadedPacks': downloadedPackCodes.toList(),
        'features': {
          'aiTutor': aiTutorEnabled,
          'community': communityEnabled,
          'voiceRooms': voiceRoomsEnabled,
          'offline': offlineMode,
        },
        'conversation': {
          'provider': aiProvider,
          'endpoint': aiEndpoint,
          'apiKeyStoredInApp': false,
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
