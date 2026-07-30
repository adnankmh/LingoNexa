import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/academy_repository.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../widgets/ui.dart';
import 'grammar_screen.dart';
import 'level_exam_screen.dart';
import 'story_library_screen.dart';
import 'unit_hub_screen.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final units = CourseRepository.unitsFor(
      language.code,
      meaningLanguageCode: locale,
    );
    final currentUnits =
        units.where((unit) => unit.level == state.currentLevel).toList();
    final nextUnit = currentUnits.firstWhere(
      (unit) => unit.lessons.any(
        (lesson) => !state.completedLessonIds.contains(lesson.id),
      ),
      orElse: () => currentUnits.first,
    );
    String copy(String key) => AcademyRepository.text(locale, key);

    return ResponsivePage(
      maxWidth: 1180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF102D5B), Color(0xFF5B4CF0)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5B4CF0).withValues(alpha: .24),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 680;
                final copyColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .13),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${language.flag} ${language.nativeName} · ${state.currentLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      copy('academy'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 29,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      copy('academy_subtitle'),
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .82),
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _HeaderMetric(
                          icon: Icons.translate_rounded,
                          label: copy('catalog_languages'),
                        ),
                        _HeaderMetric(
                          icon: Icons.verified_rounded,
                          label: copy('studio_languages'),
                        ),
                        _HeaderMetric(
                          icon: Icons.bolt_rounded,
                          label: copy('activities_count'),
                        ),
                      ],
                    ),
                  ],
                );
                if (compact) return copyColumn;
                return Row(
                  children: [
                    Expanded(child: copyColumn),
                    const SizedBox(width: 20),
                    Container(
                      width: 164,
                      height: 164,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🌐', style: TextStyle(fontSize: 92)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _CoverageBanner(
            fullPack: AcademyRepository.hasFullStudioPack(language.code),
            note: copy('coverage_note'),
            fullLabel: copy('full_pack'),
            foundationLabel: copy('foundation_pack'),
          ),
          const SizedBox(height: 28),
          SectionHeading(
            title: copy('complete_path'),
            subtitle: copy('complete_path_subtitle'),
          ),
          const SizedBox(height: 13),
          const _LearningFlow(),
          const SizedBox(height: 30),
          SectionHeading(
            title: copy('content_library'),
            subtitle: copy('content_library_subtitle'),
          ),
          const SizedBox(height: 13),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 560
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AcademyRepository.collections.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 2.35 : 1.5,
                ),
                itemBuilder: (context, index) {
                  final collection = AcademyRepository.collections[index];
                  return _CollectionCard(
                    collection: collection,
                    title: copy(collection.titleKey),
                    subtitle: copy(collection.subtitleKey),
                    onTap: () => _openCollection(
                      context,
                      collection.id,
                      units,
                      nextUnit,
                      state.currentLevel,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),
          SectionHeading(
            title: context.text.get('continue'),
            subtitle: '${copy('deep_lessons')} · ${state.currentLevel}',
          ),
          const SizedBox(height: 12),
          _ContinueCard(
            unit: nextUnit,
            title: AcademyRepository.topicTitle(nextUnit, locale),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UnitHubScreen(unit: nextUnit)),
            ),
          ),
        ],
      ),
    );
  }

  static void _openCollection(
    BuildContext context,
    String id,
    List<CourseUnit> units,
    CourseUnit nextUnit,
    String currentLevel,
  ) {
    final Widget screen = switch (id) {
      'deep_lessons' => UnitHubScreen(unit: nextUnit),
      'course_books' => _CourseBooksScreen(units: units),
      'motion' => const _MotionLibraryScreen(),
      'listening' => const StoryLibraryScreen(),
      'reference' => const GrammarScreen(),
      'assessment' => LevelExamScreen(level: currentLevel),
      _ => UnitHubScreen(unit: nextUnit),
    };
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      );
}

class _CoverageBanner extends StatelessWidget {
  const _CoverageBanner({
    required this.fullPack,
    required this.note,
    required this.fullLabel,
    required this.foundationLabel,
  });

  final bool fullPack;
  final String note;
  final String fullLabel;
  final String foundationLabel;

