import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/app.dart';
import 'package:lingonexa/core/app_state.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(WidgetTester tester, AppState state) async {
    await tester.pumpWidget(LingoNexaApp(state: state));
    // LingoNexa intentionally has looping motion assets. Never use
    // pumpAndSettle here because perpetual animations cannot settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
  }

  testWidgets('main learning shell renders primary navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(StorageService());
    await state.initialize();
    await state.signInAsGuest();
    state.locale = const Locale('en');
    state.onboardingCompleted = true;

    await pumpApp(tester, state);

    expect(find.text('Learn'), findsWidgets);
    expect(find.text('Practice'), findsWidgets);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('CEFR journey'), findsOneWidget);
  });

  testWidgets('first launch renders onboarding', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    SharedPreferences.setMockInitialValues({});
    final state = AppState(StorageService());
    await state.initialize();
    await state.signInAsGuest();

    await pumpApp(tester, state);

    expect(find.text('A world of language, built around you.'), findsOneWidget);
    expect(find.text('Create my path'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('signed-out launch renders account access', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(StorageService());
    await state.initialize();
    await pumpApp(tester, state);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create account'), findsWidgets);
    expect(find.textContaining('demo1'), findsOneWidget);
  });
}
