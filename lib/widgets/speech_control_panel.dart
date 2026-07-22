import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../services/speech_service.dart';

class SpeechControlPanel extends StatefulWidget {
  const SpeechControlPanel({
    required this.languageCode,
    this.compact = false,
    super.key,
  });

  final String languageCode;
  final bool compact;

  @override
  State<SpeechControlPanel> createState() => _SpeechControlPanelState();
}

class _SpeechControlPanelState extends State<SpeechControlPanel> {
  final SpeechService _speech = SpeechService();
  late Future<List<SpeechVoice>> _voices;

  @override
  void initState() {
    super.initState();
    _voices = _speech.installedVoices(widget.languageCode);
  }

  @override
  void didUpdateWidget(covariant SpeechControlPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.languageCode != widget.languageCode) {
      _voices = _speech.installedVoices(widget.languageCode);
    }
  }

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(widget.languageCode);
    final percentage = ((state.speechRate - .25) / .35 * 100).round();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(widget.compact ? 13 : 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(language.flag)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.text.get('voice_and_speed'),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      Text(
                        '${context.text.get('speech_speed')} · $percentage%',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: context.text.get('tip_test_voice'),
                  onPressed: () => _testVoice(context, state),
                  icon: const Icon(Icons.play_arrow_rounded),
                ),
              ],
            ),
            Slider(
              value: state.speechRate,
              min: .25,
              max: .60,
              divisions: 14,
              label: '${state.speechRate.toStringAsFixed(2)}×',
              onChanged: state.setSpeechRate,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.text.get('slower'),
                  style: const TextStyle(fontSize: 11),
                ),
                Text(
                  '${state.speechRate.toStringAsFixed(2)}×',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  context.text.get('faster'),
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 9),
            FutureBuilder<List<SpeechVoice>>(
              future: _voices,
              builder: (context, snapshot) {
                final voices = snapshot.data ?? const <SpeechVoice>[];
                final selected = state.preferredVoiceFor(widget.languageCode);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(minHeight: 3);
                }
                if (voices.isEmpty) {
                  return Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.text.get('voice_not_installed'),
                          style: const TextStyle(fontSize: 11.5),
                        ),
                      ),
                    ],
                  );
                }
                return DropdownButtonFormField<String>(
                  initialValue: voices.any((voice) => voice.id == selected)
                      ? selected
                      : null,
                  decoration: InputDecoration(
                    labelText: context.text.get('choose_reader'),
                    prefixIcon: const Icon(Icons.record_voice_over_rounded),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: '',
                      child: Text(context.text.get('device_default_voice')),
                    ),
                    for (final voice in voices)
                      DropdownMenuItem(
                        value: voice.id,
                        child: Text(
                          '${voice.label} · ${voice.locale}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (value) => state.setPreferredVoice(
                    widget.languageCode,
                    value?.isEmpty == true ? null : value,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _testVoice(BuildContext context, AppState state) async {
    final language = LanguageCatalog.byCode(widget.languageCode);
    final sample = switch (widget.languageCode) {
      'ar' => 'مرحبًا بك في لينغو نكسا',
      'es' => 'Bienvenido a LingoNexa',
      'fr' => 'Bienvenue sur LingoNexa',
      'de' => 'Willkommen bei LingoNexa',
      'tr' => "LingoNexa'ya hoş geldiniz",
      _ => 'Welcome to LingoNexa',
    };
    final success = await _speech.speak(
      sample,
      widget.languageCode,
      rate: state.speechRate,
      voiceName: state.preferredVoiceFor(widget.languageCode),
    );
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${language.englishName}: ${context.text.get('voice_not_installed')}',
          ),
        ),
      );
    }
  }
}
