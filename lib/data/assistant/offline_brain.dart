import '../database.dart' show Grade, BoxStatus;
import '../insights.dart';
import 'app_knowledge.dart';
import 'assistant_data.dart';

/// What the assistant says, plus buttons to open screens.
class AssistantReply {
  const AssistantReply(this.text,
      {this.targets = const [], this.understood = true});
  final String text;
  final List<InsightTarget> targets;

  /// false when the offline brain did not recognise the question
  /// (AI mode, when on, then answers instead).
  final bool understood;
}

/// Suggested questions shown on an empty chat.
const kSuggestedQuestions = [
  'How am I doing?',
  'What is my profit this month?',
  'Which game makes the most money?',
  'How many accounts are for sale?',
  'Any problems with my data?',
  'How do I restore an account?',
];

// ======================= Text matching =======================

const _accents = {
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'á': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'î': 'i',
  'ï': 'i',
  'í': 'i',
  'ô': 'o',
  'ö': 'o',
  'ó': 'o',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ú': 'u',
  'ç': 'c',
  'ñ': 'n',
  'أ': 'ا',
  'إ': 'ا',
  'آ': 'ا',
  'ة': 'ه',
  'ى': 'ي',
};

/// Lower case, no accents, punctuation as spaces, single spaces.
String normalizeQuestion(String s) {
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    final c = _accents[ch] ?? ch;
    final code = c.codeUnitAt(0);
    final isWordChar = (code >= 0x61 && code <= 0x7A) ||
        (code >= 0x30 && code <= 0x39) ||
        code >= 0x0600;
    b.write(isWordChar ? c : ' ');
  }
  return b.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

class _Q {
  _Q(String raw)
      : text = ' ${normalizeQuestion(raw)} ',
        tokens = normalizeQuestion(raw)
            .split(' ')
            .where((t) => t.isNotEmpty)
            .toList();
  final String text;
  final List<String> tokens;

  /// Phrases must appear as written; single Latin words match as a prefix
  /// ("profit" -> "profitable"); Arabic words may carry a prefix ("ال").
  bool hit(String w) {
    final k = normalizeQuestion(w);
    if (k.isEmpty) return false;
    if (k.contains(' ')) return text.contains(' $k ') || text.contains(' $k');
    final arabic = k.codeUnitAt(0) >= 0x0600;
    return tokens.any((t) => arabic ? t.contains(k) : t.startsWith(k));
  }

  bool any(List<String> words) => words.any(hit);

  /// Every word of [phrase] appears somewhere in the question.
  bool hasAllWords(String phrase) => normalizeQuestion(phrase).split(' ').every(hit);
  int count(List<String> words) => words.where(hit).length;
}

