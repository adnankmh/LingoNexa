import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';

class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  String? _certificateLocale;
  String? _certificateLevel;
  String? _targetLanguageCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    _certificateLocale ??= state.locale.languageCode;
    if (_targetLanguageCode != state.targetLanguageCode) {
      _targetLanguageCode = state.targetLanguageCode;
      final completedLevels = CourseRepository.levels
          .map((level) => level.code)
          .where(
            (level) => state.completedExamIds.contains(
              '${state.targetLanguageCode}_$level',
            ),
          )
          .toList();
      _certificateLevel = completedLevels.isEmpty
          ? state.currentLevel
          : completedLevels.last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final certificateLevel = _certificateLevel ?? state.currentLevel;
    final levelUnits = CourseRepository.unitsFor(
      language.code,
      meaningLanguageCode: state.locale.languageCode,
    ).where((unit) => unit.level == certificateLevel).toList();
    final lessonIds = levelUnits
        .expand((unit) => unit.lessons)
        .map((lesson) => lesson.id)
        .toSet();
    final total = lessonIds.length;
    final completed = lessonIds
        .where((id) => state.completedLessonIds.contains(id))
        .length;
    final examId = '${language.code}_$certificateLevel';
    final examPassed = state.completedExamIds.contains(examId);
    final learningProgress = total == 0 ? 0.0 : completed / total;
    final readiness = (learningProgress * .85) + (examPassed ? .15 : 0);
    final unlocked = completed == total && examPassed;
    final certificateText = AppText(Locale(_certificateLocale ?? 'en'));
    final credentialId = _credentialId(
      state.currentUser!.id,
      language.code,
      certificateLevel,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('certificates'))),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
              children: [
                DropdownButtonFormField<String>(
                  initialValue: certificateLevel,
                  decoration: InputDecoration(
                    labelText: context.text.get('certificate_level'),
                    prefixIcon: const Icon(Icons.workspace_premium_rounded),
                  ),
                  items: [
                    for (final level in CourseRepository.levels)
                      DropdownMenuItem(
                        value: level.code,
                        child: Text('${level.code} · ${level.title}'),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _certificateLevel = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _certificateLocale,
                  decoration: InputDecoration(
                    labelText: context.text.get('certificate_language'),
                    prefixIcon: const Icon(Icons.language_rounded),
                  ),
                  items: [
                    for (final option in AppText.supported)
                      DropdownMenuItem(
                        value: option.code,
                        child: Text('${option.flag} ${option.nativeName}'),
                      ),
                  ],
                  onChanged: (value) =>
                      setState(() => _certificateLocale = value),
                ),
                const SizedBox(height: 16),
                _CertificateCard(
                  text: certificateText,
                  learnerName: state.currentUser!.displayName,
                  languageName: language.nativeName,
                  languageFlag: language.flag,
                  level: certificateLevel,
                  credentialId: credentialId,
                  unlocked: unlocked,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.insights_rounded),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                context.text.get('certificate_progress'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Text(
                              '${(readiness * 100).round()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 11),
                        LinearProgressIndicator(
                          value: readiness,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        const SizedBox(height: 14),
                        _Requirement(
                          complete: completed == total,
                          icon: Icons.school_rounded,
                          title: context.text.get('complete_level_path'),
                          subtitle:
                              '$completed/$total ${context.text.get('lessons')}',
                        ),
                        _Requirement(
                          complete: examPassed,
                          icon: Icons.fact_check_rounded,
                          title: context.text.get('pass_final_exam'),
                          subtitle: context.text.get(
                            'pass_final_exam_subtitle',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: unlocked
                      ? () => _copyCredential(
                          context,
                          certificateText,
                          state.currentUser!.displayName,
                          language.nativeName,
                          certificateLevel,
                          credentialId,
                        )
                      : null,
                  icon: const Icon(Icons.copy_all_rounded),
                  label: Text(
                    unlocked
                        ? context.text.get('copy_certificate')
                        : context.text.get('keep_learning_unlock'),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.text.get('certificate_verification_note'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _credentialId(String user, String language, String level) {
    final value = '$user-$language-$level'.codeUnits.fold<int>(
      17,
      (hash, code) => (hash * 31 + code) & 0x7fffffff,
    );
    return 'LNX-${value.toRadixString(16).toUpperCase().padLeft(8, '0')}';
  }

  static Future<void> _copyCredential(
    BuildContext context,
    AppText text,
    String learner,
    String language,
    String level,
    String id,
  ) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            '${text.get('certificate_title')}\n'
            '${text.get('certificate_awarded_to')} $learner\n'
            '$language · $level\n$id',
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('certificate_copied'))),
      );
    }
  }
}

class _CertificateCard extends StatelessWidget {
  const _CertificateCard({
    required this.text,
    required this.learnerName,
    required this.languageName,
    required this.languageFlag,
    required this.level,
    required this.credentialId,
    required this.unlocked,
  });

  final AppText text;
  final String learnerName;
  final String languageName;
  final String languageFlag;
  final String level;
  final String credentialId;
  final bool unlocked;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.primaryContainer,
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: unlocked
            ? const Color(0xFFD6A627)
            : Theme.of(context).colorScheme.outlineVariant,
        width: 3,
      ),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: .12),
          blurRadius: 34,
          offset: const Offset(0, 12),
        ),
      ],
    ),
    child: Stack(
      children: [
        Column(
          children: [
            Icon(
              unlocked
                  ? Icons.workspace_premium_rounded
                  : Icons.lock_outline_rounded,
              size: 68,
              color: unlocked ? const Color(0xFFD6A627) : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              text.get('certificate_title'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: .4,
              ),
            ),
            const SizedBox(height: 18),
            Text(text.get('certificate_awarded_to')),
            const SizedBox(height: 5),
            Text(
              learnerName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 13),
            Text(
              '${text.get('certificate_completed')} $languageFlag $languageName · $level',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 6),
            Text(
              credentialId,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              'LingoNexa · 2026',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _Requirement extends StatelessWidget {
  const _Requirement({
    required this.complete,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final bool complete;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(child: Icon(complete ? Icons.check_rounded : icon)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
    subtitle: Text(subtitle),
    trailing: Icon(
      complete ? Icons.verified_rounded : Icons.pending_outlined,
      color: complete ? Colors.green : null,
    ),
  );
}
