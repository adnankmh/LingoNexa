import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/api_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('remote HTTP endpoints are rejected without changing saved settings',
      () async {
    final service = ApiService(StorageService());
    await service.setBaseUrl('https://example.test/api');

    for (final url in [
      'http://example.test/api',
      'http://localhost.example.test:8000',
      'http://192.168.1.20:8000',
    ]) {
      await expectLater(service.setBaseUrl(url), throwsA(isA<ApiException>()));
      expect(service.baseUrl, 'https://example.test/api');
    }

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString('remote_api_base_url_v1'),
      'https://example.test/api',
    );
  });

  test('HTTP is allowed only on loopback development hosts', () async {
    for (final url in [
      'http://localhost:8000',
      'http://127.0.0.1:8000',
      'http://[::1]:8000',
    ]) {
      final service = ApiService(StorageService());
      await service.setBaseUrl(url);
      expect(service.baseUrl, url);
    }
  });

  test('HTTPS is accepted for remote API servers', () async {
    final service = ApiService(StorageService());
    await service.setBaseUrl('https://example.test/api');
    expect(service.enabled, isTrue);
  });

  test('initialize clears legacy remote HTTP settings', () async {
    SharedPreferences.setMockInitialValues({
      'remote_api_base_url_v1': 'http://example.test/api',
    });
    final service = ApiService(StorageService());
    await service.initialize();
    expect(service.enabled, isFalse);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.containsKey('remote_api_base_url_v1'), isFalse);
  });
}