const _profit = [
  'profit',
  'benefice',
  'gain',
  'earn',
  'money',
  'flous',
  'rb7',
  'rbe7',
  'ربح',
  'ارباح',
  'margin',
  'marge',
  'revenue',
  'income'
];
const _howMany = [
  'how many',
  'how much',
  'combien',
  'number of',
  'count',
  'total',
  'كم',
  'ch7al',
  'chhal',
  'nombre',
  'quantity'
];
const _account = [
  'account',
  'compte',
  'حساب',
  '7sab',
  'inventory',
  'inventaire'
];
const _google = ['google', 'gmail', 'play store', 'جوجل'];
const _today = ['today', 'aujourd', 'lyoum', 'اليوم', 'this day'];
const _week = ['week', 'semaine', 'simana', 'اسبوع', 'semana'];
const _lastMonth = [
  'last month',
  'previous month',
  'mois dernier',
  'mois passe',
  'الشهر الماضي'
];
const _month = ['month', 'mois', 'chhar', 'شهر'];
const _best = [
  'best',
  'top',
  'most',
  'meilleur',
  'highest',
  'افضل',
  'mzyan',
  'winner',
  'biggest'
];
const _worst = [
  'worst',
  'losing',
  'loss',
  'lose',
  'lost',
  'perte',
  'pire',
  'خساره',
  'khsara',
  'lowest',
  'negative'
];
const _forSale = [
  'for sale',
  'a vendre',
  'listing',
  'listed',
  'للبيع',
  'unsold'
];
const _sold = ['sold', 'vendu', 'مباع', 'sales count'];
const _active = ['active', 'actif', 'own', 'owned'];
const _health = [
  'duplicate',
  'doublon',
  'problem',
  'issue',
  'error',
  'health',
  'wrong',
  'probleme',
  'مشكل',
  'invalid',
  'mistake',
  'clean'
];
const _goal = ['goal', 'objectif', 'target', 'هدف', 'pace'];
const _streak = ['streak', 'serie', 'in a row', 'consecutive'];
const _alerts = [
  'notification',
  'alert',
  'warning',
  'reminder',
  'rappel',
  'تنبيه',
  'bell',
  'attention'
];
const _advice = [
  'advice',
  'tip',
  'suggest',
  'recommend',
  'what should',
  'insight',
  'conseil',
  'نصيحه',
  'improve',
  'better',
  'idea',
  'nasi7a'
];
const _summary = [
  'summary',
  'overview',
  'how am i',
  'report',
  'resume',
  'situation',
  'ملخص',
  'kifach rani',
  'how is my',
  'doing',
  'dashboard',
  'bilan',
  'everything'
];
const _greet = [
  'hi',
  'hello',
  'hey',
  'salam',
  'salut',
  'bonjour',
  'مرحبا',
  'السلام',
  'slm',
  'cc',
  'yo',
  'bonsoir',
  'ahlan'
];
const _thanks = ['thanks', 'thank', 'merci', 'شكرا', 'chokran', 'thx'];
const _capability = [
  'what can you',
  'what do you',
  'who are you',
  'what are you',
  'capable',
  'your features',
  'aide moi',
  'help me',
  'تقدر'
];
const _howTo = [
  'how',
  'where',
  'comment',
  'kifach',
  'kifash',
  'fin ',
  'كيف',
  'وين',
  'اين',
  'can i',
  'possible',
  'steps',
  'way to',
  'ou est',
  'est ce que je peux',
  'explain',
  'what is',
  'what are',
  'c est quoi',
  'meaning',
  'what does',
  'mean',
  'signifie',
  'veut dire',
  'يعني',
  'معنى',
  'ما هو',
  'ما هي'
];
const _achieve = ['achievement', 'badge', 'rank', 'points', 'trophy', 'succes'];
const _box = ['box', 'boite', 'coming', 'not yet', 'boxes'];
const _theme = ['theme', 'style', 'color', 'colour', 'couleur'];

const _gradeWords = {
  Grade.bronze: ['bronze'],
  Grade.silver: ['silver', 'argent'],
  Grade.gold: ['gold'],
  Grade.platinum: ['platinum', 'platine'],
  Grade.diamond: ['diamond', 'diamant'],
  Grade.interdit: ['interdit', 'banned', 'ban'],
};

const _boxWords = {
  BoxStatus.empty: ['empty', 'vide'],
  BoxStatus.done: ['done', 'fait', 'complete'],
  BoxStatus.notYet: ['not yet', 'pas encore'],
  BoxStatus.coming: ['coming', 'bientot'],
};

/// Extra ways people write common game names.
const _gameAliases = {
  'free fire': ['ff', 'freefire'],
  'clash of clans': ['coc', 'clash'],
  'ea sports': ['ea', 'fifa', 'fc'],
  'efootball': ['pes', 'efoot', 'e football'],
};

GameSummary? _mentionedGame(_Q q, List<GameSummary> games) {
  final compactQ = q.text.replaceAll(' ', '');
  for (final g in games) {
    final n = normalizeQuestion(g.name);
    if (n.isEmpty) continue;
    if (q.text.contains(' $n ') || compactQ.contains(n.replaceAll(' ', ''))) {
      return g;
    }
    for (final e in _gameAliases.entries) {
      if (n.contains(e.key) && e.value.any((a) => q.text.contains(' $a '))) {
        return g;
      }
    }
  }
  return null;
}

