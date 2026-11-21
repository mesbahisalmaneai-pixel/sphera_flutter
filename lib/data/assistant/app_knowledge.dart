import '../../core/l10n.dart';
import '../insights.dart' show InsightTarget;

/// Everything the SPHERA Assistant knows about how the app works.
/// Used by the offline brain (keyword match) and, as one frozen block,
/// as the system prompt of the optional Claude AI mode.

class HelpTopic {
  const HelpTopic({
    required this.id,
    required this.title,
    required this.keywords,
    required this.answer,
    this.targets = const [],
  });
  final String id;
  final String title;

  /// Lower-case, accent-free words or phrases (English, French, Arabic, Darija).
  final List<String> keywords;
  final String answer;
  final List<InsightTarget> targets;
}

const kHelpTopics = <HelpTopic>[
  HelpTopic(
    id: 'about',
    title: 'What is SPHERA?',
    keywords: [
      'sphera',
      'what is this app',
      'about',
      'c est quoi',
      'application',
      'app do'
    ],
    answer:
        'SPHERA keeps your Google Play accounts and your gaming accounts in one place: '
        'grades, game boxes, purchase and sale prices, profit, statistics, smart tools and tournaments. '
        'Everything is stored on this phone (local mode).',
  ),
  HelpTopic(
    id: 'tabs',
    title: 'The 5 tabs',
    keywords: [
      'tab',
      'tabs',
      'navigation',
      'menu',
      'bottom bar',
      'onglet',
      'where is',
      'find'
    ],
    answer:
        'The bottom bar has 5 tabs: Home (dashboard, quick actions, KPIs, performance graph, recent activity), '
        'Stats (Analytics Center and statistics), ORBIT (the gold Earth: tap a glowing node, then Explore, '
        'to reach every screen of a section), Cards (smart tools and the Tournament Arena) and Profile '
        '(rank, achievements, session). Settings is the gear icon at the top right; the bell is Notifications.',
  ),
  HelpTopic(
    id: 'orbit',
    title: 'Using Orbit',
    keywords: ['orbit', 'earth', 'globe', 'planet', 'terre', 'node', 'explore'],
    answer:
        'Orbit is the center tab: a gold dotted Earth with one continent per section. Drag to turn it, '
        'tap a glowing node to see a glass card with live stats, then tap Explore to dive in. The bottom sheet '
        'has a Screens tab (one card per screen) and a Stats tab (gauges). Use the search button to jump to any screen.',
  ),
  HelpTopic(
    id: 'google-add',
    title: 'Add a Google account',
    keywords: [
      'add google',
      'new google',
      'google account',
      'gmail',
      'email',
      'ajouter compte google',
      'compte google',
      'جوجل',
      'غوغل'
    ],
    answer:
        'Open Google Play Accounts (Home card or Orbit) and tap Add Google Account. Enter the email and pick a grade. '
        'SPHERA creates one box per game automatically, all EMPTY. Duplicate emails are refused.',
    targets: [InsightTarget.googleAccounts],
  ),
  HelpTopic(
    id: 'grades',
    title: 'Google grades',
    keywords: [
      'grade',
      'grades',
      'bronze',
      'silver',
      'gold',
      'platinum',
      'diamond',
      'interdit',
      'banned',
      'rank google',
      'niveau'
    ],
    answer:
        'Each Google account has one grade: Bronze, Silver, Gold, Platinum, Diamond, or Interdit (banned / not usable). '
        'Change it by editing the account. Grade Statistics shows how many accounts you have per grade.',
    targets: [InsightTarget.gradeStats, InsightTarget.googleAccounts],
  ),
  HelpTopic(
    id: 'boxes',
    title: 'Game boxes and their statuses',
    keywords: [
      'box',
      'boxes',
      'boite',
      'case',
      'empty',
      'done',
      'not yet',
      'coming',
      'status google'
    ],
    answer:
        'Every Google account has one box per game. A box is EMPTY, DONE, NOT YET or COMING. '
        'Tap an account to open its boxes and change a status. A box is never a gaming account; '
        'Status Statistics counts boxes and gaming accounts separately. COMING boxes appear as reminders in Notifications.',
    targets: [InsightTarget.statusStats, InsightTarget.googleAccounts],
  ),
  HelpTopic(
    id: 'games',
    title: 'Manage games',
    keywords: [
      'manage games',
      'add game',
      'new game',
      'rename game',
      'archive game',
      'jeu',
      'jeux',
      'logo',
      'game photo'
    ],
    answer:
        'Open Games (Home quick action "Manage Games"). You can add a game, rename it (its accounts and boxes stay), '
        'archive it (it disappears from counts and stats) and set a card image or an account photo. '
        'New games get an EMPTY box in every Google account. Game names must be unique.',
    targets: [InsightTarget.games],
  ),
  HelpTopic(
    id: 'account-add',
    title: 'Add a gaming account',
    keywords: [
      'add account',
      'new account',
      'add gaming',
      'ajouter compte',
      'create account',
      'zid compte',
      'nouveau compte',
      // Single words score lower than the phrases above, so "add google
      // account" and "add game" still go to their own topics.
      'add',
      'ajouter',
      'zid',
      'nzid',
      'زيد',
      'ضيف',
      'اضافه'
    ],
    answer:
        'Tap Add Account on Home (or open a game and tap +). Choose the game, then enter the Account ID, a name, '
        'the purchase price, the sale price, a status and optional notes or a photo. Profit = sale price - purchase price.',
    targets: [InsightTarget.addAccount],
  ),
  HelpTopic(
    id: 'photos',
    title: 'Photos and images',
    keywords: [
      'photo',
      'picture',
      'image',
      'pic',
      'tswira',
      'tsawer',
      'صوره',
      'صور'
    ],
    answer:
        'One account: open it (Games > the game > tap the account) and tap Change photo; Reset puts the game\'s photo back. '
        'Every account of a game: in Games, open the game\'s menu and pick Change account photo. '
        'Change game image sets the game\'s card picture, and Reset images removes both.',
    targets: [InsightTarget.games],
  ),
  HelpTopic(
    id: 'privacy',
    title: 'Is my data safe?',
    keywords: [
      'safe',
      'private',
      'privacy',
      'where is my data',
      'stored',
      'confidential',
      'securise',
      'prive',
      'donnees',
      'امان',
      'آمن',
      'خصوصيه'
    ],
    answer:
        'Your data stays on this phone: accounts, prices, notes and photos are saved in the app\'s own database and are not '
        'sent to any server. The only exception is AI mode (off unless you turn it on): then your question and a summary of '
        'your numbers go to Claude, never your emails, Account IDs or notes. Make a backup in Settings > Backup and keep the '
        'file somewhere safe: uninstalling the app or losing the phone deletes the data on it.',
    targets: [InsightTarget.security],
  ),
  HelpTopic(
    id: 'missing',
    title: 'An account is missing',
    keywords: [
      'not see',
      'cant see',
      'cannot see',
      'disappeared',
      'missing account',
      'lost my',
      'gone',
      'disparu',
      'introuvable',
      'ma kaybanch',
      'makaybanch',
      'اختفى',
      'ضاع'
    ],
    answer:
        'If an account is missing: 1) open Settings > Trash: deleted accounts go there and can be restored; '
        '2) if you removed its game in Games, its accounts are kept but hidden with the game; '
        '3) clear the search text and filters in Google Play Accounts or Smart Organizer.',
    targets: [InsightTarget.trash],
  ),
  HelpTopic(
    id: 'statuses',
    title: 'Gaming account statuses',
    keywords: [
      'active',
      'sold',
      'sell',
      'for sale',
      'a vendre',
      'vendu',
      'statut',
      'status account'
    ],
    answer:
        'A gaming account is ACTIVE (you own it), SOLD, or FOR SALE (listed, no final price yet). '
        'FOR SALE accounts count 0 in profit until they have a price. Listings untouched for 14 days come back as reminders.',
    targets: [InsightTarget.forSale],
  ),
  HelpTopic(
    id: 'profit',
    title: 'How profit is calculated',
    keywords: [
      'how profit',
      'calculate profit',
      'profit calcul',
      'margin',
      'marge',
      'expenses',
      'depenses',
      'formula'
    ],
    answer:
        'Profit of an account = sale price - purchase price (0 for FOR SALE). Net profit is the sum over all '
        'accounts not in the Trash, from games that are not archived. Expenses = purchase prices, Sales = sale prices, '
        'margin = net profit / expenses. Periods use the date the account was added.',
    targets: [InsightTarget.profit],
  ),
  HelpTopic(
    id: 'search',
    title: 'Search and organize',
    keywords: [
      'search',
      'find account',
      'filter',
      'sort',
      'chercher',
      'recherche',
      'organizer',
      'trier'
    ],
    answer:
        'Use Search Account on Home for a quick search. Smart Organizer (Cards tab) searches, filters and sorts '
        'Google and gaming accounts together. Google Play Accounts also has search plus grade and status filters.',
    targets: [InsightTarget.organizer],
  ),
  HelpTopic(
    id: 'trash',
    title: 'Trash and restore',
    keywords: [
      'trash',
      'delete',
      'restore',
      'corbeille',
      'supprimer',
      'restaurer',
      'undo',
      'recover',
      'deleted',
      'استعيد',
      'استعاده',
      'المهملات',
      'محذوف'
    ],
    answer:
        'Deleting moves an account to the Trash (you can tap Undo right away). Trashed accounts are excluded from '
        'all counts and stats. Open Settings > Trash to restore one (grade, boxes and prices are kept) or delete it forever.',
    targets: [InsightTarget.trash],
  ),
  HelpTopic(
    id: 'stats',
    title: 'Statistics screens',
    keywords: [
      'statistics',
      'stats',
      'statistique',
      'analytics',
      'chart',
      'graph',
      'report'
    ],
    answer:
        'The Stats tab has the Analytics Center (Profit Center, Activity Center, Performance Center, SPHERA Intelligence) '
        'and Statistics (Grade, Status and Games statistics). Home also has a performance graph: daily, weekly or monthly profit.',
    targets: [
      InsightTarget.profit,
      InsightTarget.performance,
      InsightTarget.gamesStats
    ],
  ),
  HelpTopic(
    id: 'activity',
    title: 'Activity log',
    keywords: [
      'activity',
      'history',
      'log',
      'historique',
      'what changed',
      'recent'
    ],
    answer:
        'Activity Center lists every action (added, updated, status changed, trashed, restored, deleted), '
        'grouped by day and filterable by date range and type. Home shows the latest entries.',
    targets: [InsightTarget.activity],
  ),
  HelpTopic(
    id: 'goals',
    title: 'Monthly goals',
    keywords: ['goal', 'goals', 'objectif', 'target', 'pace', 'set goal'],
    answer:
        'Open Performance Center and tap Set goals. You can set a monthly profit goal and a number of accounts to add. '
        'The bars show your progress and where you should be today; falling behind creates a reminder.',
    targets: [InsightTarget.performance],
  ),
  HelpTopic(
    id: 'duplicates',
    title: 'Duplicate Scanner',
    keywords: [
      'duplicate',
      'duplicates',
      'doublon',
      'same email',
      'twice',
      'double'
    ],
    answer:
        'Duplicate Scanner (Cards tab) finds Google accounts with the same email (Gmail dots and +tags ignored) '
        'and gaming accounts with the same Account ID in the same game. Nothing is merged automatically: '
        'you review each group or dismiss it.',
    targets: [InsightTarget.duplicates],
  ),
  HelpTopic(
    id: 'vault',
    title: 'Inventory Vault',
    keywords: [
      'vault',
      'favorite',
      'favourite',
      'rare',
      'high value',
      'tag',
      'coffre'
    ],
    answer:
        'Inventory Vault (Cards tab) lets you tag accounts as Favorite, Rare or High value and see them together, '
        'with the highest sale price first.',
    targets: [InsightTarget.vault],
  ),
  HelpTopic(
    id: 'security',
    title: 'Security Center, backup and sync',
    keywords: [
      'security',
      'health',
      'backup',
      'sync',
      'cloud',
      'securite',
      'sauvegarde',
      'invalid email',
      'missing id'
    ],
    answer:
        'Security Center shows data health (duplicates, invalid emails, accounts without ID, accounts without boxes, trash). '
        'Settings > Backup saves all your data to a file you can keep or share, and restores it later. '
        'Cloud sync is not available yet.',
    targets: [InsightTarget.security],
  ),
  HelpTopic(
    id: 'arena',
    title: 'Tournament Arena',
    keywords: [
      'tournament',
      'tournoi',
      'arena',
      'league',
      'knockout',
      'groups',
      'battle royale',
      'clash squad',
      'match',
      'team'
    ],
    answer:
        'Tournament Arena (Cards tab) creates leagues, groups and knockout competitions, plus Battle Royale events '
        '(placement + kills per round). Tap Create, pick the game and mode (for example Clash Squad or Battle Royale '
        'Solo/Duo/Squad), add teams, then enter results; standings update automatically.',
    targets: [InsightTarget.arena],
  ),
  HelpTopic(
    id: 'achievements',
    title: 'Achievements and rank',
    keywords: [
      'achievement',
      'achievements',
      'badge',
      'rank',
      'points',
      'level',
      'succes',
      'trophy'
    ],
    answer:
        'Achievements unlock as you add accounts and games, sell, make profit and organize. They give achievement points. '
        'Your rank on the Profile tab uses separate rank points. Neither is related to Google Play grades.',
    targets: [InsightTarget.achievements],
  ),
  HelpTopic(
    id: 'currency',
    title: 'Currency and exchange rates',
    keywords: [
      'currency',
      'devise',
      'dollar',
      'usd',
      'euro',
      'eur',
      'dh',
      'mad',
      'dirham',
      'exchange',
      'rate',
      'taux'
    ],
    answer:
        'Amounts are stored in DH. In Settings > Currency choose DH, USD or EUR; values are converted for display. '
        'Tap Update rates (needs internet) to download live rates; otherwise approximate default rates are used.',
    targets: [InsightTarget.settings],
  ),
  HelpTopic(
    id: 'theme',
    title: 'Theme and appearance',
    keywords: [
      'theme',
      'dark',
      'light',
      'color',
      'colour',
      'style',
      'appearance',
      'mode sombre',
      'couleur',
      'rose',
      'midnight'
    ],
    answer:
        'Settings > Appearance: pick a style (Gold, Silver, Rose Gold, Midnight) and a mode (Dark, Light, or Auto to follow your phone).',
    targets: [InsightTarget.settings],
  ),
  HelpTopic(
    id: 'language',
    title: 'Language',
    keywords: [
      'language',
      'langue',
      'arabic',
      'french',
      'english',
      'arabe',
      'francais',
      'لغة'
    ],
    answer:
        'Settings > Language switches SPHERA to English, Français or العربية (Arabic reads right to left). '
        "Every screen, the assistant's answers, insights and notifications follow it. "
        'The assistant understands questions in all three languages.',
    targets: [InsightTarget.settings],
  ),
  HelpTopic(
    id: 'notifications',
    title: 'Notifications',
    keywords: [
      'notification',
      'notifications',
      'alert',
      'alerts',
      'reminder',
      'bell',
      'rappel',
      'daily summary',
      'push'
    ],
    answer:
        'The bell shows warnings (losses, duplicates, invalid emails, profit dropping) and reminders (stale FOR SALE '
        'listings, COMING boxes, goals behind pace). With phone notifications on, new alerts also appear on your phone, '
        'and a daily summary arrives at the time you choose. Configure it in Settings > Notifications.',
    targets: [InsightTarget.notifications, InsightTarget.notificationSettings],
  ),
  HelpTopic(
    id: 'profile',
    title: 'Profile, login and logout',
    keywords: [
      'profile',
      'profil',
      'login',
      'logout',
      'log out',
      'password',
      'sign in',
      'sign up',
      'photo profile',
      'mot de passe'
    ],
    answer:
        'The Profile tab shows your name, photo, rank, achievements and current session. Tap Edit profile to change '
        'name, email or photo. Log out is at the bottom; your accounts and games stay on the phone. '
        'Forgot password is on the login screen.',
  ),
  HelpTopic(
    id: 'assistant',
    title: 'About this assistant',
    keywords: [
      'who are you',
      'assistant',
      'ai',
      'claude',
      'chatbot',
      'intelligence',
      'api key',
      'offline'
    ],
    answer:
        'I am the SPHERA Assistant. Offline, I answer from your own data and from this app guide, with nothing leaving '
        'the phone. You can also turn on AI mode (tune icon) with your own Anthropic API key: then Claude answers any '
        'question, using a summary of your numbers (never emails, account IDs or notes).',
  ),
];

