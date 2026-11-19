import 'package:flutter/material.dart' show Icons;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sphera_flutter/data/assistant/app_knowledge.dart';
import 'package:sphera_flutter/data/assistant/assistant_chat.dart';
import 'package:sphera_flutter/data/assistant/assistant_data.dart';
import 'package:sphera_flutter/data/assistant/claude_client.dart';
import 'package:sphera_flutter/data/assistant/offline_brain.dart';
import 'package:sphera_flutter/data/database.dart';
import 'package:sphera_flutter/data/insights.dart';
import 'package:sphera_flutter/data/performance.dart';
import 'package:sphera_flutter/data/phone_notifications.dart';
import 'package:sphera_flutter/data/providers.dart';
import 'package:sphera_flutter/data/smart_tools.dart';

final now = DateTime(2026, 10, 15, 12); // Thursday

GameAccount acc(String id, String game, double p, double s, DateTime t,
        [GameAccountStatus st = GameAccountStatus.active]) =>
    GameAccount(
        id: id,
        ownerId: 'u1',
        gameId: game,
        idCompte: 'ID-$id',
        name: 'Acc $id',
        purchasePrice: p,
        salePrice: s,
        status: st,
        notes: 'secret note',
        playerPhotoIds: '[]',
        createdAt: t,
        updatedAt: t);

Game game(String id, String name) =>
    Game(id: id, ownerId: 'u1', name: name, createdAt: DateTime(2025), updatedAt: DateTime(2025));

GoogleAccount gacc(String id, Grade g) => GoogleAccount(
    id: id, ownerId: 'u1', email: '$id@gmail.com', grade: g, favorite: false, createdAt: DateTime(2026), updatedAt: DateTime(2026));

AssistantData sample({PerformanceGoals goals = const PerformanceGoals()}) {
  final games = [game('ef', 'eFootball'), game('ff', 'Free Fire'), game('coc', 'Clash of Clans')];
  final accounts = [
    acc('1', 'ef', 100, 300, DateTime(2026, 10, 15, 9)), // +200 today
    acc('2', 'ef', 100, 150, DateTime(2026, 10, 13), GameAccountStatus.sell), // +50 this week
    acc('3', 'ff', 200, 120, DateTime(2026, 9, 20), GameAccountStatus.sell), // -80 last month
    acc('4', 'ff', 90, 0, DateTime(2026, 10, 1), GameAccountStatus.forSale),
  ];
  final google = [gacc('a', Grade.gold), gacc('b', Grade.gold), gacc('c', Grade.diamond)];
  final boxes = [
    GoogleGameBox(id: 'x', googleAccountId: 'a', gameId: 'ff', status: BoxStatus.coming, updatedAt: DateTime(2026)),
    GoogleGameBox(id: 'y', googleAccountId: 'b', gameId: 'ef', status: BoxStatus.done, updatedAt: DateTime(2026)),
  ];
  const health = DataHealth(duplicates: 0, gameDuplicates: 0, invalidEmails: 0, missingIds: 0, noBoxes: 1, trashed: 2);
  final ins = computeInsights(
      games: games, accounts: accounts, googleAccounts: google, boxes: boxes, health: health, goals: goals, now: now);
  return buildAssistantData(
    games: games,
    accounts: accounts,
    googleAccounts: google,
    boxes: boxes,
    health: health,
    goals: goals,
    insights: ins,
    alerts: [for (final i in ins) if (i.alert) i],
    achievementsDone: 3,
    achievementsTotal: 20,
    now: now,
  );
}