/// Generic verbs ("add") that only break a tie: "how do I add a goal" is about
/// goals, while "kifach nzid compte" (nothing else matches) is about accounts.
const _weakKeywords = {'add', 'ajouter', 'zid', 'nzid', 'زيد', 'ضيف', 'اضافه'};

HelpTopic? _bestTopic(_Q q) {
  HelpTopic? best;
  var bestScore = 0;
  for (final t in kHelpTopics) {
    var s = 0;
    // Asking about the look of the app: "gold" is a theme, not a grade.
    if (t.id == 'grades' && q.any(_theme)) continue;
    for (final k in t.keywords) {
      if (q.hit(k)) {
        s += k.contains(' ') ? 6 : (_weakKeywords.contains(k) ? 1 : 2);
      } else if (k.contains(' ') && q.hasAllWords(k)) {
        s += 4; // "add a game" still matches "add game"
      }
    }
    if (s > bestScore) {
      bestScore = s;
      best = t;
    }
  }
  return best;
}

String _pl(int n, String w, [String? plural]) =>
    '$n ${n == 1 ? w : (plural ?? '${w}s')}';

String _pct(double? p) =>
    p == null ? '' : ' (${p >= 0 ? '+' : ''}${p.toStringAsFixed(0)}%)';

// ======================= Answers =======================

/// Answers [question] from [d] and the app guide, fully offline.
AssistantReply answerOffline(String question, AssistantData d) {
  final q = _Q(question);
  if (q.tokens.isEmpty) {
    return const AssistantReply(
        'Ask me anything about your accounts or about SPHERA.');
  }

  final counting = q.any(_howMany);
  final howTo = !counting && q.any(_howTo);

  // "How do I ...?" questions go to the app guide first.
  if (howTo) {
    final t = _bestTopic(q);
    if (t != null) return AssistantReply(t.answer, targets: t.targets);
  }

  if (q.tokens.length <= 3 && q.any(_thanks)) {
    return const AssistantReply(
        'You are welcome! Ask me anything else about your accounts or the app.');
  }
  if (q.tokens.length <= 3 && q.any(_greet)) {
    return AssistantReply('Hello! ${_capabilities(d)}');
  }
  if (q.any(_capability)) return AssistantReply(_capabilities(d));

  final game = _mentionedGame(q, d.games);
  if (game != null) return _gameAnswer(d, game);

  if (!q.any(_theme)) {
    final grades = [
      for (final e in _gradeWords.entries)
        if (q.any(e.value)) e.key
    ];
    if (grades.isNotEmpty) return _gradeAnswer(d, grades);
  }

  if (q.any(_box)) return _boxAnswer(d, q);
  if (q.any(_goal)) return _goalAnswer(d);
  if (q.any(_streak)) return _streakAnswer(d);
  if (q.any(_alerts)) return _alertsAnswer(d);
  if (q.any(_health)) return _healthAnswer(d);

  final best = q.any(_best), worst = q.any(_worst);
  if (best || worst) {
    if (q.any(_account) && !q.any(['game', 'jeu', 'لعبه'])) {
      return _accountsRanking(d, worst: worst && !best);
    }
    return _gameRanking(d, worst: worst && !best);
  }

  if (q.any(_today)) {
    return _periodAnswer(d, 'Today', d.today.profit, d.today.added, 'yesterday',
        d.today.prevProfit, d.today.profitChangePct);
  }
  if (q.any(_week)) {
    return _periodAnswer(d, 'This week', d.week.profit, d.week.added,
        'last week', d.week.prevProfit, d.week.profitChangePct);
  }
  if (q.any(_lastMonth)) {
    return AssistantReply(
        'Last month: ${d.sm(d.month.prevProfit)} from ${_pl(d.month.prevAdded, 'account')} added.',
        targets: const [InsightTarget.performance]);
  }
  if (q.any(_month)) {
    return _periodAnswer(d, 'This month', d.month.profit, d.month.added,
        'last month', d.month.prevProfit, d.month.profitChangePct);
  }

  if (q.any(_forSale)) {
    return AssistantReply(
        '${_pl(d.kpis.forSale, 'account')} ${d.kpis.forSale == 1 ? 'is' : 'are'} FOR SALE right now. '
        'They count 0 in profit until they have a price.',
        targets: const [InsightTarget.forSale]);
  }
  if (q.any(_sold)) {
    return AssistantReply('You have sold ${_pl(d.kpis.sold, 'account')}.',
        targets: const [InsightTarget.profit]);
  }
  if (q.any(_active) && (counting || q.any(_account))) {
    return AssistantReply(
        '${_pl(d.kpis.active, 'account')} ${d.kpis.active == 1 ? 'is' : 'are'} ACTIVE.',
        targets: const [InsightTarget.organizer]);
  }

  if (q.any(_profit)) return _profitAnswer(d);
  if (q.any(_google)) return _googleAnswer(d);
  if (counting || q.any(_account)) return _countAnswer(d);
  if (q.any(_advice)) return _adviceAnswer(d);
  if (q.any(_summary)) return _summaryAnswer(d);
  if (q.any(_achieve)) {
    return AssistantReply(
        'You unlocked ${d.achievementsDone} of ${d.achievementsTotal} achievements.',
        targets: const [InsightTarget.achievements]);
  }

  final t = _bestTopic(q);
  if (t != null) return AssistantReply(t.answer, targets: t.targets);

  return const AssistantReply(
    'I did not understand that one. Try asking about your profit, a game, your accounts, '
    'grades, boxes, goals, problems in your data, or how to do something in the app.',
    understood: false,
  );
}

