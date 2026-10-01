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
  ApiService(
    this._storage, {
    http.Client? client,
    FlutterSecureStorage? secureStorage,
  })  : _client = client ?? http.Client(),
        _secure = secureStorage ?? const FlutterSecureStorage();

  final StorageService _storage;
  final http.Client _client;
  final FlutterSecureStorage _secure;

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
    final saved = await _storage.readString(_baseUrlKey);
    if (configuredBaseUrl.trim().isEmpty && saved != null) {
      _baseUrl = saved.trim();
    }
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
    _baseUrl = value.trim().replaceFirst(RegExp(r'/+\$'), '');
    if (_baseUrl.isEmpty) {
      await _storage.remove(_baseUrlKey);
    } else {
      await _storage.writeString(_baseUrlKey, _baseUrl);
    }
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
    if (enabled && _token != null && _token!.isNotEmpty) {
      try {
        await _request('POST', '/api/v1/auth/logout');
      } on ApiException {
        // Local logout must still complete if the server is unreachable.
      }
    }
    await clearToken();
  }

  Future<Map<String, Object?>> loadProgress() async {
    if (!enabled || _token == null || _token!.isEmpty) return {};
    final data = await _request('GET', '/api/v1/progress');
    return _mapPayload(data['progress']);
  }

  Future<void> saveProgress(Map<String, Object?> progress) async {
    if (!enabled || _token == null || _token!.isEmpty) return;
    await _request('PUT', '/api/v1/progress', body: progress);
  }

  Future<void> clearToken() async {
    _token = null;
    await _secure.delete(key: _tokenKey);
    await _storage.remove(_tokenKey);
  }

  Future<void> _storeToken(Object? token) async {
    final value = token?.toString() ?? '';
    if (value.isEmpty) throw const ApiException('Authentication token missing.');
    _token = value;
    await _secure.write(key: _tokenKey, value: value);
    await _storage.remove(_tokenKey);
  }

  Future<Map<String, Object?>> _request(
    String method,
    String path, {
    Map<String, Object?>? body,
    bool authenticated = true,
  }) async {
    final uri = Uri.parse('\$_baseUrl\$path');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (authenticated && _token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer \$_token';
    }
    late http.Response response;
    try {
      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: headers);
          break;
        case 'POST':
          response = await _client.post(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          );
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: headers,
            body: body == null ? null : jsonEncode(body),
          );
          break;
        default:
          throw ApiException('Unsupported HTTP method: \$method');
      }
    } on http.ClientException {
      throw const ApiException('Unable to reach the LingoNexa server.');
    }

    Map<String, Object?> payload = {};
    if (response.body.isNotEmpty) {
      try {
        payload = Map<String, Object?>.from(jsonDecode(response.body) as Map);
      } on FormatException {
        throw ApiException(
          'The server returned an invalid response.',
          statusCode: response.statusCode,
        );
      }
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = payload['message']?.toString() ??
          'Request failed with status \${response.statusCode}.';
      throw ApiException(message, statusCode: response.statusCode);
    }
    return payload;
  }

  Map<String, Object?> _mapPayload(Object? value) {
    if (value is Map) return Map<String, Object?>.from(value);
    return {};
  }
}
