import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/course_repository.dart';
import 'package:lingonexa/data/language_catalog.dart';

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
}

