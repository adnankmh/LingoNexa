import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/course_repository.dart';

class PlacementTestScreen extends StatefulWidget {
  const PlacementTestScreen({super.key});

  @override
  State<PlacementTestScreen> createState() => _PlacementTestScreenState();
}

class _PlacementTestScreenState extends State<PlacementTestScreen> {
  int _index = 0;
  int _score = 0;
  String? _selected;

  static const _prompts = [
    'Hello',
    'Thank you',
    'Please',
    'Goodbye',
    'Hello',
    'Thank you',
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final lexicon =
        CourseRepository.starterLexicon[state.targetLanguageCode] ??
        CourseRepository.starterLexicon['en']!;
    final correctIndex = _index % lexicon.length;
    final options = [...lexicon]..shuffle();
    return Scaffold(
      appBar: AppBar(title: const Text('Placement check')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: (_index + 1) / _prompts.length,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    'Choose the expression for:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '“${_prompts[_index]}”',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final option in options)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: OutlinedButton(
                              onPressed: () =>
                                  setState(() => _selected = option),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _selected == option
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.primaryContainer
                                    : null,
                                side: BorderSide(
                                  color: _selected == option
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).dividerColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: _selected == null
                        ? null
                        : () => _advance(lexicon[correctIndex]),
                    child: const Text('Check and continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _advance(String answer) async {
    if (_selected == answer) _score++;
    if (_index < _prompts.length - 1) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    final level = _score >= 5 ? 'A2' : 'A1';
    await AppStateScope.of(context).setCurrentLevel(level);
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your starting point: $level'),
        content: Text(
          'You answered $_score of ${_prompts.length} correctly. Your path has been adjusted and can be changed later.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Open my path'),
          ),
        ],
      ),
    );
    if (mounted) Navigator.pop(context);
  }
}
