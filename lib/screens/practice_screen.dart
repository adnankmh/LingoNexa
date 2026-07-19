import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../widgets/ui.dart';
import 'lesson_screen.dart';
import 'sentence_lab_screen.dart';
import 'tutor_screen.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final allLessons = CourseRepository.unitsFor(state.targetLanguageCode).expand((unit) => unit.lessons).toList();
    final due = allLessons.where((lesson) => state.reviewLessonIds.contains(lesson.id)).toList();
    final sample = due.isNotEmpty ? due.first : allLessons.first;
    final scheme = Theme.of(context).colorScheme;

    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.text.get('practice'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text('Personalized drills based on memory strength and recent mistakes.', style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 22),
          GradientPanel(
            child: Row(
              children: [
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Today’s memory workout', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w900)), SizedBox(height: 6), Text('8 items are ready at the best moment for recall.', style: TextStyle(color: Colors.white70, height: 1.4))])),
                const SizedBox(width: 12),
                FilledButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: sample))), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: scheme.primary), child: Text(context.text.get('start'))),
              ],
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth >= 680;
              final items = [
                FeatureTile(icon: Icons.autorenew_rounded, title: context.text.get('review'), subtitle: '${due.length + 8} phrases due · spaced recall queue', color: const Color(0xFF6C63FF), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: sample)))),
                FeatureTile(icon: Icons.error_outline_rounded, title: context.text.get('mistakes'), subtitle: 'Rebuild answers you missed recently', color: const Color(0xFFFF6B6B), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: allLessons[1])))),
                FeatureTile(icon: Icons.graphic_eq_rounded, title: context.text.get('pronunciation'), subtitle: 'Listen, record, and compare your speech', color: const Color(0xFF20C997), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: allLessons[3])))),
                FeatureTile(icon: Icons.auto_stories_rounded, title: context.text.get('stories'), subtitle: 'Read and listen in meaningful context', color: const Color(0xFFFFA94D), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: allLessons[5])))),
                FeatureTile(icon: Icons.psychology_alt_rounded, title: context.text.get('tutor'), subtitle: 'Practice realistic role-play with feedback', color: const Color(0xFF4DABF7), badge: 'BETA', onTap: state.aiTutorEnabled ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorScreen())) : null),
                FeatureTile(icon: Icons.flash_on_rounded, title: 'Speed round', subtitle: '60 seconds of fast active recall', color: const Color(0xFFF06595), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: allLessons[4])))),
                FeatureTile(icon: Icons.hub_rounded, title: context.text.get('sentence_lab'), subtitle: 'Hundreds of speaking and active-recall missions', color: const Color(0xFF0757B8), badge: 'NEW', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SentenceLabScreen()))),
              ];
              if (!twoColumns) return Column(children: items);
              return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, childAspectRatio: 2.35, mainAxisSpacing: 10, crossAxisSpacing: 10, children: items);
            },
          ),
          const SizedBox(height: 22),
          const SectionHeading(title: 'Skill balance', subtitle: 'A simple diagnostic of your active course'),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(19),
              child: Column(children: const [
                _SkillBar(label: 'Vocabulary', value: .72, color: Color(0xFF6C63FF)),
                _SkillBar(label: 'Listening', value: .58, color: Color(0xFF4DABF7)),
                _SkillBar(label: 'Speaking', value: .44, color: Color(0xFF20C997)),
                _SkillBar(label: 'Grammar', value: .63, color: Color(0xFFFFA94D)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [SizedBox(width: 88, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800))), Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: value, minHeight: 9, color: color))), const SizedBox(width: 10), SizedBox(width: 36, child: Text('${(value * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w800)))]),
    );
  }
}
