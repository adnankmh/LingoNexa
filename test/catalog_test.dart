import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/course_repository.dart';
import 'package:lingonexa/data/language_catalog.dart';
import 'package:lingonexa/data/learning_content_repository.dart';

void main() {
  test('catalog includes more than fifty distinct languages', () {
    expect(LanguageCatalog.all.length, greaterThanOrEqualTo(50));
    expect(LanguageCatalog.all.map((item) => item.code).toSet().length, LanguageCatalog.all.length);
  });

  test('every catalog language has a starter lexicon', () {
    for (final language in LanguageCatalog.all) {
      expect(CourseRepository.starterLexicon[language.code], isNotNull, reason: language.code);
      expect(CourseRepository.starterLexicon[language.code], hasLength(4), reason: language.code);
    }
  });

  test('course engine creates six levels and 180 lesson nodes', () {
    final units = CourseRepository.unitsFor('es');
    expect(units, hasLength(36));
    expect(units.expand((unit) => unit.lessons), hasLength(180));
    expect(units.expand((unit) => unit.lessons).expand((lesson) => lesson.steps).every((step) => step.answer.isNotEmpty), isTrue);
  });

  test('expanded learning studio covers goals, grammar, scripts, and phrases', () {
    expect(LearningContentRepository.specializedPaths, hasLength(8));
    expect(LearningContentRepository.grammarTopics.map((topic) => topic.level).toSet(), containsAll(['A1', 'A2', 'B1', 'B2', 'C1', 'C2']));
    expect(LearningContentRepository.alphabetSamples.length, greaterThanOrEqualTo(10));
    expect(LearningContentRepository.phrasesFor('ar'), isNotEmpty);
    expect(LearningContentRepository.phrasesFor('es'), isNotEmpty);
    expect(LearningContentRepository.phrasesFor('unknown'), isNotEmpty);
  });
}
