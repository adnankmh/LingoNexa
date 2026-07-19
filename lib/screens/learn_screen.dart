import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../widgets/ui.dart';
import 'language_picker_screen.dart';
import 'lesson_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedLevel = 'A1';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final target = LanguageCatalog.byCode(state.targetLanguageCode);
    final units = CourseRepository.unitsFor(target.code).where((unit) => unit.level == _selectedLevel).toList();
    final progress = (state.dailyMinutes / state.dailyGoalMinutes).clamp(0.0, 1.0).toDouble();

    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const BrandMark(),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.brandName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                    Text(context.text.get('tagline'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguagePickerScreen())),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(18), border: Border.all(color: Theme.of(context).dividerColor)),
                  child: Row(children: [Text(target.flag, style: const TextStyle(fontSize: 23)), const SizedBox(width: 7), Text(target.nativeName, style: const TextStyle(fontWeight: FontWeight.w800)), const SizedBox(width: 2), const Icon(Icons.keyboard_arrow_down_rounded)]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatPill(icon: Icons.local_fire_department_rounded, value: '${state.streak}', label: context.text.get('streak'), color: const Color(0xFFFF7A45)),
              StatPill(icon: Icons.bolt_rounded, value: '${state.xp}', label: context.text.get('xp'), color: const Color(0xFFFFB020)),
              StatPill(icon: Icons.workspace_premium_rounded, value: _selectedLevel, label: context.text.get('level')),
            ],
          ),
          const SizedBox(height: 18),
          GradientPanel(
            child: Row(
              children: [
                ProgressRing(value: progress, label: '${state.dailyMinutes}/${state.dailyGoalMinutes}'),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.text.get('continue'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text('${context.text.get('daily_goal')} · ${state.dailyGoalMinutes} ${context.text.get('minutes')}', style: TextStyle(color: Colors.white.withValues(alpha: .78), fontWeight: FontWeight.w600)),
                      const SizedBox(height: 13),
                      FilledButton.icon(
                        onPressed: () => _openLesson(context, units.first.lessons.first),
                        style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Theme.of(context).colorScheme.primary, minimumSize: const Size(150, 45)),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(context.text.get('start')),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.sizeOf(context).width > 560) const Text('🗣️', style: TextStyle(fontSize: 84)),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SectionHeading(title: 'CEFR Journey', subtitle: '${CourseRepository.levels.length} levels · 36 units · 180 lessons per language'),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final level in CourseRepository.levels)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ChoiceChip(
                      selected: _selectedLevel == level.code,
                      onSelected: (_) => setState(() => _selectedLevel = level.code),
                      avatar: CircleAvatar(backgroundColor: Color(level.colorValue), radius: 6),
                      label: Text('${level.code} · ${level.title}'),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 780 ? 2 : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: units.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  childAspectRatio: columns == 1 ? 1.55 : 1.48,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemBuilder: (context, index) => _UnitCard(
                  unit: units[index],
                  completedIds: state.completedLessonIds,
                  onLessonTap: (lesson) => _openLesson(context, lesson),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openLesson(BuildContext context, Lesson lesson) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)));
  }
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({required this.unit, required this.completedIds, required this.onLessonTap});

  final CourseUnit unit;
  final Set<String> completedIds;
  final ValueChanged<Lesson> onLessonTap;

  @override
  Widget build(BuildContext context) {
    final completed = unit.lessons.where((lesson) => completedIds.contains(lesson.id)).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 48, height: 48, alignment: Alignment.center, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(17)), child: Text(unit.emoji, style: const TextStyle(fontSize: 25))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(unit.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)), const SizedBox(height: 3), Text(unit.description, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12))])),
                Text('$completed/${unit.lessons.length}', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900)),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var i = 0; i < unit.lessons.length; i++)
                  _LessonNode(
                    lesson: unit.lessons[i],
                    index: i,
                    completed: completedIds.contains(unit.lessons[i].id),
                    onTap: () => onLessonTap(unit.lessons[i]),
                  ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(value: completed / unit.lessons.length, minHeight: 7),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonNode extends StatelessWidget {
  const _LessonNode({required this.lesson, required this.index, required this.completed, required this.onTap});

  final Lesson lesson;
  final int index;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: lesson.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: completed ? scheme.primary : (index == 0 ? scheme.primaryContainer : scheme.surfaceContainerHighest),
            shape: BoxShape.circle,
            border: Border.all(color: completed || index == 0 ? scheme.primary : scheme.outlineVariant, width: 2),
          ),
          child: completed ? Icon(Icons.check_rounded, color: scheme.onPrimary) : Text(lesson.emoji, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
