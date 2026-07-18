import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/app.dart';
import 'package:lingonexa/core/app_state.dart';
import 'package:lingonexa/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('main learning shell renders primary navigation', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState(StorageService());
    await state.initialize();
    state.locale = const Locale('en');

    await tester.pumpWidget(LingoNexaApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Learn'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('Community'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('CEFR Journey'), findsOneWidget);
  });
}

