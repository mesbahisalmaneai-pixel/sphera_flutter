import '../../core/l10n.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../insights.dart' show InsightTarget;
import '../providers.dart';
import 'app_knowledge.dart';
import 'assistant_data.dart';
import 'claude_client.dart';
import 'offline_brain.dart';

// ======================= AI settings =======================

/// Where the API key lives. Secure storage = Android Keystore / iOS Keychain.
abstract class KeyStore {
  Future<String?> read();
  Future<void> write(String? value);
}

class SecureKeyStore implements KeyStore {
  static const _k = 'anthropic_api_key';
  static const _s = FlutterSecureStorage();
  @override
  Future<String?> read() async {
    try {
      return await _s.read(key: _k);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String? value) async {
    try {
      value == null || value.isEmpty
          ? await _s.delete(key: _k)
          : await _s.write(key: _k, value: value);
    } catch (_) {}
  }
}

final keyStoreProvider = Provider<KeyStore>((ref) => SecureKeyStore());
final claudeClientProvider = Provider<ClaudeClient>((ref) => ClaudeClient());

class AiSettings {
  const AiSettings(
      {this.enabled = false, this.hasKey = false, this.loaded = false});
  final bool enabled;
  final bool hasKey;
  final bool loaded;
  bool get active => enabled && hasKey;
}

class AiSettingsNotifier extends Notifier<AiSettings> {
  @override
  AiSettings build() {
    _load();
    return const AiSettings();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final key = await ref.read(keyStoreProvider).read();
    state = AiSettings(
        enabled: p.getBool('ai_enabled') ?? false,
        hasKey: (key ?? '').isNotEmpty,
        loaded: true);
  }

  Future<void> setEnabled(bool v) async {
    state = AiSettings(enabled: v, hasKey: state.hasKey, loaded: true);
    (await SharedPreferences.getInstance()).setBool('ai_enabled', v);
  }

  /// Saves (or, with null / empty, removes) the API key.
  Future<void> setKey(String? key) async {
    final k = key?.trim();
    await ref.read(keyStoreProvider).write(k);
    final has = (k ?? '').isNotEmpty;
    await setEnabled(has ? true : false);
    state = AiSettings(enabled: has, hasKey: has, loaded: true);
  }
}

final aiSettingsProvider =
    NotifierProvider<AiSettingsNotifier, AiSettings>(AiSettingsNotifier.new);

// ======================= Chat =======================

enum ChatRole { user, assistant }

enum ReplySource { offline, ai, notice }

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.text,
    this.targets = const [],
    this.source = ReplySource.offline,
    this.pending = false,
  });
  final ChatRole role;
  final String text;
  final List<InsightTarget> targets;
  final ReplySource source;
  final bool pending;

  ChatMessage copyWith(
          {String? text,
          bool? pending,
          ReplySource? source,
          List<InsightTarget>? targets}) =>
      ChatMessage(
          role: role,
          text: text ?? this.text,
          targets: targets ?? this.targets,
          source: source ?? this.source,
          pending: pending ?? this.pending);

  Map<String, dynamic> toJson() => {
        'r': role.name,
        't': text,
        'g': [for (final t in targets) t.name],
        's': source.name
      };

  static ChatMessage? fromJson(Map<String, dynamic> j) {
    try {
      return ChatMessage(
        role: ChatRole.values.byName(j['r'] as String),
        text: j['t'] as String,
        targets: [
          for (final n in (j['g'] as List? ?? const []))
            for (final t in InsightTarget.values)
              if (t.name == n) t
        ],
        source: ReplySource.values.byName(j['s'] as String? ?? 'offline'),
      );
    } catch (_) {
      return null;
    }
  }
}

class ChatState {
  const ChatState(
      {this.messages = const [],
      this.api = const [],
      this.lastSnapshot,
      this.busy = false});
  final List<ChatMessage> messages; // what the screen shows

  /// The Claude conversation exactly as sent (append-only; replayed unchanged).
  final List<Map<String, dynamic>> api;

  /// Data snapshot last given to Claude (sent again only when it changes).
  final String? lastSnapshot;
  final bool busy;

  ChatState copyWith(
          {List<ChatMessage>? messages,
          List<Map<String, dynamic>>? api,
          String? lastSnapshot,
          bool? busy,
          bool resetAi = false}) =>
      ChatState(
        messages: messages ?? this.messages,
        api: resetAi ? const [] : (api ?? this.api),
        lastSnapshot: resetAi ? null : (lastSnapshot ?? this.lastSnapshot),
        busy: busy ?? this.busy,
      );
}

/// After this many API messages, a new Claude conversation starts (the screen
/// keeps the old messages). History is never cut in the middle.
const kMaxApiMessages = 60;

class AssistantChatNotifier extends Notifier<ChatState> {
  static const _k = 'assistant_chat_v1';
  static final _system = buildSystemPrompt();

  @override
  ChatState build() {
    _load();
    return const ChatState();
  }

