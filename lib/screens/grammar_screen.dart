import 'package:flutter/material.dart';

import '../data/learning_content_repository.dart';
import '../models/models.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  String _level = 'All';

  @override
  Widget build(BuildContext context) {
    final topics = LearningContentRepository.grammarTopics.where((topic) => _level == 'All' || topic.level == _level).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Atlas')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                SizedBox(
                  height: 58,
                  child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8), children: [for (final level in const ['All', 'A1', 'A2', 'B1', 'B2', 'C1', 'C2']) Padding(padding: const EdgeInsetsDirectional.only(end: 7), child: ChoiceChip(selected: _level == level, onSelected: (_) => setState(() => _level = level), label: Text(level), labelStyle: const TextStyle(fontWeight: FontWeight.w900)))]),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
                    itemCount: topics.length,
                    itemBuilder: (context, index) => _GrammarCard(topic: topics[index]),
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

class _GrammarCard extends StatelessWidget {
  const _GrammarCard({required this.topic});
  final GrammarTopic topic;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 11),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 6),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        leading: CircleAvatar(child: Text(topic.emoji)),
        title: Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('${topic.level} · Concept lesson'),
        children: [
          Align(alignment: AlignmentDirectional.centerStart, child: Text(topic.summary, style: const TextStyle(height: 1.55))),
          const SizedBox(height: 12),
          for (final example in topic.examples)
            Container(width: double.infinity, margin: const EdgeInsets.only(bottom: 7), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: .45), borderRadius: BorderRadius.circular(14)), child: Text(example, style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(height: 4),
          Row(children: [Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.menu_book_rounded), label: const Text('Full explanation'))), const SizedBox(width: 8), Expanded(child: FilledButton.tonalIcon(onPressed: () {}, icon: const Icon(Icons.fitness_center_rounded), label: const Text('Practice')))]),
        ],
      ),
    );
  }
}

