enum TextFlow { leftToRight, rightToLeft }

enum ExerciseType {
  choice,
  arrange,
  listening,
  speaking,
  flashcard,
  fillBlank,
  culture,
}

class LanguageOption {
  const LanguageOption({
    required this.code,
    required this.englishName,
    required this.nativeName,
    required this.flag,
    required this.script,
    this.flow = TextFlow.leftToRight,
  });

  final String code;
  final String englishName;
  final String nativeName;
  final String flag;
  final String script;
  final TextFlow flow;
}

class LearningLevel {
  const LearningLevel({
    required this.code,
    required this.title,
    required this.description,
    required this.colorValue,
  });

  final String code;
  final String title;
  final String description;
  final int colorValue;
}

class LessonStep {
  const LessonStep({
    required this.type,
    required this.prompt,
    required this.answer,
    this.options = const [],
    this.hint = '',
    this.translation = '',
    this.visual = '🗣️',
  });

  final ExerciseType type;
  final String prompt;
  final String answer;
  final List<String> options;
  final String hint;
  final String translation;
  final String visual;
}

class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.durationMinutes,
    required this.steps,
    this.isPremium = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int durationMinutes;
  final List<LessonStep> steps;
  final bool isPremium;
}

class CourseUnit {
  const CourseUnit({
    required this.id,
    required this.level,
    required this.title,
    required this.description,
    required this.emoji,
    required this.lessons,
  });

  final String id;
  final String level;
  final String title;
  final String description;
  final String emoji;
  final List<Lesson> lessons;
}

class CultureArticle {
  const CultureArticle({
    required this.title,
    required this.summary,
    required this.readMinutes,
    required this.emoji,
    required this.category,
  });

  final String title;
  final String summary;
  final int readMinutes;
  final String emoji;
  final String category;
}

class CommunityPost {
  const CommunityPost({
    required this.author,
    required this.nativeLanguage,
    required this.learningLanguage,
    required this.text,
    required this.avatar,
    required this.likes,
    required this.comments,
    this.correctedText,
  });

  final String author;
  final String nativeLanguage;
  final String learningLanguage;
  final String text;
  final String avatar;
  final int likes;
  final int comments;
  final String? correctedText;
}

class PhraseEntry {
  const PhraseEntry({
    required this.source,
    required this.target,
    required this.category,
    this.pronunciation = '',
    this.note = '',
    this.visual = '🗣️',
  });

  final String source;
  final String target;
  final String category;
  final String pronunciation;
  final String note;
  final String visual;
}

class GrammarTopic {
  const GrammarTopic({
    required this.title,
    required this.level,
    required this.summary,
    required this.examples,
    required this.emoji,
    this.explanation = '',
    this.keyRules = const [],
    this.commonMistakes = const [],
    this.practicePrompts = const [],
  });

  final String title;
  final String level;
  final String summary;
  final List<String> examples;
  final String emoji;
  final String explanation;
  final List<String> keyRules;
  final List<String> commonMistakes;
  final List<String> practicePrompts;
}

class SpecializedPath {
  const SpecializedPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.modules,
    required this.colorValue,
  });

  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final int modules;
  final int colorValue;
}

class Achievement {
  const Achievement({
    required this.title,
    required this.description,
    required this.emoji,
    required this.goal,
    required this.progress,
  });

  final String title;
  final String description;
  final String emoji;
  final int goal;
  final int progress;
}
