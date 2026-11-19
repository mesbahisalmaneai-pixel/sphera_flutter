import 'package:flutter/material.dart';
import '../data/database.dart';
import 'l10n.dart';
import 'theme.dart';

/// ACTIVE / SOLD / FOR SALE in the app language.
String accountStatusLabel(GameAccountStatus s) => switch (s) {
      GameAccountStatus.active => appL10n.statusActive,
      GameAccountStatus.sell => appL10n.statusSold,
      GameAccountStatus.forSale => appL10n.statusForSale,
    };

Color boxColor(BoxStatus s) => switch (s) {
      BoxStatus.empty => SpheraColors.empty,
      BoxStatus.done => SpheraColors.done,
      BoxStatus.notYet => SpheraColors.danger,
      BoxStatus.coming => SpheraColors.coming,
    };

/// Labels follow the app language ([appL10n]).
String boxLabel(BoxStatus s) => switch (s) {
      BoxStatus.empty => appL10n.boxEmpty,
      BoxStatus.done => appL10n.boxDone,
      BoxStatus.notYet => appL10n.boxNotYet,
      BoxStatus.coming => appL10n.boxComing,
    };

String gradeLabel(Grade g) => switch (g) {
      Grade.bronze => appL10n.gradeBronze,
      Grade.silver => appL10n.gradeSilver,
      Grade.gold => appL10n.gradeGold,
      Grade.platinum => appL10n.gradePlatinum,
      Grade.diamond => appL10n.gradeDiamond,
      Grade.interdit => appL10n.gradeInterdit,
    };

/// TEMPORARY colours until the real medal images are supplied
/// (replace with Image.asset in GradeBadge).
Color gradeColor(Grade g) => switch (g) {
      Grade.bronze => Color(0xFFCD7F32),
      Grade.silver => Color(0xFFC0C0C0),
      Grade.gold => Color(0xFFD4AF37),
      Grade.platinum => Color(0xFFB8C7D9),
      Grade.diamond => Color(0xFF7FD1FF),
      Grade.interdit => SpheraColors.danger,
    };

/// Medal image for a grade: assets/images/grades/`grade`.png
/// Falls back to a temporary coloured medal icon until the real image exists.
class GradeMedal extends StatelessWidget {
  const GradeMedal(this.grade, {super.key, this.size = 22});
  final Grade grade;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/grades/${grade.name}.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      // Decode at the size shown, not the file size (interdit.png is 1278 px).
      cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
errorBuilder: (context, error, stackTrace) =>
    Icon(
      Icons.workspace_premium,
      size: size,
      color: gradeColor(grade),
    ),

    );
  }
}

class GradeBadge extends StatelessWidget {
  const GradeBadge(this.grade, {super.key});
  final Grade grade;

  @override
  Widget build(BuildContext context) {
    final c = gradeColor(grade);
    return Container(
      padding: EdgeInsets.fromLTRB(6, 3, 10, 3),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withValues(alpha: 0.6)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        GradeMedal(grade, size: 22),
        SizedBox(width: 5),
        Text(gradeLabel(grade),
            style: TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
