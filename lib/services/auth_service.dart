import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import 'storage_service.dart';
import 'api_service.dart';

enum UserRole { administrator, learner, guest }

class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.role,
    this.provider = 'password',
  });

  final String id;
  final String username;
  final String email;
  final String displayName;
  final UserRole role;
  final String provider;

  bool get isAdmin => role == UserRole.administrator;

  Map<String, Object?> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'displayName': displayName,
        'role': role.name,
        'provider': provider,
      };

  static AppUser fromJson(Map<String, Object?> json) => AppUser(
        id: json['id']! as String,
        username: json['username']! as String,
        email: json['email']! as String,
        displayName: json['displayName']! as String,
        role: UserRole.values.firstWhere(
          (item) => item.name == json['role'],
          orElse: () => UserRole.learner,
        ),
        provider: json['provider'] as String? ?? 'password',
      );
}

class AuthResult {
  const AuthResult({this.user, this.error});
  final AppUser? user;
  final String? error;
  bool get success => user != null;
}

class _StoredAccount {
  const _StoredAccount({
    required this.user,
    required this.passwordHash,
    required this.passwordSalt,
    required this.iterations,
    this.legacyHash = false,
  });
  final AppUser user;
  final String passwordHash;
  final String passwordSalt;
  final int iterations;
  final bool legacyHash;

  Map<String, Object?> toJson() => {
        ...user.toJson(),
        'passwordHash': passwordHash,
        'passwordSalt': passwordSalt,
        'iterations': iterations,
        'algorithm': 'PBKDF2-HMAC-SHA256',
      };

  static _StoredAccount fromJson(Map<String, Object?> json) => _StoredAccount(
        user: AppUser.fromJson(json),
        passwordHash: json['passwordHash']! as String,
        passwordSalt: json['passwordSalt'] as String? ?? '',
        iterations: json['iterations'] as int? ?? 0,
        legacyHash: json['passwordSalt'] == null,
      );
}

/// Local account adapter used for the offline demo. It deliberately exposes no
/// social-provider secrets. Production builds should replace this adapter with
/// Firebase Auth, Supabase Auth, or another server-verified identity provider.
class AuthService {
  AuthService(this._storage) : _api = ApiService(_storage);

  final StorageService _storage;
  final ApiService _api;
  static const _accountsKey = 'auth_accounts_v1';
  static const _sessionKey = 'auth_session_v1';
  static const _sessionStartedKey = 'auth_session_started_v2';
  static const _iterations = 12000;
  static const _maximumSessionLifetime = Duration(hours: 12);
  List<_StoredAccount> _accounts = [];
  final Map<String, int> _failedAttempts = {};
  final Map<String, DateTime> _blockedUntil = {};
  int get accountCount => _accounts.length;
  bool get remoteEnabled => _api.enabled;
  String get apiBaseUrl => _api.baseUrl;

  Future<void> initialize() async {
    await _api.initialize();
    final encoded = await _storage.readString(_accountsKey);
    if (encoded == null) {
      _accounts = _seedAccounts();
      await _persistAccounts();
    } else {
      try {
        final decoded = jsonDecode(encoded) as List<dynamic>;
        _accounts = decoded
            .map(
              (item) => _StoredAccount.fromJson(
                Map<String, Object?>.from(item as Map),
              ),
            )
            .toList();
      } on Object {
        // Local demo data may outlive schema changes or be partially corrupted.
        // Recover to known-safe seed accounts and invalidate any stale session.
        _accounts = _seedAccounts();
        await _persistAccounts();
        await _storage.remove(_sessionKey);
        await _storage.remove(_sessionStartedKey);
      }
    }
  }

  Future<AppUser?> restoreSession({Duration? sessionLifetime}) async {
    if (_api.enabled) {
      final payload = await _api.restoreRemoteSession();
      return payload == null ? null : _remoteUser(payload);
    }
    final id = await _storage.readString(_sessionKey);
    if (id == null) return null;
    final startedValue = await _storage.readString(_sessionStartedKey);
    final started = DateTime.tryParse(startedValue ?? '');
    final lifetime = sessionLifetime ?? _maximumSessionLifetime;
    if (started == null || DateTime.now().difference(started) > lifetime) {
      await signOut();
      return null;
    }
    for (final account in _accounts) {
      if (account.user.id == id) return account.user;
    }
    if (id == 'guest') return guestUser;
    return null;
  }

