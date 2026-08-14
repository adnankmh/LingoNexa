import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../data/modern_learning_repository.dart';
import '../data/product_copy_repository.dart';
import '../models/models.dart';
import '../widgets/ui.dart';
import 'language_picker_screen.dart';
import 'lesson_screen.dart';
import 'level_exam_screen.dart';
import 'learning_labs_screen.dart';
import 'grammar_screen.dart';
import 'phrasebook_screen.dart';
import 'story_library_screen.dart';
import 'translator_screen.dart';
import 'unit_hub_screen.dart';
import 'progress_insights_screen.dart';
import 'shadowing_lab_screen.dart';

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
    final units = CourseRepository.unitsFor(
      target.code,
      meaningLanguageCode: state.locale.languageCode,
    ).where((unit) => unit.level == _selectedLevel).toList();
    final progress = (state.dailyMinutes / state.dailyGoalMinutes)
        .clamp(0.0, 1.0)
        .toDouble();
    final locale = state.locale.languageCode;
    String productCopy(String key) => ProductCopyRepository.text(locale, key);

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
                    Text(
                      state.brandName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    Text(
                      context.text.get('tagline'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LanguagePickerScreen(),
                  ),
                ),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Text(target.flag, style: const TextStyle(fontSize: 23)),
                      const SizedBox(width: 7),
                      Text(
                        target.nativeName,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatPill(
                icon: Icons.local_fire_department_rounded,
                value: '${state.streak}',
                label: context.text.get('streak'),
                color: const Color(0xFFFF7A45),
              ),
              StatPill(
                icon: Icons.bolt_rounded,
                value: '${state.xp}',
                label: context.text.get('xp'),
                color: const Color(0xFFFFB020),
              ),
              StatPill(
                icon: Icons.workspace_premium_rounded,
                value: _selectedLevel,
                label: context.text.get('level'),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProgressInsightsScreen(),
                  ),
                ),
                borderRadius: BorderRadius.circular(16),
                child: StatPill(
                  icon: Icons.insights_rounded,
                  value: '${state.masteryScore}%',
                  label: productCopy('mastery'),
                  color: const Color(0xFF008F79),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          GradientPanel(
            child: Row(
              children: [
                ProgressRing(
                  value: progress,
                  label: '${state.dailyMinutes}/${state.dailyGoalMinutes}',
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        productCopy('next_move'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        productCopy('next_move_sub'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .78),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 13),
                      FilledButton.icon(
                        onPressed: () =>
                            _openLesson(context, units.first.lessons.first),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          minimumSize: const Size(150, 45),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(context.text.get('start')),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.sizeOf(context).width > 560)
                  SizedBox(
                    width: 105,
                    height: 105,
                    child: Lottie.asset(
                      'assets/lottie/conversation.json',
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.record_voice_over_rounded,
                        color: Colors.white,
                        size: 76,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DailyQuest(
            title: productCopy('daily_quest'),
            subtitle: productCopy('daily_quest_sub'),
            completedLessons: state.completedLessonIds.length,
            dueReviews: state.dueReviews().length,
            minutes: state.dailyMinutes,
            learnLabel: context.text.get('learn'),
            recallLabel: context.text.get('review'),
            speakLabel: context.text.get('speaking'),
            useLabel: context.text.get('practice'),
          ),
          const SizedBox(height: 28),
          SectionHeading(
            title: productCopy('quick_labs'),
            subtitle: context.text.get('learning_center_subtitle'),
          ),
          const SizedBox(height: 11),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 820 ? 3 : 2;
              final firstUnit = units.first;
              final actions = [
                _HomeAction(
                  icon: Icons.menu_book_rounded,
                  animationAsset: 'assets/lottie/grammar_book.json',
                  title: context.text.get('full_explanation'),
                  subtitle: context.text.get('full_explanation_short'),
                  color: const Color(0xFF6C63FF),
                  onTap: () => _openUnit(context, firstUnit),
                ),
                _HomeAction(
                  icon: Icons.text_fields_rounded,
                  animationAsset: 'assets/lottie/flashcards.json',
                  title: context.text.get('words_examples'),
                  subtitle: context.text.get('words_examples_short'),
                  color: const Color(0xFFEC8B20),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PhrasebookScreen()),
                  ),
                ),
                _HomeAction(
                  icon: Icons.account_tree_rounded,
                  animationAsset: 'assets/lottie/review_loop.json',
                  title: context.text.get('grammar'),
                  subtitle: context.text.get('grammar_short'),
                  color: const Color(0xFFB14FCE),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GrammarScreen()),
                  ),
                ),
                _HomeAction(
                  icon: Icons.fact_check_rounded,
                  animationAsset: 'assets/lottie/learning_goal.json',
                  title: context.text.get('exams'),
                  subtitle: context.text.get('exams_short'),
                  color: const Color(0xFF0E9F79),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelExamScreen(level: _selectedLevel),
                    ),
                  ),
                ),
                _HomeAction(
                  icon: Icons.auto_stories_rounded,
                  animationAsset: 'assets/lottie/culture_world.json',
                  title: context.text.get('stories'),
                  subtitle: context.text.get('stories_short'),
                  color: const Color(0xFFE04F78),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StoryLibraryScreen(),
                    ),
                  ),
                ),
                _HomeAction(
                  icon: Icons.g_translate_rounded,
                  animationAsset: 'assets/lottie/writing_lab.json',
                  title: context.text.get('translator'),
                  subtitle: context.text.get('translator_short'),
                  color: const Color(0xFF1675D1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TranslatorScreen()),
                  ),
                ),
                _HomeAction(
                  icon: Icons.multitrack_audio_rounded,
                  animationAsset: 'assets/lottie/speaking.json',
                  title: productCopy('shadowing'),
                  subtitle: productCopy('shadowing_sub'),
                  color: const Color(0xFF7452D6),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShadowingLabScreen(),
                    ),
                  ),
                ),
                _HomeAction(
                  icon: Icons.insights_rounded,
                  animationAsset: 'assets/lottie/learning_goal.json',
                  title: productCopy('insights'),
                  subtitle: productCopy('progress_sub'),
                  color: const Color(0xFF008F79),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProgressInsightsScreen(),
                    ),
                  ),
                ),
                _HomeAction(
                  icon: Icons.psychology_alt_rounded,
                  animationAsset: 'assets/lottie/brain_pulse.json',
                  title: ModernLearningRepository.copy(locale).hubTitle,
                  subtitle: ModernLearningRepository.copy(locale).hubSubtitle,
                  color: const Color(0xFF5B4CF0),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LearningLabsScreen(),
                    ),
                  ),
                ),
              ];
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: columns,
                childAspectRatio: constraints.maxWidth < 520 ? 1.12 : 1.55,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: actions,
              );
            },
          ),
          const SizedBox(height: 28),
          SectionHeading(
            title: context.text.get('cefr_journey'),
            subtitle:
                '${CourseRepository.levels.length} ${context.text.get('levels')} · 90 ${context.text.get('units')} · 450 ${context.text.get('lessons')}',
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              if (state.examsEnabled)
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LevelExamScreen(level: _selectedLevel),
                    ),
                  ),
                  icon: const Icon(Icons.fact_check_rounded),
                  label: Text(
                    '$_selectedLevel · ${context.text.get('unit_exam')}',
                  ),
                ),
              if (state.storiesEnabled)
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StoryLibraryScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: Text(context.text.get('dialogue_stories')),
                ),
            ],
          ),
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
                      onSelected: (_) =>
                          setState(() => _selectedLevel = level.code),
                      avatar: CircleAvatar(
                        backgroundColor: Color(level.colorValue),
                        radius: 6,
                      ),
                      label: Text('${level.code} · ${level.title}'),
                      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                  onOpen: () => _openUnit(context, units[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LessonScreen(lesson: lesson)),
    );
  }

  void _openUnit(BuildContext context, CourseUnit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UnitHubScreen(unit: unit)),
    );
  }
}

