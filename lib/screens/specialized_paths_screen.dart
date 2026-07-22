import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';
import '../data/learning_content_repository.dart';
import '../models/models.dart';
import '../services/speech_service.dart';

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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: columns == 1 ? 1.9 : 1.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) => _PathCard(
                    path: LearningContentRepository.specializedPaths[index],
                  ),
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
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => _PathDetails(path: path)),
        ),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(19),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .13),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      path.emoji,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: .11),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      '${path.modules} modules',
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                path.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                path.subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: .08,
                        minHeight: 7,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.arrow_forward_rounded, size: 19),
                ],
              ),
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
    const moduleNames = [
      'Essential vocabulary',
      'Listen in context',
      'Guided dialogue',
      'Grammar in action',
      'Pronunciation clinic',
      'Real-world mission',
      'Question patterns',
      'Polite responses',
      'Problem solving',
      'Fast recall',
      'Story practice',
      'Scenario checkpoint',
    ];
    return Scaffold(
      appBar: AppBar(title: Text(path.title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, Color.lerp(color, Colors.black, .24)!],
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(path.emoji, style: const TextStyle(fontSize: 62)),
                    const SizedBox(height: 14),
                    Text(
                      path.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 27,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      path.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton(
                      onPressed: () => _openModule(context, 0),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: color,
                      ),
                      child: const Text('Begin this path'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Path curriculum',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < path.modules; i++)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withValues(alpha: .12),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    title: Text(
                      moduleNames[i % moduleNames.length],
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    subtitle: Text('Module ${i + 1} · ${8 + (i % 5)} min'),
                    trailing: Icon(
                      i == 0
                          ? Icons.play_circle_fill_rounded
                          : Icons.arrow_forward_ios_rounded,
                      color: i == 0 ? color : null,
                    ),
                    onTap: () => _openModule(context, i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openModule(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ScenarioModuleScreen(path: path, moduleIndex: index),
      ),
    );
  }
}

class _ScenarioModuleScreen extends StatefulWidget {
  const _ScenarioModuleScreen({required this.path, required this.moduleIndex});
  final SpecializedPath path;
  final int moduleIndex;

  @override
  State<_ScenarioModuleScreen> createState() => _ScenarioModuleScreenState();
}

class _ScenarioModuleScreenState extends State<_ScenarioModuleScreen> {
  final SpeechService _speech = SpeechService();
  final Set<int> _mastered = {};

  static const _pathCategories = <String, List<String>>{
    'travel': ['Travel', 'Airport', 'Hotel', 'Food', 'Emergencies'],
    'business': ['Work', 'Technology', 'Introductions'],
    'health': ['Health', 'At the Doctor', 'Pharmacy', 'Emergencies'],
    'doctor': ['At the Doctor', 'Health', 'Pharmacy', 'Emergencies'],
    'airport': ['Airport', 'Travel', 'Emergencies'],
    'restaurant': ['Food', 'Shopping'],
    'hotel': ['Hotel', 'Travel'],
    'shopping': ['Shopping', 'Essentials'],
    'family': ['Relationships', 'Introductions'],
    'technology': ['Technology', 'Work'],
    'emergency': ['Emergencies', 'Health', 'Essentials'],
    'academic': ['Work', 'Technology', 'Essentials'],
    'kids': ['Introductions', 'Relationships', 'Essentials'],
    'citizenship': ['Travel', 'Work', 'Shopping', 'Essentials'],
    'exam': ['Essentials', 'Introductions', 'Work'],
    'media': ['Culture', 'Relationships', 'Technology'],
  };

  @override
  void dispose() {
    _speech.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final language = LanguageCatalog.byCode(state.targetLanguageCode);
    final all = LearningContentRepository.phrasesFor(
      language.code,
      sourceLanguageCode: state.locale.languageCode,
    );
    final categories = _pathCategories[widget.path.id] ?? const ['Essentials'];
    final relevant = all
        .where((item) => categories.contains(item.category))
        .toList();
    final pool = relevant.length >= 4 ? relevant : all;
    final phrases = [
      for (var i = 0; i < 10; i++)
        pool[(widget.moduleIndex * 7 + i) % pool.length],
    ];
    final color = Color(widget.path.colorValue);
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.path.title} · ${widget.moduleIndex + 1}'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 36),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.path.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Real-world scenario module',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Listen, understand, say, and mark each useful expression. ${language.flag} ${language.englishName}',
                            style: const TextStyle(height: 1.45),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              for (var index = 0; index < phrases.length; index++)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    leading: Text(
                      phrases[index].visual,
                      style: const TextStyle(fontSize: 31),
                    ),
                    title: Text(
                      phrases[index].target,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(phrases[index].source),
                    trailing: Wrap(
                      spacing: 3,
                      children: [
                        IconButton(
                          tooltip: 'Listen',
                          onPressed: () => _play(
                            phrases[index].target,
                            language,
                            state.speechRate,
                          ),
                          icon: const Icon(Icons.volume_up_rounded),
                        ),
                        IconButton(
                          tooltip: 'Mark as mastered',
                          onPressed: () => setState(() {
                            if (!_mastered.add(index)) {
                              _mastered.remove(index);
                            }
                          }),
                          icon: Icon(
                            _mastered.contains(index)
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                          ),
                          color: _mastered.contains(index) ? color : null,
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mission',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Build a short dialogue using at least three expressions, say it twice without reading, then change one detail and repeat.',
                        style: TextStyle(height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: _mastered.length / phrases.length,
                        minHeight: 8,
                        color: color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_mastered.length}/${phrases.length} mastered',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _play(String text, LanguageOption language, double rate) async {
    final spoken = await _speech.speak(text, language.code, rate: rate);
    if (!spoken && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${language.englishName} voice is not installed.'),
        ),
      );
    }
  }
}
