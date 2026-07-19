import 'package:flutter/material.dart';

import '../core/i18n.dart';
import '../widgets/ui.dart';
import 'community_screen.dart';
import 'explore_screen.dart';
import 'learn_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _index = 0;

  static const _pages = [
    LearnScreen(),
    PracticeScreen(),
    ExploreScreen(),
    CommunityScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final destinations = [
      NavigationDestination(
          icon: const Icon(Icons.route_outlined),
          selectedIcon: const Icon(Icons.route_rounded),
          label: context.text.get('learn')),
      NavigationDestination(
          icon: const Icon(Icons.fitness_center_outlined),
          selectedIcon: const Icon(Icons.fitness_center_rounded),
          label: context.text.get('practice')),
      NavigationDestination(
          icon: const Icon(Icons.explore_outlined),
          selectedIcon: const Icon(Icons.explore_rounded),
          label: context.text.get('explore')),
      NavigationDestination(
          icon: const Icon(Icons.people_alt_outlined),
          selectedIcon: const Icon(Icons.people_alt_rounded),
          label: context.text.get('community')),
      NavigationDestination(
          icon: const Icon(Icons.person_outline_rounded),
          selectedIcon: const Icon(Icons.person_rounded),
          label: context.text.get('profile')),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: wide,
        child: SoftBackground(
          child: Row(
            children: [
              if (wide)
                Container(
                  width: 102,
                  margin: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: BrandMark(size: 48)),
                      Expanded(
                        child: NavigationRail(
                          backgroundColor: Colors.transparent,
                          selectedIndex: _index,
                          labelType: NavigationRailLabelType.all,
                          groupAlignment: 0,
                          onDestinationSelected: (value) =>
                              setState(() => _index = value),
                          destinations: [
                            for (final item in destinations)
                              NavigationRailDestination(
                                  icon: item.icon,
                                  selectedIcon: item.selectedIcon,
                                  label: Text(item.label)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(child: IndexedStack(index: _index, children: _pages)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: destinations,
            ),
    );
  }
}
