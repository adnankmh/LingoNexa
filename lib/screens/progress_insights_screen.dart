import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../data/product_copy_repository.dart';
import '../widgets/ui.dart';

class ProgressInsightsScreen extends StatelessWidget {
  const ProgressInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final locale = state.locale.languageCode;
    String copy(String key) => ProductCopyRepository.text(locale, key);
    final due = state.dueReviews().length;
    final weeklyBars = [
      (state.weeklyXp * .28).round().clamp(6, 100),
      (state.weeklyXp * .42).round().clamp(9, 100),
      (state.weeklyXp * .36).round().clamp(8, 100),
      (state.weeklyXp * .55).round().clamp(12, 100),
      (state.weeklyXp * .48).round().clamp(10, 100),
      (state.dailyMinutes * 4).clamp(8, 100),
      (state.dailyMinutes * 5).clamp(10, 100),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(copy('progress_center'))),
      body: ResponsivePage(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientPanel(
              child: Row(
                children: [
                  ProgressRing(
                    value: state.masteryScore / 100,
                    label: '${state.masteryScore}%',
                    size: 92,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy('mastery'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          copy('progress_sub'),
                          style: const TextStyle(
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (MediaQuery.sizeOf(context).width > 560)
                    SizedBox(
                      width: 92,
                      height: 92,
                      child: Lottie.asset(
                        'assets/lottie/insights_wave.json',
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.insights_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = (constraints.maxWidth - 20) / 3;
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _MetricCard(
                      width: width,
                      icon: Icons.track_changes_rounded,
                      value:
                          '${(76 + state.completedLessonIds.length).clamp(76, 96)}%',
                      label: copy('accuracy'),
                      color: const Color(0xFF0E9F79),
                    ),
                    _MetricCard(
                      width: width,
                      icon: Icons.calendar_month_rounded,
                      value: '${state.streak}',
                      label: copy('consistency'),
                      color: const Color(0xFFF07B3F),
                    ),
                    _MetricCard(
                      width: width,
                      icon: Icons.timer_outlined,
                      value: '${state.dailyMinutes + (state.weeklyXp ~/ 10)}',
                      label: copy('minutes_week'),
                      color: const Color(0xFF4176E9),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 26),
            SectionHeading(
              title: copy('skills'),
              subtitle:
                  '${copy('strongest')}: ${copy(state.strongestSkill)} · ${copy('focus_next')}: ${copy(state.focusSkill)}',
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    for (final entry in state.skillMastery.entries)
                      _SkillRow(
                        label: copy(entry.key),
                        value: entry.value / 100,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 26),
            SectionHeading(
              title: copy('today'),
              subtitle: '$due ${copy('words_due')}',
              action: FilledButton.tonalIcon(
                onPressed: () => Navigator.pop(context, 'practice'),
                icon: const Icon(Icons.autorenew_rounded),
                label: Text(copy('review_now')),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      copy('consistency'),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 128,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var index = 0;
                              index < weeklyBars.length;
                              index++)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: _DayBar(
                                  value: weeklyBars[index] / 100,
                                  label: '${index + 1}',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.width,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final double width;
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.label, required this.value});
  final String label;
  final double value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(
          children: [
            SizedBox(
              width: 88,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w800)),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(value: value, minHeight: 10),
              ),
            ),
            SizedBox(
              width: 46,
              child: Text(
                '${(value * 100).round()}%',
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      );
}

class _DayBar extends StatelessWidget {
  const _DayBar({required this.value, required this.label});
  final double value;
  final String label;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: value.clamp(.08, 1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      );
}
