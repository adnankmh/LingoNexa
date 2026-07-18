import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/app_state.dart';
import '../data/language_catalog.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  TextEditingController? _brandController;
  late double _goal;
  late bool _ai;
  late bool _community;
  late bool _voice;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = AppStateScope.of(context);
    _brandController ??= TextEditingController(text: state.brandName);
    _goal = state.dailyGoalMinutes.toDouble();
    _ai = state.aiTutorEnabled;
    _community = state.communityEnabled;
    _voice = state.voiceRoomsEnabled;
  }

  @override
  void dispose() {
    _brandController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Studio'), actions: [TextButton.icon(onPressed: _save, icon: const Icon(Icons.save_rounded), label: const Text('Save'))]),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
              children: [
                _AdminHero(state: state),
                const SizedBox(height: 18),
                const _AdminHeading(title: 'Brand & behavior', subtitle: 'Local settings take effect immediately after saving.'),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(children: [
                      TextField(controller: _brandController, decoration: const InputDecoration(labelText: 'Application name', prefixIcon: Icon(Icons.branding_watermark_rounded))),
                      const SizedBox(height: 18),
                      Row(children: [const Expanded(child: Text('Default daily goal', style: TextStyle(fontWeight: FontWeight.w800))), Text('${_goal.round()} min', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w900))]),
                      Slider(value: _goal, min: 5, max: 60, divisions: 11, label: '${_goal.round()}', onChanged: (value) => setState(() => _goal = value)),
                    ]),
                  ),
                ),
                const SizedBox(height: 18),
                const _AdminHeading(title: 'Feature switches', subtitle: 'Disable modules that are not connected to your production backend yet.'),
                const SizedBox(height: 10),
                Card(
                  child: Column(children: [
                    SwitchListTile(value: _ai, onChanged: (value) => setState(() => _ai = value), secondary: const Icon(Icons.psychology_alt_rounded), title: const Text('AI tutor', style: TextStyle(fontWeight: FontWeight.w800)), subtitle: const Text('Scenario practice and generative feedback adapter')),
                    const Divider(height: 1),
                    SwitchListTile(value: _community, onChanged: (value) => setState(() => _community = value), secondary: const Icon(Icons.people_alt_rounded), title: const Text('Community'), subtitle: const Text('Posts, corrections, partner matching, safety tools')),
                    const Divider(height: 1),
                    SwitchListTile(value: _voice, onChanged: (value) => setState(() => _voice = value), secondary: const Icon(Icons.graphic_eq_rounded), title: const Text('Voice rooms'), subtitle: const Text('Live group speaking module')),
                  ]),
                ),
                const SizedBox(height: 18),
                const _AdminHeading(title: 'Content operations', subtitle: 'The production workflow uses versioned JSON course packs.'),
                const SizedBox(height: 10),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 620 ? 2 : 1;
                    final cards = [
                      _AdminAction(icon: Icons.translate_rounded, title: '${LanguageCatalog.all.length} languages', subtitle: 'Catalog, scripts, direction, and course availability', onTap: () => _showInfo('Language catalog', 'The bundled catalog includes ${LanguageCatalog.all.length} languages. Add reviewed course packs in assets/data and register them in the repository.')),
                      _AdminAction(icon: Icons.school_rounded, title: 'Course editor', subtitle: 'Units, lessons, exercises, hints, and CEFR tags', onTap: () => _showInfo('Course editor', 'A cloud CMS adapter belongs in lib/services. Until connected, edit versioned course JSON and validate it before publishing.')),
                      _AdminAction(icon: Icons.video_library_rounded, title: 'Media library', subtitle: 'Audio, video, images, Lottie, and attribution', onTap: () => _showInfo('Media library', 'Use only owned, licensed, or open media. Keep attribution and license metadata beside each asset.')),
                      _AdminAction(icon: Icons.shield_rounded, title: 'Moderation center', subtitle: 'Reports, blocks, trust levels, and audit logs', onTap: () => _showInfo('Moderation center', 'Production moderation requires authenticated server roles, abuse queues, retention rules, and emergency escalation.')),
                    ];
                    return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: columns, childAspectRatio: columns == 1 ? 2.65 : 2.25, mainAxisSpacing: 10, crossAxisSpacing: 10, children: cards);
                  },
                ),
                const SizedBox(height: 18),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.data_object_rounded),
                    title: const Text('Export configuration JSON', style: TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: const Text('Copies current brand and feature settings for deployment.'),
                    trailing: const Icon(Icons.copy_rounded),
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: state.exportConfiguration()));
                      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configuration copied.')));
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.orange.withValues(alpha: .10), borderRadius: BorderRadius.circular(18)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.security_rounded, color: Colors.orange), SizedBox(width: 10), Expanded(child: Text('Before production: protect this page with server-verified administrator roles. A hidden button or local PIN is not sufficient security.', style: TextStyle(fontWeight: FontWeight.w700, height: 1.4)))])),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    await AppStateScope.of(context).updateAdmin(name: _brandController?.text ?? 'LingoNexa', goal: _goal.round(), ai: _ai, community: _community, voiceRooms: _voice);
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Admin settings saved.')));
  }

  void _showInfo(String title, String text) => showDialog<void>(context: context, builder: (context) => AlertDialog(title: Text(title), content: Text(text, style: const TextStyle(height: 1.5)), actions: [FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Done'))]));
}

class _AdminHero extends StatelessWidget {
  const _AdminHero({required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary]), borderRadius: BorderRadius.circular(27)),
      child: Row(children: [const Icon(Icons.admin_panel_settings_rounded, size: 54, color: Colors.white), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Content & Experience Control', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)), const SizedBox(height: 5), Text('${state.completedLessonIds.length} completions · ${state.xp} total XP · ${state.themeId} theme', style: const TextStyle(color: Colors.white70))]))]),
    );
  }
}

class _AdminHeading extends StatelessWidget {
  const _AdminHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))]);
}

class _AdminAction extends StatelessWidget {
  const _AdminAction({required this.icon, required this.title, required this.subtitle, required this.onTap});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(24), child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [CircleAvatar(child: Icon(icon)), const SizedBox(width: 12), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11.5))])), const Icon(Icons.chevron_right_rounded)]))));
}
