import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_state.dart';
import 'core/app_theme.dart';
import 'core/i18n.dart';
import 'screens/shell_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/language_picker_screen.dart';
import 'data/language_catalog.dart';

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
            builder: (context, child) => Stack(
              children: [
                if (child != null) child,
                PositionedDirectional(
                  top: MediaQuery.paddingOf(context).top + 5,
                  end: 7,
                  child: _GlobalThemeButton(state: state),
                ),
              ],
            ),
            home: !state.isAuthenticated
                ? const LoginScreen()
                : state.onboardingCompleted
                    ? const ShellScreen()
                    : const OnboardingScreen(),
          );
        },
      ),
    );
  }
}

class _GlobalThemeButton extends StatelessWidget {
  const _GlobalThemeButton({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final current = AppThemes.preset(state.themeId);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: .92),
      elevation: 2,
      shape: const CircleBorder(),
      child: SizedBox(
        width: 36,
        height: 36,
        child: PopupMenuButton<String>(
          tooltip: 'Quick theme',
          padding: EdgeInsets.zero,
          iconSize: 19,
          icon: state.isAuthenticated
              ? Stack(clipBehavior: Clip.none, children: [Text(language.flag, style: const TextStyle(fontSize: 19)), PositionedDirectional(end: -5, bottom: -5, child: Icon(current.brightness == Brightness.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, size: 12))])
              : Icon(current.brightness == Brightness.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
          onSelected: (value) {
            if (value == '__language__') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguagePickerScreen()));
            } else {
              state.setTheme(value);
            }
          },
          itemBuilder: (context) => [
            if (state.isAuthenticated)
              PopupMenuItem(value: '__language__', child: Row(children: [Text(language.flag, style: const TextStyle(fontSize: 22)), const SizedBox(width: 10), Expanded(child: Text('Learning: ${language.nativeName}', style: const TextStyle(fontWeight: FontWeight.w800))), const Icon(Icons.swap_horiz_rounded, size: 18)])),
            if (state.isAuthenticated) const PopupMenuDivider(),
            for (final preset in AppThemes.presets)
              PopupMenuItem(
                value: preset.id,
                child: Row(children: [
                  Container(width: 18, height: 18, decoration: BoxDecoration(color: preset.seed, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(preset.name)),
                  if (preset.id == state.themeId) const Icon(Icons.check_rounded, size: 18),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}
