import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/product_copy_repository.dart';
import '../widgets/ui.dart';
import 'content_trust_screen.dart';

class SecurityCenterScreen extends StatelessWidget {
  const SecurityCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    String copy(String key) => ProductCopyRepository.text(locale, key);
    return Scaffold(
      appBar: AppBar(title: Text(copy('security'))),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF092B5B), Color(0xFF075B7A)],
                ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white12,
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Lottie.asset(
                        'assets/lottie/shield_lock.json',
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.shield_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy('protected'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          copy('device_first'),
                          style: const TextStyle(
                              color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    value: state.privacyFirstMode,
                    onChanged: (value) =>
                        state.updatePrivacy(privacyFirst: value),
                    secondary: const Icon(Icons.privacy_tip_rounded),
                    title: Text(copy('privacy_mode'),
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(copy('device_first')),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: state.anonymousAnalytics,
                    onChanged: state.privacyFirstMode
                        ? null
                        : (value) => state.updatePrivacy(analytics: value),
                    secondary: const Icon(Icons.query_stats_rounded),
                    title: Text(copy('analytics'),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: state.privateCrashReports,
                    onChanged: (value) =>
                        state.updatePrivacy(crashReports: value),
                    secondary: const Icon(Icons.health_and_safety_outlined),
                    title: Text(copy('crash_reports'),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: state.onDevicePersonalization,
                    onChanged: (value) =>
                        state.updatePrivacy(personalization: value),
                    secondary: const Icon(Icons.psychology_alt_outlined),
                    title: Text(copy('personalization'),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    value: state.saveVoiceRecordings,
                    onChanged: state.privacyFirstMode
                        ? null
                        : (value) => state.updatePrivacy(storeVoice: value),
                    secondary: const Icon(Icons.mic_none_rounded),
                    title: Text(copy('voice_storage'),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(copy('session_timeout'),
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                    ),
                    DropdownButton<int>(
                      value: state.sessionTimeoutMinutes,
                      items: const [
                        DropdownMenuItem(value: 15, child: Text('15 min')),
                        DropdownMenuItem(value: 30, child: Text('30 min')),
                        DropdownMenuItem(value: 60, child: Text('60 min')),
                        DropdownMenuItem(value: 720, child: Text('12 h')),
                      ],
                      onChanged: (value) {
                        if (value != null)
                          state.updatePrivacy(timeoutMinutes: value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.fact_check_outlined),
                    title: Text(copy('content_trust'),
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(copy('content_trust_sub')),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ContentTrustScreen()),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined,
                        color: Colors.red),
                    title: const Text('Clear local learning history',
                        style: TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: const Text(
                        'Removes local progress, review schedules, and voice choices.'),
                    onTap: () => _confirmClear(context, state),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: .55),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Security boundary: this package is an offline product foundation. Public release must use server-verified authentication, encrypted platform storage, signed APIs, abuse controls, and store-managed secrets. No API key is bundled in the app.',
                style: TextStyle(fontSize: 11.5, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> _confirmClear(
      BuildContext context, AppState state) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear local learning history?'),
        content: const Text(
            'This removes progress from this account on this device. The action cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Clear')),
        ],
      ),
    );
    if (confirmed == true) await state.clearLearningHistory();
  }
}
