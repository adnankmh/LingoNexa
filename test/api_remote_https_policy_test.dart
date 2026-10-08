import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/api_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('remote HTTP endpoints are rejected', () async {
    final service = ApiService(StorageService());
    await expectLater(
      service.setBaseUrl('http://example.test/api'),
      throwsA(isA<ApiException>()),
    );
    expect(service.enabled, isFalse);
  });
}
