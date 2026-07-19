import 'dart:convert';

import 'package:crypto/crypto.dart';

import 'storage_service.dart';

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
        role: UserRole.values.firstWhere((item) => item.name == json['role'],
            orElse: () => UserRole.learner),
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
  const _StoredAccount({required this.user, required this.passwordHash});
  final AppUser user;
  final String passwordHash;

  Map<String, Object?> toJson() =>
      {...user.toJson(), 'passwordHash': passwordHash};

  static _StoredAccount fromJson(Map<String, Object?> json) => _StoredAccount(
        user: AppUser.fromJson(json),
        passwordHash: json['passwordHash']! as String,
      );
}

/// Local account adapter used for the offline demo. It deliberately exposes no
/// social-provider secrets. Production builds should replace this adapter with
/// Firebase Auth, Supabase Auth, or another server-verified identity provider.
class AuthService {
  AuthService(this._storage);

  final StorageService _storage;
  static const _accountsKey = 'auth_accounts_v1';
  static const _sessionKey = 'auth_session_v1';
  static const _salt = 'lingonexa-local-demo-v1';
  List<_StoredAccount> _accounts = [];
  int get accountCount => _accounts.length;

  Future<void> initialize() async {
    final encoded = await _storage.readString(_accountsKey);
    if (encoded == null) {
      _accounts = _seedAccounts();
      await _persistAccounts();
    } else {
      try {
        final decoded = jsonDecode(encoded) as List<dynamic>;
        _accounts = decoded
            .map((item) =>
                _StoredAccount.fromJson(Map<String, Object?>.from(item as Map)))
            .toList();
      } on FormatException {
        _accounts = _seedAccounts();
        await _persistAccounts();
      }
    }
  }

  Future<AppUser?> restoreSession() async {
    final id = await _storage.readString(_sessionKey);
    if (id == null) return null;
    for (final account in _accounts) {
      if (account.user.id == id) return account.user;
    }
    if (id == 'guest') return guestUser;
    return null;
  }

  Future<AuthResult> signIn(String identifier, String password) async {
    final normalized = identifier.trim().toLowerCase();
    for (final account in _accounts) {
      final matchesIdentity =
          account.user.username.toLowerCase() == normalized ||
              account.user.email.toLowerCase() == normalized;
      if (matchesIdentity && account.passwordHash == _hash(password)) {
        await _storage.writeString(_sessionKey, account.user.id);
        return AuthResult(user: account.user);
      }
    }
    return const AuthResult(error: 'Incorrect username, email, or password.');
  }

  Future<AuthResult> register(
      {required String displayName,
      required String username,
      required String email,
      required String password}) async {
    final cleanUsername = username.trim();
    final cleanEmail = email.trim().toLowerCase();
    if (displayName.trim().length < 2 || cleanUsername.length < 3) {
      return const AuthResult(error: 'Name and username are too short.');
    }
    if (!cleanEmail.contains('@') || !cleanEmail.contains('.')) {
      return const AuthResult(error: 'Enter a valid email address.');
    }
    if (password.length < 6) {
      return const AuthResult(
          error: 'Password must contain at least 6 characters.');
    }
    if (_accounts.any((item) =>
        item.user.username.toLowerCase() == cleanUsername.toLowerCase() ||
        item.user.email == cleanEmail)) {
      return const AuthResult(
          error: 'This username or email is already registered.');
    }
    final user = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: cleanUsername,
      email: cleanEmail,
      displayName: displayName.trim(),
      role: UserRole.learner,
    );
    _accounts.add(_StoredAccount(user: user, passwordHash: _hash(password)));
    await _persistAccounts();
    await _storage.writeString(_sessionKey, user.id);
    return AuthResult(user: user);
  }

  Future<AppUser> signInAsGuest() async {
    await _storage.writeString(_sessionKey, guestUser.id);
    return guestUser;
  }

  Future<void> signOut() => _storage.remove(_sessionKey);

  static const guestUser = AppUser(
      id: 'guest',
      username: 'guest',
      email: '',
      displayName: 'Guest Explorer',
      role: UserRole.guest);

  static List<_StoredAccount> _seedAccounts() => [
        const _StoredAccount(
          user: AppUser(
              id: 'admin_adnan',
              username: 'Adnan',
              email: 'adnanasd63@gmail.com',
              displayName: 'Adnan',
              role: UserRole.administrator),
          passwordHash:
              '5189848b80763ad69c8fca00f09e22fb5ebda3b1eb0cce3c4ab86f374a543ace',
        ),
        const _StoredAccount(
          user: AppUser(
              id: 'demo_1',
              username: 'demo1',
              email: 'demo1@lingonexa.app',
              displayName: 'Demo Explorer',
              role: UserRole.learner),
          passwordHash:
              '97b2dfa7f25e76ea534d30ae9fe1d4b650bc1b7cd3f3092ab9db5a72f6a8ddf4',
        ),
        const _StoredAccount(
          user: AppUser(
              id: 'demo_2',
              username: 'demo2',
              email: 'demo2@lingonexa.app',
              displayName: 'World Learner',
              role: UserRole.learner),
          passwordHash:
              '97b2dfa7f25e76ea534d30ae9fe1d4b650bc1b7cd3f3092ab9db5a72f6a8ddf4',
        ),
      ];

  static String _hash(String password) =>
      sha256.convert(utf8.encode('$_salt::$password')).toString();

  Future<void> _persistAccounts() => _storage.writeString(_accountsKey,
      jsonEncode(_accounts.map((item) => item.toJson()).toList()));
}
