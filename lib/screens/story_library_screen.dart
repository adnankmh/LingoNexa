import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../models/models.dart';
import '../services/speech_service.dart';

class StoryLibraryScreen extends StatefulWidget {
  const StoryLibraryScreen({super.key});

  @override
  State<StoryLibraryScreen> createState() => _StoryLibraryScreenState();
}

class _StoryLibraryScreenState extends State<StoryLibraryScreen> {
  String _level = 'A1';

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final stories = _storiesFor(language.code, _level, state.locale.languageCode);
    return Scaffold(
      appBar: AppBar(title: const Text('Verified Dialogue Stories'), actions: [Padding(padding: const EdgeInsetsDirectional.only(end: 54), child: Center(child: Text(language.flag, style: const TextStyle(fontSize: 24))))]),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: Column(children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(18, 10, 18, 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .55), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [const Text('📚', style: TextStyle(fontSize: 42)), const SizedBox(width: 12), Expanded(child: Text('Every dialogue line is taken from the same verified phrase record as its meaning and target-language audio. No automatic prose translation is invented.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4, fontWeight: FontWeight.w700)))]),
              ),
              SizedBox(
                height: 55,
                child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7), children: [for (final level in CourseRepository.levels) Padding(padding: const EdgeInsetsDirectional.only(end: 7), child: ChoiceChip(selected: _level == level.code, onSelected: (_) => setState(() => _level = level.code), label: Text(level.code, style: const TextStyle(fontWeight: FontWeight.w900))))]),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                  itemCount: stories.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 440, childAspectRatio: MediaQuery.sizeOf(context).width < 500 ? 2.15 : 2.35, mainAxisSpacing: 10, crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return Card(child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _StoryReader(story: story, language: language))), borderRadius: BorderRadius.circular(24), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Text(story.emoji, style: const TextStyle(fontSize: 45)), const SizedBox(width: 13), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(story.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), const SizedBox(height: 5), Text('${story.lines.length} verified lines · $_level', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11.5)), const SizedBox(height: 7), LinearProgressIndicator(value: (index + 1) / stories.length, minHeight: 5)])), const Icon(Icons.arrow_forward_ios_rounded, size: 15)]))));
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  List<_DialogueStory> _storiesFor(String languageCode, String level, String sourceLanguageCode) {
    final phrases = LearningContentRepository.phrasesFor(languageCode, sourceLanguageCode: sourceLanguageCode);
    const titles = [
      ('First conversation', '👋'), ('At the station', '🚆'), ('A quick meal', '🍽️'), ('Checking in', '🏨'),
      ('A busy workday', '💼'), ('Getting help', '🆘'),
    ];
    final levelIndex = CourseRepository.levels.indexWhere((item) => item.code == level);
    return [
      for (var storyIndex = 0; storyIndex < titles.length; storyIndex++)
        _DialogueStory(
          title: '${titles[storyIndex].$1} · ${storyIndex + 1}',
          emoji: titles[storyIndex].$2,
          level: level,
          lines: [
            for (var lineIndex = 0; lineIndex < 6; lineIndex++)
              phrases[(levelIndex * 7 + storyIndex * 3 + lineIndex) % phrases.length],
          ],
        ),
    ];
  }
}

class _DialogueStory {
  const _DialogueStory({required this.title, required this.emoji, required this.level, required this.lines});
  final String title;
  final String emoji;
  final String level;
  final List<PhraseEntry> lines;
}

class _StoryReader extends StatefulWidget {
  const _StoryReader({required this.story, required this.language});
  final _DialogueStory story;
  final LanguageOption language;

  @override
  State<_StoryReader> createState() => _StoryReaderState();
}

class _StoryReaderState extends State<_StoryReader> {
  final SpeechService _speech = SpeechService();

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.story.title), actions: [Padding(padding: const EdgeInsetsDirectional.only(end: 54), child: Center(child: Text(widget.language.flag, style: const TextStyle(fontSize: 23))))]),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 35),
          itemCount: widget.story.lines.length,
          itemBuilder: (context, index) {
            final line = widget.story.lines[index];
            return Align(
              alignment: index.isEven ? AlignmentDirectional.centerStart : AlignmentDirectional.centerEnd,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 650),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: index.isEven ? Theme.of(context).cardTheme.color : Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(22), border: Border.all(color: Theme.of(context).dividerColor)),
                child: Row(children: [
                  Text(line.visual, style: const TextStyle(fontSize: 34)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(line.target, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)), const SizedBox(height: 5), Text(line.source, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))])),
                  IconButton.filledTonal(onPressed: () => _play(line.target), icon: const Icon(Icons.volume_up_rounded)),
                ]),
              ),
            );
          },
        ),
      );

  Future<void> _play(String text) async {
    final spoken = await _speech.speak(text, widget.language.code, rate: AppStateScope.of(context).speechRate);
    if (!spoken && mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${widget.language.englishName} voice is not installed.')));
  }
}
