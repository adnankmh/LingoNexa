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
      _baseUrl = '';
    }

    if (_baseUrl.isEmpty) {
      final saved = await _storage.readString(_baseUrlKey);
      if (saved != null && saved.trim().isNotEmpty) {
        final normalizedSaved = _normalizeBaseUrl(saved);
        if (normalizedSaved == null) {
          await _storage.remove(_baseUrlKey);
        } else {
          _baseUrl = normalizedSaved;
          if (normalizedSaved != saved) {
            await _storage.writeString(_baseUrlKey, normalizedSaved);
          }
        }
      }
    }
    if (!enabled) return;
    _token = await _secure.read(key: _tokenKey);
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
        uri.host.isEmpty ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      return null;
    }
    try {
      final port = uri.port;
      if (port < 1 || port > 65535) return null;
    } on FormatException {
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

  Future<Map<String, Object?>> login({
    required String email,
    required String password,
  }) async {
    final data = await _request(
      'POST',
      '/api/v1/login',
      body: {'email': email, 'password': password},
      authenticated: false,
    );
    await _captureAuth(data);
    return _mapPayload(data['user']) ?? <String, Object?>{};
  }

  Future<Map<String, Object?>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = await _request(
      'POST',
      '/api/v1/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      },
      authenticated: false,
    );
    await _captureAuth(data);
    return _mapPayload(data['user']) ?? <String, Object?>{};
  }

  Future<void> logout() async {
    if (enabled && _token != null && _token!.isNotEmpty) {
      try {
        await _request('POST', '/api/v1/logout');
      } catch (_) {}
    }
    await clearToken();
  }

  Future<void> clearToken() async {
    _token = null;
    await _secure.delete(key: _tokenKey);
    await _storage.remove(_tokenKey);
  }

  Future<Map<String, Object?>> pushProgress(Map<String, Object?> progress) async {
    return _request('PUT', '/api/v1/progress', body: progress);
  }

  Future<Map<String, Object?>> pullProgress() async {
    return _request('GET', '/api/v1/progress');
  }

  Future<Map<String, Object?>> updateAdminAccount({
    required String name,
    required String email,
    String? password,
    String? currentPassword,
  }) async {
    final body = <String, Object?>{'name': name, 'email': email};
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
      body['password_confirmation'] = password;
      body['current_password'] = currentPassword ?? '';
    }
    return _request('PUT', '/api/v1/admin/account', body: body);
  }

  Future<void> _captureAuth(Map<String, Object?> data) async {
    final token = data['token']?.toString();
    if (token == null || token.isEmpty) {
      throw const ApiException('The server did not return an authentication token.');
    }
    _token = token;
    await _secure.write(key: _tokenKey, value: token);
    await _storage.remove(_tokenKey);
  }

  Future<Map<String, Object?>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    if (!enabled) {
      throw const ApiException('Remote sync is not configured.');
    }
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (authenticated && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    final uri = Uri.parse('$_baseUrl$path');
    http.Response response;
    try {
      switch (method) {
        case 'POST':
          response = await _client.post(uri, headers: headers, body: jsonEncode(body ?? {}));
          break;
        case 'PUT':
          response = await _client.put(uri, headers: headers, body: jsonEncode(body ?? {}));
          break;
        default:
          response = await _client.get(uri, headers: headers);
      }
    } catch (_) {
      throw const ApiException('Could not reach the LingoNexa server.');
    }

    Map<String, Object?> payload = <String, Object?>{};
    if (response.body.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map) {
          payload = decoded.map((key, value) => MapEntry(key.toString(), value));
        }
      } catch (_) {}
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = payload['message']?.toString() ?? 'Server request failed.';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return payload;
  }

  Map<String, Object?>? _mapPayload(Object? value) {
    if (value is! Map) return null;
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
}
