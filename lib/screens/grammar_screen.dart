import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/grammar_book_repository.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../models/models.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  String _level = 'All';
  String _query = '';
  final Set<int> _readChapters = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    final copy = GrammarBookRepository.copy(locale);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final verified = LearningContentRepository.phrasesFor(
      language.code,
      sourceLanguageCode: locale,
    );
    final indexedTopics = LearningContentRepository.grammarTopics.indexed
        .where((entry) => _level == 'All' || entry.$2.level == _level)
        .where((entry) {
      if (_query.trim().isEmpty) return true;
      final title = GrammarBookRepository.localizedTopicTitle(
        locale,
        entry.$1,
        entry.$2.title,
      );
      return '$title ${entry.$2.level}'
          .toLowerCase()
          .contains(_query.trim().toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(copy.title),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '${language.flag} ${language.nativeName}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  sliver: SliverToBoxAdapter(
                    child: _GrammarHero(
                      copy: copy,
                      language: language,
                      exampleCount: verified.length,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 178,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                      itemCount: 6,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final level =
                            const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'][index];
                        final total = LearningContentRepository.grammarTopics
                            .where((topic) => topic.level == level)
                            .length;
                        final read = LearningContentRepository
                            .grammarTopics.indexed
                            .where((entry) => entry.$2.level == level)
                            .where((entry) => _readChapters.contains(entry.$1))
                            .length;
                        return _BookCover(
                          level: level,
                          bookLabel: copy.book,
                          chaptersLabel: copy.chapters,
                          chapters: total,
                          progress: total == 0 ? 0 : read / total,
                          selected: _level == level,
                          color: _bookColors[index],
                          onTap: () => setState(
                            () => _level = _level == level ? 'All' : level,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 2, 18, 10),
                  sliver: SliverToBoxAdapter(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                        hintText: copy.searchHint,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: copy.allLevels,
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 4, 18, 34),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final columns =
                          constraints.crossAxisExtent >= 760 ? 2 : 1;
                      return SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: columns == 1 ? 1.9 : 1.5,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final entry = indexedTopics[index];
                            final chapterTitle =
                                GrammarBookRepository.localizedTopicTitle(
                              locale,
                              entry.$1,
                              entry.$2.title,
                            );
                            final examples = _examplesFor(
                              verified,
                              entry.$1,
                              3,
                            );
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(
                                milliseconds: 260 + (index % 6) * 45,
                              ),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) =>
                                  Transform.translate(
                                offset: Offset(0, 18 * (1 - value)),
                                child: Opacity(opacity: value, child: child),
                              ),
                              child: _ChapterCard(
                                chapterNumber: entry.$1 + 1,
                                title: chapterTitle,
                                topic: entry.$2,
                                copy: copy,
                                color: _bookColors[_levelIndex(entry.$2.level)],
                                complete: _readChapters.contains(entry.$1),
                                onOpen: (practice) async {
                                  await Navigator.push<void>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => _GrammarChapterScreen(
                                        chapterNumber: entry.$1 + 1,
                                        topic: entry.$2,
                                        title: chapterTitle,
                                        examples: examples,
                                        language: language,
                                        locale: locale,
                                        startWithPractice: practice,
                                      ),
                                    ),
                                  );
                                  if (mounted) {
                                    setState(() => _readChapters.add(entry.$1));
                                  }
                                },
                              ),
                            );
                          },
                          childCount: indexedTopics.length,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static List<PhraseEntry> _examplesFor(
    List<PhraseEntry> phrases,
    int offset,
    int count,
  ) {
    if (phrases.isEmpty) return const [];
    return [
      for (var index = 0; index < count; index++)
        phrases[(offset * count + index) % phrases.length],
    ];
  }

  static int _levelIndex(String level) => const [
        'A1',
        'A2',
        'B1',
        'B2',
        'C1',
        'C2'
      ].indexOf(level).clamp(0, 5).toInt();

  static const _bookColors = [
    Color(0xFF4E72E8),
    Color(0xFF0A9A7C),
    Color(0xFFE7783D),
    Color(0xFF9B55D3),
    Color(0xFFDB4F7A),
    Color(0xFFB27A15),
  ];
}

