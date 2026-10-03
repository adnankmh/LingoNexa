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
}
