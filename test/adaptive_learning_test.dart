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
}