  Future<void> _load() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_k);
      if (raw == null || state.messages.isNotEmpty) return;
      final j = (jsonDecode(raw) as Map).cast<String, dynamic>();
      state = ChatState(
        messages: [
          for (final m in (j['m'] as List? ?? const []))
            if (ChatMessage.fromJson((m as Map).cast<String, dynamic>())
                case final msg?)
              msg
        ],
        api: [
          for (final a in (j['a'] as List? ?? const []))
            (a as Map).cast<String, dynamic>()
        ],
        lastSnapshot: j['s'] as String?,
      );
    } catch (_) {}
  }

  Future<void> _save() async {
    final keep = state.messages.where((m) => !m.pending).toList();
    final tail = keep.length > 80 ? keep.sublist(keep.length - 80) : keep;
    final enc = jsonEncode({
      'm': [for (final m in tail) m.toJson()],
      'a': state.api,
      's': state.lastSnapshot
    });
    (await SharedPreferences.getInstance()).setString(_k, enc);
  }

  Future<void> clear() async {
    state = const ChatState();
    (await SharedPreferences.getInstance()).remove(_k);
  }

  void _replaceLast(ChatMessage m) => state = state.copyWith(
      messages: [...state.messages.sublist(0, state.messages.length - 1), m]);

  /// Waits (briefly) until the account streams have loaded, so the first
  /// question asked right after opening the app does not see empty data.
  Future<void> _dataReady() async {
    try {
      await Future.wait([
        ref.read(allGameAccountsProvider.future),
        ref.read(activeGamesProvider.future),
        ref.read(googleAccountsProvider.future),
        ref.read(googleBoxesProvider.future),
      ]).timeout(const Duration(seconds: 3));
    } catch (_) {
      // Answer with whatever is loaded.
    }
  }

  Future<void> ask(String question) async {
    final q = question.trim();
    if (q.isEmpty || state.busy) return;
    await _dataReady();
    final data = ref.read(assistantDataProvider);
    final offline = answerOffline(q, data);
    final ai = ref.read(aiSettingsProvider);

    state = state.copyWith(messages: [
      ...state.messages,
      ChatMessage(role: ChatRole.user, text: q)
    ], busy: true);

    if (!ai.active) {
      final hint = offline.understood || ai.hasKey
          ? ''
          : appL10n.chatAiTip;
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
              role: ChatRole.assistant,
              text: '${offline.text}$hint',
              targets: offline.targets)
        ],
        busy: false,
      );
      await _save();
      return;
    }

    state = state.copyWith(messages: [
      ...state.messages,
      const ChatMessage(
          role: ChatRole.assistant,
          text: '',
          source: ReplySource.ai,
          pending: true),
    ]);

    final key = await ref.read(keyStoreProvider).read() ?? '';
    var base = state.api.length >= kMaxApiMessages
        ? const <Map<String, dynamic>>[]
        : state.api;
    var lastSnap =
        state.api.length >= kMaxApiMessages ? null : state.lastSnapshot;
    final snapshot = data.toPromptText();

    List<Map<String, dynamic>> request(
            List<Map<String, dynamic>> history, String? sent) =>
        [
          ...history,
          {'role': 'user', 'content': q},
          if (snapshot != sent) {'role': 'system', 'content': snapshot},
        ];

    final client = ref.read(claudeClientProvider);
    Future<ClaudeReply> call(List<Map<String, dynamic>> msgs) => client.send(
          apiKey: key,
          system: _system,
          messages: msgs,
          onText: (t) => _replaceLast(state.messages.last.copyWith(text: t)),
        );

    try {
      var msgs = request(base, lastSnap);
      ClaudeReply reply;
      try {
        reply = await call(msgs);
      } on ClaudeException catch (e) {
        if (!e.historyMismatch) rethrow;
        // One-time recovery: drop thinking blocks from the history and retry.
        base = [
          for (final m in base)
            if (m['content'] is List)
              {
                ...m,
                'content': [
                  for (final b in (m['content'] as List))
                    if (!const {'thinking', 'redacted_thinking'}
                        .contains((b as Map)['type']))
                      b
                ],
              }
            else
              m
        ];
        msgs = request(base, lastSnap);
        reply = await call(msgs);
      }
      state = state.copyWith(
        api: [
          ...msgs,
          {'role': 'assistant', 'content': reply.content}
        ],
        lastSnapshot: snapshot,
      );
      _replaceLast(ChatMessage(
        role: ChatRole.assistant,
        text: reply.text.isEmpty ? offline.text : reply.text,
        targets: offline.understood ? offline.targets : const [],
        source: ReplySource.ai,
      ));
    } on ClaudeException catch (e) {
      _replaceLast(ChatMessage(
        role: ChatRole.assistant,
        text: offline.understood
            ? '${offline.text}\n\n${appL10n.chatAnsweredOffline(e.message)}'
            : e.message,
        targets: offline.targets,
        source: offline.understood ? ReplySource.offline : ReplySource.notice,
      ));
    } catch (_) {
      _replaceLast(ChatMessage(
        role: ChatRole.assistant,
        text: offline.understood
            ? offline.text
            : appL10n.chatSomethingWrong,
        targets: offline.targets,
        source: ReplySource.notice,
      ));
    } finally {
      state = state.copyWith(busy: false);
      await _save();
    }
  }
}

final assistantChatProvider =
    NotifierProvider<AssistantChatNotifier, ChatState>(
        AssistantChatNotifier.new);