  Future<AuthResult> signIn(String identifier, String password) async {
    if (_api.enabled) {
      try {
        final payload = await _api.login(identifier.trim(), password);
        return AuthResult(user: _remoteUser(payload));
      } on ApiException catch (error) {
        return AuthResult(error: error.message);
      }
    }
    final normalized = identifier.trim().toLowerCase();
    final blocked = _blockedUntil[normalized];
    if (blocked != null && blocked.isAfter(DateTime.now())) {
      final seconds = blocked.difference(DateTime.now()).inSeconds + 1;
      return AuthResult(
        error: 'Too many attempts. Try again in $seconds seconds.',
      );
    }
    for (final account in _accounts) {
      final matchesIdentity =
          account.user.username.toLowerCase() == normalized ||
              account.user.email.toLowerCase() == normalized;
      if (matchesIdentity) {
        final candidate = account.legacyHash
            ? _legacyHash(password)
            : _deriveHash(password, account.passwordSalt, account.iterations);
        if (_constantTimeEquals(account.passwordHash, candidate)) {
          _failedAttempts.remove(normalized);
          _blockedUntil.remove(normalized);
          if (account.legacyHash)
            await _upgradeLegacyAccount(account, password);
          await _startSession(account.user.id);
          return AuthResult(user: account.user);
        }
      }
    }
    final failures = (_failedAttempts[normalized] ?? 0) + 1;
    _failedAttempts[normalized] = failures;
    if (failures >= 5) {
      _blockedUntil[normalized] =
          DateTime.now().add(const Duration(seconds: 30));
      _failedAttempts[normalized] = 0;
    }
    return const AuthResult(error: 'Incorrect username, email, or password.');
  }