String _capabilities(AssistantData d) =>
    'I can answer questions about your ${_pl(d.kpis.total, 'gaming account')} and ${_pl(d.googleTotal, 'Google account')} '
    '(profit by day, week or month, best and losing games, for sale, grades, boxes, goals, data problems) '
    'and explain how to use any part of SPHERA. Try: "profit this month", "how many Free Fire accounts", '
    '"how do I add a game".';

AssistantReply _gameAnswer(AssistantData d, GameSummary g) {
  if (g.count == 0) {
    return AssistantReply('You have no ${g.name} accounts yet.',
        targets: const [InsightTarget.addAccount]);
  }
  final margin = g.expenses > 0
      ? ' Margin ${(g.profit / g.expenses * 100).toStringAsFixed(1)}%.'
      : '';
  final rank = d.games.where((x) => x.count > 0).toList().indexOf(g) + 1;
  return AssistantReply(
    '${g.name}: ${_pl(g.count, 'account')} (${g.active} active, ${g.sold} sold, ${g.forSale} for sale). '
    'Net profit ${d.sm(g.profit)}, sales ${d.m(g.sales)}, expenses ${d.m(g.expenses)}.$margin'
    '${rank > 0 && d.games.length > 1 ? ' It ranks #$rank of your games by profit.' : ''}',
    targets: const [InsightTarget.gamesStats, InsightTarget.profit],
  );
}

AssistantReply _gradeAnswer(AssistantData d, List<Grade> grades) {
  final parts = [
    for (final g in grades)
      '${_pl(d.byGrade[g] ?? 0, 'account')} ${gradeName(g)}'
  ];
  return AssistantReply(
      'You have ${parts.join(', ')} (out of ${_pl(d.googleTotal, 'Google account')}).',
      targets: const [InsightTarget.gradeStats]);
}

AssistantReply _boxAnswer(AssistantData d, _Q q) {
  final asked = [
    for (final e in _boxWords.entries)
      if (q.any(e.value)) e.key
  ];
  final list = asked.isEmpty ? BoxStatus.values : asked;
  final parts = [for (final s in list) '${boxName(s)} ${d.byBox[s] ?? 0}'];
  return AssistantReply('Game boxes: ${parts.join(', ')}.',
      targets: const [InsightTarget.statusStats]);
}

