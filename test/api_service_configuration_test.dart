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

  test('initialize normalizes a persisted API URL before use', () async {
    SharedPreferences.setMockInitialValues({
      'remote_api_base_url_v1': '  https://example.test/api///  ',
    });
    final storage = StorageService();
    final service = ApiService(storage);

    // A valid remote URL would continue into secure-storage initialization,
    // which is platform-backed. Verify normalization through persisted state
    // without coupling this host test to that plugin.
    try {
      await service.initialize();
    } catch (_) {}

    expect(service.baseUrl, 'https://example.test/api');
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('remote_api_base_url_v1'),
      'https://example.test/api',
    );
  });
}
