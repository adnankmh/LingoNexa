import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../services/speech_service.dart';
import '../widgets/speech_control_panel.dart';
import 'grammar_screen.dart';
import 'lesson_screen.dart';
import 'level_exam_screen.dart';
import 'story_library_screen.dart';
import 'translator_screen.dart';

class UnitHubScreen extends StatelessWidget {
  const UnitHubScreen({required this.unit, super.key});

  final CourseUnit unit;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final completed = unit.lessons
        .where((lesson) => state.completedLessonIds.contains(lesson.id))
        .length;
    final vocabulary = _vocabularyFor(unit);
    return Scaffold(
      appBar: AppBar(title: Text(unit.title)),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 980),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 36),
              children: [
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            unit.emoji,
                            style: const TextStyle(fontSize: 52),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  unit.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  unit.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '$completed/${unit.lessons.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 19,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: completed / unit.lessons.length,
                          minHeight: 9,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  icon: Icons.menu_book_rounded,
                  title: context.text.get('full_explanation'),
                  subtitle: context.text.get('full_explanation_subtitle'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.text.get('what_you_will_learn'),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 8),
                      _Bullet(text: unit.description),
                      _Bullet(text: context.text.get('unit_goal_listen')),
                      _Bullet(text: context.text.get('unit_goal_speak')),
                      _Bullet(text: context.text.get('unit_goal_context')),
                      const SizedBox(height: 12),
                      FilledButton.tonalIcon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GrammarScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.account_tree_rounded),
                        label: Text(context.text.get('open_grammar')),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  icon: Icons.text_fields_rounded,
                  title: context.text.get('topic_words'),
                  subtitle:
                      '${vocabulary.length} ${context.text.get('verified_items')}',
                  child: Column(
                    children: [
                      for (final item in vocabulary)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Text(
                            item.visual,
                            style: const TextStyle(fontSize: 25),
                          ),
                          title: Text(
                            item.target,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          subtitle: Text(item.meaning),
                          trailing: IconButton(
                            tooltip: context.text.get('tip_speak'),
                            onPressed: () =>
                                _speak(context, item.target, language.code),
                            icon: const Icon(Icons.volume_up_rounded),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  icon: Icons.format_quote_rounded,
                  title: context.text.get('examples_dialogues'),
                  subtitle: context.text.get('examples_dialogues_subtitle'),
                  child: Column(
                    children: [
                      for (var index = 0; index < vocabulary.length; index++)
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? Theme.of(context).colorScheme.primaryContainer
                                      .withValues(alpha: .45)
                                : Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withValues(alpha: .45),
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Text(
                            '${index.isEven ? 'A' : 'B'}: ${vocabulary[index].target}\n${vocabulary[index].meaning}',
                            style: const TextStyle(height: 1.45),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  icon: Icons.school_rounded,
                  title: context.text.get('complete_unit_path'),
                  subtitle: context.text.get('complete_unit_path_subtitle'),
                  child: Column(
                    children: [
                      for (var index = 0; index < unit.lessons.length; index++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 9),
                          child: ListTile(
                            tileColor: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: .5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            leading: CircleAvatar(
                              child:
                                  state.completedLessonIds.contains(
                                    unit.lessons[index].id,
                                  )
                                  ? const Icon(Icons.check_rounded)
                                  : Text(unit.lessons[index].emoji),
                            ),
                            title: Text(
                              '${index + 1}. ${unit.lessons[index].title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            subtitle: Text(
                              '${unit.lessons[index].steps.length} ${context.text.get('activities')} · ${unit.lessons[index].durationMinutes} ${context.text.get('minutes')}',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LessonScreen(lesson: unit.lessons[index]),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final twoColumns = constraints.maxWidth >= 680;
                    final cards = [
                      _ActionCard(
                        icon: Icons.auto_stories_rounded,
                        title: context.text.get('stories'),
                        subtitle: context.text.get('stories_action_subtitle'),
                        color: const Color(0xFF7653DC),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StoryLibraryScreen(),
                          ),
                        ),
                      ),
                      _ActionCard(
                        icon: Icons.fact_check_rounded,
                        title: context.text.get('unit_exam'),
                        subtitle: context.text.get('unit_exam_subtitle'),
                        color: const Color(0xFF0E9F79),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LevelExamScreen(level: unit.level),
                          ),
                        ),
                      ),
                      _ActionCard(
                        icon: Icons.g_translate_rounded,
                        title: context.text.get('translator'),
                        subtitle: context.text.get('translator_short'),
                        color: const Color(0xFF1675D1),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TranslatorScreen(),
                          ),
                        ),
                      ),
                    ];
                    if (!twoColumns) return Column(children: cards);
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2.35,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: cards,
                    );
                  },
                ),
                const SizedBox(height: 12),
                SpeechControlPanel(languageCode: language.code),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static List<_VocabularyItem> _vocabularyFor(CourseUnit unit) {
    final seen = <String>{};
    final result = <_VocabularyItem>[];
    for (final lesson in unit.lessons) {
      for (final step in lesson.steps) {
        if (step.type != ExerciseType.flashcard &&
            step.type != ExerciseType.speaking) {
          continue;
        }
        final target = step.type == ExerciseType.flashcard
            ? step.prompt
            : step.answer;
        final meaning = step.translation.isNotEmpty
            ? step.translation
            : step.answer;
        if (target.trim().isNotEmpty && seen.add(target.toLowerCase())) {
          result.add(
            _VocabularyItem(
              target: target,
              meaning: meaning,
              visual: step.visual,
            ),
          );
        }
      }
    }
    return result.take(12).toList(growable: false);
  }

  static Future<void> _speak(
    BuildContext context,
    String text,
    String languageCode,
  ) async {
    final state = AppStateScope.of(context);
    final speech = SpeechService();
    final success = await speech.speak(
      text,
      languageCode,
      rate: state.speechRate,
      voiceName: state.preferredVoiceFor(languageCode),
    );
    speech.dispose();
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('voice_not_installed'))),
      );
    }
  }
}

class _VocabularyItem {
  const _VocabularyItem({
    required this.target,
    required this.meaning,
    required this.visual,
  });

  final String target;
  final String meaning;
  final String visual;
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(child: Icon(icon)),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 19,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(height: 1.4))),
      ],
    ),
  );
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: .14),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    ),
  );
}
