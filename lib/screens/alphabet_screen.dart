import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../services/speech_service.dart';

class AlphabetScreen extends StatefulWidget {
  const AlphabetScreen({super.key});

  @override
  State<AlphabetScreen> createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final List<Offset?> _points = [];
  final SpeechService _speech = SpeechService();

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final sample =
        LearningContentRepository.alphabetSamples[language.script] ??
        LearningContentRepository.alphabetSamples['Latin']!;
    final characters = sample.split(' ').where((item) => item != '·').toList();
    return Scaffold(
      appBar: AppBar(title: Text('${language.flag} Script & Alphabet Lab')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.tertiaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language.script,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap characters, listen repeatedly, then trace them in the practice pad. Master recognition before speed.',
                        style: TextStyle(height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Character map',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final character in characters)
                      ActionChip(
                        onPressed: () => _characterDialog(character),
                        label: Text(
                          character,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Writing practice',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => setState(_points.clear),
                      icon: const Icon(Icons.delete_sweep_outlined),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 300,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: GestureDetector(
                    onPanStart: (details) =>
                        setState(() => _points.add(details.localPosition)),
                    onPanUpdate: (details) =>
                        setState(() => _points.add(details.localPosition)),
                    onPanEnd: (_) => setState(() => _points.add(null)),
                    child: CustomPaint(
                      painter: _TracePainter(
                        points: _points,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _characterDialog(String character) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            character,
            style: const TextStyle(fontSize: 82, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          const Text(
            'Observe the shape, direction, and position. Audio mapping can be supplied by the language content pack.',
          ),
          const SizedBox(height: 14),
          IconButton.filledTonal(
            tooltip: context.text.get('tip_speak'),
            onPressed: () async {
              final state = AppStateScope.of(context);
              final success = await _speech.speak(
                character,
                state.targetLanguageCode,
                rate: state.speechRate,
                voiceName: state.preferredVoiceFor(state.targetLanguageCode),
              );
              if (!success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.text.get('voice_not_installed')),
                  ),
                );
              }
            },
            icon: const Icon(Icons.volume_up_rounded),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Practice'),
        ),
      ],
    ),
  );
}

class _TracePainter extends CustomPainter {
  _TracePainter({required this.points, required this.color});
  final List<Offset?> points;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = color.withValues(alpha: .08)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      grid,
    );
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      grid,
    );
    final ink = Paint()
      ..color = color
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (var i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, ink);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TracePainter oldDelegate) => true;
}
