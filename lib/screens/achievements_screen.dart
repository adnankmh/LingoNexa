import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../core/app_state.dart';
import '../core/i18n.dart';
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
      lessons: state.completedLessonIds.length,
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.text.get('achievements')),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.emoji_events_rounded),
                text: context.text.get('achievements_only'),
              ),
              Tab(
                icon: const Icon(Icons.leaderboard_rounded),
                text: context.text.get('league'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _AchievementsList(achievements: achievements),
            _LeagueTable(state: state),
          ],
        ),
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
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final item = achievements[index];
            final progress = (item.progress / item.goal)
                .clamp(0.0, 1.0)
                .toDouble();
            final unlocked = progress >= 1;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 62,
                      height: 62,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (unlocked ? Colors.amber : Colors.grey)
                            .withValues(alpha: .14),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        item.emoji,
                        style: TextStyle(
                          fontSize: 32,
                          color: unlocked ? null : Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                              fontSize: 11.5,
                            ),
                          ),
                          const SizedBox(height: 9),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 7,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.progress.clamp(0, item.goal)}/${item.goal}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeagueTable extends StatelessWidget {
  const _LeagueTable({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    final userName = state.currentUser!.displayName;
    final userScore = state.weeklyXp;
    final players = <(String, String, int, bool)>[
      ('🇵🇸', 'Lina', 760, false),
      ('🇪🇸', 'Mateo', 690, false),
      ('🇯🇵', 'Yuki', 640, false),
      ('🌍', userName, userScore, true),
      ('🇲🇦', 'Amira', 515, false),
      ('🇩🇪', 'Thomas', 470, false),
      ('🇮🇹', 'Sofia', 420, false),
      ('🇯🇴', 'Omar', 360, false),
      ('🇰🇷', 'Mina', 310, false),
      ('🇧🇷', 'Ana', 260, false),
    ]..sort((a, b) => b.$3.compareTo(a.$3));
    final leagueName = userScore >= 1000
        ? context.text.get('diamond_league')
        : userScore >= 600
        ? context.text.get('gold_league')
        : userScore >= 250
        ? context.text.get('silver_league')
        : context.text.get('bronze_league');
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: 74,
                    height: 74,
                    child: Lottie.asset('assets/lottie/streak.json'),
                  ),
                  Text(
                    '🏆 $leagueName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 23,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    context.text.get('weekly_league_subtitle'),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < players.length; index++)
              Card(
                color: players[index].$4
                    ? Theme.of(context).colorScheme.primaryContainer
                    : null,
                child: ListTile(
                  leading: SizedBox(
                    width: 38,
                    child: Center(
                      child: Text(
                        index < 3 ? ['🥇', '🥈', '🥉'][index] : '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    '${players[index].$1} ${players[index].$2}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  trailing: Text(
                    '${players[index].$3} XP',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
