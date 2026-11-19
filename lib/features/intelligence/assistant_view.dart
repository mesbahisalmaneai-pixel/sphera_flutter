import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/l10n.dart';
import '../../core/theme.dart';
import '../../data/assistant/assistant_chat.dart';
import '../../data/assistant/assistant_data.dart';
import '../../data/assistant/offline_brain.dart';
import 'insight_widgets.dart';

/// The "Ask" tab: chat with the SPHERA Assistant.
class AssistantView extends ConsumerStatefulWidget {
  const AssistantView({super.key});

  @override
  ConsumerState<AssistantView> createState() => _AssistantViewState();
}

class _AssistantViewState extends ConsumerState<AssistantView> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final q = (text ?? _input.text).trim();
    if (q.isEmpty) return;
    _input.clear();
    ref.read(assistantChatProvider.notifier).ask(q);
  }

  void _toBottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients) {
          _scroll.animateTo(_scroll.position.maxScrollExtent,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut);
        }
      });

  @override
  Widget build(BuildContext context) {
    final chat = ref.watch(assistantChatProvider);
    final ai = ref.watch(aiSettingsProvider);
    // Keeps the data streams loaded while the chat is open.
    ref.watch(assistantDataProvider);
    ref.listen(assistantChatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length ||
          (next.messages.lastOrNull?.pending ?? false)) {
        _toBottom();
      }
    });

    return Column(children: [
      Expanded(
        child: chat.messages.isEmpty
            ? _empty(ai)
            : ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: chat.messages.length,
                itemBuilder: (_, i) => _Bubble(chat.messages[i]),
              ),
      ),
      _inputBar(chat.busy),
    ]);
  }

  Widget _empty(AiSettings ai) =>
      ListView(padding: const EdgeInsets.all(20), children: [
        const SizedBox(height: 12),
        Icon(Icons.auto_awesome_rounded, size: 48, color: SpheraColors.gold),
        const SizedBox(height: 12),
        Text(context.l10n.askSpheraAnything,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(
          ai.active
              ? context.l10n.aiModeOnHint
              : context.l10n.offlineHint,
          textAlign: TextAlign.center,
          style: TextStyle(color: SpheraColors.muted),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in kSuggestedQuestions)
              ActionChip(label: Text(s), onPressed: () => _send(s))
          ],
        ),
      ]);

  Widget _inputBar(bool busy) => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: SpheraColors.border))),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: busy ? null : (_) => _send(),
                decoration: InputDecoration(
                  hintText: context.l10n.askQuestionHint,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 6),
            IconButton.filled(
              tooltip: context.l10n.send,
              onPressed: busy ? null : _send,
              icon: busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.arrow_upward_rounded),
            ),
          ]),
        ),
      );
}

class _Bubble extends StatelessWidget {
  const _Bubble(this.m);
  final ChatMessage m;

  @override
  Widget build(BuildContext context) {
    final user = m.role == ChatRole.user;
    final maxW = MediaQuery.sizeOf(context).width * 0.82;
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          decoration: BoxDecoration(
            color: user
                ? SpheraColors.gold.withValues(alpha: 0.16)
                : SpheraColors.surface,
            border: Border.all(
                color: user
                    ? SpheraColors.gold.withValues(alpha: 0.4)
                    : SpheraColors.border),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(user ? 16 : 4),
              bottomRight: Radius.circular(user ? 4 : 16),
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (m.pending && m.text.isEmpty)
                  Text(context.l10n.thinking,
                      style: TextStyle(
                          color: SpheraColors.muted,
                          fontStyle: FontStyle.italic))
                else
                  SelectableText(m.text, style: const TextStyle(height: 1.35)),
                if (!user && !m.pending) ...[
                  if (m.targets.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(spacing: 6, runSpacing: 6, children: [
                      for (final t in m.targets.take(3))
                        ActionChip(
                          visualDensity: VisualDensity.compact,
                          avatar: Icon(Icons.open_in_new_rounded,
                              size: 16, color: SpheraColors.gold),
                          label: Text(targetLabel(t),
                              style: const TextStyle(fontSize: 12)),
                          onPressed: () => openTarget(context, t),
                        ),
                    ]),
                  ],
                  const SizedBox(height: 6),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      switch (m.source) {
                        ReplySource.ai => Icons.auto_awesome_rounded,
                        ReplySource.offline => Icons.offline_bolt_outlined,
                        ReplySource.notice => Icons.info_outline_rounded,
                      },
                      size: 12,
                      color: SpheraColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      switch (m.source) {
                        ReplySource.ai => 'Claude',
                        ReplySource.offline => context.l10n.sourceOffline,
                        ReplySource.notice => context.l10n.sourceNotice,
                      },
                      style: TextStyle(color: SpheraColors.muted, fontSize: 11),
                    ),
                  ]),
                ],
              ]),
        ),
      ),
    );
  }
}

/// AI mode settings: on/off and the Anthropic API key.
Future<void> showAiSettings(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _AiSettingsSheet(),
    );

class _AiSettingsSheet extends ConsumerStatefulWidget {
  const _AiSettingsSheet();
  @override
  ConsumerState<_AiSettingsSheet> createState() => _AiSettingsSheetState();
}

class _AiSettingsSheetState extends ConsumerState<_AiSettingsSheet> {
  final _key = TextEditingController();
  bool _show = false;

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ai = ref.watch(aiSettingsProvider);
    final notifier = ref.read(aiSettingsProvider.notifier);
    final looksValid = _key.text.trim().startsWith('sk-ant-');

    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, 20 + MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(context.l10n.aiMode,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(
                context.l10n.aiModeExplain,
                style: TextStyle(color: SpheraColors.muted),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.useClaudeAi),
                subtitle: Text(ai.hasKey
                    ? context.l10n.apiKeySaved
                    : context.l10n.addApiKeyFirst),
                value: ai.active,
                onChanged: ai.hasKey ? notifier.setEnabled : null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _key,
                obscureText: !_show,
                autocorrect: false,
                enableSuggestions: false,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText:
                      ai.hasKey ? context.l10n.replaceApiKey : context.l10n.anthropicApiKey,
                  hintText: 'sk-ant-…',
                  errorText: _key.text.isNotEmpty && !looksValid
                      ? context.l10n.keysStartWith
                      : null,
                  suffixIcon: IconButton(
                    tooltip: _show ? context.l10n.hide : context.l10n.show,
                    icon: Icon(_show
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _show = !_show),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(
                  child: FilledButton(
                    onPressed: looksValid
                        ? () async {
                            await notifier.setKey(_key.text);
                            _key.clear();
                            if (context.mounted) Navigator.pop(context);
                          }
                        : null,
                    child: Text(context.l10n.saveKey),
                  ),
                ),
                if (ai.hasKey) ...[
                  const SizedBox(width: 10),
                  OutlinedButton(
                      onPressed: () => notifier.setKey(null),
                      child: Text(context.l10n.removeKey)),
                ],
              ]),
              const SizedBox(height: 16),
              Text(context.l10n.privacy,
                  style: TextStyle(
                      color: SpheraColors.gold, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                context.l10n.aiPrivacyText,
                style: TextStyle(color: SpheraColors.muted, fontSize: 12),
              ),
            ]),
      ),
    );
  }
}
