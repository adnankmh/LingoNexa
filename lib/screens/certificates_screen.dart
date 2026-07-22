import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final total = CourseRepository.unitsFor(
      language.code,
    ).expand((unit) => unit.lessons).length;
    final completed = state.completedLessonIds.length.clamp(0, total);
    final readiness = total == 0 ? 0.0 : completed / total;
    return Scaffold(
      appBar: AppBar(title: const Text('Progress & Certificates')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: .10),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.workspace_premium_rounded,
                        size: 66,
                        color: Colors.amber,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'LingoNexa Learning Record',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${language.flag} ${language.englishName} · ${state.currentLevel}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20),
                      LinearProgressIndicator(
                        value: readiness,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$completed of $total lesson nodes complete',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const _Requirement(
                  icon: Icons.school_rounded,
                  title: 'Complete the level path',
                  subtitle:
                      'Finish all required lessons and reviews for the selected CEFR level.',
                ),
                const _Requirement(
                  icon: Icons.mic_rounded,
                  title: 'Speaking checkpoint',
                  subtitle:
                      'Complete pronunciation and scenario tasks with recorded evidence.',
                ),
                const _Requirement(
                  icon: Icons.fact_check_rounded,
                  title: 'Final assessment',
                  subtitle:
                      'Pass reading, listening, writing, and speaking checkpoints.',
                ),
                const _Requirement(
                  icon: Icons.verified_user_rounded,
                  title: 'Verified certificates',
                  subtitle:
                      'Production verification requires secure accounts, server-side exams, and identity rules.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: readiness >= 1
                      ? () => _showCertificate(
                          context,
                          language.englishName,
                          state.currentLevel,
                        )
                      : null,
                  icon: const Icon(Icons.card_membership_rounded),
                  label: Text(
                    readiness >= 1
                        ? 'Preview certificate'
                        : 'Keep learning to unlock',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showCertificate(
    BuildContext context,
    String language,
    String level,
  ) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.workspace_premium_rounded,
          color: Colors.amber,
          size: 50,
        ),
        title: const Text('Certificate preview'),
        content: Text(
          'This learning record recognizes completion of the $language $level pathway. Connect a verified assessment backend before presenting it as an accredited certificate.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _Requirement extends StatelessWidget {
  const _Requirement({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      leading: CircleAvatar(child: Icon(icon)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
    ),
  );
}