class _GrammarHero extends StatelessWidget {
  const _GrammarHero({
    required this.copy,
    required this.language,
    required this.exampleCount,
  });

  final GrammarBookCopy copy;
  final LanguageOption language;
  final int exampleCount;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF172D63), Color(0xFF694FE7)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B4CF0).withValues(alpha: .22),
              blurRadius: 32,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final details = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  copy.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  copy.subtitle,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .82),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _HeroPill(
                        icon: Icons.library_books_rounded,
                        text: '6 ${copy.book}'),
                    _HeroPill(
                        icon: Icons.auto_stories_rounded,
                        text: '54 ${copy.chapters}'),
                    _HeroPill(
                        icon: Icons.translate_rounded,
                        text: '$exampleCount ${copy.alignedExamples}'),
                  ],
                ),
              ],
            );
            if (constraints.maxWidth < 650) return details;
            return Row(
              children: [
                Expanded(child: details),
                SizedBox(
                  width: 170,
                  height: 150,
                  child: Lottie.asset(
                    'assets/lottie/grammar_book.json',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 92),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _BookCover extends StatelessWidget {
  const _BookCover({
    required this.level,
    required this.bookLabel,
    required this.chaptersLabel,
    required this.chapters,
    required this.progress,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final String level;
  final String bookLabel;
  final String chaptersLabel;
  final int chapters;
  final double progress;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 142,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, Color.lerp(color, Colors.black, .24)!],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? Colors.white : color.withValues(alpha: .7),
                width: selected ? 3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: selected ? .34 : .17),
                  blurRadius: selected ? 20 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_stories_rounded,
                    color: Colors.white, size: 24),
                const Spacer(),
                Text('$bookLabel $level',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('$chapters $chaptersLabel',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 9),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: Colors.white24,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
}

class _ChapterCard extends StatelessWidget {
  const _ChapterCard({
    required this.chapterNumber,
    required this.title,
    required this.topic,
    required this.copy,
    required this.color,
    required this.complete,
    required this.onOpen,
  });

  final int chapterNumber;
  final String title;
  final GrammarTopic topic;
  final GrammarBookCopy copy;
  final Color color;
  final bool complete;
  final ValueChanged<bool> onOpen;

  @override
  Widget build(BuildContext context) => Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              top: -34,
              end: -24,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('${copy.chapter} $chapterNumber',
                            style: TextStyle(
                                color: color,
                                fontSize: 11,
                                fontWeight: FontWeight.w900)),
                      ),
                      const Spacer(),
                      Text(topic.level,
                          style: TextStyle(
                              color: color, fontWeight: FontWeight.w900)),
                      if (complete) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF0A9A7C), size: 19),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text('8 ${copy.minutes} · ${topic.emoji}',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => onOpen(false),
                          icon: const Icon(Icons.menu_book_rounded, size: 18),
                          label: Text(copy.fullExplanation,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: copy.practice,
                        onPressed: () => onOpen(true),
                        icon: const Icon(Icons.bolt_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _GrammarChapterScreen extends StatefulWidget {
  const _GrammarChapterScreen({
    required this.chapterNumber,
    required this.topic,
    required this.title,
    required this.examples,
    required this.language,
    required this.locale,
    required this.startWithPractice,
  });

  final int chapterNumber;
  final GrammarTopic topic;
  final String title;
  final List<PhraseEntry> examples;
  final LanguageOption language;
  final String locale;
  final bool startWithPractice;

  @override
  State<_GrammarChapterScreen> createState() => _GrammarChapterScreenState();
}

class _GrammarChapterScreenState extends State<_GrammarChapterScreen> {
  late bool _showAnswers;
  final Set<int> _completed = {};

  @override
  void initState() {
    super.initState();
    _showAnswers = widget.startWithPractice;
  }

  @override
  Widget build(BuildContext context) {
    final copy = GrammarBookRepository.copy(widget.locale);
    final paragraphs = GrammarBookRepository.explanationFor(
      widget.locale,
      topic: widget.title,
      language: widget.language.nativeName,
      level: widget.topic.level,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('${copy.chapter} ${widget.chapterNumber}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
            children: [
              _ChapterHero(widget: widget, copy: copy),
              const SizedBox(height: 16),
              _LessonSection(
                icon: Icons.language_rounded,
                title: copy.languageWorks,
                child: Text(
                  GrammarBookRepository.profileFor(
                      widget.locale, widget.language),
                  style: const TextStyle(height: 1.65),
                ),
              ),
              _LessonSection(
                icon: Icons.menu_book_rounded,
                title: copy.completeExplanation,
                child: Column(
                  children: [
                    for (final paragraph in paragraphs)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(paragraph,
                              style: const TextStyle(height: 1.72)),
                        ),
                      ),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.account_tree_rounded,
                title: copy.meaningFormUse,
                child: Column(
                  children: [
                    for (var index = 0; index < copy.lensLabels.length; index++)
                      _NumberedLine(
                          number: index + 1, text: copy.lensLabels[index]),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.translate_rounded,
                title:
                    '${copy.practicePhrases} · ${widget.language.nativeName}',
                child: Column(
                  children: [
                    for (final example in widget.examples)
                      _PhrasePanel(example: example),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.rule_rounded,
                title: copy.rulesSteps,
                child: Column(
                  children: [
                    for (var index = 0; index < copy.ruleSteps.length; index++)
                      _NumberedLine(
                          number: index + 1, text: copy.ruleSteps[index]),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.warning_amber_rounded,
                title: copy.commonMistakes,
                child: Column(
                  children: [
                    for (final mistake in copy.mistakeSteps)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.close_rounded,
                                color: Colors.redAccent, size: 20),
                            const SizedBox(width: 9),
                            Expanded(
                                child: Text(mistake,
                                    style: const TextStyle(height: 1.5))),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.psychology_alt_rounded,
                title: copy.guidedPractice,
                child: Column(
                  children: [
                    for (var index = 0;
                        index < copy.practiceSteps.length;
                        index++)
                      CheckboxListTile(
                        value: _completed.contains(index),
                        onChanged: (value) => setState(() => value == true
                            ? _completed.add(index)
                            : _completed.remove(index)),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: Text(copy.practiceSteps[index],
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle:
                            _showAnswers ? Text(copy.answerSteps[index]) : null,
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            setState(() => _showAnswers = !_showAnswers),
                        icon: Icon(_showAnswers
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                        label: Text(
                            _showAnswers ? copy.hideAnswers : copy.showAnswers),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withValues(alpha: .62),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(copy.masteryTip,
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, height: 1.5)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterHero extends StatelessWidget {
  const _ChapterHero({required this.widget, required this.copy});
  final _GrammarChapterScreen widget;
  final GrammarBookCopy copy;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF3D55C6), Color(0xFF8A4BC1)],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 82,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(widget.topic.emoji,
                    style: const TextStyle(fontSize: 38)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${copy.chapter} ${widget.chapterNumber} · ${widget.topic.level}',
                    style: const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(widget.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(
                    '${widget.language.flag} ${widget.language.nativeName} · 8 ${copy.minutes}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PhrasePanel extends StatelessWidget {
  const _PhrasePanel({required this.example});
  final PhraseEntry example;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: .42),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text(example.visual, style: const TextStyle(fontSize: 27)),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(example.target,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(example.source,
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  if (example.pronunciation.isNotEmpty)
                    Text(example.pronunciation,
                        style: const TextStyle(
                            fontSize: 11.5, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _LessonSection extends StatelessWidget {
  const _LessonSection({
    required this.icon,
    required this.title,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 13),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: .7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon,
                        color: Theme.of(context).colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 17)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      );
}

class _NumberedLine extends StatelessWidget {
  const _NumberedLine({required this.number, required this.text});
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 12, child: Text('$number')),
            const SizedBox(width: 10),
            Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
          ],
        ),
      );
}
