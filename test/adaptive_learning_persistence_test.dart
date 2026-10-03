import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/adaptive_learning_engine.dart';

void main() {
  group('adaptive learning persistence', () {
    test('round-trips review records without losing scheduling state', () {
      final nextReview = DateTime(2026, 10, 3, 9, 30);
      final records = {
        'lesson-42': ReviewRecord(
          lessonId: 'lesson-42',
          repetitions: 4,
          intervalDays: 14,
          ease: 2.35,
          nextReview: nextReview,
          lastQuality: 4,
          lapses: 2,
        ),
      };

      final decoded = AdaptiveLearningEngine.decode(
        AdaptiveLearningEngine.encode(records),
      );
      final restored = decoded['lesson-42'];

      expect(restored, isNotNull);
      expect(restored!.lessonId, 'lesson-42');
      expect(restored.repetitions, 4);
      expect(restored.intervalDays, 14);
      expect(restored.ease, 2.35);
      expect(restored.nextReview, nextReview);
      expect(restored.lastQuality, 4);
      expect(restored.lapses, 2);
    });

    test('treats malformed or incompatible payloads as empty state', () {
      expect(AdaptiveLearningEngine.decode(null), isEmpty);
      expect(AdaptiveLearningEngine.decode(''), isEmpty);
      expect(AdaptiveLearningEngine.decode('not-json'), isEmpty);
      expect(AdaptiveLearningEngine.decode('[]'), isEmpty);
      expect(
        AdaptiveLearningEngine.decode('{"lesson":{"lessonId":42}}'),
        isEmpty,
      );
    });

    test('keeps valid progress when a sibling record is corrupt', () {
      const payload = '''{
        "lesson-good": {
          "lessonId": "lesson-good",
          "repetitions": 3,
          "intervalDays": 7,
          "ease": 2.4,
          "nextReview": "2026-10-04T09:30:00.000Z",
          "lastQuality": 4,
          "lapses": 1
        },
        "lesson-bad": {"lessonId": 42}
      }''';

      final decoded = AdaptiveLearningEngine.decode(payload);

      expect(decoded.keys, ['lesson-good']);
      expect(decoded['lesson-good']!.repetitions, 3);
      expect(decoded['lesson-good']!.intervalDays, 7);
    });
  });
}
