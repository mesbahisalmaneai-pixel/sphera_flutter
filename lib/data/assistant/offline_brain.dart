import '../database.dart' show Grade, BoxStatus;
import '../insights.dart';
import '../../core/l10n.dart';
import '../../core/status_style.dart' show gradeLabel, boxLabel;
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
List<String> get kSuggestedQuestions => [
      appL10n.suggestHowAmIDoing,
      appL10n.suggestProfitMonth,
      appL10n.suggestBestGame,
      appL10n.suggestForSale,
      appL10n.suggestProblems,
      appL10n.suggestRestore,
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
  'biggest',
  'le plus',
  'rapporte',
  'اكثر'
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
  'مشاكل',
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
  'everything',
  'je m en sors',
  'comment ca va',
  'حالي',
  'وضعي'
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

String _pct(double? p) =>
    p == null ? '' : ' (${p >= 0 ? '+' : ''}${p.toStringAsFixed(0)}%)';

// ======================= Answers =======================

/// Answers [question] from [d] and the app guide, fully offline.
AssistantReply answerOffline(String question, AssistantData d) {
  final q = _Q(question);
  if (q.tokens.isEmpty) {
    return AssistantReply(appL10n.abEmpty);
  }

  final counting = q.any(_howMany);
  final howTo = !counting && q.any(_howTo);

  // "How do I ...?" questions go to the app guide first.
  if (howTo) {
    final t = _bestTopic(q);
    if (t != null) return AssistantReply(helpAnswer(t), targets: t.targets);
  }

  if (q.tokens.length <= 3 && q.any(_thanks)) {
    return AssistantReply(appL10n.abThanks);
  }
  if (q.tokens.length <= 3 && q.any(_greet)) {
    return AssistantReply(appL10n.abHello(_capabilities(d)));
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
    return _periodAnswer(d, appL10n.todayCap, d.today.profit, d.today.added, appL10n.yesterday,
        d.today.prevProfit, d.today.profitChangePct);
  }
  if (q.any(_week)) {
    return _periodAnswer(d, appL10n.thisWeek, d.week.profit, d.week.added,
        appL10n.abLastWeekCap, d.week.prevProfit, d.week.profitChangePct);
  }
  if (q.any(_lastMonth)) {
    return AssistantReply(
        appL10n.abLastMonth(d.sm(d.month.prevProfit), appL10n.accountsCount(d.month.prevAdded)),
        targets: const [InsightTarget.performance]);
  }
  if (q.any(_month)) {
    return _periodAnswer(d, appL10n.thisMonth, d.month.profit, d.month.added,
        appL10n.abLastMonthCap, d.month.prevProfit, d.month.profitChangePct);
  }

  if (q.any(_forSale)) {
    return AssistantReply(
        appL10n.abForSale(d.kpis.forSale),
        targets: const [InsightTarget.forSale]);
  }
  if (q.any(_sold)) {
    return AssistantReply(appL10n.abSold(appL10n.accountsCount(d.kpis.sold)),
        targets: const [InsightTarget.profit]);
  }
  if (q.any(_active) && (counting || q.any(_account))) {
    return AssistantReply(
        appL10n.abActive(d.kpis.active),
        targets: const [InsightTarget.organizer]);
  }

  if (q.any(_profit)) return _profitAnswer(d);
  if (q.any(_google)) return _googleAnswer(d);
  if (counting || q.any(_account)) return _countAnswer(d);
  if (q.any(_advice)) return _adviceAnswer(d);
  if (q.any(_summary)) return _summaryAnswer(d);
  if (q.any(_achieve)) {
    return AssistantReply(
        appL10n.abAchievements(d.achievementsDone, d.achievementsTotal),
        targets: const [InsightTarget.achievements]);
  }

  final t = _bestTopic(q);
  if (t != null) return AssistantReply(helpAnswer(t), targets: t.targets);

  return AssistantReply(appL10n.abNotUnderstood, understood: false);
}

String _capabilities(AssistantData d) => appL10n.abCapabilities(
    appL10n.abGamingAccounts(d.kpis.total), appL10n.googleAccountsCount(d.googleTotal));

AssistantReply _gameAnswer(AssistantData d, GameSummary g) {
  if (g.count == 0) {
    return AssistantReply(appL10n.abNoGameAccounts(g.name),
        targets: const [InsightTarget.addAccount]);
  }
  final margin = g.expenses > 0
      ? appL10n.abGameMargin((g.profit / g.expenses * 100).toStringAsFixed(1))
      : '';
  final rank = d.games.where((x) => x.count > 0).toList().indexOf(g) + 1;
  return AssistantReply(
    appL10n.abGameLine(g.name, appL10n.accountsCount(g.count), g.active, g.sold, g.forSale, d.sm(g.profit),
            d.m(g.sales), d.m(g.expenses)) +
        margin +
        (rank > 0 && d.games.length > 1 ? appL10n.abGameRank(rank) : ''),
    targets: const [InsightTarget.gamesStats, InsightTarget.profit],
  );
}

AssistantReply _gradeAnswer(AssistantData d, List<Grade> grades) {
  final parts = [
    for (final g in grades)
      '${appL10n.accountsCount(d.byGrade[g] ?? 0)} ${gradeLabel(g)}'
  ];
  return AssistantReply(
      appL10n.abGradeAnswer(parts.join(', '), appL10n.googleAccountsCount(d.googleTotal)),
      targets: const [InsightTarget.gradeStats]);
}

AssistantReply _boxAnswer(AssistantData d, _Q q) {
  final asked = [
    for (final e in _boxWords.entries)
      if (q.any(e.value)) e.key
  ];
  final list = asked.isEmpty ? BoxStatus.values : asked;
  final parts = [for (final s in list) '${boxLabel(s)} ${d.byBox[s] ?? 0}'];
  return AssistantReply(appL10n.abBoxes(parts.join(', ')),
      targets: const [InsightTarget.statusStats]);
}

AssistantReply _goalAnswer(AssistantData d) {
  if (!d.goals.any) {
    return AssistantReply(appL10n.abNoGoals, targets: const [InsightTarget.performance]);
  }
  final parts = <String>[];
  if (d.goals.monthlyProfit > 0) {
    final pct = (d.month.profit / d.goals.monthlyProfit * 100)
        .clamp(0, 999)
        .toStringAsFixed(0);
    parts.add(appL10n.abGoalProfit(d.sm(d.month.profit), d.m(d.goals.monthlyProfit), pct));
  }
  if (d.goals.monthlyAccounts > 0) {
    parts.add(appL10n.abGoalAccounts(d.month.added, d.goals.monthlyAccounts));
  }
  final behind = d.insights
      .where((i) => i.id.startsWith('goal-') && i.id.contains(':behind'))
      .isNotEmpty;
  return AssistantReply(
      '${parts.join('. ')}.${behind ? appL10n.abBehindPace : ''}',
      targets: const [InsightTarget.performance]);
}

AssistantReply _streakAnswer(AssistantData d) => AssistantReply(
    d.streak == 0
        ? appL10n.abNoStreak
        : appL10n.abStreak(appL10n.daysCount(d.streak)),
    targets: const [InsightTarget.performance]);

AssistantReply _alertsAnswer(AssistantData d) {
  if (d.alerts.isEmpty) {
    return AssistantReply(appL10n.abNoAlerts, targets: const [InsightTarget.notificationSettings]);
  }
  final lines = d.alerts.take(4).map((i) => '- ${i.title}').join('\n');
  return AssistantReply('${appL10n.abAlertsCount(d.alerts.length)}:\n$lines',
      targets: const [InsightTarget.notifications]);
}

AssistantReply _healthAnswer(AssistantData d) {
  final h = d.health;
  final issues = <String>[
    if (h.duplicates > 0) appL10n.abHGoogleDup(h.duplicates),
    if (h.gameDuplicates > 0) appL10n.abHGameDup(h.gameDuplicates),
    if (h.invalidEmails > 0) appL10n.insBadEmailTitle(h.invalidEmails),
    if (h.missingIds > 0) appL10n.abHMissingId(appL10n.accountsCount(h.missingIds)),
    if (h.noBoxes > 0) appL10n.abHNoBoxes(appL10n.googleAccountsCount(h.noBoxes)),
  ];
  if (issues.isEmpty) {
    return AssistantReply(
        appL10n.abHealthy + (h.trashed > 0 ? appL10n.abInTrash(appL10n.itemsCount(h.trashed)) : ''));
  }
  return AssistantReply(appL10n.abFound(issues.join(', ')), targets: [
    if (h.duplicates + h.gameDuplicates > 0) InsightTarget.duplicates,
    InsightTarget.security
  ]);
}

AssistantReply _gameRanking(AssistantData d, {required bool worst}) {
  final played = d.games.where((g) => g.count > 0).toList();
  if (played.isEmpty) {
    return AssistantReply(appL10n.abNoGamingAccounts, targets: const [InsightTarget.addAccount]);
  }
  if (worst) {
    final losing = played.where((g) => g.profit < 0).toList()
      ..sort((a, b) => a.profit.compareTo(b.profit));
    if (losing.isEmpty) {
      final low = played.last;
      return AssistantReply(
          appL10n.abNoLosing(low.name, d.sm(low.profit)),
          targets: const [InsightTarget.gamesStats]);
    }
    return AssistantReply(
        appL10n.abLosing(losing.map((g) => '${g.name} ${d.sm(g.profit)}').join(', ')),
        targets: const [InsightTarget.profit]);
  }
  final lines = played.take(3).toList();
  return AssistantReply(
      appL10n.abMakesMost(lines.first.name, d.sm(lines.first.profit), appL10n.accountsCount(lines.first.count)) +
          (lines.length > 1
              ? appL10n.abThen(lines.skip(1).map((g) => '${g.name} ${d.sm(g.profit)}').join(', '))
              : ''),
      targets: const [InsightTarget.gamesStats]);
}

AssistantReply _accountsRanking(AssistantData d, {required bool worst}) {
  final list = worst ? d.losses : d.top;
  if (list.isEmpty) {
    return AssistantReply(
        worst
            ? appL10n.abNoLoss
            : appL10n.abNoProfitYet,
        targets: const [InsightTarget.profit]);
  }
  final lines = list
      .take(3)
      .map((a) => '- ${a.name} (${a.game}) ${d.sm(a.profit)}')
      .join('\n');
  return AssistantReply(
      '${worst ? appL10n.abBiggestLosses : appL10n.abMostProfitable}:\n$lines',
      targets: const [InsightTarget.profit]);
}

AssistantReply _periodAnswer(AssistantData d, String label, double profit,
        int added, String prevLabel, double prev, double? pct) =>
    AssistantReply(
        appL10n.abPeriod(label, d.sm(profit), appL10n.accountsCount(added), prevLabel, d.sm(prev), _pct(pct)),
        targets: const [InsightTarget.performance]);

AssistantReply _profitAnswer(AssistantData d) {
  final margin = d.expenses > 0
      ? appL10n.abMarginSuffix((d.kpis.netProfit / d.expenses * 100).toStringAsFixed(1))
      : '';
  return AssistantReply(
      appL10n.abProfit(d.sm(d.kpis.netProfit), d.m(d.sales), d.m(d.expenses), margin, d.sm(d.month.profit),
          _pct(d.month.profitChangePct)),
      targets: const [InsightTarget.profit, InsightTarget.performance]);
}

AssistantReply _googleAnswer(AssistantData d) {
  final grades = Grade.values
      .where((g) => (d.byGrade[g] ?? 0) > 0)
      .map((g) => '${gradeLabel(g)} ${d.byGrade[g]}');
  return AssistantReply(
      appL10n.abGoogle(appL10n.googleAccountsCount(d.googleTotal), grades.isEmpty ? '' : ': ${grades.join(', ')}'),
      targets: const [InsightTarget.googleAccounts, InsightTarget.gradeStats]);
}

AssistantReply _countAnswer(AssistantData d) => AssistantReply(
    appL10n.abCount(appL10n.abGamingAccounts(d.kpis.total), d.kpis.active, d.kpis.sold, d.kpis.forSale,
        appL10n.gamesCount(d.games.length), appL10n.googleAccountsCount(d.googleTotal)),
    targets: const [InsightTarget.gamesStats, InsightTarget.googleAccounts]);

AssistantReply _adviceAnswer(AssistantData d) {
  final tips =
      d.insights.where((i) => i.level != InsightLevel.good).take(3).toList();
  if (tips.isEmpty) {
    return AssistantReply(appL10n.abNothingToFix, targets: const [InsightTarget.performance]);
  }
  return AssistantReply(tips.map((i) => '- ${i.title}: ${i.body}').join('\n'),
      targets: {
        for (final i in tips)
          if (i.target != null) i.target!
      }.toList());
}

AssistantReply _summaryAnswer(AssistantData d) {
  final b = StringBuffer()
    ..write(appL10n.abSummaryCounts(appL10n.abGamingAccounts(d.kpis.total), appL10n.googleAccountsCount(d.googleTotal)))
    ..write(appL10n.abSummaryProfit(d.sm(d.kpis.netProfit), d.sm(d.month.profit), _pct(d.month.profitChangePct)));
  final top = d.games.where((g) => g.count > 0 && g.profit > 0);
  if (top.isNotEmpty) b.write(appL10n.abBestGame(top.first.name));
  b.write(d.alerts.isEmpty
      ? appL10n.abNoAlertsShort
      : appL10n.abAlertsAttention(appL10n.abAlertsCount(d.alerts.length)));
  return AssistantReply(b.toString(), targets: [
    InsightTarget.performance,
    if (d.alerts.isNotEmpty) InsightTarget.notifications,
  ]);
}
