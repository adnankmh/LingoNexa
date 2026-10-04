import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/auth_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'administrator and both demo accounts authenticate with their assigned roles',
    () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService(StorageService());
      await auth.initialize();

      final admin = await auth.signIn(
        'admin@lingonexa.local',
        'LingoNexa!2026',
      );
      expect(admin.success, isTrue);
      expect(admin.user!.isAdmin, isTrue);

      final demo1 = await auth.signIn('demo1', 'Demo-Learner!2026');
      final demo2 = await auth.signIn('demo2', 'Demo-Learner!2026');
      expect(demo1.user!.role, UserRole.learner);
      expect(demo2.user!.role, UserRole.learner);
    },
  );

  test(
    'wrong password is rejected and registration creates a learner',
    () async {
      SharedPreferences.setMockInitialValues({});
      final auth = AuthService(StorageService());
      await auth.initialize();
      expect((await auth.signIn('Adnan', 'wrong')).success, isFalse);
      final created = await auth.register(
        displayName: 'Test Learner',
        username: 'testlearner',
        email: 'test@example.com',
        password: 'TestPassword9',
      );
      expect(created.success, isTrue);
      expect(created.user!.role, UserRole.learner);
    },
  );

  test('local sessions expire and repeated attempts are throttled', () async {
    SharedPreferences.setMockInitialValues({});
    final auth = AuthService(StorageService());
    await auth.initialize();
    await auth.signIn('demo1', 'Demo-Learner!2026');
    expect(
      await auth.restoreSession(sessionLifetime: Duration.zero),
      isNull,
    );

    AuthResult result = const AuthResult();
    for (var index = 0; index < 6; index++) {
      result = await auth.signIn('unknown@example.com', 'WrongPassword9');
    }
    expect(result.error, contains('Too many attempts'));
  });

  test(
    'incompatible stored accounts recover without restoring a stale session',
    () async {
      SharedPreferences.setMockInitialValues({
        'auth_accounts_v1': '{"unexpected":"object"}',
        'auth_session_v1': 'demo_1',
        'auth_session_started_v2': DateTime.now().toUtc().toIso8601String(),
      });

      final storage = StorageService();
      final auth = AuthService(storage);
      await auth.initialize();

      expect(auth.accountCount, 3);
      expect(await auth.restoreSession(), isNull);
      expect(await storage.readString('auth_session_v1'), isNull);
      expect(await storage.readString('auth_session_started_v2'), isNull);

      final demo = await auth.signIn('demo1', 'Demo-Learner!2026');
      expect(demo.success, isTrue);
    },
  );
}