/// The frozen system prompt for Claude AI mode. It must not change between
/// requests of a conversation (live data goes in a separate message).
String buildSystemPrompt() {
  final b = StringBuffer()
    ..writeln('You are the SPHERA Assistant, built into the SPHERA mobile app. '
        'SPHERA helps one person manage Google Play accounts and gaming accounts they buy and sell '
        '(games such as eFootball, Free Fire, Clash of Clans, EA Sports FC), with prices, profit, statistics, smart tools and tournaments.')
    ..writeln()
    ..writeln('How to answer:')
    ..writeln(
        '- Reply in the language of the question (English, French, Arabic or Moroccan Darija).')
    ..writeln(
        '- Keep answers short and practical for a phone screen: a few sentences or a short list. No tables.')
    ..writeln(
        '- For questions about the user\'s own numbers, use only the latest <sphera_data> message. '
        'If the data does not contain the answer, say so instead of guessing.')
    ..writeln(
        '- Amounts in <sphera_data> are already in the user\'s display currency.')
    ..writeln(
        '- For "how do I" questions, explain the steps using the app guide below and name the screen to open.')
    ..writeln(
        '- You cannot change data in the app; tell the user where to tap instead.')
    ..writeln(
        '- You may also answer general questions (gaming, selling accounts, pricing advice), but say clearly when '
        'something is general advice rather than from SPHERA.')
    ..writeln()
    ..writeln('<app_guide>');
  for (final t in kHelpTopics) {
    b
      ..writeln('## ${t.title}')
      ..writeln(t.answer);
  }
  b.writeln('</app_guide>');
  return b.toString();
}

