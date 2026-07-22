import 'dart:io';

import 'package:lingonexa/data/global_content_repository.dart';
import 'package:lingonexa/data/learning_content_repository.dart';

Never _fail(String message) => throw StateError(message);

void _require(bool condition, String message) {
  if (!condition) _fail(message);
}

void main() {
  _require(
    GlobalContentRepository.concepts.length >= 84,
    'The aligned concept bank is smaller than the 1.6 release contract.',
  );
  _require(
    GlobalContentRepository.localizedPhrasePairs >= 1008,
    'The localized phrase-pair count is below the release contract.',
  );
  _require(
    GlobalContentRepository.sentenceDrillCount >= 4032,
    'The sentence-drill count is below the release contract.',
  );

  final sources = <String>{};
  for (final concept in GlobalContentRepository.concepts) {
    _require(
      sources.add(concept.source),
      'Duplicate concept: ${concept.source}',
    );
    _require(
      concept.category.trim().isNotEmpty,
      'Missing category: ${concept.source}',
    );
    _require(
      concept.translations.keys.toSet().containsAll(
        GlobalContentRepository.coreLanguageCodes,
      ),
      'Missing core translation: ${concept.source}',
    );
    _require(
      concept.translations.values.every((text) => text.trim().isNotEmpty),
      'Empty translation: ${concept.source}',
    );
  }

  for (final code in GlobalContentRepository.coreLanguageCodes) {
    final phrases = GlobalContentRepository.phrasesFor(code);
    _require(
      phrases.length == GlobalContentRepository.concepts.length,
      'Phrase alignment failed for $code.',
    );
    _require(
      phrases.map((item) => item.target.toLowerCase()).toSet().length ==
          phrases.length,
      'Duplicate target phrase found for $code.',
    );
  }

  _require(
    LearningContentRepository.categories.length >= 34,
    'Not enough real-world learning categories.',
  );
  _require(
    LearningContentRepository.specializedPaths.length >= 28,
    'Not enough specialized paths.',
  );
  _require(
    LearningContentRepository.grammarTopics.length >= 54,
    'Not enough grammar masterclasses.',
  );
  _require(
    LearningContentRepository.grammarTopics
        .map((topic) => topic.level)
        .toSet()
        .containsAll(const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']),
    'Grammar coverage does not include every CEFR level.',
  );

  final screenSource = Directory('lib/screens')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .map((file) => file.readAsStringSync())
      .join('\n');
  final iconButtons = RegExp(
    r'IconButton(?:\.filledTonal|\.filled|\.outlined)?\(',
  ).allMatches(screenSource).length;
  final describedIconButtons = RegExp(
    r'IconButton(?:\.filledTonal|\.filled|\.outlined)?\([\s\S]{0,260}?tooltip:',
  ).allMatches(screenSource).length;
  _require(
    describedIconButtons == iconButtons,
    '$describedIconButtons of $iconButtons icon buttons have tooltips.',
  );

  stdout.writeln(
    'Release verification passed: '
    '${GlobalContentRepository.concepts.length} concepts, '
    '${GlobalContentRepository.localizedPhrasePairs} localized pairs, '
    '${LearningContentRepository.grammarTopics.length} grammar lessons, '
    '${LearningContentRepository.specializedPaths.length} scenario paths, '
    '$iconButtons described icon buttons.',
  );
}