class _DailyQuest extends StatelessWidget {
  const _DailyQuest({
    required this.title,
    required this.subtitle,
    required this.completedLessons,
    required this.dueReviews,
    required this.minutes,
    required this.learnLabel,
    required this.recallLabel,
    required this.speakLabel,
    required this.useLabel,
  });

  final String title;
  final String subtitle;
  final int completedLessons;
  final int dueReviews;
  final int minutes;
  final String learnLabel;
  final String recallLabel;
  final String speakLabel;
  final String useLabel;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB54A), Color(0xFFF36B45)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Lottie.asset(
                        'assets/lottie/daily_quest.json',
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 16)),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _QuestStep(
                      icon: Icons.school_outlined,
                      done: completedLessons > 0,
                      label: learnLabel),
                  _QuestLine(done: dueReviews == 0),
                  _QuestStep(
                      icon: Icons.autorenew_rounded,
                      done: dueReviews == 0,
                      label: recallLabel),
                  _QuestLine(done: minutes >= 10),
                  _QuestStep(
                      icon: Icons.mic_none_rounded,
                      done: minutes >= 10,
                      label: speakLabel),
                  _QuestLine(done: minutes >= 15),
                  _QuestStep(
                      icon: Icons.forum_outlined,
                      done: minutes >= 15,
                      label: useLabel),
                ],
              ),
            ],
          ),
        ),
      );
}

class _QuestStep extends StatelessWidget {
  const _QuestStep(
      {required this.icon, required this.done, required this.label});
  final IconData icon;
  final bool done;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: done
                ? const Color(0xFF0E9F79)
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Icon(done ? Icons.check_rounded : icon,
                color: done ? Colors.white : null, size: 18),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
        ],
      );
}

class _QuestLine extends StatelessWidget {
  const _QuestLine({required this.done});
  final bool done;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          height: 3,
          margin: const EdgeInsets.only(bottom: 17),
          color:
              done ? const Color(0xFF0E9F79) : Theme.of(context).dividerColor,
        ),
      );
}

class _UnitCard extends StatelessWidget {
  const _UnitCard({
    required this.unit,
    required this.completedIds,
    required this.onOpen,
  });

  final CourseUnit unit;
  final Set<String> completedIds;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final completed =
        unit.lessons.where((lesson) => completedIds.contains(lesson.id)).length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Text(unit.emoji, style: const TextStyle(fontSize: 25)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unit.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        unit.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '$completed/${unit.lessons.length}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: onOpen,
                icon: const Icon(Icons.school_rounded),
                label: Text(context.text.get('open_complete_unit')),
              ),
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: completed / unit.lessons.length,
                minHeight: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.animationAsset,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String animationAsset;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Lottie.asset(
                    animationAsset,
                    repeat: true,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(icon, color: color),
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
