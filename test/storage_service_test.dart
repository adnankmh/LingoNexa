import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lingonexa/services/storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StorageService storage;

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    storage = StorageService();
  });

  test('round-trips every supported value type', () async {
    await storage.writeString('string', 'LingoNexa');
    await storage.writeInt('int', 42);
    await storage.writeBool('bool', true);
    await storage.writeDouble('double', 4.2);
    await storage.writeStrings('strings', <String>['ar', 'en', 'de']);

    expect(await storage.readString('string'), 'LingoNexa');
    expect(await storage.readInt('int'), 42);
    expect(await storage.readBool('bool'), isTrue);
    expect(await storage.readDouble('double'), 4.2);
    expect(await storage.readStrings('strings'), <String>['ar', 'en', 'de']);
  });

  test('missing values return null without creating state', () async {
    expect(await storage.readString('missing-string'), isNull);
    expect(await storage.readInt('missing-int'), isNull);
    expect(await storage.readBool('missing-bool'), isNull);
    expect(await storage.readDouble('missing-double'), isNull);
    expect(await storage.readStrings('missing-strings'), isNull);
  });

  test('remove deletes an existing value and is idempotent', () async {
    await storage.writeString('session', 'cached');
    expect(await storage.readString('session'), 'cached');

    await storage.remove('session');
    expect(await storage.readString('session'), isNull);

    await storage.remove('session');
    expect(await storage.readString('session'), isNull);
  });

  test('writes replace the previous value for the same key', () async {
    await storage.writeInt('streak', 3);
    await storage.writeInt('streak', 4);

    expect(await storage.readInt('streak'), 4);
  });
}
