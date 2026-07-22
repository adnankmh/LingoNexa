import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/app_theme.dart';
import '../core/i18n.dart';
import '../data/language_catalog.dart';
import '../widgets/ui.dart';
import 'achievements_screen.dart';
import 'admin_screen.dart';
import 'certificates_screen.dart';
import 'downloads_screen.dart';
import 'language_picker_screen.dart';
import 'interface_language_screen.dart';
import 'learning_plan_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final target = LanguageCatalog.byCode(state.targetLanguageCode);
    final user = state.currentUser!;
    final nextXp = ((state.xp ~/ 500) + 1) * 500;
    final xpFloor = nextXp - 500;
    final xpProgress = ((state.xp - xpFloor) / 500).clamp(0.0, 1.0).toDouble();
    return ResponsivePage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  user.displayName
                      .substring(0, user.displayName.length.clamp(1, 2).toInt())
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        if (state.isAdmin) ...[
                          const SizedBox(width: 7),
                          const Chip(
                            label: Text('ADMIN'),
                            avatar: Icon(Icons.verified_rounded, size: 16),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '@${user.username} · ${target.flag} ${target.nativeName} · ${state.currentLevel}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.orange.shade600,
                          size: 18,
                        ),
                        Text(
                          ' ${state.streak} days  ·  ${state.xp} XP',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primaryContainer.withValues(alpha: .48),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'XP level ${state.xp ~/ 500 + 1}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Text(
                      '${state.xp}/$nextXp XP',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: xpProgress,
                    minHeight: 10,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 20) / 3;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _MiniStat(
                    width: width,
                    value: '${state.completedLessonIds.length}',
                    label: 'Lessons',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                  _MiniStat(
                    width: width,
                    value: '${state.reviewLessonIds.length}',
                    label: 'Reviews',
                    icon: Icons.autorenew_rounded,
                  ),
                  _MiniStat(
                    width: width,
                    value: '${state.dailyMinutes}',
                    label: 'Minutes',
                    icon: Icons.timer_outlined,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 25),
          SectionHeading(
            title: context.text.get('my_learning'),
            subtitle: 'Plan, milestones, offline access, and records',
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_month_rounded),
                  title: Text(
                    context.text.get('learning_plan'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${state.learningReason} · ${state.dailyGoalMinutes} min/day',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LearningPlanScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.emoji_events_rounded),
                  title: Text(
                    context.text.get('achievements'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text('${state.xp} XP · ${state.streak}-day streak'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AchievementsScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.offline_bolt_rounded),
                  title: Text(
                    context.text.get('downloads'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${state.downloadedPackCodes.length} languages selected',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DownloadsScreen()),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.workspace_premium_rounded),
                  title: Text(
                    context.text.get('certificates'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Completion and assessment readiness'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CertificatesScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SectionHeading(
            title: context.text.get('themes'),
            subtitle: '${AppThemes.presets.length} polished color systems',
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 82,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final preset in AppThemes.presets)
                  _ThemeChoice(
                    preset: preset,
                    selected: state.themeId == preset.id,
                    onTap: () => state.setTheme(preset.id),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.translate_rounded),
                  title: Text(
                    context.text.get('learning_language'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text('${target.flag} ${target.nativeName}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LanguagePickerScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_rounded),
                  title: Text(
                    context.text.get('interface_language'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    '${AppText.optionFor(state.locale.languageCode).flag} ${AppText.optionFor(state.locale.languageCode).nativeName} · ${AppText.supported.length} languages',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InterfaceLanguageScreen(),
                    ),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: state.offlineMode,
                  onChanged: state.setOfflineMode,
                  secondary: const Icon(Icons.offline_bolt_rounded),
                  title: Text(
                    context.text.get('offline'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text(
                    'Keep downloaded lessons available without a connection',
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  value: state.sprintMode,
                  onChanged: state.setSprintMode,
                  secondary: const Icon(Icons.speed_rounded),
                  title: const Text(
                    'Fast learning mode',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text(
                    'Six essential steps per micro-lesson; full mode keeps all ten',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text(
                    'Learning reminders',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Daily at 7:30 PM'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.accessibility_new_rounded),
                  title: const Text(
                    'Accessibility',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text('Text scale, reduced motion, contrast'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restart_alt_rounded),
                  title: const Text(
                    'Rebuild my learning plan',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: const Text(
                    'Restart onboarding and placement choices',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _confirmReset(context, state),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.workspace_premium_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                context.text.get('premium'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text(
                'Offline packs, unlimited role-play, family learning',
              ),
              trailing: FilledButton.tonal(
                onPressed: () {},
                child: const Text('View'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (state.isAdmin)
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: Text(
                  context.text.get('admin'),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: const Text(
                  'Full administrator access: brand, content, users, modules, audio, exams, and deployment',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminScreen()),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: Text(
                context.text.get('sign_out'),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: Text(
                user.role.name == 'guest'
                    ? 'Leave guest session'
                    : 'Your local progress remains attached to this account',
              ),
              onTap: () => _confirmSignOut(context, state),
            ),
          ),
          const SizedBox(height: 15),
          Center(
            child: Text(
              'LingoNexa 1.4.0 · Content Mastery Edition',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _confirmReset(
    BuildContext context,
    AppState state,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rebuild your plan?'),
        content: const Text(
          'The onboarding questions will open again. Your lesson completions and XP will stay saved.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.resetOnboarding();
  }

  static Future<void> _confirmSignOut(
    BuildContext context,
    AppState state,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text(
          'Your account progress stays saved on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed == true) await state.signOut();
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.width,
    required this.value,
    required this.label,
    required this.icon,
  });
  final double width;
  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
    decoration: BoxDecoration(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Theme.of(context).dividerColor),
    ),
    child: Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 21),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 10.5,
          ),
        ),
      ],
    ),
  );
}

class _ThemeChoice extends StatelessWidget {
  const _ThemeChoice({
    required this.preset,
    required this.selected,
    required this.onTap,
  });
  final ThemePreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 92,
      margin: const EdgeInsetsDirectional.only(end: 9),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: preset.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected ? preset.seed : Theme.of(context).dividerColor,
          width: selected ? 3 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: preset.seed,
              shape: BoxShape.circle,
            ),
            child: selected
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 5),
          Text(
            preset.name,
            style: TextStyle(
              color: preset.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    ),
  );
}
