import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/course_repository.dart';
import 'package:lingonexa/data/global_content_repository.dart';
import 'package:lingonexa/data/language_catalog.dart';
import 'package:lingonexa/data/learning_content_repository.dart';
import 'package:lingonexa/core/i18n.dart';
import 'package:lingonexa/services/speech_service.dart';

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
    expect(units.expand((unit) => unit.lessons).every((lesson) => lesson.steps.length >= 10), isTrue);
  });

  test('global content and interface localization are substantially expanded', () {
    expect(AppText.supported, hasLength(12));
    expect(GlobalContentRepository.concepts.length, greaterThanOrEqualTo(35));
    expect(GlobalContentRepository.localizedPhrasePairs, greaterThanOrEqualTo(420));
    expect(GlobalContentRepository.sentenceDrillCount, greaterThanOrEqualTo(1680));
    for (final code in GlobalContentRepository.coreLanguageCodes) {
      expect(GlobalContentRepository.phrasesFor(code), hasLength(GlobalContentRepository.concepts.length));
      expect(GlobalContentRepository.sentenceDrillsFor(code), hasLength(GlobalContentRepository.concepts.length * 4));
    }
    for (final concept in GlobalContentRepository.concepts) {
      expect(concept.translations.keys, containsAll(GlobalContentRepository.coreLanguageCodes), reason: concept.source);
      expect(concept.translations.values.every((value) => value.trim().isNotEmpty), isTrue, reason: concept.source);
    }
  });

  test('expanded learning studio covers goals, grammar, scripts, and phrases', () {
    expect(LearningContentRepository.specializedPaths, hasLength(8));
    expect(LearningContentRepository.grammarTopics.map((topic) => topic.level).toSet(), containsAll(['A1', 'A2', 'B1', 'B2', 'C1', 'C2']));
    expect(LearningContentRepository.alphabetSamples.length, greaterThanOrEqualTo(10));
    expect(LearningContentRepository.phrasesFor('ar'), isNotEmpty);
    expect(LearningContentRepository.phrasesFor('es'), isNotEmpty);
    expect(LearningContentRepository.phrasesFor('unknown'), isNotEmpty);
  });

  test('every catalog language has an explicit speech locale and aligned starter meanings', () {
    const meanings = ['Hello', 'Thank you', 'Please', 'Goodbye'];
    for (final language in LanguageCatalog.all) {
      expect(SpeechService.voiceLocale(language.code), isNot(language.code), reason: 'missing explicit locale for ${language.code}');
      final phrases = CourseRepository.verifiedStarterPhrasesFor(language.code);
      for (var index = 0; index < 4; index++) {
        expect(phrases[index].target, CourseRepository.starterLexicon[language.code]![index]);
        expect(phrases[index].source, meanings[index]);
      }
    }
  });

  test('non-core language content never falls back to English text', () {
    final welsh = LearningContentRepository.phrasesFor('cy');
    expect(welsh.take(4).map((item) => item.target), CourseRepository.starterLexicon['cy']);
    expect(welsh.any((item) => item.target == 'Hello'), isFalse);
  });

  test('lesson flashcards keep target text and exact meaning in one aligned record', () {
    for (final code in ['ar', 'es', 'de', 'ja', 'cy', 'sw']) {
      final aligned = {for (final item in CourseRepository.verifiedStarterPhrasesFor(code)) item.target: item.source};
      for (final lesson in CourseRepository.unitsFor(code).expand((unit) => unit.lessons)) {
        final flashcard = lesson.steps.first;
        expect(aligned[flashcard.prompt], flashcard.answer, reason: '$code ${lesson.id}');
      }
    }
  });

  test('meaning language follows interface locale instead of always using English', () {
    final spanishForArabicUi = GlobalContentRepository.phrasesFor('es', sourceLanguageCode: 'ar');
    expect(spanishForArabicUi.first.target, '¿Cómo estás?');
    expect(spanishForArabicUi.first.source, 'كيف حالك؟');
    final completeSpanishForArabicUi = LearningContentRepository.phrasesFor('es', sourceLanguageCode: 'ar');
    expect(completeSpanishForArabicUi.any((item) => item.source == 'Hello'), isFalse);
    final arabicCourseForSpanishUi = CourseRepository.unitsFor('ar', meaningLanguageCode: 'es');
    expect(arabicCourseForSpanishUi.first.lessons.first.steps.first.prompt, 'مرحبًا');
    expect(arabicCourseForSpanishUi.first.lessons.first.steps.first.answer, 'Hola');
  });
}
