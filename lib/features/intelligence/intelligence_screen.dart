import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/assistant/assistant_chat.dart';
import '../../data/insights.dart';
import 'assistant_view.dart';
import 'insight_widgets.dart';

/// SPHERA Intelligence: the Assistant (Ask) and the offline Insights.
class IntelligenceScreen extends ConsumerWidget {
  const IntelligenceScreen({super.key, this.initialTab = 0});

  /// 0 = Ask, 1 = Insights.
  final int initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ai = ref.watch(aiSettingsProvider);
    final hasChat =
        ref.watch(assistantChatProvider.select((c) => c.messages.isNotEmpty));
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.spheraIntelligence),
          actions: [
            if (hasChat)
              IconButton(
                tooltip: context.l10n.newChat,
                icon: const Icon(Icons.add_comment_outlined),
                onPressed: () =>
                    ref.read(assistantChatProvider.notifier).clear(),
              ),
            IconButton(
              tooltip: ai.active ? context.l10n.aiModeOn : context.l10n.aiModeOff,
              icon: Icon(Icons.tune_rounded,
                  color: ai.active ? SpheraColors.gold : null),
              onPressed: () => showAiSettings(context),
            ),
          ],
          bottom: TabBar(tabs: [
            Tab(icon: const Icon(Icons.chat_bubble_outline_rounded), text: context.l10n.ask),
            Tab(icon: const Icon(Icons.lightbulb_outline_rounded), text: context.l10n.insights),
          ]),
        ),
        body: const TabBarView(children: [AssistantView(), _InsightsTab()]),
      ),
    );
  }
}

class _InsightsTab extends ConsumerStatefulWidget {
  const _InsightsTab();

  @override
  ConsumerState<_InsightsTab> createState() => _InsightsTabState();
}

class _InsightsTabState extends ConsumerState<_InsightsTab> {
  InsightLevel? _level; // null = all

  String _label(InsightLevel l) => switch (l) {
        InsightLevel.warning => context.l10n.levelAttention,
        InsightLevel.info => context.l10n.levelTips,
        InsightLevel.good => context.l10n.levelGood,
      };

  @override
  Widget build(BuildContext context) {
    final all = ref.watch(insightsProvider);
    final shown =
        _level == null ? all : all.where((i) => i.level == _level).toList();
    int count(InsightLevel l) => all.where((i) => i.level == l).length;

    return ListView(padding: const EdgeInsets.all(16), children: [
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Icon(Icons.auto_awesome_outlined,
                color: SpheraColors.gold, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.insightsCount(all.length),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(
                        context.l10n.attentionAndGood(count(InsightLevel.warning), count(InsightLevel.good)),
                        style:
                            TextStyle(color: SpheraColors.muted, fontSize: 12)),
                  ]),
            ),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 4, children: [
        ChoiceChip(
          label: Text(context.l10n.all),
          selected: _level == null,
          onSelected: (_) => setState(() => _level = null),
        ),
        for (final l in InsightLevel.values)
          ChoiceChip(
            label: Text('${_label(l)} (${count(l)})'),
            selected: _level == l,
            onSelected: (_) => setState(() => _level = l),
          ),
      ]),
      const SizedBox(height: 8),
      if (shown.isEmpty)
        Padding(
          padding: const EdgeInsets.all(32),
          child: Text(context.l10n.nothingHereNow,
              textAlign: TextAlign.center,
              style: TextStyle(color: SpheraColors.muted)),
        )
      else
        for (final i in shown) InsightTile(i),
      Padding(
        padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
        child: Text(
            context.l10n.analysisOnDevice,
            style: TextStyle(color: SpheraColors.muted, fontSize: 12)),
      ),
    ]);
  }
}
