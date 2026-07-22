import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/course_repository.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../services/speech_service.dart';

class LevelExamScreen extends StatefulWidget {
  const LevelExamScreen({required this.level, super.key});
  final String level;

  @override
  State<LevelExamScreen> createState() => _LevelExamScreenState();
}

class _LevelExamScreenState extends State<LevelExamScreen> {
  final SpeechService _speech = SpeechService();
  List<LessonStep> _questions = const [];
  final Map<int, String> _answers = {};
  int _index = 0;
  bool _finished = false;
  int _score = 0;

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_questions.isNotEmpty) return;
    final state = AppStateScope.of(context);
    final code = state.targetLanguageCode;
    final seen = <String>{};
    _questions =
        CourseRepository.unitsFor(
              code,
              meaningLanguageCode: state.locale.languageCode,
            )
            .where((unit) => unit.level == widget.level)
            .expand((unit) => unit.lessons)
            .expand((lesson) => lesson.steps)
            .where(
              (step) =>
                  step.type == ExerciseType.choice &&
                  step.options.length >= 3 &&
                  seen.add(step.answer),
            )
            .take(12)
            .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    if (_finished) return _result(context, language);
    final question = _questions[_index];
    final selected = _answers[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level} Level Exam'),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 54),
            child: Center(
              child: Text(
                '${language.flag} ${_index + 1}/${_questions.length}',
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: (_index + 1) / _questions.length,
                      minHeight: 9,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        question.visual,
                        style: const TextStyle(fontSize: 72),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        tooltip: 'Hear the target-language question',
                        onPressed: () => _play(question.answer, language),
                        icon: const Icon(Icons.volume_up_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    question.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Expanded(
                    child: RadioGroup<String>(
                      groupValue: selected,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _answers[_index] = value);
                        }
                      },
                      child: ListView(
                        children: [
                          for (final option in question.options)
                            Card(
                              color: selected == option
                                  ? Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer
                                  : null,
                              child: RadioListTile<String>(
                                value: option,
                                title: Text(
                                  option,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: selected == null ? null : _next,
                      icon: Icon(
                        _index == _questions.length - 1
                            ? Icons.fact_check_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(
                        _index == _questions.length - 1
                            ? 'Finish exam'
                            : 'Next question',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _next() async {
    if (_index < _questions.length - 1) {
      setState(() => _index++);
      return;
    }
    var correct = 0;
    for (var index = 0; index < _questions.length; index++) {
      if (_answers[index] == _questions[index].answer) correct++;
    }
    _score = ((correct / _questions.length) * 100).round();
    await AppStateScope.of(context).completeLevelExam(widget.level, _score);
    if (mounted) setState(() => _finished = true);
  }

  Future<void> _play(String text, LanguageOption language) async {
    final spoken = await _speech.speak(
      text,
      language.code,
      rate: AppStateScope.of(context).speechRate,
    );
    if (!spoken && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${language.englishName} voice is not installed. English fallback is disabled.',
          ),
        ),
      );
    }
  }

  Widget _result(BuildContext context, LanguageOption language) {
    final passed = _score >= 70;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.level} Exam Result')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 190,
                    child: Lottie.asset(
                      passed
                          ? 'assets/lottie/celebration.json'
                          : 'assets/lottie/error.json',
                      repeat: true,
                    ),
                  ),
                  Text(
                    passed ? 'Level passed!' : 'Keep building your foundation',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${language.flag} ${widget.level} · $_score%',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    passed
                        ? 'Your next level is unlocked and your XP has been updated.'
                        : 'Review the exact phrases and try again. No wrong answer is added to your vocabulary.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Return to course'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
