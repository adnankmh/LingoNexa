import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../models/models.dart';
import '../services/speech_service.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({super.key});

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  final SpeechService _speech = SpeechService();
  String _category = 'All';
  String _query = '';
  final Set<String> _favorites = {};

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final phrases = LearningContentRepository.phrasesFor(language.code, sourceLanguageCode: state.locale.languageCode).where((phrase) {
      final categoryMatch = _category == 'All' || phrase.category == _category;
      final q = _query.toLowerCase().trim();
      final queryMatch = q.isEmpty || phrase.source.toLowerCase().contains(q) || phrase.target.toLowerCase().contains(q);
      return categoryMatch && queryMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Phrasebook & Dictionary'), actions: [Padding(padding: const EdgeInsetsDirectional.only(end: 16), child: Center(child: Text('${language.flag} ${language.nativeName}', style: const TextStyle(fontWeight: FontWeight.w800))))]),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(prefixIcon: Icon(Icons.search_rounded), hintText: 'Search words and phrases…')),
                ),
                SizedBox(
                  height: 52,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final category in ['All', ...LearningContentRepository.categories])
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 7),
                          child: ChoiceChip(selected: _category == category, onSelected: (_) => setState(() => _category = category), label: Text(category), labelStyle: const TextStyle(fontWeight: FontWeight.w800)),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: phrases.isEmpty
                      ? const Center(child: Text('No phrases match this filter.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                          itemCount: phrases.length,
                          itemBuilder: (context, index) => _PhraseCard(
                            phrase: phrases[index],
                            favorite: _favorites.contains(phrases[index].target),
                            onFavorite: () => setState(() {
                              if (!_favorites.add(phrases[index].target)) _favorites.remove(phrases[index].target);
                            }),
                            onSpeak: () async {
                              final spoken = await _speech.speak(phrases[index].target, language.code, rate: state.speechRate);
                              if (!spoken && context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${language.englishName} voice is not installed. No English fallback was used.')));
                            },
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
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({required this.phrase, required this.favorite, required this.onFavorite, required this.onSpeak});
  final PhraseEntry phrase;
  final bool favorite;
  final VoidCallback onFavorite;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(children: [Text(phrase.visual, style: const TextStyle(fontSize: 31)), const SizedBox(height: 5), IconButton.filledTonal(onPressed: onSpeak, icon: const Icon(Icons.volume_up_rounded))]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(phrase.target, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(phrase.source, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                  if (phrase.pronunciation.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('/${phrase.pronunciation}/', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 12)),
                  ],
                  const SizedBox(height: 6),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)), child: Text(phrase.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800))),
                ],
              ),
            ),
            IconButton(onPressed: onFavorite, icon: Icon(favorite ? Icons.bookmark_rounded : Icons.bookmark_border_rounded, color: favorite ? Theme.of(context).colorScheme.primary : null)),
          ],
        ),
      ),
    );
  }
}
