import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../services/storage_service.dart';
import '../services/auth_service.dart';

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
  double speechRate = .42;
  int lessonXp = 30;
  String aiProvider = 'Local practice engine';
  String aiEndpoint = '';
  String learningReason = 'Travel';
  AppUser? currentUser;
  bool authBusy = false;
  String? authError;
  final Set<String> downloadedPackCodes = {};
  final Set<String> completedLessonIds = {};
  final Set<String> reviewLessonIds = {};
  final Set<String> completedExamIds = {};

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
    speechRate = await _storage.readDouble('speech_rate') ?? .42;
    lessonXp = await _storage.readInt('lesson_xp') ?? 30;
    aiProvider =
        await _storage.readString('ai_provider') ?? 'Local practice engine';
    aiEndpoint = await _storage.readString('ai_endpoint') ?? '';
    await _auth.initialize();
    currentUser = await _auth.restoreSession();
    if (currentUser != null) await _loadUserProgress();
    initialized = true;
    notifyListeners();
  }

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;
  int get registeredAccountCount => _auth.accountCount;

  String _userKey(String key) => 'user_${currentUser?.id ?? 'guest'}_$key';

  Future<void> _loadUserProgress() async {
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
    sprintMode = await _storage.readBool(_userKey('sprint_mode')) ?? true;
    downloadedPackCodes
      ..clear()
      ..addAll(
          await _storage.readStrings(_userKey('downloaded_packs')) ?? const []);
    completedLessonIds
      ..clear()
      ..addAll(await _storage.readStrings(_userKey('completed')) ?? const []);
    reviewLessonIds
      ..clear()
      ..addAll(await _storage.readStrings(_userKey('review')) ?? const []);
    completedExamIds
      ..clear()
      ..addAll(
          await _storage.readStrings(_userKey('completed_exams')) ?? const []);
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

  Future<bool> register(
      {required String displayName,
      required String username,
      required String email,
      required String password}) async {
    authBusy = true;
    authError = null;
    notifyListeners();
    final result = await _auth.register(
        displayName: displayName,
        username: username,
        email: email,
        password: password);
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
    await _storage.writeString(_userKey('target_language'), code);
    await _storage.writeString(_userKey('level'), currentLevel);
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
    notifyListeners();
  }

  Future<void> setCurrentLevel(String level) async {
    currentLevel = level;
    await _storage.writeString(_userKey('level'), level);
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
        _userKey('downloaded_packs'), downloadedPackCodes.toList());
    notifyListeners();
  }

  Future<void> setTheme(String id) async {
    themeId = id;
    await _storage.writeString('theme', id);
    notifyListeners();
  }

  Future<void> completeLesson(String lessonId, {int? earnedXp}) async {
    completedLessonIds.add(lessonId);
    reviewLessonIds.add(lessonId);
    xp += earnedXp ?? lessonXp;
    dailyMinutes += 5;
    await _storage.writeStrings(
        _userKey('completed'), completedLessonIds.toList());
    await _storage.writeStrings(_userKey('review'), reviewLessonIds.toList());
    await _storage.writeInt(_userKey('xp'), xp);
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    notifyListeners();
  }

  Future<void> completeLevelExam(String level, int score) async {
    final examId = '${targetLanguageCode}_$level';
    if (score >= 70) completedExamIds.add(examId);
    xp += score >= 90
        ? 180
        : score >= 70
            ? 120
            : 35;
    dailyMinutes += 10;
    if (score >= 70) {
      const order = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
      final index = order.indexOf(level);
      if (index >= 0 && index < order.length - 1) {
        currentLevel = order[index + 1];
      }
    }
    await _storage.writeStrings(
        _userKey('completed_exams'), completedExamIds.toList());
    await _storage.writeInt(_userKey('xp'), xp);
    await _storage.writeInt(_userKey('daily_minutes'), dailyMinutes);
    await _storage.writeString(_userKey('level'), currentLevel);
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

  Future<void> setSprintMode(bool value) async {
    sprintMode = value;
    await _storage.writeBool(_userKey('sprint_mode'), value);
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
        'features': {
          'aiTutor': aiTutorEnabled,
          'community': communityEnabled,
          'voiceRooms': voiceRoomsEnabled,
          'exams': examsEnabled,
          'stories': storiesEnabled,
          'registration': registrationEnabled,
          'offline': offlineMode,
          'sprintMode': sprintMode,
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
