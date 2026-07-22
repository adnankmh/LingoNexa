import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/course_repository.dart';
import '../data/global_content_repository.dart';
import '../data/language_catalog.dart';
import '../services/speech_service.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();
  final SpeechService _speech = SpeechService();
  final List<_LiveMessage> _messages = [];
  late final AnimationController _pulse;

  String _scenario = 'free_talk';
  String _persona = 'friendly';
  bool _listening = false;
  bool _focusMode = true;
  double _speechConfidence = .72;

  static const _scenarios = <String, IconData>{
    'free_talk': Icons.forum_rounded,
    'travel': Icons.flight_takeoff_rounded,
    'career': Icons.business_center_rounded,
    'cafe': Icons.local_cafe_rounded,
    'hotel': Icons.hotel_rounded,
    'health': Icons.health_and_safety_rounded,
  };

  static const _personas = <String, (String, String)>{
    'friendly': ('Nexa Mira', '🌟'),
    'professional': ('Nexa Alex', '🎓'),
    'travel_buddy': ('Nexa Rio', '🌍'),
  };

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    _speech.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final scheme = Theme.of(context).colorScheme;
    final persona = _personas[_persona]!;

    if (_messages.isEmpty) {
      final opening = _openingFor(language.code, state.locale.languageCode);
      _messages.add(
        _LiveMessage(
          text: opening.$1,
          translation: opening.$2,
          fromTutor: true,
          score: 100,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const _LiveDot(),
            const SizedBox(width: 9),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.text.get('nexa_live')),
                Text(
                  '${language.flag} ${language.nativeName} · ${context.text.get(_scenario)}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Focus view',
            onPressed: () => setState(() => _focusMode = !_focusMode),
            icon: Icon(
              _focusMode
                  ? Icons.fullscreen_exit_rounded
                  : Icons.fullscreen_rounded,
            ),
          ),
          IconButton(
            onPressed: _showSetup,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  height: _focusMode ? 230 : 118,
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(14, 4, 14, 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF063B94),
                        scheme.primary,
                        const Color(0xFF13BFC4),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: .25),
                        blurRadius: 28,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      const PositionedDirectional(
                        top: 15,
                        end: 17,
                        child: _StatusChip(
                          text: '24/7 · PRIVATE',
                          icon: Icons.lock_rounded,
                        ),
                      ),
                      PositionedDirectional(
                        bottom: 14,
                        start: 16,
                        child: _StatusChip(
                          text:
                              '${context.text.get('fluency_score')} ${_sessionScore()}%',
                          icon: Icons.graphic_eq_rounded,
                        ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pulse,
                              builder: (context, child) => Container(
                                width: _focusMode
                                    ? 112 + (_listening ? _pulse.value * 8 : 0)
                                    : 72,
                                height: _focusMode
                                    ? 112 + (_listening ? _pulse.value * 8 : 0)
                                    : 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: .16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: .65),
                                    width: 3,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  persona.$2,
                                  style: TextStyle(
                                    fontSize: _focusMode ? 55 : 34,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 18),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  persona.$1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: _focusMode ? 24 : 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  context.text.get(_persona),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (_focusMode) ...[
                                  const SizedBox(height: 12),
                                  _Waveform(
                                    active: _listening,
                                    animation: _pulse,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: .65),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.text.get('private_mode'),
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _MessageBubble(
                      message: _messages[index],
                      languageCode: language.code,
                      speech: _speech,
                      speechRate: state.speechRate,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: _listening
                            ? context.text.get('stop')
                            : context.text.get('speak_now'),
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: _listening
                                ? Colors.red
                                : scheme.tertiary,
                          ),
                          onPressed: () => _toggleListening(language.code),
                          icon: Icon(
                            _listening ? Icons.stop_rounded : Icons.mic_rounded,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: _listening
                                ? context.text.get('speak_now')
                                : context.text.get('write_reply'),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: _send,
                        icon: const Icon(Icons.arrow_upward_rounded),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleListening(String languageCode) async {
    if (_listening) {
      await _speech.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final started = await _speech.listen(
      languageCode: languageCode,
      onResult: (words, confidence) {
        if (!mounted) return;
        setState(() {
          _controller.text = words;
          _controller.selection = TextSelection.collapsed(offset: words.length);
          if (confidence > 0) _speechConfidence = confidence;
        });
      },
    );
    if (!mounted) return;
    setState(() => _listening = started);
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Microphone or speech recognition is not available on this device.',
          ),
        ),
      );
    }
  }

  Future<void> _send() async {
    final input = _controller.text.trim();
    if (input.isEmpty) return;
    if (_listening) await _speech.stopListening();
    if (!mounted) return;
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final score = _scoreFor(input);
    final reply = _replyFor(
      language.code,
      state.locale.languageCode,
      _messages.length,
    );
    setState(() {
      _listening = false;
      _messages.add(_LiveMessage(text: input, fromTutor: false, score: score));
      _messages.add(
        _LiveMessage(
          text: reply.$1,
          translation: reply.$2,
          fromTutor: true,
          score: score,
          correction: _feedbackFor(input, score),
        ),
      );
      _controller.clear();
    });
    final spoken = await _speech.speak(
      reply.$1,
      language.code,
      rate: state.speechRate,
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
    _scrollToEnd();
  }

  int _scoreFor(String input) {
    final words = input
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .length;
    final lengthScore = (48 + math.min(words, 12) * 4).clamp(48, 92);
    final speechBonus = (_speechConfidence * 8).round();
    return (lengthScore + speechBonus).clamp(52, 99).toInt();
  }

  String _feedbackFor(String input, int score) {
    if (input.split(RegExp(r'\s+')).length < 3) {
      return 'Build a complete thought: add who, what, and one useful detail.';
    }
    if (!RegExp(r'[.!?؟。]$').hasMatch(input)) {
      return 'Strong attempt. Add a clear ending and repeat once with steady rhythm.';
    }
    if (score >= 90) {
      return 'Natural length and confident delivery. Add a follow-up question to keep the exchange moving.';
    }
    return 'Good communication. Repeat once more, linking the words smoothly instead of pausing after each word.';
  }

  (String, String) _replyFor(
    String languageCode,
    String sourceLanguageCode,
    int turn,
  ) {
    final category = switch (_scenario) {
      'travel' => 'Travel',
      'career' => 'Work',
      'cafe' => 'Food',
      'hotel' => 'Hotel',
      'health' => 'Health',
      _ => 'Introductions',
    };
    final pool = GlobalContentRepository.phrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    ).where((item) => item.category == category).toList();
    if (pool.isNotEmpty) {
      final phrase = pool[(turn ~/ 2) % pool.length];
      return (phrase.target, phrase.source);
    }
    final verified = CourseRepository.verifiedStarterPhrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    );
    final phrase = verified[turn % verified.length];
    return (phrase.target, phrase.source);
  }

  (String, String) _openingFor(String languageCode, String sourceLanguageCode) {
    final phrases = GlobalContentRepository.phrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    );
    if (phrases.length >= 3) {
      return (
        '${phrases.first.target} ${phrases[2].target}',
        '${phrases.first.source} · ${phrases[2].source}',
      );
    }
    final verified = CourseRepository.verifiedStarterPhrasesFor(
      languageCode,
      sourceLanguageCode: sourceLanguageCode,
    );
    return (verified.first.target, verified.first.source);
  }

  int _sessionScore() {
    final scored = _messages.where((item) => !item.fromTutor).toList();
    if (scored.isEmpty) return 72;
    return scored.map((item) => item.score).reduce((a, b) => a + b) ~/
        scored.length;
  }

  void _scrollToEnd() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scroll.hasClients) {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });

  Future<void> _showSetup() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.text.get('choose_scenario'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final item in _scenarios.entries)
                      ChoiceChip(
                        avatar: Icon(item.value, size: 17),
                        label: Text(context.text.get(item.key)),
                        selected: _scenario == item.key,
                        onSelected: (_) {
                          setState(() => _scenario = item.key);
                          setSheetState(() {});
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                Text(
                  'Conversation personality',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 9),
                RadioGroup<String>(
                  groupValue: _persona,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _persona = value);
                      setSheetState(() {});
                    }
                  },
                  child: Column(
                    children: [
                      for (final item in _personas.entries)
                        RadioListTile<String>(
                          value: item.key,
                          title: Text(
                            '${item.value.$2} ${item.value.$1}',
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(context.text.get(item.key)),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    child: Text(context.text.get('start')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveMessage {
  const _LiveMessage({
    required this.text,
    required this.fromTutor,
    required this.score,
    this.translation,
    this.correction,
  });
  final String text;
  final bool fromTutor;
  final int score;
  final String? translation;
  final String? correction;
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.languageCode,
    required this.speech,
    required this.speechRate,
  });
  final _LiveMessage message;
  final String languageCode;
  final SpeechService speech;
  final double speechRate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: message.fromTutor
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 620),
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: message.fromTutor
              ? Theme.of(context).cardTheme.color
              : scheme.primary,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(21),
            topEnd: const Radius.circular(21),
            bottomStart: Radius.circular(message.fromTutor ? 6 : 21),
            bottomEnd: Radius.circular(message.fromTutor ? 21 : 6),
          ),
          border: message.fromTutor
              ? Border.all(color: Theme.of(context).dividerColor)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.fromTutor
                          ? scheme.onSurface
                          : scheme.onPrimary,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.5,
                    ),
                  ),
                ),
                if (message.fromTutor)
                  IconButton(
                    onPressed: () => speech.speak(
                      message.text,
                      languageCode,
                      rate: speechRate,
                    ),
                    icon: const Icon(Icons.volume_up_rounded),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            if (message.translation != null) ...[
              const SizedBox(height: 6),
              Text(
                message.translation!,
                style: TextStyle(
                  color: scheme.onSurfaceVariant,
                  fontSize: 11.5,
                  height: 1.4,
                ),
              ),
            ],
            if (message.correction != null) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: scheme.tertiaryContainer.withValues(alpha: .55),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.auto_fix_high_rounded,
                      color: scheme.tertiary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${context.text.get('correction')} · ${message.correction!}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${message.score}%',
                      style: TextStyle(
                        color: scheme.tertiary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LiveDot extends StatelessWidget {
  const _LiveDot();
  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(
      color: Colors.greenAccent.shade700,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(color: Colors.green.withValues(alpha: .45), blurRadius: 8),
      ],
    ),
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: .18),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 14),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

class _Waveform extends StatelessWidget {
  const _Waveform({required this.active, required this.animation});
  final bool active;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (context, _) => Row(
      children: [
        for (var i = 0; i < 8; i++)
          Container(
            width: 4,
            height: active
                ? 8 +
                      18 *
                          ((math.sin(animation.value * math.pi * 2 + i) + 1) /
                              2)
                : 7 + (i % 3) * 3,
            margin: const EdgeInsetsDirectional.only(end: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: active ? .95 : .48),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
      ],
    ),
  );
}
