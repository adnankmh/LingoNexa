import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/api_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('setBaseUrl rejects embedded control characters', () async {
    final service = ApiService(StorageService());
    const unsafeUrls = [
      'https://example.test/api\nadmin',
      'https://example.test/api\tadmin',
      'https://example.test/api\u007fadmin',
    ];

    for (final url in unsafeUrls) {
      await expectLater(service.setBaseUrl(url), throwsA(isA<ApiException>()));
      expect(service.enabled, isFalse);
    }
  });

  test('rejected control-character URL does not replace valid state', () async {
    final service = ApiService(StorageService());
    await service.setBaseUrl('https://example.test/api');

    await expectLater(
      service.setBaseUrl('https://example.test/api\nadmin'),
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
}
