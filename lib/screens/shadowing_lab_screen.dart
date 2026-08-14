import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/learning_content_repository.dart';
import '../data/language_catalog.dart';
import '../data/product_copy_repository.dart';
import '../models/models.dart';
import '../services/speech_service.dart';
import '../widgets/ui.dart';

class ShadowingLabScreen extends StatefulWidget {
  const ShadowingLabScreen({super.key});

  @override
  State<ShadowingLabScreen> createState() => _ShadowingLabScreenState();
}

class _ShadowingLabScreenState extends State<ShadowingLabScreen> {
  final SpeechService _speech = SpeechService();
  int _index = 0;
  bool _listening = false;
  String _recognized = '';
  int _score = 0;
  bool _scoredCurrentPhrase = false;

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final phrases = LearningContentRepository.phrasesFor(
      language.code,
      sourceLanguageCode: locale,
    );
    final available = phrases.isEmpty
        ? const <PhraseEntry>[]
        : phrases.take(math.min(phrases.length, 24)).toList();
    final phrase =
        available.isEmpty ? null : available[_index % available.length];
    String copy(String key) => ProductCopyRepository.text(locale, key);

    return Scaffold(
      appBar: AppBar(title: Text(copy('shadowing'))),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 46),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1A2A6C),
                    Color(0xFF6B46D9),
                    Color(0xFF13A6A1)
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${language.flag} ${language.nativeName}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 22),
                        ),
                        const SizedBox(height: 7),
                        Text(copy('shadowing_sub'),
                            style: const TextStyle(
                                color: Colors.white70, height: 1.45)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 92,
                    height: 92,
                    child: Lottie.asset(
                      'assets/lottie/shadowing_wave.json',
                      errorBuilder: (_, __, ___) => const Icon(
                          Icons.graphic_eq_rounded,
                          color: Colors.white,
                          size: 58),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            if (phrase == null)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                      'This starter pack does not yet contain a reviewed shadowing set.'),
                ),
              )
            else ...[
              Row(
                children: [
                  for (final step in [
                    copy('listen'),
                    copy('record'),
                    copy('compare')
                  ])
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withValues(alpha: .55),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(step,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 11)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Text(copy('try_phrase'),
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      const SizedBox(height: 12),
                      Text(
                        phrase.target,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w900,
                            height: 1.35),
                      ),
                      const SizedBox(height: 9),
                      Text(phrase.source,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontSize: 15)),
                      const SizedBox(height: 20),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.tonalIcon(
                            onPressed: () =>
                                _play(phrase.target, language.code, state),
                            icon: const Icon(Icons.volume_up_rounded),
                            label: Text(copy('listen')),
                          ),
                          FilledButton.icon(
                            onPressed: () =>
                                _toggleRecording(phrase, language.code, state),
                            style: FilledButton.styleFrom(
                                backgroundColor:
                                    _listening ? Colors.red : null),
                            icon: Icon(_listening
                                ? Icons.stop_rounded
                                : Icons.mic_rounded),
                            label: Text(_listening
                                ? context.text.get('stop')
                                : copy('record')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_recognized.isNotEmpty) ...[
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(copy('compare'),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17))),
                            CircleAvatar(
                              backgroundColor: _score >= 75
                                  ? const Color(0xFF0E9F79)
                                  : Colors.orange,
                              child: Text('$_score',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(_recognized,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                              value: _score / 100, minHeight: 10),
                        ),
                        const SizedBox(height: 7),
                        Text('${copy('pronunciation_score')}: $_score%',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _index == 0 ? null : () => _changePhrase(-1),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: Text(context.text.get('previous')),
                  ),
                  const Spacer(),
                  Text('${_index + 1}/${available.length}',
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => _changePhrase(1, count: available.length),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: Text(context.text.get('next')),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _play(String text, String languageCode, AppState state) async {
    final success = await _speech.speak(
      text,
      languageCode,
      rate: state.speechRate,
      voiceName: state.preferredVoiceFor(languageCode),
    );
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('voice_not_installed'))),
      );
    }
  }

  Future<void> _toggleRecording(
      PhraseEntry phrase, String languageCode, AppState state) async {
    if (_listening) {
      await _speech.stopListening();
      if (mounted) setState(() => _listening = false);
      return;
    }
    final started = await _speech.listen(
      languageCode: languageCode,
      onResult: (words, confidence) {
        if (!mounted) return;
        final score = _similarityScore(phrase.target, words, confidence);
        setState(() {
          _recognized = words;
          _score = score;
        });
        if (!_scoredCurrentPhrase && words.trim().isNotEmpty) {
          _scoredCurrentPhrase = true;
          state.recordSkillPractice('speaking', score);
        }
      },
    );
    if (!mounted) return;
    if (!started) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.text.get('voice_not_installed'))),
      );
      return;
    }
    setState(() => _listening = true);
  }

  void _changePhrase(int delta, {int? count}) {
    setState(() {
      _index = (_index + delta).clamp(0, (count ?? _index + 1) - 1);
      _recognized = '';
      _score = 0;
      _scoredCurrentPhrase = false;
      _listening = false;
    });
  }

  static int _similarityScore(
      String expected, String spoken, double confidence) {
    final left = _normalize(expected);
    final right = _normalize(spoken);
    if (left.isEmpty || right.isEmpty) return 0;
    final distance = _levenshtein(left, right);
    final textScore =
        (1 - distance / math.max(left.length, right.length)).clamp(0, 1);
    final confidenceWeight =
        confidence > 0 ? confidence.clamp(0, 1) : textScore;
    return ((textScore * .82 + confidenceWeight * .18) * 100)
        .round()
        .clamp(0, 100);
  }

  static String _normalize(String value) => value
      .toLowerCase()
      .replaceAll(RegExp(r'''[\s.,!?¿¡،。！？；;:：«»"'’ـ-]'''), '');

  static int _levenshtein(String left, String right) {
    var previous = List<int>.generate(right.length + 1, (index) => index);
    for (var i = 1; i <= left.length; i++) {
      final current = <int>[i];
      for (var j = 1; j <= right.length; j++) {
        final cost = left.codeUnitAt(i - 1) == right.codeUnitAt(j - 1) ? 0 : 1;
        current.add(math.min(math.min(current[j - 1] + 1, previous[j] + 1),
            previous[j - 1] + cost));
      }
      previous = current;
    }
    return previous.last;
  }
}
