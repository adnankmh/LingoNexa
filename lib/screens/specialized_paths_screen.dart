import 'package:flutter/material.dart';

import '../data/learning_content_repository.dart';
import '../models/models.dart';

class SpecializedPathsScreen extends StatelessWidget {
  const SpecializedPathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Goal-Based Learning Paths')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1050),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columns = constraints.maxWidth >= 760 ? 2 : 1;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                  itemCount: LearningContentRepository.specializedPaths.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columns, childAspectRatio: columns == 1 ? 1.9 : 1.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                  itemBuilder: (context, index) => _PathCard(path: LearningContentRepository.specializedPaths[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({required this.path});
  final SpecializedPath path;

  @override
  Widget build(BuildContext context) {
    final color = Color(path.colorValue);
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _PathDetails(path: path))),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Container(width: 56, height: 56, alignment: Alignment.center, decoration: BoxDecoration(color: color.withValues(alpha: .13), borderRadius: BorderRadius.circular(18)), child: Text(path.emoji, style: const TextStyle(fontSize: 30))), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withValues(alpha: .11), borderRadius: BorderRadius.circular(14)), child: Text('${path.modules} modules', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 11)))]),
              const Spacer(),
              Text(path.title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
              const SizedBox(height: 5),
              Text(path.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4)),
              const Spacer(),
              Row(children: [Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(12), child: LinearProgressIndicator(value: .08, minHeight: 7, color: color))), const SizedBox(width: 10), const Icon(Icons.arrow_forward_rounded, size: 19)]),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathDetails extends StatelessWidget {
  const _PathDetails({required this.path});
  final SpecializedPath path;

  @override
  Widget build(BuildContext context) {
    final color = Color(path.colorValue);
    const moduleNames = ['Essential vocabulary', 'Listen in context', 'Guided dialogue', 'Grammar in action', 'Pronunciation clinic', 'Real-world mission'];
    return Scaffold(
      appBar: AppBar(title: Text(path.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
            children: [
              Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(gradient: LinearGradient(colors: [color, Color.lerp(color, Colors.black, .24)!]), borderRadius: BorderRadius.circular(28)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(path.emoji, style: const TextStyle(fontSize: 62)), const SizedBox(height: 14), Text(path.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 27)), const SizedBox(height: 7), Text(path.subtitle, style: const TextStyle(color: Colors.white70, height: 1.5)), const SizedBox(height: 18), FilledButton(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: color), child: const Text('Begin this path'))])),
              const SizedBox(height: 22),
              Text('Path curriculum', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              for (var i = 0; i < path.modules; i++)
                Card(child: ListTile(leading: CircleAvatar(backgroundColor: color.withValues(alpha: .12), child: Text('${i + 1}', style: TextStyle(color: color, fontWeight: FontWeight.w900))), title: Text(moduleNames[i % moduleNames.length], style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text('Module ${i + 1} · ${8 + (i % 5)} min'), trailing: Icon(i == 0 ? Icons.play_circle_fill_rounded : Icons.lock_outline_rounded, color: i == 0 ? color : null), onTap: i == 0 ? () {} : null)),
            ],
          ),
        ),
      ),
    );
  }
}