void main() {
  final d = sample();

  group('offline brain: data questions', () {
    String ask(String q) => answerOffline(q, d).text;

    test('profit overview and periods', () {
      expect(ask('What is my profit?'), contains('Net profit: +170 DH'));
      expect(ask('profit this month'), startsWith('This month: +250 DH'));
      expect(ask('how much did I earn today'), startsWith('Today: +200 DH'));
      expect(ask('this week?'), startsWith('This week: +250 DH'));
      expect(ask('last month profit'), contains('-80 DH'));
    });

    test('a game by name or alias', () {
      expect(ask('how is efootball doing'), startsWith('eFootball: 2 accounts'));
      expect(ask('combien de comptes free fire ?'), startsWith('Free Fire: 2 accounts'));
      expect(ask('ff stats'), startsWith('Free Fire'));
      expect(ask('clash of clans'), 'You have no Clash of Clans accounts yet.');
    });

    test('best and worst', () {
      expect(ask('which game makes the most money'), startsWith('eFootball makes the most: +250 DH'));
      expect(ask('which game is losing'), contains('Free Fire -80 DH'));
      expect(ask('best accounts'), contains('Acc 1 (eFootball) +200 DH'));
    });

    test('statuses, counts, grades, boxes, health', () {
      expect(ask('how many accounts are for sale'), startsWith('1 account is FOR SALE'));
      expect(ask('how many accounts do I have'), contains('4 gaming accounts'));
      expect(ask('how many gold accounts'), startsWith('You have 2 accounts Gold'));
      expect(ask('coming boxes'), 'Game boxes: COMING 1.');
      expect(ask('any problems with my data?'), contains('1 Google account with no box set'));
      expect(ask('google accounts'), contains('3 Google accounts: Gold 2, Diamond 1'));
    });

    test('summary, alerts, advice, goals', () {
      expect(ask('how am I doing?'), contains('Best game: eFootball'));
      expect(ask('show my alerts'), contains('alert'));
      expect(ask('any advice?'), contains('Free Fire is losing money'));
      expect(ask('my goals'), contains('no monthly goals'));
      final withGoal = answerOffline('goal progress', sample(goals: const PerformanceGoals(monthlyProfit: 1000)));
      expect(withGoal.text, contains('Profit: +250 DH of 1000 DH (25%)'));
    });

    test('Arabic and French questions', () {
      expect(ask('كم ربح هذا الشهر'), startsWith('This month'));
      expect(ask('quel est mon bénéfice ?'), contains('Net profit'));
    });
  });

  group('offline brain: app help', () {
    test('"how do I" questions use the guide, with a button', () {
      final r = answerOffline('How do I restore a deleted account?', d);
      expect(r.text, contains('Trash'));
      expect(r.targets, contains(InsightTarget.trash));
      expect(answerOffline('how to change the currency to euro', d).text, contains('Settings > Currency'));
      expect(answerOffline('comment créer un tournoi', d).text, contains('Tournament Arena'));
      expect(answerOffline('how do I add a game', d).text, contains('Manage Games'));
    });

    test('photos, privacy, missing accounts, meanings, Darija and Arabic', () {
      String help(String q) => answerOffline(q, d).text;
      expect(help('how to put a photo on an account'), contains('Change photo'));
      expect(help('is my data safe'), contains('stays on this phone'));
      expect(help('why can I not see my accounts'), contains('Settings > Trash'));
      expect(help('what does the diamond grade mean'), isNot(startsWith('You have')));
      expect(help('kifach nzid compte'), contains('Add Account'));
      expect(help('كيف أضيف حساب'), contains('Add Account'));
      expect(help('كيف أضيف حساب جوجل'), contains('Add Google Account'));
      // A generic "add" never beats a real topic.
      expect(help('how do I add a goal'), contains('Set goals'));
      expect(help('how do I add a google account'), contains('Add Google Account'));
      expect(help('comment ajouter un jeu'), contains('Manage Games'));
    });

    test('"how many" is a data question, not help', () {
      expect(answerOffline('how many sold accounts', d).text, 'You have sold 2 accounts.');
    });

    test('theme words do not count as grades', () {
      expect(answerOffline('how to change gold theme', d).text, contains('Appearance'));
    });

    test('greetings and unknown questions', () {
      expect(answerOffline('hi', d).text, startsWith('Hello!'));
      final r = answerOffline('qwerty zxcv', d);
      expect(r.understood, isFalse);
    });

    test('every help topic is reachable from its own keywords', () {
      for (final t in kHelpTopics) {
        final r = answerOffline('how ${t.keywords.first}', d);
        expect(r.understood, isTrue, reason: t.id);
      }
    });
  });

  group('snapshot sent to Claude', () {
    test('has the numbers but never emails, account IDs or notes', () {
      final s = d.toPromptText();
      expect(s, contains('Net profit: +170 DH'));
      expect(s, contains('eFootball: 2 accounts'));
      expect(s, isNot(contains('@gmail.com')));
      expect(s, isNot(contains('ID-1')));
      expect(s, isNot(contains('secret note')));
    });

    test('system prompt is stable and contains the guide', () {
      expect(buildSystemPrompt(), buildSystemPrompt());
      expect(buildSystemPrompt(), contains('## Trash and restore'));
    });
  });

  group('stream accumulator', () {
    test('rebuilds text and keeps thinking blocks with their signature', () {
      final a = StreamAccumulator()
        ..feed({'type': 'content_block_start', 'index': 0, 'content_block': {'type': 'thinking', 'thinking': ''}})
        ..feed({'type': 'content_block_delta', 'index': 0, 'delta': {'type': 'signature_delta', 'signature': 'SIG'}})
        ..feed({'type': 'content_block_start', 'index': 1, 'content_block': {'type': 'text', 'text': '', 'citations': null}})
        ..feed({'type': 'content_block_delta', 'index': 1, 'delta': {'type': 'text_delta', 'text': 'Hel'}})
        ..feed({'type': 'content_block_delta', 'index': 1, 'delta': {'type': 'text_delta', 'text': 'lo'}})
        ..feed({'type': 'message_delta', 'delta': {'stop_reason': 'end_turn'}});
      expect(a.text, 'Hello');
      expect(a.stopReason, 'end_turn');
      expect(a.replayContent, [
        {'type': 'thinking', 'thinking': '', 'signature': 'SIG'},
        {'type': 'text', 'text': 'Hello'}, // null fields removed
      ]);
    });

    test('after a fallback, thinking before the marker is not replayed', () {
      final a = StreamAccumulator()
        ..feed({'type': 'content_block_start', 'index': 0, 'content_block': {'type': 'thinking', 'thinking': ''}})
        ..feed({'type': 'content_block_start', 'index': 1, 'content_block': {'type': 'text', 'text': 'Par'}})
        ..feed({'type': 'content_block_start', 'index': 2, 'content_block': {'type': 'fallback', 'from': {}, 'to': {}}})
        ..feed({'type': 'content_block_start', 'index': 3, 'content_block': {'type': 'text', 'text': 'tial'}});
      expect(a.text, 'Partial');
      expect(a.replayContent.map((b) => b['type']), ['text', 'fallback', 'text']);
    });

    test('error events are reported', () {
      final a = StreamAccumulator()..feed({'type': 'error', 'error': {'message': 'Overloaded'}});
      expect(a.error, 'Overloaded');
    });
  });

  group('chat', () {
    late _FakeClaude claude;
    late ProviderContainer c;

    Future<void> settle() async {
      for (var i = 0; i < 5; i++) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    Future<ProviderContainer> make({required bool ai}) async {
      SharedPreferences.setMockInitialValues({'ai_enabled': ai});
      claude = _FakeClaude();
      c = ProviderContainer(overrides: [
        keyStoreProvider.overrideWithValue(_MemKeys(ai ? 'sk-ant-test' : null)),
        claudeClientProvider.overrideWithValue(claude),
        assistantDataProvider.overrideWithValue(d),
        ..._noDb,
      ]);
      c.read(aiSettingsProvider);
      c.read(assistantChatProvider);
      await settle();
      return c;
    }

    tearDown(() => c.dispose());

    test('offline mode answers locally and never calls Claude', () async {
      await make(ai: false);
      await c.read(assistantChatProvider.notifier).ask('profit this month');
      final m = c.read(assistantChatProvider).messages;
      expect(m.map((x) => x.role), [ChatRole.user, ChatRole.assistant]);
      expect(m.last.text, startsWith('This month: +250 DH'));
      expect(m.last.source, ReplySource.offline);
      expect(claude.calls, isEmpty);
    });

    test('offline: unknown question suggests AI mode', () async {
      await make(ai: false);
      await c.read(assistantChatProvider.notifier).ask('write me a poem');
      expect(c.read(assistantChatProvider).messages.last.text, contains('turn on AI mode'));
    });

    test('AI mode: data snapshot sent once, history replayed unchanged', () async {
      await make(ai: true);
      final chat = c.read(assistantChatProvider.notifier);
      await chat.ask('first question');
      await chat.ask('second question');

      expect(claude.calls, hasLength(2));
      final first = claude.calls[0];
      expect(first.map((m) => m['role']), ['user', 'system']);
      expect(first[1]['content'], contains('<sphera_data'));

      final second = claude.calls[1];
      // Same data -> no new snapshot; earlier turn (with its thinking block) is byte-identical.
      expect(second.map((m) => m['role']), ['user', 'system', 'assistant', 'user']);
      expect(second.sublist(0, 2), first);
      expect(second[2]['content'], claude.replyContent);

      final m = c.read(assistantChatProvider).messages.last;
      expect(m.text, 'AI answer 2');
      expect(m.source, ReplySource.ai);
    });

    test('AI error falls back to the offline answer', () async {
      await make(ai: true);
      claude.fail = const ClaudeException('No internet connection.');
      await c.read(assistantChatProvider.notifier).ask('profit this month');
      final m = c.read(assistantChatProvider).messages.last;
      expect(m.text, startsWith('This month: +250 DH'));
      expect(m.text, contains('No internet connection. Answered offline.'));
      expect(c.read(assistantChatProvider).busy, isFalse);
    });

    test('history mismatch: thinking blocks are stripped and the request retried once', () async {
      await make(ai: true);
      final chat = c.read(assistantChatProvider.notifier);
      await chat.ask('one');
      claude.failOnce = const ClaudeException('thinking mismatch', status: 400, historyMismatch: true);
      await chat.ask('two');
      final retry = claude.calls.last;
      final assistant = retry.firstWhere((m) => m['role'] == 'assistant');
      expect((assistant['content'] as List).map((b) => (b as Map)['type']), ['text']);
      expect(c.read(assistantChatProvider).messages.last.text, startsWith('AI answer'));
    });

    test('chat survives an app restart', () async {
      await make(ai: false);
      await c.read(assistantChatProvider.notifier).ask('hi');
      final c2 = ProviderContainer(overrides: [
        keyStoreProvider.overrideWithValue(_MemKeys(null)),
        assistantDataProvider.overrideWithValue(d),
        ..._noDb,
      ]);
      addTearDown(c2.dispose);
      c2.read(assistantChatProvider);
      await settle();
      expect(c2.read(assistantChatProvider).messages, hasLength(2));
    });
  });

  group('phone notification text', () {
    test('one alert uses its own title; several are grouped', () {
      const a = Insight(id: 'a', level: InsightLevel.warning, icon: _i, title: 'A', body: 'body A');
      const b = Insight(id: 'b', level: InsightLevel.warning, icon: _i, title: 'B', body: 'body B');
      expect(alertPushText([a]), ('A', 'body A'));
      expect(alertPushText([a, b, a, b]), ('4 things need your attention', 'A · B · A (+1 more)'));
    });

    test('daily summary has no stale "today" numbers', () {
      final (t, body) = dailySummaryText(alerts: 2, netProfit: '+170 DH', accounts: 4);
      expect(t, 'SPHERA daily summary');
      expect(body, '2 alerts waiting · Net profit +170 DH · 4 accounts. Tap to review.');
      expect(dailySummaryText(alerts: 0, netProfit: '0 DH', accounts: 1).$2, startsWith('All clear'));
    });
  });
}

const _i = Icons.info_outline;

class _MemKeys implements KeyStore {
  _MemKeys(this.v);
  String? v;
  @override
  Future<String?> read() async => v;
  @override
  Future<void> write(String? value) async => v = value;
}

class _FakeClaude extends ClaudeClient {
  final calls = <List<Map<String, dynamic>>>[];
  ClaudeException? fail;
  ClaudeException? failOnce;
  final replyContent = [
    {'type': 'thinking', 'thinking': '', 'signature': 'S1'},
    {'type': 'text', 'text': 'AI answer'},
  ];

  @override
  Future<ClaudeReply> send({
    required String apiKey,
    required String system,
    required List<Map<String, dynamic>> messages,
    void Function(String textSoFar)? onText,
  }) async {
    calls.add(List.of(messages));
    if (fail != null) throw fail!;
    if (failOnce != null) {
      final e = failOnce!;
      failOnce = null;
      throw e;
    }
    onText?.call('AI');
    return ClaudeReply('AI answer ${calls.length}', replyContent, 'end_turn');
  }
}

/// The chat waits for these streams; in unit tests they come from memory.
final _noDb = [
  allGameAccountsProvider.overrideWith((ref) => Stream.value(const <GameAccount>[])),
  activeGamesProvider.overrideWith((ref) => Stream.value(const <Game>[])),
  googleAccountsProvider.overrideWith((ref) => Stream.value(const <GoogleAccount>[])),
  googleBoxesProvider.overrideWith((ref) => Stream.value(const <GoogleGameBox>[])),
];
