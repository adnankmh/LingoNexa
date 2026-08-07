import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/practice_copy_repository.dart';
import '../widgets/ui.dart';
import 'lesson_screen.dart';
import 'sentence_lab_screen.dart';
import 'tutor_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final allLessons = CourseRepository.unitsFor(
      state.targetLanguageCode,
      meaningLanguageCode: state.locale.languageCode,
    ).expand((unit) => unit.lessons).toList();
    final due = allLessons
        .where((lesson) => state.reviewLessonIds.contains(lesson.id))
        .toList();
    final sample = due.isNotEmpty ? due.first : allLessons.first;
    final scheme = Theme.of(context).colorScheme;
    final locale = state.locale.languageCode;
    String copy(String key) => PracticeCopyRepository.text(locale, key);

    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.text.get('practice'),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            copy('subtitle'),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 22),
          GradientPanel(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        copy('workout'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        copy('ready').replaceAll('{count}', '8'),
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: sample),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: scheme.primary,
                  ),
                  child: Text(context.text.get('start')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 680;
              final items = [
                FeatureTile(
                  icon: Icons.autorenew_rounded,
                  title: context.text.get('review'),
                  subtitle:
                      copy('due').replaceAll('{count}', '${due.length + 8}'),
                  color: const Color(0xFF6C63FF),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: sample),
                    ),
                  ),
                ),
                FeatureTile(
                  icon: Icons.error_outline_rounded,
                  title: context.text.get('mistakes'),
                  subtitle: copy('mistakes_sub'),
                  color: const Color(0xFFFF6B6B),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: allLessons[1]),
                    ),
                  ),
                ),
                FeatureTile(
                  icon: Icons.graphic_eq_rounded,
                  title: context.text.get('pronunciation'),
                  subtitle: copy('pronunciation_sub'),
                  color: const Color(0xFF20C997),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: allLessons[3]),
                    ),
                  ),
                ),
                FeatureTile(
                  icon: Icons.auto_stories_rounded,
                  title: context.text.get('stories'),
                  subtitle: copy('stories_sub'),
                  color: const Color(0xFFFFA94D),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: allLessons[5]),
                    ),
                  ),
                ),
                FeatureTile(
                  icon: Icons.psychology_alt_rounded,
                  title: context.text.get('tutor'),
                  subtitle: copy('tutor_sub'),
                  color: const Color(0xFF4DABF7),
                  badge: copy('beta'),
                  onTap: state.aiTutorEnabled
                      ? () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TutorScreen(),
                            ),
                          )
                      : null,
                ),
                FeatureTile(
                  icon: Icons.flash_on_rounded,
                  title: copy('speed'),
                  subtitle: copy('speed_sub'),
                  color: const Color(0xFFF06595),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(lesson: allLessons[4]),
                    ),
                  ),
                ),
                FeatureTile(
                  icon: Icons.hub_rounded,
                  title: context.text.get('sentence_lab'),
                  subtitle: copy('sentence_sub'),
                  color: const Color(0xFF0757B8),
                  badge: copy('new'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SentenceLabScreen(),
                    ),
                  ),
                ),
              ];
              if (!twoColumns) return Column(children: items);
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 2.35,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: items,
              );
            },
          ),
          const SizedBox(height: 22),
          SectionHeading(
            title: copy('balance'),
            subtitle: copy('balance_sub'),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                children: [
                  _SkillBar(
                    label: copy('vocabulary'),
                    value: .72,
                    color: const Color(0xFF6C63FF),
                  ),
                  _SkillBar(
                    label: copy('listening'),
                    value: .58,
                    color: const Color(0xFF4DABF7),
                  ),
                  _SkillBar(
                    label: copy('speaking'),
                    value: .44,
                    color: const Color(0xFF20C997),
                  ),
                  _SkillBar(
                    label: copy('grammar'),
                    value: .63,
                    color: const Color(0xFFFFA94D),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 9,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              '${(value * 100).round()}%',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
