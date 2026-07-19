import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../widgets/ui.dart';
import 'placement_test_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pages = PageController();
  int _page = 0;
  String _targetCode = 'en';
  int _goal = 20;
  String _reason = 'Travel';

  static const _reasons = [
    ('Travel', '✈️', 'Feel confident anywhere'),
    ('Work', '💼', 'Build professional fluency'),
    ('Study', '🎓', 'Prepare for academic life'),
    ('Family', '❤️', 'Connect across generations'),
    ('Culture', '🎭', 'Understand people and media'),
    ('Brain training', '🧠', 'Create a rewarding daily habit'),
  ];

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
              child: Row(
                children: [
                  const BrandMark(size: 48),
                  const SizedBox(width: 11),
                  const Expanded(child: Text('LingoNexa', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 21))),
                  PopupMenuButton<String>(
                    tooltip: context.text.get('interface_language'),
                    icon: const Icon(Icons.language_rounded),
                    onSelected: (code) => AppStateScope.of(context).setLocale(code),
                    itemBuilder: (context) => [
                      for (final option in AppText.supported)
                        PopupMenuItem(value: option.code, child: Text('${option.flag} ${option.nativeName}')),
                    ],
                  ),
                  Text('${_page + 1}/4', style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ClipRRect(borderRadius: BorderRadius.circular(20), child: LinearProgressIndicator(value: (_page + 1) / 4, minHeight: 7)),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _WelcomeStep(onStart: _next),
                  _LanguageStep(selectedCode: _targetCode, onSelected: (value) => setState(() => _targetCode = value)),
                  _ReasonStep(selected: _reason, onSelected: (value) => setState(() => _reason = value), reasons: _reasons),
                  _GoalStep(goal: _goal, onChanged: (value) => setState(() => _goal = value)),
                ],
              ),
            ),
            if (_page > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                child: Row(
                  children: [
                    IconButton.outlined(onPressed: _back, icon: const Icon(Icons.arrow_back_rounded)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: _page == 3 ? _finish : _next,
                        child: Text(_page == 3 ? 'Build my learning plan' : 'Continue'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _next() {
    if (_page >= 3) return;
    setState(() => _page++);
    _pages.animateToPage(_page, duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
  }

  void _back() {
    if (_page == 0) return;
    setState(() => _page--);
    _pages.animateToPage(_page, duration: const Duration(milliseconds: 260), curve: Curves.easeOutCubic);
  }

  Future<void> _finish() async {
    final state = AppStateScope.of(context);
    final takePlacement = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do you already know some of this language?'),
        content: const Text('Take a short placement check to choose a better starting level, or begin safely from A1.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Start at A1')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Placement check')),
        ],
      ),
    );
    if (takePlacement == true && mounted) {
      await state.setTargetLanguage(_targetCode);
      if (!mounted) return;
      await Navigator.push(context, MaterialPageRoute(builder: (_) => const PlacementTestScreen()));
    }
    await state.completeOnboarding(targetCode: _targetCode, goalMinutes: _goal, reason: _reason);
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onStart});
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 540;
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: compact ? 14 : 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: (constraints.maxHeight - (compact ? 28 : 56)).clamp(0, double.infinity).toDouble(), maxWidth: 680),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LingoNexaLogo(height: compact ? 130 : 190),
                  SizedBox(height: compact ? 16 : 30),
                  Text('A world of language, built around you.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.15)),
                  const SizedBox(height: 12),
                  Text('Structured courses, real-world speaking, memory science, culture, and a global community in one original experience.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: compact ? 14 : 16, height: 1.5)),
                  SizedBox(height: compact ? 16 : 28),
                  FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.arrow_forward_rounded), label: const Text('Create my path')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageStep extends StatelessWidget {
  const _LanguageStep({required this.selectedCode, required this.onSelected});
  final String selectedCode;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final featured = LanguageCatalog.all.take(18).toList();
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          children: [
            const SizedBox(height: 18),
            Text('What do you want to learn?', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text('${LanguageCatalog.all.length} languages are available in the catalog', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 240, childAspectRatio: 2.45, crossAxisSpacing: 9, mainAxisSpacing: 9),
                itemCount: featured.length,
                itemBuilder: (context, index) {
                  final language = featured[index];
                  final selected = language.code == selectedCode;
                  return InkWell(
                    onTap: () => onSelected(language.code),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: selected ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color, borderRadius: BorderRadius.circular(18), border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor, width: selected ? 2 : 1)),
                      child: Row(children: [Text(language.flag, style: const TextStyle(fontSize: 25)), const SizedBox(width: 9), Expanded(child: Text(language.nativeName, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800))), if (selected) Icon(Icons.check_circle_rounded, color: Theme.of(context).colorScheme.primary)]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonStep extends StatelessWidget {
  const _ReasonStep({required this.selected, required this.onSelected, required this.reasons});
  final String selected;
  final ValueChanged<String> onSelected;
  final List<(String, String, String)> reasons;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          children: [
            Text('What brings you here?', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 18),
            for (final reason in reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Material(
                  color: selected == reason.$1 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: selected == reason.$1 ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor)),
                  child: ListTile(onTap: () => onSelected(reason.$1), contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5), leading: Text(reason.$2, style: const TextStyle(fontSize: 30)), title: Text(reason.$1, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(reason.$3), trailing: selected == reason.$1 ? const Icon(Icons.check_circle_rounded) : null),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GoalStep extends StatelessWidget {
  const _GoalStep({required this.goal, required this.onChanged});
  final int goal;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const goals = [(5, 'Gentle', 'Build the habit'), (10, 'Regular', 'Steady daily progress'), (20, 'Focused', 'Recommended balance'), (30, 'Intensive', 'Move faster'), (45, 'Immersion', 'Serious daily study')];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          children: [
            Text('Choose your daily rhythm', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text('You can change this at any time.', textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 18),
            for (final item in goals)
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Material(
                  color: goal == item.$1 ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).cardTheme.color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: goal == item.$1 ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor)),
                  child: ListTile(onTap: () => onChanged(item.$1), contentPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 7), leading: CircleAvatar(child: Text('${item.$1}')), title: Text(item.$2, style: const TextStyle(fontWeight: FontWeight.w900)), subtitle: Text(item.$3), trailing: const Text('min/day')),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
