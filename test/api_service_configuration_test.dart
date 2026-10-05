import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/api_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('setBaseUrl trims whitespace and trailing slashes', () async {
    final service = ApiService(StorageService());

    await service.setBaseUrl('  https://example.test/api///  ');

    expect(service.baseUrl, 'https://example.test/api');
    expect(service.enabled, isTrue);
  });

  test('setBaseUrl disables remote API when value is blank', () async {
    final service = ApiService(StorageService());

    await service.setBaseUrl('https://example.test');
    await service.setBaseUrl('   ');

    expect(service.baseUrl, isEmpty);
    expect(service.enabled, isFalse);
  });

  test('setBaseUrl persists the normalized API base URL', () async {
    final service = ApiService(StorageService());

    await service.setBaseUrl('  https://example.test/api///  ');

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('remote_api_base_url_v1'),
      'https://example.test/api',
    );
  });

  test('setBaseUrl rejects non-HTTP server URLs without changing state', () async {
    final service = ApiService(StorageService());
    await service.setBaseUrl('https://example.test/api');

    await expectLater(
      service.setBaseUrl('javascript:alert(1)'),
      throwsA(isA<ApiException>()),
    );

    expect(service.baseUrl, 'https://example.test/api');
    expect(service.enabled, isTrue);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('remote_api_base_url_v1'),
      'https://example.test/api',
    );
  });

  test('setBaseUrl rejects malformed server URLs', () async {
    final service = ApiService(StorageService());

    await expectLater(
      service.setBaseUrl('not-a-server-address'),
      throwsA(isA<ApiException>()),
    );

    expect(service.enabled, isFalse);
  });

  test('setBaseUrl rejects URLs without a concrete host', () async {
    final service = ApiService(StorageService());
    const hostlessUrls = [
      'http://:8080',
      'https:///api',
    ];

    for (final url in hostlessUrls) {
      await expectLater(service.setBaseUrl(url), throwsA(isA<ApiException>()));
      expect(service.enabled, isFalse);
    }
  });

  test('setBaseUrl rejects invalid TCP ports', () async {
    final service = ApiService(StorageService());
    const invalidPortUrls = [
      'https://example.test:0',
      'https://example.test:65536',
      'https://example.test:not-a-port',
    ];

    for (final url in invalidPortUrls) {
      await expectLater(service.setBaseUrl(url), throwsA(isA<ApiException>()));
      expect(service.enabled, isFalse);
    }
  });

  test('setBaseUrl accepts valid explicit TCP ports', () async {
    final service = ApiService(StorageService());

    await service.setBaseUrl('http://localhost:8000');

    expect(service.baseUrl, 'http://localhost:8000');
    expect(service.enabled, isTrue);
  });

  test('setBaseUrl rejects credentials, query strings, and fragments', () async {
    final service = ApiService(StorageService());
    const unsafeOrAmbiguousUrls = [
      'https://user:secret@example.test',
      'https://example.test?tenant=one',
      'https://example.test#api',
    ];

    for (final url in unsafeOrAmbiguousUrls) {
      await expectLater(service.setBaseUrl(url), throwsA(isA<ApiException>()));
      expect(service.enabled, isFalse);
    }
  });

  test('initialize removes an unsafe persisted API URL', () async {
    SharedPreferences.setMockInitialValues({
      'remote_api_base_url_v1': 'javascript:alert(1)',
    });
    final service = ApiService(StorageService());

    await service.initialize();

    expect(service.enabled, isFalse);
    expect(service.baseUrl, isEmpty);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.containsKey('remote_api_base_url_v1'), isFalse);
  });
}
