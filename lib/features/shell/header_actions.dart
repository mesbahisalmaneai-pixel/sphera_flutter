import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../intelligence/intelligence_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';

/// Top-right actions shown on every main tab: Notifications 🔔 then Settings ⚙️.
class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      IconButton(
        tooltip: 'Ask SPHERA',
        icon: Icon(Icons.auto_awesome_outlined, color: SpheraColors.muted),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const IntelligenceScreen())),
      ),
      const NotificationBell(),
      IconButton(
        tooltip: 'Settings',
        icon: Icon(Icons.settings_outlined, color: SpheraColors.muted),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
      ),
    ]);
  }
}
