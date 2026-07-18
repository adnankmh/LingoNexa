import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';

class LearningPlanScreen extends StatefulWidget {
  const LearningPlanScreen({super.key});

  @override
  State<LearningPlanScreen> createState() => _LearningPlanScreenState();
}

class _LearningPlanScreenState extends State<LearningPlanScreen> {
  final Set<int> _finished = {0, 1};

  static const _days = [
    ('MON', 'Core lesson', 'Vocabulary + recall', Icons.school_rounded),
    ('TUE', 'Listening lab', 'Short audio + shadowing', Icons.headphones_rounded),
    ('WED', 'Grammar focus', 'One pattern in context', Icons.account_tree_rounded),
    ('THU', 'Speak aloud', 'Pronunciation + role-play', Icons.mic_rounded),
    ('FRI', 'Story mode', 'Read, listen, and choose', Icons.auto_stories_rounded),
    ('SAT', 'Culture day', 'Article + useful expressions', Icons.public_rounded),
    ('SUN', 'Weekly review', 'Mistakes + spaced recall', Icons.autorenew_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final progress = _finished.length / _days.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Learning Plan')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(21),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary]),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${language.flag} ${state.learningReason} plan · ${state.currentLevel}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 21)),
                    const SizedBox(height: 6),
                    Text('${state.dailyGoalMinutes} minutes a day · adaptive weekly mix', style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 17),
                    ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: progress, minHeight: 9, backgroundColor: Colors.white24, color: Colors.white)),
                    const SizedBox(height: 7),
                    Text('${_finished.length}/${_days.length} sessions complete', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12)),
                  ]),
                ),
                const SizedBox(height: 18),
                Text('This week', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 9),
                for (var index = 0; index < _days.length; index++)
                  Card(
                    child: CheckboxListTile(
                      value: _finished.contains(index),
                      onChanged: (value) => setState(() => value == true ? _finished.add(index) : _finished.remove(index)),
                      secondary: CircleAvatar(child: Icon(_days[index].$4, size: 20)),
                      title: Text('${_days[index].$1} · ${_days[index].$2}', style: const TextStyle(fontWeight: FontWeight.w900)),
                      subtitle: Text(_days[index].$3),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ),
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: const ListTile(
                    leading: Icon(Icons.auto_awesome_rounded),
                    title: Text('Coach insight', style: TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text('Short daily sessions outperform one long session. Review difficult items before adding new vocabulary.'),
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