AssistantReply _goalAnswer(AssistantData d) {
  if (!d.goals.any) {
    return const AssistantReply(
        'You have no monthly goals yet. Open Performance Center and tap Set goals.',
        targets: [InsightTarget.performance]);
  }
  final parts = <String>[];
  if (d.goals.monthlyProfit > 0) {
    final pct = (d.month.profit / d.goals.monthlyProfit * 100)
        .clamp(0, 999)
        .toStringAsFixed(0);
    parts.add(
        'Profit: ${d.sm(d.month.profit)} of ${d.m(d.goals.monthlyProfit)} ($pct%)');
  }
  if (d.goals.monthlyAccounts > 0) {
    parts.add('Accounts added: ${d.month.added} of ${d.goals.monthlyAccounts}');
  }
  final behind = d.insights
      .where((i) => i.id.startsWith('goal-') && i.id.contains(':behind'))
      .isNotEmpty;
  return AssistantReply(
      '${parts.join('. ')}.${behind ? ' You are behind pace this month.' : ''}',
      targets: const [InsightTarget.performance]);
}

AssistantReply _streakAnswer(AssistantData d) => AssistantReply(
    d.streak == 0
        ? 'No add streak right now. Add an account today to start one.'
        : 'Your add streak is ${_pl(d.streak, 'day')} in a row.',
    targets: const [InsightTarget.performance]);

AssistantReply _alertsAnswer(AssistantData d) {
  if (d.alerts.isEmpty) {
    return const AssistantReply(
        'No warnings or reminders right now. All clear.',
        targets: [InsightTarget.notificationSettings]);
  }
  final lines = d.alerts.take(4).map((i) => '- ${i.title}').join('\n');
  return AssistantReply('${_pl(d.alerts.length, 'alert')}:\n$lines',
      targets: const [InsightTarget.notifications]);
}

AssistantReply _healthAnswer(AssistantData d) {
  final h = d.health;
  final issues = <String>[
    if (h.duplicates > 0) _pl(h.duplicates, 'Google duplicate group'),
    if (h.gameDuplicates > 0) _pl(h.gameDuplicates, 'gaming duplicate group'),
    if (h.invalidEmails > 0) _pl(h.invalidEmails, 'invalid email'),
    if (h.missingIds > 0) '${_pl(h.missingIds, 'account')} without Account ID',
    if (h.noBoxes > 0) '${_pl(h.noBoxes, 'Google account')} with no box set',
  ];
  if (issues.isEmpty) {
    return AssistantReply(
        'Your data looks healthy: no duplicates, no invalid emails, every account has an ID.'
        '${h.trashed > 0 ? ' ${_pl(h.trashed, 'item')} in the Trash.' : ''}');
  }
  return AssistantReply('Found: ${issues.join(', ')}.', targets: [
    if (h.duplicates + h.gameDuplicates > 0) InsightTarget.duplicates,
    InsightTarget.security
  ]);
}

AssistantReply _gameRanking(AssistantData d, {required bool worst}) {
  final played = d.games.where((g) => g.count > 0).toList();
  if (played.isEmpty) {
    return const AssistantReply('No gaming accounts yet.',
        targets: [InsightTarget.addAccount]);
  }
  if (worst) {
    final losing = played.where((g) => g.profit < 0).toList()
      ..sort((a, b) => a.profit.compareTo(b.profit));
    if (losing.isEmpty) {
      final low = played.last;
      return AssistantReply(
          'No game is losing money. The least profitable is ${low.name} (${d.sm(low.profit)}).',
          targets: const [InsightTarget.gamesStats]);
    }
    return AssistantReply(
        'Losing money: ${losing.map((g) => '${g.name} ${d.sm(g.profit)}').join(', ')}.',
        targets: const [InsightTarget.profit]);
  }
  final lines = played.take(3).toList();
  return AssistantReply(
      '${lines.first.name} makes the most: ${d.sm(lines.first.profit)} from ${_pl(lines.first.count, 'account')}.'
      '${lines.length > 1 ? ' Then ${lines.skip(1).map((g) => '${g.name} ${d.sm(g.profit)}').join(', ')}.' : ''}',
      targets: const [InsightTarget.gamesStats]);
}

