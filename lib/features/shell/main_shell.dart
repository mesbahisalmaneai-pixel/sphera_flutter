import 'package:flutter/material.dart';
import '../cards/cards_screen.dart';
import '../home/home_screen.dart';
import '../notifications/notification_sync.dart';
import '../orbit/orbit_screen.dart';
import '../orbit/widgets/orbit_nav_bar.dart';
import '../profile/profile_screen.dart';
import '../stats/statistics_screen.dart';

/// Root screen after login: bottom navigation
/// Home | Stats | ORBIT | Cards | Profile.
/// Home stays the initial destination. Settings is NOT a tab; it lives in the
/// gear icon at the top right (HeaderActions).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  /// The Orbit scene is only built the first time its tab is opened, and its
  /// animations only run while that tab is visible (saves battery at startup).
  bool _orbitVisited = false;

  void _select(int i) {
    if (i == _index) return;
    setState(() {
      _index = i;
      if (i == 2) _orbitVisited = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationSync(
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            const HomeScreen(),
            const StatisticsScreen(),
            TickerMode(
              enabled: _index == 2,
              child:
                  _orbitVisited ? const OrbitScreen() : const SizedBox.shrink(),
            ),
            const CardsScreen(),
            const ProfileScreen(),
          ],
        ),
        bottomNavigationBar:
            OrbitNavigationBar(index: _index, onChanged: _select),
      ),
    );
  }
}
