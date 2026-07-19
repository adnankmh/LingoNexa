import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/services/auth_service.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
      'administrator and both demo accounts authenticate with their assigned roles',
      () async {
    SharedPreferences.setMockInitialValues({});
    final auth = AuthService(StorageService());
    await auth.initialize();

    final admin = await auth.signIn('adnanasd63@gmail.com', 'Adnan123');
    expect(admin.success, isTrue);
    expect(admin.user!.isAdmin, isTrue);

    final demo1 = await auth.signIn('demo1', 'Demo123');
    final demo2 = await auth.signIn('demo2', 'Demo123');
    expect(demo1.user!.role, UserRole.learner);
    expect(demo2.user!.role, UserRole.learner);
  });

  test('wrong password is rejected and registration creates a learner',
      () async {
    SharedPreferences.setMockInitialValues({});
    final auth = AuthService(StorageService());
    await auth.initialize();
    expect((await auth.signIn('Adnan', 'wrong')).success, isFalse);
    final created = await auth.register(
        displayName: 'Test Learner',
        username: 'testlearner',
        email: 'test@example.com',
        password: 'Test123');
    expect(created.success, isTrue);
    expect(created.user!.role, UserRole.learner);
  });
}