  @override
  Widget build(BuildContext context) {
    final color = fullPack ? const Color(0xFF008F79) : const Color(0xFFF09A28);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        border: Border.all(color: color.withValues(alpha: .24)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color,
            foregroundColor: Colors.white,
            child: Icon(
              fullPack ? Icons.verified_rounded : Icons.school_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullPack ? fullLabel : foundationLabel,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(note, style: const TextStyle(height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearningFlow extends StatelessWidget {
  const _LearningFlow();

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.text.get('full_explanation'),
      context.text.get('words_examples'),
      context.text.get('listening'),
      context.text.get('speaking'),
      context.text.get('practice'),
      context.text.get('exams'),
    ];
    const icons = [
      Icons.lightbulb_rounded,
      Icons.text_fields_rounded,
      Icons.headphones_rounded,
      Icons.mic_rounded,
      Icons.psychology_rounded,
      Icons.workspace_premium_rounded,
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth >= 760
            ? (constraints.maxWidth - 50) / 6
            : constraints.maxWidth >= 470
                ? (constraints.maxWidth - 20) / 3
                : (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var index = 0; index < labels.length; index++)
              SizedBox(
                width: itemWidth,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Icon(icons[index], size: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({
    required this.collection,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final AcademyCollection collection;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(collection.colorValue);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .11),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      collection.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      collection.metric,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  subtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.35,
                    fontSize: 12,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: color,
                  size: 21,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.unit,
    required this.title,
    required this.onTap,
  });

  final CourseUnit unit;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Text(unit.emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$title · ${unit.level}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${unit.lessons.length} ${context.text.get('lessons')} · 50 ${context.text.get('activities')}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: onTap,
                  child: Text(context.text.get('start')),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CourseBooksScreen extends StatelessWidget {
  const _CourseBooksScreen({required this.units});

  final List<CourseUnit> units;

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    String copy(String key) => AcademyRepository.text(locale, key);
    return Scaffold(
      appBar: AppBar(title: Text(copy('course_books'))),
      body: SafeArea(
        top: false,
        child: ResponsivePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                title: copy('course_books'),
                subtitle: copy('course_books_subtitle'),
              ),
              const SizedBox(height: 14),
              for (final level in CourseRepository.levels)
                _BookCard(
                  level: level,
                  units:
                      units.where((unit) => unit.level == level.code).toList(),
                  locale: locale,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookCard extends ExpansionTile {
  _BookCard({
    required LearningLevel level,
    required List<CourseUnit> units,
    required String locale,
  }) : super(
          tilePadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          leading: CircleAvatar(
            backgroundColor: Color(level.colorValue),
            foregroundColor: Colors.white,
            child: Text(
              level.code,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
            ),
          ),
          title: Text(
            '${AcademyRepository.text(locale, 'course_books')} · ${level.code}',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          subtitle: Text('15 ${AcademyRepository.text(locale, 'chapters')}'),
          children: [
            for (final unit in units)
              Builder(
                builder: (context) => ListTile(
                  leading: Text(unit.emoji),
                  title: Text(AcademyRepository.topicTitle(unit, locale)),
                  subtitle: Text(
                    '${unit.lessons.length} ${AcademyRepository.text(locale, 'lessons_count')}',
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => UnitHubScreen(unit: unit)),
                  ),
                ),
              ),
          ],
        );
}

class _MotionLibraryScreen extends StatelessWidget {
  const _MotionLibraryScreen();

  static const _resources = [
    (
      'listening.json',
      'VOA Learning English',
      'https://learningenglish.voanews.com/',
    ),
    (
      'speaking.json',
      'DW Language Learning',
      'https://www.dw.com/en/learn-german/s-2469',
    ),
    (
      'streak.json',
      'TV5MONDE Apprendre',
      'https://apprendre.tv5monde.com/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    String copy(String key) => AcademyRepository.text(locale, key);
    return Scaffold(
      appBar: AppBar(title: Text(copy('motion_lessons'))),
      body: SafeArea(
        top: false,
        child: ResponsivePage(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(
                title: copy('motion_lessons'),
                subtitle: copy('motion_lessons_subtitle'),
              ),
              const SizedBox(height: 14),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 720 ? 3 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _resources.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: columns == 1 ? 2.4 : .9,
                    ),
                    itemBuilder: (context, index) {
                      final resource = _resources[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _openUrl(context, resource.$3),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Lottie.asset(
                                    'assets/lottie/${resource.$1}',
                                    repeat: true,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  resource.$2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                FilledButton.tonalIcon(
                                  onPressed: () =>
                                      _openUrl(context, resource.$3),
                                  icon: const Icon(Icons.play_circle_rounded),
                                  label: Text(copy('open')),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _openUrl(BuildContext context, String url) async {
    final success = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!success && context.mounted) {
      final state = AppStateScope.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AcademyRepository.text(
              state.locale.languageCode,
              'resource_open_failed',
            ),
          ),
        ),
      );
    }
  }
}
