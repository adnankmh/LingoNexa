import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_service.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService(this._storage, {http.Client? client})
      : _client = client ?? http.Client();

  final StorageService _storage;
  final http.Client _client;
  final FlutterSecureStorage _secure = const FlutterSecureStorage();

  static const String configuredBaseUrl = String.fromEnvironment(
    'LINGONEXA_API_URL',
    defaultValue: '',
  );
  static const _tokenKey = 'remote_auth_token_v1';
  static const _baseUrlKey = 'remote_api_base_url_v1';

  String _baseUrl = configuredBaseUrl;
  String? _token;

  bool get enabled => _baseUrl.trim().isNotEmpty;
  String get baseUrl => _baseUrl;

  Future<void> initialize() async {
    final configured = _normalizeBaseUrl(configuredBaseUrl);
    if (configured != null) {
      _baseUrl = configured;
    } else if (configuredBaseUrl.trim().isNotEmpty) {
      // A malformed compile-time endpoint must never enable remote requests.
      _baseUrl = '';
    }

    if (_baseUrl.isEmpty) {
      final saved = await _storage.readString(_baseUrlKey);
      if (saved != null && saved.trim().isNotEmpty) {
        final normalizedSaved = _normalizeBaseUrl(saved);
        if (normalizedSaved == null) {
          // Clean up stale/legacy values that predate URL validation.
          await _storage.remove(_baseUrlKey);
        } else {
          _baseUrl = normalizedSaved;
          if (normalizedSaved != saved) {
            await _storage.writeString(_baseUrlKey, normalizedSaved);
          }
        }
      }
    }
    // Offline-only installs never need to touch the secure-storage plugin.
    // This also keeps local unit/widget tests deterministic on host runners.
    if (!enabled) return;
    _token = await _secure.read(key: _tokenKey);
    // One-time migration from the older SharedPreferences token slot.
    if (_token == null || _token!.isEmpty) {
      final legacy = await _storage.readString(_tokenKey);
      if (legacy != null && legacy.isNotEmpty) {
        _token = legacy;
        await _secure.write(key: _tokenKey, value: legacy);
        await _storage.remove(_tokenKey);
      }
    }
  }

  Future<void> setBaseUrl(String value) async {
    if (value.trim().isEmpty) {
      _baseUrl = '';
      await _storage.remove(_baseUrlKey);
      return;
    }

    final normalized = _normalizeBaseUrl(value);
    if (normalized == null) {
      throw const ApiException(
        'LingoNexa server URL must be a valid HTTP or HTTPS URL.',
      );
    }

    _baseUrl = normalized;
    await _storage.writeString(_baseUrlKey, _baseUrl);
  }

  String? _normalizeBaseUrl(String value) {
    final normalized = value.trim().replaceFirst(RegExp(r'/+$'), '');
    if (normalized.isEmpty) return null;
    final uri = Uri.tryParse(normalized);
    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return null;
    }
    return normalized;
  }

  Future<Map<String, Object?>?> restoreRemoteSession() async {
    if (!enabled || _token == null || _token!.isEmpty) return null;
    try {
      final data = await _request('GET', '/api/v1/me');
      return _mapPayload(data['user']);
    } on ApiException catch (error) {
      if (error.statusCode == 401) await clearToken();
      return null;
    }
  }

  Future<Map<String, Object?>> login(String identifier, String password) async {
    final data = await _request(
      'POST',
      '/api/v1/auth/login',
      body: {'identifier': identifier, 'password': password},
      authenticated: false,
    );
    await _storeToken(data['token']);
    return _mapPayload(data['user']);
  }

  Future<Map<String, Object?>> register({
    required String displayName,
    required String username,
    required String email,
    required String password,
  }) async {
    final data = await _request(
      'POST',
      '/api/v1/auth/register',
      body: {
        'name': displayName,
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
      authenticated: false,
    );
    await _storeToken(data['token']);
    return _mapPayload(data['user']);
  }

  Future<void> logout() async {
    if (enabled && _token != null) {
      try {
        await _request('POST', '/api/v1/auth/logout');
      } catch (_) {
        // Local token cleanup must still happen if the network is unavailable.
      }
    }
    if (enabled) {
      await clearToken();
    }
  }

  Future<Map<String, Object?>> loadProgress() async {
    if (!enabled || _token == null) return const {};
    final data = await _request('GET', '/api/v1/progress');
    final progress = data['progress'];
    if (progress is Map) return Map<String, Object?>.from(progress);
    return const {};
  }

  Future<void> saveProgress(Map<String, Object?> progress) async {
    if (!enabled || _token == null) return;
    await _request('PUT', '/api/v1/progress', body: {'progress': progress});
  }

  Future<void> clearToken() async {
    _token = null;
    await _secure.delete(key: _tokenKey);
    await _storage.remove(_tokenKey);
  }

  Future<void> _storeToken(Object? token) async {
    final value = token?.toString() ?? '';
    if (value.isEmpty) {
      throw const ApiException(
        'The server did not return an authentication token.',
      );
    }
    _token = value;
    await _secure.write(key: _tokenKey, value: value);
  }

  Map<String, Object?> _mapPayload(Object? payload) {
    if (payload is! Map) {
      throw const ApiException('Invalid user data returned by the server.');
    }
    return Map<String, Object?>.from(payload);
  }

  Future<Map<String, Object?>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    if (!enabled) {
      throw const ApiException('LingoNexa server URL is not configured.');
    }
    final uri = Uri.parse('${_baseUrl.replaceFirst(RegExp(r'/+$'), '')}$path');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (authenticated && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }

    late http.Response response;
    try {
      response = switch (method) {
        'GET' => await _client
            .get(uri, headers: headers)
            .timeout(const Duration(seconds: 15)),
        'POST' => await _client
            .post(uri, headers: headers, body: jsonEncode(body ?? const {}))
            .timeout(const Duration(seconds: 15)),
        'PUT' => await _client
            .put(uri, headers: headers, body: jsonEncode(body ?? const {}))
            .timeout(const Duration(seconds: 15)),
        _ => throw ApiException('Unsupported HTTP method: $method'),
      };
    } catch (error) {
      if (error is ApiException) rethrow;
      throw ApiException('Could not connect to the LingoNexa server: $error');
    }

    Object? decoded;
    if (response.body.trim().isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        throw ApiException(
          'The server returned an unreadable response.',
          statusCode: response.statusCode,
        );
      }
    }
    final data = decoded is Map
        ? Map<String, Object?>.from(decoded)
        : <String, Object?>{};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = data['message']?.toString() ??
          _firstValidationMessage(data['errors']) ??
          'Server request failed (${response.statusCode}).';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return data;
  }

  String? _firstValidationMessage(Object? errors) {
    if (errors is! Map) return null;
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) return value.first.toString();
      if (value != null) return value.toString();
    }
    return null;
  }
}
