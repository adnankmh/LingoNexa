import 'dart:io';

import 'package:flutter/widgets.dart';
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
    expect(
      LanguageCatalog.all.map((item) => item.code).toSet().length,
      LanguageCatalog.all.length,
    );
  });

  test('every catalog language has a starter lexicon', () {
    for (final language in LanguageCatalog.all) {
      expect(
        CourseRepository.starterLexicon[language.code],
        isNotNull,
        reason: language.code,
      );
      expect(
        CourseRepository.starterLexicon[language.code],
        hasLength(4),
        reason: language.code,
      );
    }
  });

  test('course engine creates six levels and 450 rich lesson nodes', () {
    final units = CourseRepository.unitsFor('es');
    expect(units, hasLength(90));
    expect(units.expand((unit) => unit.lessons), hasLength(450));
    expect(
      units
          .expand((unit) => unit.lessons)
          .expand((lesson) => lesson.steps)
          .every((step) => step.answer.isNotEmpty),
      isTrue,
    );
    expect(
      units
          .expand((unit) => unit.lessons)
          .every((lesson) => lesson.steps.length >= 10),
      isTrue,
    );
    expect(
      units
          .expand((unit) => unit.lessons)
          .every(
            (lesson) =>
                lesson.steps.map((step) => step.answer).toSet().length >= 3,
          ),
      isTrue,
    );
  });

  test(
    'global content and interface localization are substantially expanded',
    () {
      expect(AppText.supported, hasLength(12));
      expect(GlobalContentRepository.concepts.length, greaterThanOrEqualTo(84));
      expect(
        GlobalContentRepository.localizedPhrasePairs,
        greaterThanOrEqualTo(1008),
      );
      expect(
        GlobalContentRepository.sentenceDrillCount,
        greaterThanOrEqualTo(4032),
      );
      for (final code in GlobalContentRepository.coreLanguageCodes) {
        expect(
          GlobalContentRepository.phrasesFor(code),
          hasLength(GlobalContentRepository.concepts.length),
        );
        expect(
          GlobalContentRepository.sentenceDrillsFor(code),
          hasLength(GlobalContentRepository.concepts.length * 4),
        );
      }
      for (final concept in GlobalContentRepository.concepts) {
        expect(
          concept.translations.keys,
          containsAll(GlobalContentRepository.coreLanguageCodes),
          reason: concept.source,
        );
        expect(
          concept.translations.values.every((value) => value.trim().isNotEmpty),
          isTrue,
          reason: concept.source,
        );
      }
    },
  );

  test(
    'expanded learning studio covers goals, grammar, scripts, and phrases',
    () {
      expect(LearningContentRepository.specializedPaths, hasLength(28));
      expect(
        LearningContentRepository.categories.length,
        greaterThanOrEqualTo(34),
      );
      expect(
        LearningContentRepository.grammarTopics.length,
        greaterThanOrEqualTo(54),
      );
      expect(
        LearningContentRepository.grammarTopics
            .map((topic) => topic.level)
            .toSet(),
        containsAll(['A1', 'A2', 'B1', 'B2', 'C1', 'C2']),
      );
      expect(
        LearningContentRepository.alphabetSamples.length,
        greaterThanOrEqualTo(10),
      );
      expect(LearningContentRepository.phrasesFor('ar'), isNotEmpty);
      expect(LearningContentRepository.phrasesFor('es'), isNotEmpty);
      expect(LearningContentRepository.phrasesFor('unknown'), isNotEmpty);
    },
  );

  test(
    'new learning hub and translator labels are localized in every UI pack',
    () {
      const keys = [
        'learning_center',
        'full_explanation',
        'words_examples',
        'exams',
        'translator',
        'instant_translator',
        'voice_and_speed',
        'choose_reader',
        'unit_exam',
        'open_complete_unit',
        'offline_ready',
        'community_subtitle',
        'league',
        'certificate_title',
        'certificate_level',
        'finish_exam',
        'exam_result',
        'report_post',
        'room_preview_note',
      ];
      final english = AppText(const Locale('en'));
      for (final locale in AppText.supported) {
        final text = AppText(Locale(locale.code));
        for (final key in keys) {
          expect(text.get(key), isNot(key), reason: '${locale.code}: $key');
          if (locale.code != 'en') {
            expect(
              text.get(key),
              isNot(english.get(key)),
              reason: '${locale.code} falls back to English for $key',
            );
          }
        }
      }
    },
  );

  test('translator returns only aligned verified meanings', () {
    final result = GlobalContentRepository.translateExact(
      'أحتاج إلى مساعدة فورًا.',
      sourceLanguageCode: 'ar',
      targetLanguageCode: 'es',
    );
    expect(result, isNotNull);
    expect(result!.target, 'Necesito ayuda de inmediato.');
    expect(
      GlobalContentRepository.translateExact(
        'unverified free text',
        sourceLanguageCode: 'en',
        targetLanguageCode: 'ar',
      ),
      isNull,
    );
  });

  test('every actionable icon has a clear tooltip', () {
    final source = Directory('lib/screens')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .map((file) => file.readAsStringSync())
        .join('\n');
    final buttons = RegExp(
      r'IconButton(?:\.filledTonal|\.filled|\.outlined)?\(',
    ).allMatches(source).length;
    final described = RegExp(
      r'IconButton(?:\.filledTonal|\.filled|\.outlined)?\([\s\S]{0,260}?tooltip:',
    ).allMatches(source).length;
    expect(described, buttons, reason: 'Every icon action needs a tooltip.');

    for (final locale in AppText.supported) {
      final text = AppText(Locale(locale.code));
      expect(text.get('tip_speak'), isNot('tip_speak'));
      expect(text.get('tip_theme'), isNot('tip_theme'));
    }
  });

  test(
    'every catalog language has an explicit speech locale and aligned starter meanings',
    () {
      const meanings = ['Hello', 'Thank you', 'Please', 'Goodbye'];
      for (final language in LanguageCatalog.all) {
        expect(
          SpeechService.voiceLocale(language.code),
          isNot(language.code),
          reason: 'missing explicit locale for ${language.code}',
        );
        final phrases = CourseRepository.verifiedStarterPhrasesFor(
          language.code,
        );
        for (var index = 0; index < 4; index++) {
          expect(
            phrases[index].target,
            CourseRepository.starterLexicon[language.code]![index],
          );
          expect(phrases[index].source, meanings[index]);
        }
      }
    },
  );

  test('non-core language content never falls back to English text', () {
    final welsh = LearningContentRepository.phrasesFor('cy');
    expect(
      welsh.take(4).map((item) => item.target),
      CourseRepository.starterLexicon['cy'],
    );
    expect(welsh.any((item) => item.target == 'Hello'), isFalse);
  });

  test(
    'lesson flashcards keep target text and exact meaning in one aligned record',
    () {
      for (final code in ['ar', 'es', 'de', 'ja', 'cy', 'sw']) {
        final aligned = {
          for (final item in CourseRepository.verifiedStarterPhrasesFor(code))
            item.target: item.source,
        };
        for (final lesson in CourseRepository.unitsFor(
          code,
        ).expand((unit) => unit.lessons)) {
          final flashcard = lesson.steps.first;
          expect(
            aligned[flashcard.prompt],
            flashcard.answer,
            reason: '$code ${lesson.id}',
          );
        }
      }
    },
  );

  test(
    'meaning language follows interface locale instead of always using English',
    () {
      final spanishForArabicUi = GlobalContentRepository.phrasesFor(
        'es',
        sourceLanguageCode: 'ar',
      );
      expect(spanishForArabicUi.first.target, '¿Cómo estás?');
      expect(spanishForArabicUi.first.source, 'كيف حالك؟');
      final completeSpanishForArabicUi = LearningContentRepository.phrasesFor(
        'es',
        sourceLanguageCode: 'ar',
      );
      expect(
        completeSpanishForArabicUi.any((item) => item.source == 'Hello'),
        isFalse,
      );
      final arabicCourseForSpanishUi = CourseRepository.unitsFor(
        'ar',
        meaningLanguageCode: 'es',
      );
      expect(
        arabicCourseForSpanishUi.first.lessons.first.steps.first.prompt,
        'كيف حالك؟',
      );
      expect(
        arabicCourseForSpanishUi.first.lessons.first.steps.first.answer,
        '¿Cómo estás?',
      );
    },
  );
}
