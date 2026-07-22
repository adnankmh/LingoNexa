import 'package:flutter/material.dart';

import '../core/app_state.dart';
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

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final verified = LearningContentRepository.phrasesFor(
      language.code,
      sourceLanguageCode: state.locale.languageCode,
    );
    final topics = LearningContentRepository.grammarTopics
        .where((topic) => _level == 'All' || topic.level == _level)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grammar Atlas'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 54),
            child: Center(
              child: Text(language.flag, style: const TextStyle(fontSize: 23)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(18, 10, 18, 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${language.flag} ${language.englishName} grammar profile',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _languageProfile(language.code, language.script),
                        style: const TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Writing system: ${language.script} · ${verified.length} aligned examples currently available',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 58,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    children: [
                      for (final level in const [
                        'All',
                        'A1',
                        'A2',
                        'B1',
                        'B2',
                        'C1',
                        'C2',
                      ])
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 7),
                          child: ChoiceChip(
                            selected: _level == level,
                            onSelected: (_) => setState(() => _level = level),
                            label: Text(level),
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                    itemCount: topics.length,
                    itemBuilder: (context, index) => _GrammarCard(
                      topic: topics[index],
                      language: language,
                      languageProfile: _languageProfile(
                        language.code,
                        language.script,
                      ),
                      examples: [
                        for (var i = 0; i < 3; i++)
                          verified[(index * 3 + i) % verified.length],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _languageProfile(String code, String script) => switch (code) {
    'en' =>
      'English relies on relatively fixed word order, auxiliary verbs, articles, and tense/aspect combinations. Learn patterns inside complete phrases.',
    'ar' =>
      'Arabic uses a root-and-pattern system, grammatical gender, agreement, and right-to-left writing. Formal Arabic and spoken varieties should be labelled separately.',
    'es' =>
      'Spanish combines noun gender and agreement with rich verb conjugation. Subject pronouns can often be omitted because the verb ending carries information.',
    'fr' =>
      'French uses articles, gender, agreement, verb conjugation, liaison, and a major difference between written and naturally spoken forms.',
    'de' =>
      'German uses grammatical gender, four cases, separable verbs, and verb-position rules. Learn nouns together with their articles.',
    'tr' =>
      'Turkish is agglutinative: clear suffix chains express case, possession, tense, and person. Vowel harmony helps predict many forms.',
    'pt' =>
      'Portuguese uses gender, agreement, rich conjugation, and distinct spoken varieties. Pronunciation and pronoun placement vary by region.',
    'it' =>
      'Italian uses gender, agreement, articles, and expressive verb conjugation. Double consonants and stress can change meaning.',
    'ru' =>
      'Russian uses six cases, grammatical gender, verb aspect, and flexible word order. Endings show the role of each word.',
    'zh' =>
      'Mandarin Chinese uses tones, classifiers, particles, and word order rather than verb conjugation. Characters and pronunciation must be learned together.',
    'ja' =>
      'Japanese commonly uses subject–object–verb order, particles, counters, and politeness levels. Context often allows subjects to be omitted.',
    'ko' =>
      'Korean commonly uses subject–object–verb order, particles, speech levels, and honorifics. Verb endings express social relationship and sentence function.',
    _ =>
      'This course uses the $script writing system. Only aligned reviewed phrases are presented as target-language examples; broader grammar notes remain cross-language concepts until a specialist pack is installed.',
  };
}

class _GrammarCard extends StatelessWidget {
  const _GrammarCard({
    required this.topic,
    required this.examples,
    required this.language,
    required this.languageProfile,
  });
  final GrammarTopic topic;
  final List<PhraseEntry> examples;
  final LanguageOption language;
  final String languageProfile;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 11),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        leading: CircleAvatar(child: Text(topic.emoji)),
        title: Text(
          topic.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text('${topic.level} · Concept lesson'),
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(topic.summary, style: const TextStyle(height: 1.55)),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Verified target-language examples',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final example in examples)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withValues(alpha: .45),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Text(example.visual, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          example.target,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          example.source,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openDetail(context),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Full explanation'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed: () => _openDetail(context, practice: true),
                  icon: const Icon(Icons.fitness_center_rounded),
                  label: const Text('Practice'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, {bool practice = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _GrammarDetailScreen(
          topic: topic,
          examples: examples,
          language: language,
          languageProfile: languageProfile,
          startWithPractice: practice,
        ),
      ),
    );
  }
}

class _GrammarDetailScreen extends StatefulWidget {
  const _GrammarDetailScreen({
    required this.topic,
    required this.examples,
    required this.language,
    required this.languageProfile,
    required this.startWithPractice,
  });

  final GrammarTopic topic;
  final List<PhraseEntry> examples;
  final LanguageOption language;
  final String languageProfile;
  final bool startWithPractice;

  @override
  State<_GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends State<_GrammarDetailScreen> {
  late bool _showAnswers;
  final Set<int> _completed = {};

  @override
  void initState() {
    super.initState();
    _showAnswers = widget.startWithPractice;
  }

  @override
  Widget build(BuildContext context) {
    final topic = widget.topic;
    final rules = _rulesFor(topic);
    final mistakes = _mistakesFor(topic);
    return Scaffold(
      appBar: AppBar(title: Text('${topic.level} · ${topic.title}')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
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
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.emoji, style: const TextStyle(fontSize: 50)),
                    const SizedBox(height: 10),
                    Text(
                      topic.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${widget.language.flag} ${widget.language.englishName} · ${topic.level}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      topic.summary,
                      style: const TextStyle(color: Colors.white, height: 1.55),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _LessonSection(
                icon: Icons.language_rounded,
                title: 'How this language works',
                child: Text(
                  widget.languageProfile,
                  style: const TextStyle(height: 1.65),
                ),
              ),
              _LessonSection(
                icon: Icons.menu_book_rounded,
                title: 'Complete explanation',
                child: Text(
                  _explanationFor(topic),
                  style: const TextStyle(height: 1.7),
                ),
              ),
              _LessonSection(
                icon: Icons.account_tree_rounded,
                title: 'Meaning, form, and use',
                child: Text(
                  _conceptLensFor(topic),
                  style: const TextStyle(height: 1.7),
                ),
              ),
              _LessonSection(
                icon: Icons.pattern_rounded,
                title: 'Pattern bank',
                child: Column(
                  children: [
                    for (var index = 0; index < topic.examples.length; index++)
                      _NumberedLine(
                        number: index + 1,
                        text:
                            '${topic.examples[index]} — change one detail, preserve the structure, then say the new version aloud.',
                      ),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.rule_rounded,
                title: 'Rules and decision steps',
                child: Column(
                  children: [
                    for (var index = 0; index < rules.length; index++)
                      _NumberedLine(number: index + 1, text: rules[index]),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.translate_rounded,
                title:
                    'Aligned practice phrases in ${widget.language.englishName}',
                child: Column(
                  children: [
                    for (final example in widget.examples)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 9),
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.primaryContainer.withValues(alpha: .45),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Text(
                              example.visual,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    example.target,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    example.source,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.warning_amber_rounded,
                title: 'Common mistakes to avoid',
                child: Column(
                  children: [
                    for (final mistake in mistakes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 9),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.close_rounded,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                mistake,
                                style: const TextStyle(height: 1.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              _LessonSection(
                icon: Icons.fitness_center_rounded,
                title: 'Guided practice',
                child: Column(
                  children: [
                    for (var index = 0; index < 8; index++)
                      CheckboxListTile(
                        value: _completed.contains(index),
                        onChanged: (value) => setState(
                          () => value == true
                              ? _completed.add(index)
                              : _completed.remove(index),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _practiceFor(topic, index),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: _showAnswers
                            ? Text(_answerFor(topic, index))
                            : null,
                      ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            setState(() => _showAnswers = !_showAnswers),
                        icon: Icon(
                          _showAnswers
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                        label: Text(
                          _showAnswers
                              ? 'Hide model answers'
                              : 'Check model answers',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Text(
                  'Mastery tip: understand the pattern, notice it in three real phrases, produce your own example, then review it after one day and one week.',
                  style: TextStyle(fontWeight: FontWeight.w800, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _explanationFor(GrammarTopic topic) =>
      '${topic.summary}\n\nStart with the communicative goal: decide exactly what the listener must understand. Then identify which part of the pattern carries that meaning—word order, an ending, a helper word, a particle, agreement, or context. In ${widget.language.englishName}, compare complete phrases instead of translating isolated words.\n\nWork in four passes: notice the pattern, explain the contrast, produce a controlled variation, and use it in a personal message. At ${topic.level}, accuracy comes first; speed, flexibility, and natural register are added only after the pattern stays stable.';

  String _conceptLensFor(GrammarTopic topic) =>
      'MEANING — ${topic.summary}\n\nFORM — Locate the smallest visible or audible change that carries the grammar. It may appear before the main word, after it, inside it, or through word order.\n\nUSE — Ask who is speaking, to whom, for what purpose, and in which setting. A structurally correct sentence can still sound unnatural if its register is wrong.\n\nCONTRAST — Build a pair in which only one feature changes. Explain how that change affects time, certainty, politeness, focus, or relationship.\n\nTRANSFER — Create one spoken example and one written example about your own life, then revisit both after one day.';

  List<String> _rulesFor(GrammarTopic topic) => [
    'For ${topic.title.toLowerCase()}, identify the meaning you want to express before choosing a form.',
    'Notice the normal word order in the verified examples; do not copy the order of your first language automatically.',
    'Keep agreement, particles, endings, or helper words attached to the phrase pattern in which you learned them.',
    'Check whether the situation is formal, neutral, or friendly before speaking.',
    'Say the complete pattern aloud, then substitute only one element at a time.',
    'Review the pattern through listening, recognition, controlled production, and a personal sentence.',
    'Compare a positive, negative, and question version where the language allows that contrast.',
    'Finish with a context check: who can say it, to whom, and in which register?',
  ];

  List<String> _mistakesFor(GrammarTopic topic) => [
    'Treating ${topic.title.toLowerCase()} as a word-for-word translation and preserving the source-language order.',
    'Memorizing an ending or particle without the complete phrase that controls it.',
    'Using one form for every context without checking politeness or register.',
    'Recognizing the rule on paper but never producing it aloud.',
    'Moving to a new topic before correcting the same repeated error.',
    'Assuming that a grammatically possible form is automatically the most natural form.',
    'Ignoring regional or spoken variation when the course labels a form as formal or neutral.',
  ];

  String _practiceFor(GrammarTopic topic, int index) => switch (index) {
    0 =>
      'In a ${topic.title.toLowerCase()} example, underline the part that carries the main grammatical meaning.',
    1 => 'Change one person, time, quantity, or place in a verified example.',
    2 => 'Turn one example into a question or a negative form.',
    3 => 'Say a personal sentence using the same pattern without reading.',
    4 => 'Create a two-line mini-dialogue that uses this structure naturally.',
    5 => 'Rewrite one example for a more formal or more friendly situation.',
    6 => 'Record yourself, wait ten seconds, then correct one detail you hear.',
    _ => 'Teach the rule in one minute and give an original example.',
  };

  String _answerFor(GrammarTopic topic, int index) => switch (index) {
    0 =>
      'Model for ${topic.title.toLowerCase()}: identify the word order plus any ending, particle, or helper word that changes the meaning.',
    1 =>
      'Keep the structure stable and replace only one meaningful element; then verify agreement.',
    2 =>
      'Use the question or negative strategy described by the target language, not a word-for-word translation.',
    3 =>
      'A strong answer is accurate, relevant to your life, and easy to say twice at a natural pace.',
    4 =>
      'Line 1 introduces the situation; line 2 responds with the target pattern and an appropriate level of politeness.',
    5 =>
      'Keep the core meaning, but adjust pronouns, politeness markers, vocabulary, or sentence length to match the relationship.',
    6 =>
      'Listen for one target only: order, ending, helper word, agreement, or rhythm. Correct that target and record again.',
    _ =>
      'A successful explanation names the meaning, identifies the form, states when it is used, and includes an original example.',
  };
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
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
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
        Expanded(child: Text(text, style: const TextStyle(height: 1.45))),
      ],
    ),
  );
}
