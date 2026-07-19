import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../data/learning_content_repository.dart';
import '../models/models.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    final achievements = LearningContentRepository.achievements(
        xp: state.xp,
        streak: state.streak,
        lessons: state.completedLessonIds.length);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Achievements & League'),
            bottom: const TabBar(tabs: [
              Tab(icon: Icon(Icons.emoji_events_rounded), text: 'Achievements'),
              Tab(icon: Icon(Icons.leaderboard_rounded), text: 'League')
            ])),
        body: TabBarView(children: [
          _AchievementsList(achievements: achievements),
          const _LeagueTable()
        ]),
      ),
    );
  }
}

class _AchievementsList extends StatelessWidget {
  const _AchievementsList({required this.achievements});
  final List<Achievement> achievements;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 880),
        child: GridView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 420,
              childAspectRatio: 1.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            final item = achievements[index];
            final progress =
                (item.progress / item.goal).clamp(0.0, 1.0).toDouble();
            final unlocked = progress >= 1;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: (unlocked ? Colors.amber : Colors.grey)
                              .withValues(alpha: .14),
                          shape: BoxShape.circle),
                      child: Text(item.emoji,
                          style: TextStyle(
                              fontSize: 32,
                              color: unlocked ? null : Colors.grey))),
                  const SizedBox(width: 13),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        Text(item.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(item.description,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                fontSize: 11.5)),
                        const SizedBox(height: 9),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                                value: progress, minHeight: 7)),
                        const SizedBox(height: 4),
                        Text(
                            '${item.progress.clamp(0, item.goal)}/${item.goal}',
                            style: const TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w800))
                      ]))
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeagueTable extends StatelessWidget {
  const _LeagueTable();

  static const players = [
    ('🥇', 'Lina', '🇵🇸', 2840),
    ('🥈', 'Mateo', '🇪🇸', 2675),
    ('🥉', 'Yuki', '🇯🇵', 2510),
    ('4', 'Adnan', '🌍', 2340),
    ('5', 'Amira', '🇲🇦', 2210),
    ('6', 'Thomas', '🇩🇪', 2085),
    ('7', 'Sofia', '🇮🇹', 1960),
    ('8', 'Omar', '🇯🇴', 1810),
    ('9', 'Mina', '🇰🇷', 1740),
    ('10', 'Ana', '🇧🇷', 1625),
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary
                    ]),
                    borderRadius: BorderRadius.circular(25)),
                child: const Column(children: [
                  Text('💎 Diamond League',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 23)),
                  SizedBox(height: 5),
                  Text('Top 10 advance in 3 days',
                      style: TextStyle(color: Colors.white70))
                ])),
            const SizedBox(height: 14),
            for (final player in players)
              Card(
                  color: player.$2 == 'Adnan'
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
                  child: ListTile(
                      leading: SizedBox(
                          width: 38,
                          child: Center(
                              child: Text(player.$1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 19)))),
                      title: Text('${player.$3} ${player.$2}',
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      trailing: Text('${player.$4} XP',
                          style:
                              const TextStyle(fontWeight: FontWeight.w900)))),
          ],
        ),
      ),
    );
  }
}
