import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/learning_content_repository.dart';
import '../data/language_catalog.dart';
import '../services/speech_service.dart';
import '../widgets/ui.dart';

class SentenceLabScreen extends StatefulWidget {
  const SentenceLabScreen({super.key});

  @override
  State<SentenceLabScreen> createState() => _SentenceLabScreenState();
}

class _SentenceLabScreenState extends State<SentenceLabScreen> {
  final SpeechService _speech = SpeechService();
  final Set<String> _mastered = {};
  String _category = 'All';
  String _query = '';

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final all = LearningContentRepository.sentenceDrillsFor(language.code,
        sourceLanguageCode: state.locale.languageCode);
    final categories = <String>{for (final item in all) item.category}.toList()
      ..sort();
    final items = all.where((item) {
      final q = _query.trim().toLowerCase();
      return (_category == 'All' || item.category == _category) &&
          (q.isEmpty ||
              item.target.toLowerCase().contains(q) ||
              item.source.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(context.text.get('sentence_lab')), actions: [
        Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
                child: Text('${language.flag} ${language.nativeName}',
                    style: const TextStyle(fontWeight: FontWeight.w800))))
      ]),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: GradientPanel(
                    padding: const EdgeInsets.all(18),
                    child: Row(children: [
                      const Text('🧠', style: TextStyle(fontSize: 44)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                                '${all.length} ${context.text.get('practice_sentences')}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 19)),
                            const SizedBox(height: 4),
                            const Text(
                                'Recognition · active recall · natural rhythm · real-world transfer',
                                style: TextStyle(
                                    color: Colors.white70, height: 1.35)),
                          ])),
                      Text('${_mastered.length}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 26)),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                      onChanged: (value) => setState(() => _query = value),
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: context.text.get('search'))),
                ),
                SizedBox(
                  height: 55,
                  child: ListView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final category in ['All', ...categories])
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 7),
                          child: ChoiceChip(
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                            label: Text(category == 'All'
                                ? context.text.get('all')
                                : category),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 30),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final key = '${item.target}|${item.mission}';
                      final mastered = _mastered.contains(key);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(children: [
                            Column(children: [
                              Text(item.visual,
                                  style: const TextStyle(fontSize: 30)),
                              IconButton.filledTonal(
                                  onPressed: () async {
                                    final spoken = await _speech.speak(
                                        item.target, language.code,
                                        rate: state.speechRate);
                                    if (!spoken && context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  '${language.englishName} voice is not installed.')));
                                    }
                                  },
                                  icon: const Icon(Icons.volume_up_rounded))
                            ]),
                            const SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                  Text(item.target,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17)),
                                  const SizedBox(height: 4),
                                  Text(item.source,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant)),
                                  const SizedBox(height: 7),
                                  Text(item.mission,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 11)),
                                ])),
                            IconButton(
                                onPressed: () => setState(() {
                                      if (!_mastered.add(key)) {
                                        _mastered.remove(key);
                                      }
                                    }),
                                icon: Icon(
                                    mastered
                                        ? Icons.check_circle_rounded
                                        : Icons.radio_button_unchecked_rounded,
                                    color: mastered
                                        ? Theme.of(context).colorScheme.primary
                                        : null)),
                          ]),
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
}
