import 'dart:convert';

class ReviewRecord {
  const ReviewRecord({
    required this.lessonId,
    required this.repetitions,
    required this.intervalDays,
    required this.ease,
    required this.nextReview,
    required this.lastQuality,
    required this.lapses,
  });

  final String lessonId;
  final int repetitions;
  final int intervalDays;
  final double ease;
  final DateTime nextReview;
  final int lastQuality;
  final int lapses;

  bool isDueAt(DateTime now) => !nextReview.isAfter(now);

  Map<String, Object> toJson() => {
        'lessonId': lessonId,
        'repetitions': repetitions,
        'intervalDays': intervalDays,
        'ease': ease,
        'nextReview': nextReview.toUtc().toIso8601String(),
        'lastQuality': lastQuality,
        'lapses': lapses,
      };

  static ReviewRecord fromJson(Map<String, Object?> json) => ReviewRecord(
        lessonId: json['lessonId']! as String,
        repetitions: json['repetitions']! as int,
        intervalDays: json['intervalDays']! as int,
        ease: (json['ease']! as num).toDouble(),
        nextReview: DateTime.parse(json['nextReview']! as String).toLocal(),
        lastQuality: json['lastQuality']! as int,
        lapses: json['lapses']! as int,
      );
}

/// A compact SM-2-inspired scheduler. It is deterministic, offline friendly,
/// and keeps the learning decision explainable to the learner.
abstract final class AdaptiveLearningEngine {
  static ReviewRecord firstReview(String lessonId, {DateTime? now}) {
    final timestamp = now ?? DateTime.now();
    return ReviewRecord(
      lessonId: lessonId,
      repetitions: 0,
      intervalDays: 1,
      ease: 2.5,
      nextReview: timestamp.add(const Duration(days: 1)),
      lastQuality: 0,
      lapses: 0,
    );
  }

  static ReviewRecord grade(
    ReviewRecord current,
    int quality, {
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    final score = quality.clamp(0, 5);
    if (score < 3) {
      return ReviewRecord(
        lessonId: current.lessonId,
        repetitions: 0,
        intervalDays: 1,
        ease: (current.ease - .2).clamp(1.3, 3.0),
        nextReview: timestamp.add(const Duration(days: 1)),
        lastQuality: score,
        lapses: current.lapses + 1,
      );
    }

    final repetitions = current.repetitions + 1;
    final interval = switch (repetitions) {
      1 => 1,
      2 => 3,
      3 => 7,
      4 => 14,
      5 => 30,
      6 => 60,
      _ => (current.intervalDays * current.ease).round().clamp(60, 180),
    };
    final easeDelta = .1 - (5 - score) * (.08 + (5 - score) * .02);
    final ease = (current.ease + easeDelta).clamp(1.3, 3.0).toDouble();
    return ReviewRecord(
      lessonId: current.lessonId,
      repetitions: repetitions,
      intervalDays: interval,
      ease: ease,
      nextReview: timestamp.add(Duration(days: interval)),
      lastQuality: score,
      lapses: current.lapses,
    );
  }

  static String encode(Map<String, ReviewRecord> records) => jsonEncode({
        for (final entry in records.entries) entry.key: entry.value.toJson(),
      });

  static Map<String, ReviewRecord> decode(String? value) {
    if (value == null || value.trim().isEmpty) return {};
    try {
      final decoded = jsonDecode(value);
      if (decoded is! Map) return {};
      return {
        for (final entry in decoded.entries)
          if (entry.key is String && entry.value is Map)
            entry.key as String: ReviewRecord.fromJson(
              Map<String, Object?>.from(entry.value as Map),
            ),
      };
    } catch (_) {
      return {};
    }
  }
}
