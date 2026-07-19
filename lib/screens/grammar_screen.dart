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
    final verified = LearningContentRepository.phrasesFor(language.code, sourceLanguageCode: state.locale.languageCode);
    final topics = LearningContentRepository.grammarTopics.where((topic) => _level == 'All' || topic.level == _level).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Atlas'), actions: [Padding(padding: const EdgeInsetsDirectional.only(end: 54), child: Center(child: Text(language.flag, style: const TextStyle(fontSize: 23))))]),
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
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .55), borderRadius: BorderRadius.circular(20)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${language.flag} ${language.englishName} grammar profile', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
                    const SizedBox(height: 6),
                    Text(_languageProfile(language.code, language.script), style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 7),
                    Text('Writing system: ${language.script} · ${verified.length} aligned examples currently available', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11.5, fontWeight: FontWeight.w700)),
                  ]),
                ),
                SizedBox(
                  height: 58,
                  child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8), children: [for (final level in const ['All', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2']) Padding(padding: const EdgeInsetsDirectional.only(end: 7), child: ChoiceChip(selected: _level == level, onSelected: (_) => setState(() => _level = level), label: Text(level), labelStyle: const TextStyle(fontWeight: FontWeight.w900)))]),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                    itemCount: topics.length,
                    itemBuilder: (context, index) => _GrammarCard(topic: topics[index], examples: [for (var i = 0; i < 3; i++) verified[(index * 3 + i) % verified.length]]),
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
        'en' => 'English relies on relatively fixed word order, auxiliary verbs, articles, and tense/aspect combinations. Learn patterns inside complete phrases.',
        'ar' => 'Arabic uses a root-and-pattern system, grammatical gender, agreement, and right-to-left writing. Formal Arabic and spoken varieties should be labelled separately.',
        'es' => 'Spanish combines noun gender and agreement with rich verb conjugation. Subject pronouns can often be omitted because the verb ending carries information.',
        'fr' => 'French uses articles, gender, agreement, verb conjugation, liaison, and a major difference between written and naturally spoken forms.',
        'de' => 'German uses grammatical gender, four cases, separable verbs, and verb-position rules. Learn nouns together with their articles.',
        'tr' => 'Turkish is agglutinative: clear suffix chains express case, possession, tense, and person. Vowel harmony helps predict many forms.',
        'pt' => 'Portuguese uses gender, agreement, rich conjugation, and distinct spoken varieties. Pronunciation and pronoun placement vary by region.',
        'it' => 'Italian uses gender, agreement, articles, and expressive verb conjugation. Double consonants and stress can change meaning.',
        'ru' => 'Russian uses six cases, grammatical gender, verb aspect, and flexible word order. Endings show the role of each word.',
        'zh' => 'Mandarin Chinese uses tones, classifiers, particles, and word order rather than verb conjugation. Characters and pronunciation must be learned together.',
        'ja' => 'Japanese commonly uses subject–object–verb order, particles, counters, and politeness levels. Context often allows subjects to be omitted.',
        'ko' => 'Korean commonly uses subject–object–verb order, particles, speech levels, and honorifics. Verb endings express social relationship and sentence function.',
        _ => 'This course uses the $script writing system. Only aligned reviewed phrases are presented as target-language examples; broader grammar notes remain cross-language concepts until a specialist pack is installed.',
      };
}

class _GrammarCard extends StatelessWidget {
  const _GrammarCard({required this.topic, required this.examples});
  final GrammarTopic topic;
  final List<PhraseEntry> examples;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 11),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        leading: CircleAvatar(child: Text(topic.emoji)),
        title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('${topic.level} · Concept lesson'),
        children: [
          Align(alignment: AlignmentDirectional.centerStart, child: Text(topic.summary, style: const TextStyle(height: 1.55))),
          const SizedBox(height: 12),
          Align(alignment: AlignmentDirectional.centerStart, child: Text('Verified target-language examples', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900))),
          const SizedBox(height: 8),
          for (final example in examples)
            Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .45), borderRadius: BorderRadius.circular(14)), child: Row(children: [Text(example.visual, style: const TextStyle(fontSize: 24)), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(example.target, style: const TextStyle(fontWeight: FontWeight.w900)), Text(example.source, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11.5))]))])),
          const SizedBox(height: 4),
          Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.menu_book_rounded), label: const Text('Full explanation'))), const SizedBox(width: 8), Expanded(child: FilledButton.tonalIcon(onPressed: () {}, icon: const Icon(Icons.fitness_center_rounded), label: const Text('Practice')))]),
        ],
      ),
    );
  }
}
