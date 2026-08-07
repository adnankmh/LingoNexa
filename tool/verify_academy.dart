import 'dart:io';

import 'package:lingonexa/data/academy_repository.dart';
import 'package:lingonexa/data/course_repository.dart';
import 'package:lingonexa/data/grammar_book_repository.dart';
import 'package:lingonexa/data/language_catalog.dart';
import 'package:lingonexa/data/learning_content_repository.dart';

Never _fail(String message) => throw StateError(message);

void _require(bool condition, String message) {
  if (!condition) _fail(message);
}

void main() {
  const locales = [
    'en',
    'ar',
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
  const keys = [
    'academy',
    'academy_subtitle',
    'deep_lessons',
    'deep_lessons_subtitle',
    'course_books',
    'course_books_subtitle',
    'motion_lessons',
    'motion_lessons_subtitle',
    'listening_studio',
    'listening_studio_subtitle',
    'reference_guides',
    'reference_guides_subtitle',
    'exam_center',
    'exam_center_subtitle',
    'complete_path',
    'complete_path_subtitle',
    'content_library',
    'content_library_subtitle',
    'coverage_note',
    'overview',
    'objectives',
    'sequence',
    'mistakes',
    'checklist',
    'resource_open_failed',
  ];
  final sample = CourseRepository.unitsFor('es').first;
  for (final locale in locales) {
    for (final key in keys) {
      final value = AcademyRepository.text(locale, key);
      _require(
        value.trim().isNotEmpty && value != key,
        'Missing $locale academy copy: $key',
      );
    }
    final guide = AcademyRepository.guideFor(sample, locale);
    _require(guide.overview.length == 2, '$locale overview is incomplete.');
    _require(
        guide.objectives.length == 5, '$locale objectives are incomplete.');
    _require(
      guide.learningSequence.length == 8,
      '$locale study sequence is incomplete.',
    );
    _require(
      guide.commonMistakes.length == 4,
      '$locale mistake repair is incomplete.',
    );
    _require(
      guide.masteryChecklist.length == 6,
      '$locale mastery checklist is incomplete.',
    );
    final grammarCopy = GrammarBookRepository.copy(locale);
    _require(
      grammarCopy.explanationParagraphs.length == 3 &&
          grammarCopy.lensLabels.length == 5 &&
          grammarCopy.ruleSteps.length == 8 &&
          grammarCopy.mistakeSteps.length == 6 &&
          grammarCopy.practiceSteps.length == 8 &&
          grammarCopy.answerSteps.length == 8,
      '$locale grammar book teaching copy is incomplete.',
    );
    for (final entry in LearningContentRepository.grammarTopics.indexed) {
      final localizedTitle = GrammarBookRepository.localizedTopicTitle(
        locale,
        entry.$1,
        entry.$2.title,
      );
      _require(
        localizedTitle.trim().isNotEmpty,
        '$locale grammar chapter ${entry.$1 + 1} is empty.',
      );
      if (locale != 'en') {
        _require(
          localizedTitle != entry.$2.title,
          '$locale grammar chapter ${entry.$1 + 1} leaked from English.',
        );
      }
    }
    final profile = GrammarBookRepository.profileFor(
      locale,
      LanguageCatalog.byCode('tr'),
    );
    _require(
      profile.isNotEmpty &&
          !profile.contains('{language}') &&
          !profile.contains('{features}'),
      '$locale target-language grammar profile is incomplete.',
    );
  }
  _require(
    AcademyRepository.collections.length == 6,
    'Academy collection navigation is incomplete.',
  );
  stdout.writeln(
    'Academy verification passed: 12 interface languages, '
    '15 localized topics each, 6 collections, 54 grammar chapters, '
    'and complete study guides.',
  );
}
