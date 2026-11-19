import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/status_style.dart';
import '../../core/theme.dart';
import '../../data/database.dart';
import '../../data/providers.dart';

/// Bottom sheet to set game-box statuses of one Google account directly from
/// its card (no need to open the edit form). If [onlyGameId] is given, only
/// that game's box is shown and the sheet closes after a choice.
class BoxSheet extends ConsumerWidget {
  const BoxSheet({super.key, required this.account, this.onlyGameId});
  final GoogleAccount account;
  final String? onlyGameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = (ref.watch(activeGamesProvider).value ?? <Game>[])
        .where((g) => onlyGameId == null || g.id == onlyGameId)
        .toList();
    final boxes = ref.watch(googleBoxesProvider).value ?? <GoogleGameBox>[];
    final current = {
      for (final b in boxes.where((b) => b.googleAccountId == account.id)) b.gameId: b.status
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(account.email, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          SizedBox(height: 12),
          for (final g in games)
            Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.name, style: TextStyle(color: SpheraColors.muted)),
                SizedBox(height: 6),
                Wrap(spacing: 8, runSpacing: 6, children: [
                  for (final s in BoxStatus.values)
                    ChoiceChip(
                      label: Text(boxLabel(s)),
                      selected: (current[g.id] ?? BoxStatus.empty) == s,
                      selectedColor: boxColor(s).withValues(alpha: 0.3),
                      side: BorderSide(color: boxColor(s)),
                      onSelected: (_) async {
                        await ref.read(googleRepoProvider).setBoxStatus(account.id, g.id, s);
                        if (onlyGameId != null && context.mounted) Navigator.of(context).pop();
                      },
                    ),
                ]),
              ]),
            ),
          if (onlyGameId == null)
            SizedBox(
              width: double.infinity,
              child: FilledButton(onPressed: () => Navigator.of(context).pop(), child: Text('Done')),
            ),
        ]),
      ),
    );
  }
}