  Future<AuthResult> register({
    required String displayName,
    required String username,
    required String email,
    required String password,
  }) async {
    if (_api.enabled) {
      try {
        final payload = await _api.register(
          displayName: displayName.trim(),
          username: username.trim(),
          email: email.trim(),
          password: password,
        );
        return AuthResult(user: _remoteUser(payload));
      } on ApiException catch (error) {
        return AuthResult(error: error.message);
      }
    }
    final cleanUsername = username.trim();
    final cleanEmail = email.trim().toLowerCase();
    if (displayName.trim().length < 2 || cleanUsername.length < 3) {
      return const AuthResult(error: 'Name and username are too short.');
    }
    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return const AuthResult(error: 'Enter a valid email address.');
    }
    if (!_isStrongPassword(password)) {
      return const AuthResult(
        error:
            'Use at least 10 characters with upper and lower case letters and a number.',
      );
    }
    if (_accounts.any(
      (item) =>
          item.user.username.toLowerCase() == cleanUsername.toLowerCase() ||
          item.user.email == cleanEmail,
    )) {
      return const AuthResult(
        error: 'This username or email is already registered.',
      );
    }
    final user = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: cleanUsername,
      email: cleanEmail,
      displayName: displayName.trim(),
      role: UserRole.learner,
    );
    final salt = _randomSalt();
    _accounts.add(
      _StoredAccount(
        user: user,
        passwordHash: _deriveHash(password, salt, _iterations),
        passwordSalt: salt,
        iterations: _iterations,
      ),
    );
    await _persistAccounts();
    await _startSession(user.id);
    return AuthResult(user: user);
  }

  Future<AppUser> signInAsGuest() async {
    await _startSession(guestUser.id);
    return guestUser;
  }

  Future<void> signOut() async {
    if (_api.enabled) await _api.logout();
    await _storage.remove(_sessionKey);
    await _storage.remove(_sessionStartedKey);
  }

  Future<Map<String, Object?>> loadRemoteProgress() async =>
      _api.loadProgress();

  Future<void> saveRemoteProgress(Map<String, Object?> progress) async =>
      _api.saveProgress(progress);

  Future<void> setApiBaseUrl(String value) async => _api.setBaseUrl(value);

  AppUser _remoteUser(Map<String, Object?> json) => AppUser(
        id: json['id']?.toString() ?? '',
        username: json['username']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        displayName:
            json['displayName']?.toString() ?? json['name']?.toString() ?? 'Learner',
        role: json['role']?.toString() == 'administrator'
            ? UserRole.administrator
            : UserRole.learner,
        provider: json['provider']?.toString() ?? 'password',
      );

  static const guestUser = AppUser(
    id: 'guest',
    username: 'guest',
    email: '',
    displayName: 'Guest Explorer',
    role: UserRole.guest,
  );

  static List<_StoredAccount> _seedAccounts() => [
        const _StoredAccount(
          user: AppUser(
            id: 'admin_local_demo',
            username: 'admin',
            email: 'admin@lingonexa.local',
            displayName: 'Local Administrator',
            role: UserRole.administrator,
          ),
          passwordHash: 'YdruNxA-M9Z8wEFYWBsGyWNqKC-2Mf2xA0AHe2OD9dU',
          passwordSalt: 'bGluZ29uZXhhLWFkbWluLXYz',
          iterations: _iterations,
        ),
        const _StoredAccount(
          user: AppUser(
            id: 'demo_1',
            username: 'demo1',
            email: 'demo1@lingonexa.app',
            displayName: 'Demo Explorer',
            role: UserRole.learner,
          ),
          passwordHash: 'jL4l_TKqjF8bTRRiJwYvw5totTh1kaMqd7r0yEbvDMQ',
          passwordSalt: 'bGluZ29uZXhhLWRlbW8xLXYz',
          iterations: _iterations,
        ),
        const _StoredAccount(
          user: AppUser(
            id: 'demo_2',
            username: 'demo2',
            email: 'demo2@lingonexa.app',
            displayName: 'World Learner',
            role: UserRole.learner,
          ),
          passwordHash: 'sE-8xnrVAHbGOf50jCunQIKWK4WlbVG25e7fa8ntzCY',
          passwordSalt: 'bGluZ29uZXhhLWRlbW8yLXYz',
          iterations: _iterations,
        ),
      ];

  static bool _isStrongPassword(String password) =>
      password.length >= 10 &&
      RegExp('[a-z]').hasMatch(password) &&
      RegExp('[A-Z]').hasMatch(password) &&
      RegExp('[0-9]').hasMatch(password);

  static String _randomSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(18, (_) => random.nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static List<int> _decodeBase64Url(String value) {
    final padding = '=' * ((4 - value.length % 4) % 4);
    return base64Url.decode('$value$padding');
  }

  static String _deriveHash(String password, String salt, int iterations) {
    final key = utf8.encode(password);
    final saltBytes = _decodeBase64Url(salt);
    final hmac = Hmac(sha256, key);
    var block = hmac.convert([...saltBytes, 0, 0, 0, 1]).bytes;
    final result = Uint8List.fromList(block);
    for (var round = 1; round < iterations; round++) {
      block = hmac.convert(block).bytes;
      for (var index = 0; index < result.length; index++) {
        result[index] ^= block[index];
      }
    }
    return base64UrlEncode(result).replaceAll('=', '');
  }

  static String _legacyHash(String password) => sha256
      .convert(utf8.encode('lingonexa-local-demo-v1::$password'))
      .toString();

  static bool _constantTimeEquals(String expected, String actual) {
    if (expected.length != actual.length) return false;
    var difference = 0;
    for (var index = 0; index < expected.length; index++) {
      difference |= expected.codeUnitAt(index) ^ actual.codeUnitAt(index);
    }
    return difference == 0;
  }

  Future<void> _startSession(String userId) async {
    await _storage.writeString(_sessionKey, userId);
    await _storage.writeString(
      _sessionStartedKey,
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  Future<void> _upgradeLegacyAccount(
    _StoredAccount account,
    String password,
  ) async {
    final salt = _randomSalt();
    final index = _accounts.indexOf(account);
    if (index < 0) return;
    _accounts[index] = _StoredAccount(
      user: account.user,
      passwordHash: _deriveHash(password, salt, _iterations),
      passwordSalt: salt,
      iterations: _iterations,
    );
    await _persistAccounts();
  }

  Future<void> _persistAccounts() => _storage.writeString(
        _accountsKey,
        jsonEncode(_accounts.map((item) => item.toJson()).toList()),
      );
}