/// [t]'s answer in the app language, for the offline assistant. The English
/// [HelpTopic.answer] stays the source (and goes to Claude in AI mode); a
/// test checks that it matches the English translation.
String helpAnswer(HelpTopic t) => switch (t.id) {
      'about' => appL10n.helpAbout,
      'tabs' => appL10n.helpTabs,
      'orbit' => appL10n.helpOrbit,
      'google-add' => appL10n.helpGoogleAdd,
      'grades' => appL10n.helpGrades,
      'boxes' => appL10n.helpBoxes,
      'games' => appL10n.helpGames,
      'account-add' => appL10n.helpAccountAdd,
      'photos' => appL10n.helpPhotos,
      'privacy' => appL10n.helpPrivacy,
      'missing' => appL10n.helpMissing,
      'statuses' => appL10n.helpStatuses,
      'profit' => appL10n.helpProfit,
      'search' => appL10n.helpSearch,
      'trash' => appL10n.helpTrash,
      'stats' => appL10n.helpStats,
      'activity' => appL10n.helpActivity,
      'goals' => appL10n.helpGoals,
      'duplicates' => appL10n.helpDuplicates,
      'vault' => appL10n.helpVault,
      'security' => appL10n.helpSecurity,
      'arena' => appL10n.helpArena,
      'achievements' => appL10n.helpAchievements,
      'currency' => appL10n.helpCurrency,
      'theme' => appL10n.helpTheme,
      'language' => appL10n.helpLanguage,
      'notifications' => appL10n.helpNotifications,
      'profile' => appL10n.helpProfile,
      'assistant' => appL10n.helpAssistant,
      _ => t.answer,
    };
