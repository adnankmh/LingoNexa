import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'core/i18n.dart';
import 'screens/shell_screen.dart';
import 'screens/onboarding_screen.dart';

class LingoNexaApp extends StatelessWidget {
  const LingoNexaApp({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppStateScope(
      state: state,
      child: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: state.brandName,
            theme: AppThemes.build(state.themeId),
            locale: state.locale,
            supportedLocales: AppText.supported.map((item) => Locale(item.code)).toList(growable: false),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: state.onboardingCompleted ? const ShellScreen() : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}
