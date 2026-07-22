import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../models/models.dart';
import '../services/speech_service.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final SpeechService _speech = SpeechService();
  final TextEditingController _answerController = TextEditingController();
  int _stepIndex = 0;
  String? _selectedAnswer;
  final List<String> _arranged = [];
  bool _revealed = false;
  bool _checked = false;
  bool _correct = false;
  bool _listening = false;
  String _recognizedSpeech = '';
  List<LessonStep> _steps = const [];

  LessonStep get _step => _steps[_stepIndex];

  @override
  void initState() {
    super.initState();
    _answerController.addListener(_refreshAnswerState);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_steps.isNotEmpty) return;
    final all = widget.lesson.steps;
    _steps = AppStateScope.of(context).sprintMode && all.length >= 10
        ? [all[0], all[1], all[2], all[4], all[5], all[9]]
        : all;
  }

  void _refreshAnswerState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _answerController.removeListener(_refreshAnswerState);
    _speech.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final target = LanguageCatalog.byCode(state.targetLanguageCode);
    final progress = (_stepIndex + 1) / _steps.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: context.text.get('tip_close'),
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(value: progress, minHeight: 10),
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 54),
            child: Center(
              child: Text(
                '${target.flag} ${_stepIndex + 1}/${_steps.length}',
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
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween(
                              begin: const Offset(.06, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        ),
                        child: _StepBody(
                          key: ValueKey(_stepIndex),
                          step: _step,
                          targetCode: target.code,
                          selectedAnswer: _selectedAnswer,
                          arranged: _arranged,
                          revealed: _revealed,
                          listening: _listening,
                          recognizedSpeech: _recognizedSpeech,
                          answerController: _answerController,
                          onSelect: (value) =>
                              setState(() => _selectedAnswer = value),
                          onArrange: (value) =>
                              setState(() => _arranged.add(value)),
                          onRemoveArranged: (value) =>
                              setState(() => _arranged.remove(value)),
                          onReveal: () => setState(() => _revealed = true),
                          onSpeak: () => _speakOrWarn(
                            _step.type == ExerciseType.flashcard
                                ? _step.prompt
                                : _step.answer,
                            target.code,
                          ),
                          onListen: _toggleListening,
                        ),
                      ),
                    ),
                  ),
                  if (_checked) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: (_correct ? Colors.green : Colors.orange)
                            .withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 54,
                            height: 54,
                            child: Lottie.asset(
                              _correct
                                  ? 'assets/lottie/celebration.json'
                                  : 'assets/lottie/error.json',
                              repeat: true,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              _correct
                                  ? context.text.get('correct')
                                  : '${context.text.get('try_again')} · ${_step.answer}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  FilledButton(
                    onPressed: _canCheck ? (_checked ? _next : _check) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _checked
                              ? context.text.get('next')
                              : context.text.get('check'),
                        ),
                        const SizedBox(width: 7),
                        Icon(
                          _checked
                              ? Icons.arrow_forward_rounded
                              : Icons.check_rounded,
                        ),
                      ],
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

  bool get _canCheck {
    if (_step.type == ExerciseType.flashcard) return _revealed;
    if (_step.type == ExerciseType.arrange) return _arranged.isNotEmpty;
    if (_step.type == ExerciseType.speaking) {
      return _recognizedSpeech.isNotEmpty || _revealed;
    }
    if (_step.type == ExerciseType.fillBlank) {
      return _answerController.text.trim().isNotEmpty;
    }
    if (_step.type == ExerciseType.culture) return true;
    return _selectedAnswer != null;
  }

  void _check() {
    final expected = _normalize(_step.answer);
    final submitted = switch (_step.type) {
      ExerciseType.flashcard || ExerciseType.culture => expected,
      ExerciseType.arrange => _normalize(_arranged.join(' ')),
      ExerciseType.speaking =>
        _recognizedSpeech.isEmpty ? expected : _normalize(_recognizedSpeech),
      ExerciseType.fillBlank => _normalize(_answerController.text),
      ExerciseType.choice ||
      ExerciseType.listening => _normalize(_selectedAnswer ?? ''),
    };
    setState(() {
      _checked = true;
      _correct =
          submitted == expected ||
          (_step.type == ExerciseType.speaking &&
              _similarity(submitted, expected) >= .55);
    });
    SystemSound.play(_correct ? SystemSoundType.click : SystemSoundType.alert);
  }

  Future<void> _next() async {
    if (_stepIndex == _steps.length - 1) {
      await AppStateScope.of(context).completeLesson(widget.lesson.id);
      if (mounted) await _showCompletion();
      return;
    }
    setState(() {
      _stepIndex++;
      _selectedAnswer = null;
      _arranged.clear();
      _answerController.clear();
      _revealed = false;
      _checked = false;
      _correct = false;
      _recognizedSpeech = '';
      _listening = false;
    });
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await _speech.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    final started = await _speech.listen(
      languageCode: AppStateScope.of(context).targetLanguageCode,
      onResult: (words, confidence) {
        if (mounted) {
          setState(() {
            _recognizedSpeech = words;
            if (words.isNotEmpty) _revealed = true;
          });
        }
      },
    );
    if (!started && mounted) {
      setState(() {
        _listening = false;
        _revealed = true;
        _recognizedSpeech = _step.answer;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Speech recognition is unavailable on this device. Practice mode enabled.',
          ),
        ),
      );
    }
  }

  Future<void> _speakOrWarn(String text, String languageCode) async {
    final spoken = await _speech.speak(
      text,
      languageCode,
      rate: AppStateScope.of(context).speechRate,
      voiceName: AppStateScope.of(context).preferredVoiceFor(languageCode),
    );
    if (!spoken && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('voice_not_installed'))),
      );
    }
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'''[.,!?،؛:;"'“”‘’…()\[\]{}_-]+'''), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  double _similarity(String a, String b) {
    if (a.isEmpty || b.isEmpty) return 0;
    final aWords = a.split(' ').toSet();
    final bWords = b.split(' ').toSet();
    return aWords.intersection(bWords).length /
        math.max(aWords.length, bWords.length);
  }

  Future<void> _showCompletion() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 180,
              child: Lottie.asset(
                'assets/lottie/celebration.json',
                repeat: true,
              ),
            ),
            Text(
              context.text.get('completed'),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              '+${AppStateScope.of(context).lessonXp} XP · Review scheduled',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: Text(context.text.get('continue')),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.step,
    required this.targetCode,
    required this.selectedAnswer,
    required this.arranged,
    required this.revealed,
    required this.listening,
    required this.recognizedSpeech,
    required this.answerController,
    required this.onSelect,
    required this.onArrange,
    required this.onRemoveArranged,
    required this.onReveal,
    required this.onSpeak,
    required this.onListen,
    super.key,
  });

  final LessonStep step;
  final String targetCode;
  final String? selectedAnswer;
  final List<String> arranged;
  final bool revealed;
  final bool listening;
  final String recognizedSpeech;
  final TextEditingController answerController;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onArrange;
  final ValueChanged<String> onRemoveArranged;
  final VoidCallback onReveal;
  final VoidCallback onSpeak;
  final VoidCallback onListen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _label(step.type),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Center(
          child: Text(
            step.visual,
            style: const TextStyle(fontSize: 58),
            semanticsLabel: 'Meaning illustration',
          ),
        ),
        const SizedBox(height: 10),
        Text(
          step.prompt,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.25,
          ),
        ),
        if (step.hint.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            step.hint,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 30),
        _content(context),
      ],
    );
  }

  Widget _content(BuildContext context) {
    switch (step.type) {
      case ExerciseType.choice:
      case ExerciseType.listening:
        return Column(
          children: [
            if (step.type == ExerciseType.listening) ...[
              Center(child: _AudioButton(onTap: onSpeak)),
              const SizedBox(height: 24),
            ],
            for (final option in step.options)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _AnswerOption(
                  text: option,
                  selected: selectedAnswer == option,
                  onTap: () => onSelect(option),
                ),
              ),
          ],
        );
      case ExerciseType.flashcard:
        return Center(
          child: InkWell(
            onTap: onReveal,
            borderRadius: BorderRadius.circular(28),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 250),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primaryContainer,
                    Theme.of(context).colorScheme.tertiaryContainer,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    step.prompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    revealed
                        ? step.translation
                        : 'Tap to reveal the exact meaning',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  IconButton.filledTonal(
                    tooltip: context.text.get('tip_speak'),
                    onPressed: onSpeak,
                    icon: const Icon(Icons.volume_up_rounded),
                  ),
                ],
              ),
            ),
          ),
        );
      case ExerciseType.arrange:
        return Column(
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 90),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final word in arranged)
                    InputChip(
                      label: Text(word),
                      onDeleted: () => onRemoveArranged(word),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 9,
              runSpacing: 9,
              children: [
                for (final word in step.options)
                  if (!arranged.contains(word))
                    ActionChip(
                      label: Text(word),
                      onPressed: () => onArrange(word),
                    ),
              ],
            ),
          ],
        );
      case ExerciseType.speaking:
        return Center(
          child: Column(
            children: [
              Text(
                step.answer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                ),
              ),
              if (step.translation.isNotEmpty)
                Text(
                  step.translation,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              const SizedBox(height: 22),
              Tooltip(
                message: context.text.get('tip_record'),
                child: GestureDetector(
                  onTap: onListen,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    width: listening ? 106 : 92,
                    height: listening ? 106 : 92,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: .35),
                          blurRadius: listening ? 32 : 18,
                          spreadRadius: listening ? 8 : 2,
                        ),
                      ],
                    ),
                    child: listening
                        ? Icon(
                            Icons.stop_rounded,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 40,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(12),
                            child: Lottie.asset(
                              'assets/lottie/speaking.json',
                              repeat: true,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                recognizedSpeech.isEmpty ? 'Tap and speak' : recognizedSpeech,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onReveal,
                child: const Text(
                  'Microphone unavailable? Continue in practice mode',
                ),
              ),
            ],
          ),
        );
      case ExerciseType.fillBlank:
        return TextField(
          controller: answerController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.edit_rounded),
            hintText: 'Type your answer',
          ),
        );
      case ExerciseType.culture:
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              const Text('🌍', style: TextStyle(fontSize: 54)),
              const SizedBox(height: 12),
              Text(
                step.translation,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.55,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
    }
  }

  String _label(ExerciseType type) => switch (type) {
    ExerciseType.choice => 'MEANING',
    ExerciseType.arrange => 'BUILD',
    ExerciseType.listening => 'LISTEN',
    ExerciseType.speaking => 'SPEAK',
    ExerciseType.flashcard => 'DISCOVER',
    ExerciseType.fillBlank => 'RECALL',
    ExerciseType.culture => 'CULTURE NOTE',
  };
}

class _AnswerOption extends StatelessWidget {
  const _AnswerOption({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: selected
          ? scheme.primaryContainer
          : Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
        side: BorderSide(
          color: selected ? scheme.primary : Theme.of(context).dividerColor,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: scheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioButton extends StatelessWidget {
  const _AudioButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: context.text.get('tip_speak'),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 94,
          height: 94,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Lottie.asset('assets/lottie/listening.json', repeat: true),
          ),
        ),
      ),
    );
  }
}
