import 'package:flutter_test/flutter_test.dart';
import 'package:lingonexa/data/adaptive_learning_engine.dart';

void main() {
  test('adaptive scheduler expands strong recall intervals', () {
    final start = DateTime(2026, 8, 10, 9);
    var record = AdaptiveLearningEngine.firstReview('lesson-1', now: start);
    expect(record.intervalDays, 1);
    const expected = [1, 3, 7, 14, 30, 60];
    for (final interval in expected) {
      record = AdaptiveLearningEngine.grade(record, 5, now: start);
      expect(record.intervalDays, interval);
    }
    expect(record.repetitions, 6);
    expect(record.lapses, 0);
  });

  test('a failed recall returns to one day and records a lapse', () {
    final start = DateTime(2026, 8, 10, 9);
    var record = AdaptiveLearningEngine.firstReview('lesson-2', now: start);
    record = AdaptiveLearningEngine.grade(record, 5, now: start);
    record = AdaptiveLearningEngine.grade(record, 5, now: start);
    expect(record.intervalDays, 3);
    record = AdaptiveLearningEngine.grade(record, 1, now: start);
    expect(record.intervalDays, 1);
    expect(record.repetitions, 0);
    expect(record.lapses, 1);
  });

  test('review records survive local serialization', () {
    final source = {
      'lesson-3': AdaptiveLearningEngine.firstReview(
        'lesson-3',
        now: DateTime(2026, 8, 10, 9),
      ),
    };
    final decoded = AdaptiveLearningEngine.decode(
      AdaptiveLearningEngine.encode(source),
    );
    expect(decoded.keys, source.keys);
    expect(decoded['lesson-3']!.intervalDays, 1);
  });

  test('review queue prioritises due lapses then fills upcoming cards', () {
    final now = DateTime(2026, 10, 1, 12);
    final records = [
      ReviewRecord(
        lessonId: 'upcoming',
        repetitions: 2,
        intervalDays: 3,
        ease: 2.5,
        nextReview: now.add(const Duration(days: 1)),
        lastQuality: 5,
        lapses: 0,
      ),
      ReviewRecord(
        lessonId: 'due-stable',
        repetitions: 4,
        intervalDays: 14,
        ease: 2.5,
        nextReview: now.subtract(const Duration(days: 3)),
        lastQuality: 5,
        lapses: 0,
      ),
      ReviewRecord(
        lessonId: 'due-struggling',
        repetitions: 0,
        intervalDays: 1,
        ease: 1.7,
        nextReview: now.subtract(const Duration(days: 1)),
        lastQuality: 1,
        lapses: 3,
      ),
    ];

    final queue = AdaptiveLearningEngine.reviewQueue(records, now: now);
    expect(
      queue.map((record) => record.lessonId),
      ['due-struggling', 'due-stable', 'upcoming'],
    );
    expect(AdaptiveLearningEngine.dueCount(records, now: now), 2);
  });

  test('review queue respects session limit and deterministic tie breaking', () {
    final now = DateTime(2026, 10, 1, 12);
    final sameDate = now.subtract(const Duration(hours: 1));
    final records = [
      for (final id in ['c', 'a', 'b'])
        ReviewRecord(
          lessonId: id,
          repetitions: 1,
          intervalDays: 1,
          ease: 2.5,
          nextReview: sameDate,
          lastQuality: 4,
          lapses: 0,
        ),
    ];

    final queue = AdaptiveLearningEngine.reviewQueue(
      records,
      now: now,
      limit: 2,
    );
    expect(queue.map((record) => record.lessonId), ['a', 'b']);
    expect(
      AdaptiveLearningEngine.reviewQueue(records, now: now, limit: 0),
      isEmpty,
    );
  });
}
