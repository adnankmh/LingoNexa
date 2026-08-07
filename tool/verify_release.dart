import 'dart:io';

import 'package:lingonexa/data/academy_repository.dart';
import 'package:lingonexa/data/course_repository.dart';
import 'package:lingonexa/data/global_content_repository.dart';
import 'package:lingonexa/data/grammar_book_repository.dart';
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
  _require(
    AcademyRepository.collections.length == 6,
    'The academy collection contract is incomplete.',
  );
  final sampleUnit = CourseRepository.unitsFor('es').first;
  const interfaceLocales = [
    'ar',
    'en',
    'es',
    'fr',
    'de',
    'tr',
    'pt',
    'it',
    'ru',
    'zh',
    'ja',
    'ko',
  ];
  for (final locale in interfaceLocales) {
    final guide = AcademyRepository.guideFor(sampleUnit, locale);
    _require(
      guide.overview.length == 2 &&
          guide.objectives.length == 5 &&
          guide.learningSequence.length == 8 &&
          guide.commonMistakes.length == 4 &&
          guide.masteryChecklist.length == 6,
      'Incomplete academy guide for $locale.',
    );
    for (final key in const [
      'academy',
      'academy_subtitle',
      'deep_lessons_subtitle',
      'course_books_subtitle',
      'motion_lessons_subtitle',
      'listening_studio_subtitle',
      'reference_guides_subtitle',
      'exam_center_subtitle',
      'coverage_note',
    ]) {
      _require(
        AcademyRepository.text(locale, key) != key,
        'Missing academy localization for $locale: $key',
      );
    }
    final grammarCopy = GrammarBookRepository.copy(locale);
    _require(
      grammarCopy.ruleSteps.length == 8 &&
          grammarCopy.practiceSteps.length == 8 &&
          grammarCopy.answerSteps.length == 8,
      'Incomplete grammar book localization for $locale.',
    );
  }

  final lottieFiles = Directory('assets/lottie')
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .toList();
  _require(
    lottieFiles.length >= 15,
    'The motion library must include at least 15 Lottie assets.',
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
    '${AcademyRepository.collections.length} academy collections, '
    '$iconButtons described icon buttons.',
  );
}