AssistantReply _accountsRanking(AssistantData d, {required bool worst}) {
  final list = worst ? d.losses : d.top;
  if (list.isEmpty) {
    return AssistantReply(
        worst
            ? 'No account is at a loss.'
            : 'No account has made a profit yet.',
        targets: const [InsightTarget.profit]);
  }
  final lines = list
      .take(3)
      .map((a) => '- ${a.name} (${a.game}) ${d.sm(a.profit)}')
      .join('\n');
  return AssistantReply(
      '${worst ? 'Biggest losses' : 'Most profitable accounts'}:\n$lines',
      targets: const [InsightTarget.profit]);
}

AssistantReply _periodAnswer(AssistantData d, String label, double profit,
        int added, String prevLabel, double prev, double? pct) =>
    AssistantReply(
        '$label: ${d.sm(profit)} from ${_pl(added, 'account')} added. '
        '${prevLabel[0].toUpperCase()}${prevLabel.substring(1)}: ${d.sm(prev)}${_pct(pct)}.',
        targets: const [InsightTarget.performance]);

AssistantReply _profitAnswer(AssistantData d) {
  final margin = d.expenses > 0
      ? ', margin ${(d.kpis.netProfit / d.expenses * 100).toStringAsFixed(1)}%'
      : '';
  return AssistantReply(
      'Net profit: ${d.sm(d.kpis.netProfit)} (sales ${d.m(d.sales)} - expenses ${d.m(d.expenses)}$margin). '
      'This month: ${d.sm(d.month.profit)}${_pct(d.month.profitChangePct)} vs last month.',
      targets: const [InsightTarget.profit, InsightTarget.performance]);
}

AssistantReply _googleAnswer(AssistantData d) {
  final grades = Grade.values
      .where((g) => (d.byGrade[g] ?? 0) > 0)
      .map((g) => '${gradeName(g)} ${d.byGrade[g]}');
  return AssistantReply(
      'You have ${_pl(d.googleTotal, 'Google account')}${grades.isEmpty ? '' : ': ${grades.join(', ')}'}.',
      targets: const [InsightTarget.googleAccounts, InsightTarget.gradeStats]);
}

AssistantReply _countAnswer(AssistantData d) => AssistantReply(
    'You have ${_pl(d.kpis.total, 'gaming account')} (${d.kpis.active} active, ${d.kpis.sold} sold, '
    '${d.kpis.forSale} for sale) across ${_pl(d.games.length, 'game')}, and ${_pl(d.googleTotal, 'Google account')}.',
    targets: const [InsightTarget.gamesStats, InsightTarget.googleAccounts]);

AssistantReply _adviceAnswer(AssistantData d) {
  final tips =
      d.insights.where((i) => i.level != InsightLevel.good).take(3).toList();
  if (tips.isEmpty) {
    return const AssistantReply(
        'Nothing to fix right now. Keep adding accounts and set a monthly goal to track your pace.',
        targets: [InsightTarget.performance]);
  }
  return AssistantReply(tips.map((i) => '- ${i.title}: ${i.body}').join('\n'),
      targets: {
        for (final i in tips)
          if (i.target != null) i.target!
      }.toList());
}

AssistantReply _summaryAnswer(AssistantData d) {
  final b = StringBuffer()
    ..write(
        '${_pl(d.kpis.total, 'gaming account')} and ${_pl(d.googleTotal, 'Google account')}. ')
    ..write(
        'Net profit ${d.sm(d.kpis.netProfit)}; this month ${d.sm(d.month.profit)}${_pct(d.month.profitChangePct)}. ');
  final top = d.games.where((g) => g.count > 0 && g.profit > 0);
  if (top.isNotEmpty) b.write('Best game: ${top.first.name}. ');
  b.write(d.alerts.isEmpty
      ? 'No alerts.'
      : '${_pl(d.alerts.length, 'alert')} need your attention.');
  return AssistantReply(b.toString(), targets: [
    InsightTarget.performance,
    if (d.alerts.isNotEmpty) InsightTarget.notifications,
  ]);
}
