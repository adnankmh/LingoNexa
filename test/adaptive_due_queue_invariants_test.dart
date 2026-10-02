import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/adaptive_learning_engine.dart';

void main() {
  group('dueReviewQueue invariants', () {
    test('does not mutate caller-owned records', () {
      final now = DateTime(2026, 10, 2, 10);
      final records = [
        ReviewRecord(
          lessonId: 'later-due',
          repetitions: 2,
          intervalDays: 3,
          ease: 2.3,
          nextReview: now.subtract(const Duration(minutes: 10)),
          lastQuality: 4,
          lapses: 0,
        ),
        ReviewRecord(
          lessonId: 'struggling',
          repetitions: 0,
          intervalDays: 1,
          ease: 1.6,
          nextReview: now.subtract(const Duration(hours: 2)),
          lastQuality: 1,
          lapses: 4,
        ),
      ];
      final originalOrder = records.map((record) => record.lessonId).toList();

      final queue = AdaptiveLearningEngine.dueReviewQueue(records, now: now);

      expect(queue.map((record) => record.lessonId), ['struggling', 'later-due']);
      expect(records.map((record) => record.lessonId), originalOrder);
    });

    test('applies limit after excluding future records', () {
      final now = DateTime(2026, 10, 2, 10);
      final records = [
        ReviewRecord(
          lessonId: 'future',
          repetitions: 5,
          intervalDays: 30,
          ease: 2.8,
          nextReview: now.add(const Duration(seconds: 1)),
          lastQuality: 5,
          lapses: 0,
        ),
        ReviewRecord(
          lessonId: 'due-a',
          repetitions: 1,
          intervalDays: 1,
          ease: 2.1,
          nextReview: now.subtract(const Duration(minutes: 5)),
          lastQuality: 3,
          lapses: 1,
        ),
        ReviewRecord(
          lessonId: 'due-b',
          repetitions: 1,
          intervalDays: 1,
          ease: 2.1,
          nextReview: now.subtract(const Duration(minutes: 15)),
          lastQuality: 3,
          lapses: 1,
        ),
      ];

      final queue = AdaptiveLearningEngine.dueReviewQueue(
        records,
        now: now,
        limit: 1,
      );

      expect(queue, hasLength(1));
      expect(queue.single.lessonId, 'due-b');
      expect(queue.single.nextReview.isAfter(now), isFalse);
    });
  });
}
