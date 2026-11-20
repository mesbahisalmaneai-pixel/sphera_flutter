// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navHome => 'Accueil';

  @override
  String get navStats => 'Stats';

  @override
  String get navOrbit => 'Orbit';

  @override
  String get navCards => 'Cartes';

  @override
  String get navProfile => 'Profil';

  @override
  String get askSphera => 'Demander à SPHERA';

  @override
  String get settings => 'Paramètres';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get forSale => 'À vendre';

  @override
  String get addAccount => 'Ajouter un compte';

  @override
  String get searchAccount => 'Chercher un compte';

  @override
  String get manageGames => 'Gérer les jeux';

  @override
  String get netProfit => 'Bénéfice net';

  @override
  String vsLastMonth(String arrow, String pct) {
    return '$arrow $pct % vs mois dernier';
  }

  @override
  String thisMonthAmount(String amount) {
    return 'Ce mois-ci $amount';
  }

  @override
  String get totalAccounts => 'Total des comptes';

  @override
  String get noneAddedThisMonth => 'Aucun ajouté ce mois-ci';

  @override
  String addedThisMonth(int count) {
    return '+$count ce mois-ci';
  }

  @override
  String get activeAccounts => 'Comptes actifs';

  @override
  String get noAccountsYet => 'Aucun compte pour l\'instant';

  @override
  String percentOfTotal(int pct) {
    return '$pct % du total';
  }

  @override
  String get nothingListed => 'Rien en vente';

  @override
  String get listedNoPrice => 'En vente, sans prix';

  @override
  String get sold => 'Vendus';

  @override
  String get performance => 'Performance';

  @override
  String get profitByDateAdded => 'Bénéfice par date d\'ajout';

  @override
  String get daily => 'Jour';

  @override
  String get weekly => 'Semaine';

  @override
  String get monthly => 'Mois';

  @override
  String accountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes',
      one: '1 compte',
      zero: '0 compte',
    );
    return '$_temp0';
  }

  @override
  String gamesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jeux',
      one: '1 jeu',
      zero: '0 jeu',
    );
    return '$_temp0';
  }

  @override
  String weekOf(String date) {
    return 'Semaine du $date';
  }

  @override
  String get noAccountsInPeriod => 'Aucun compte ajouté sur cette période';

  @override
  String get actionAdded => 'Ajouté';

  @override
  String get actionUpdated => 'Modifié';

  @override
  String get actionStatusChanged => 'Statut modifié';

  @override
  String get actionMovedToTrash => 'Mis à la corbeille';

  @override
  String get actionRestored => 'Restauré';

  @override
  String get actionDeleted => 'Supprimé';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minutesAgo(int count) {
    return 'il y a $count min';
  }

  @override
  String hoursAgo(int count) {
    return 'il y a $count h';
  }

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get noActivityYet =>
      'Aucune activité pour l\'instant.\nVos actions apparaîtront ici.';

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get viewAll => 'Tout voir';

  @override
  String get statistics => 'Statistiques';

  @override
  String get analyticsCenter => 'Centre d\'analyse';

  @override
  String get profitCenter => 'Centre des bénéfices';

  @override
  String get profitCenterSub =>
      'Ventes, dépenses, prix d\'achat et de vente, bénéfice net';

  @override
  String get activityCenter => 'Centre d\'activité';

  @override
  String get activityCenterSub => 'Historique, filtre par date et par type';

  @override
  String get performanceCenter => 'Centre de performance';

  @override
  String get performanceCenterSub => 'Jour, semaine, mois et objectifs';

  @override
  String get spheraIntelligence => 'SPHERA Intelligence';

  @override
  String get spheraIntelligenceSub => 'Analyse hors ligne de vos comptes';

  @override
  String get gradeStatistics => 'Statistiques des grades';

  @override
  String get gradeStatisticsSub =>
      'Bronze, Argent, Or, Platine, Diamant et Interdit';

  @override
  String get statusStatistics => 'Statistiques des statuts';

  @override
  String get statusStatisticsSub =>
      'Boîtes Google et comptes de jeu, chacun séparément';

  @override
  String get gamesStatistics => 'Statistiques des jeux';

  @override
  String get gamesStatisticsSub => 'Bénéfice, nombre et statut par jeu';

  @override
  String get cards => 'Cartes';

  @override
  String get googlePlayAccounts => 'Comptes Google Play';

  @override
  String get googlePlayAccountsSub => 'Grades et boîtes de jeux';

  @override
  String get games => 'Jeux';

  @override
  String get gamesSub => 'Inventaire des comptes de jeu';

  @override
  String get statisticsSub => 'Bénéfice, nombres et statuts';

  @override
  String get toolsSettings => 'Outils et paramètres';

  @override
  String get toolsSettingsSub => 'Sauvegarde, corbeille, profil';

  @override
  String get manage => 'Gérer';

  @override
  String get arenaTitle => 'SPHERA TOURNAMENT ARENA';

  @override
  String get arenaSub => 'Ligues, groupes et phases finales';

  @override
  String get createOne => 'En créer un';

  @override
  String tournamentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournois',
      one: '1 tournoi',
    );
    return '$_temp0';
  }

  @override
  String get achievements => 'Succès';

  @override
  String get achievementsSub => 'Badges et étapes';

  @override
  String achievementsUnlocked(int done, int total) {
    return '$done / $total débloqués';
  }

  @override
  String get smartTools => 'Outils intelligents';

  @override
  String get duplicateScanner => 'Détecteur de doublons';

  @override
  String get duplicateScannerSub =>
      'Trouver les comptes en double, à vérifier vous-même';

  @override
  String get noDuplicates => 'Aucun doublon';

  @override
  String toReview(int count) {
    return '$count à vérifier';
  }

  @override
  String get smartOrganizer => 'Organiseur intelligent';

  @override
  String get smartOrganizerSub => 'Chercher, filtrer et trier les comptes';

  @override
  String get smartOrganizerSummary => 'Par jeu, statut, grade et date';

  @override
  String get inventoryVault => 'Coffre d\'inventaire';

  @override
  String get inventoryVaultSub => 'Comptes favoris, rares et de grande valeur';

  @override
  String inVault(int count) {
    return '$count dans le coffre';
  }

  @override
  String get securityCenter => 'Centre de sécurité';

  @override
  String get securityCenterSub =>
      'Santé des données, sauvegarde et synchronisation';

  @override
  String get allGood => 'Tout va bien';

  @override
  String get language => 'Langue';

  @override
  String get profileSecurity => 'Profil et sécurité';

  @override
  String get localMode => 'Mode local';

  @override
  String get localModeSub =>
      'Non connecté. Vos données sont enregistrées sur cet appareil uniquement. La connexion au compte et la synchronisation cloud ne sont pas encore disponibles.';

  @override
  String get protectionPrivacy => 'Protection et confidentialité';

  @override
  String get appearance => 'Apparence';

  @override
  String get mode => 'Mode';

  @override
  String get dark => 'Sombre';

  @override
  String get light => 'Clair';

  @override
  String get auto => 'Auto';

  @override
  String get style => 'Style';

  @override
  String get autoFollowsPhone =>
      'Auto suit le réglage sombre / clair de votre téléphone.';

  @override
  String get notifications => 'Notifications';

  @override
  String get off => 'Désactivées';

  @override
  String get onRemindersOn => 'Activées · Rappels activés';

  @override
  String get onRemindersOff => 'Activées · Rappels désactivés';

  @override
  String get currency => 'Devise';

  @override
  String get data => 'Données';

  @override
  String get trash => 'Corbeille';

  @override
  String get empty => 'Vide';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
    );
    return '$_temp0';
  }

  @override
  String get storedItems => 'Éléments et biens enregistrés';

  @override
  String get aboutSphera => 'À propos de SPHERA';

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get aboutText =>
      'Comptes Google Play, comptes de jeu, prix et statistiques au même endroit.';

  @override
  String get ratesUpdated => 'Taux de change mis à jour.';

  @override
  String get dhIsBase =>
      'Le DH est la devise de base : les montants sont enregistrés en DH.';

  @override
  String liveRate(String when) {
    return 'Taux en direct, mis à jour le $when';
  }

  @override
  String get approximateRate =>
      'Taux approximatif, pas encore en direct. Appuyez sur « Mettre à jour les taux » une fois en ligne.';

  @override
  String get conversionNote =>
      'Chaque prix est converti à ce taux pour l\'affichage, et ce que vous saisissez est reconverti en DH à l\'enregistrement.';

  @override
  String get updateRates => 'Mettre à jour les taux';

  @override
  String get authNeedHelp => 'Besoin d\'aide ?';

  @override
  String get authHelpBody =>
      'Nouveau ? Choisissez « Créer un nouveau compte ».\n\nDéjà inscrit sur cet appareil ? Choisissez « J\'ai déjà un compte ».\n\nImpossible de vous connecter ? Utilisez « J\'ai un problème de connexion et de mot de passe ».';

  @override
  String get gotIt => 'Compris';

  @override
  String get cancel => 'Annuler';

  @override
  String get back => 'Retour';

  @override
  String get help => 'Aide';

  @override
  String get authVerifyUnavailableTitle =>
      'La vérification n\'est pas encore disponible';

  @override
  String get authVerifyUnavailableBody =>
      'Les codes par e-mail ou SMS nécessitent un service en ligne, qui n\'est pas encore relié à SPHERA.\n\nVous pouvez plutôt réinitialiser la connexion sur cet appareil et en créer une nouvelle. Vos comptes, jeux et statistiques sont conservés.\n\nCette connexion protège seulement l\'accès occasionnel à l\'application sur cet appareil.';

  @override
  String get authResetLogin => 'Réinitialiser la connexion';

  @override
  String get authOops => 'Oups !';

  @override
  String get authHintEmailOrPhone => 'e-mail ou numéro de téléphone';

  @override
  String get authHintCode => 'code de validation';

  @override
  String get authLogin => 'Connexion';

  @override
  String get authEnterUserAndPassword =>
      'Saisissez votre nom d\'utilisateur et votre mot de passe.';

  @override
  String get authWelcomeTitle => 'BIENVENUE !';

  @override
  String get authHintUsername => 'nom d\'utilisateur';

  @override
  String get authHintPassword => 'mot de passe';

  @override
  String get authForgotPassword => 'mot de passe oublié ?';

  @override
  String get authProfilePhotoOptional => 'Photo de profil (facultatif)';

  @override
  String get authHintChooseUsername => 'choisissez un nom d\'utilisateur';

  @override
  String get authHintCreatePassword => 'créez un mot de passe';

  @override
  String get authHintConfirmPassword => 'confirmez votre mot de passe';

  @override
  String get authConfirmInfo =>
      'Je confirme que mes informations sont correctes';

  @override
  String get authCreateAccount => 'Créer le compte';

  @override
  String get authYourAge => 'votre âge';

  @override
  String get authHelloTitle => 'BONJOUR !';

  @override
  String get authCreateNewAccount => 'Créer un nouveau compte';

  @override
  String get authHaveAccount => 'J\'ai déjà un compte';

  @override
  String get authLoginProblem =>
      'J\'ai un problème de connexion et de mot de passe';

  @override
  String get valEnterIdentifier =>
      'Saisissez votre e-mail ou votre numéro de téléphone';

  @override
  String get valInvalidIdentifier =>
      'Saisissez un e-mail ou un numéro de téléphone valide';

  @override
  String get valChooseUsername => 'Choisissez un nom d\'utilisateur';

  @override
  String get valUsernameRule => '3 à 20 caractères : lettres, chiffres, _ ou .';

  @override
  String get valCreatePassword => 'Créez un mot de passe';

  @override
  String get valPasswordLength => 'Au moins 8 caractères';

  @override
  String get valPasswordMix => 'Utilisez des lettres et des chiffres';

  @override
  String get valConfirmPassword => 'Confirmez votre mot de passe';

  @override
  String get valPasswordsMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String valMinAge(int age) {
    return 'SPHERA est réservé aux personnes de $age ans et plus';
  }

  @override
  String get valInvalidAge => 'Saisissez un âge valide';

  @override
  String get authErrAccountExists =>
      'Un compte existe déjà sur cet appareil. Connectez-vous plutôt.';

  @override
  String get authErrWrongCredentials =>
      'Nom d\'utilisateur ou mot de passe incorrect.';

  @override
  String get authNoCode => 'Je n\'ai pas reçu le code de vérification';

  @override
  String get boxEmpty => 'VIDE';

  @override
  String get boxDone => 'FAIT';

  @override
  String get boxNotYet => 'PAS ENCORE';

  @override
  String get boxComing => 'BIENTÔT';

  @override
  String get gradeBronze => 'Bronze';

  @override
  String get gradeSilver => 'Argent';

  @override
  String get gradeGold => 'Or';

  @override
  String get gradePlatinum => 'Platine';

  @override
  String get gradeDiamond => 'Diamant';

  @override
  String get gradeInterdit => 'Interdit';

  @override
  String get statusActive => 'ACTIF';

  @override
  String get statusSold => 'VENDU';

  @override
  String get statusForSale => 'À VENDRE';

  @override
  String get done => 'Terminé';

  @override
  String couldNotSave(String error) {
    return 'Enregistrement impossible : $error';
  }

  @override
  String errDuplicateEmail(String email) {
    return 'Un compte Google avec $email existe déjà.';
  }

  @override
  String errDuplicateGame(String name) {
    return 'Un jeu nommé « $name » existe déjà.';
  }

  @override
  String get editGoogleAccount => 'Modifier le compte Google';

  @override
  String get addGoogleAccount => 'Ajouter un compte Google';

  @override
  String get email => 'E-mail';

  @override
  String get emailRequired => 'L\'e-mail est obligatoire';

  @override
  String get emailInvalid => 'Saisissez une adresse e-mail valide';

  @override
  String get grade => 'Grade';

  @override
  String get gameBoxes => 'Boîtes de jeux';

  @override
  String get saveChanges => 'Enregistrer';

  @override
  String get addAccountShort => 'Ajouter le compte';

  @override
  String movedToTrash(String name) {
    return '$name mis à la corbeille';
  }

  @override
  String get undo => 'ANNULER';

  @override
  String get manageGamesLower => 'Gérer les jeux';

  @override
  String couldNotLoadAccounts(String error) {
    return 'Impossible de charger les comptes : $error';
  }

  @override
  String get searchByEmail => 'Rechercher par e-mail';

  @override
  String get allGrades => 'Tous les grades';

  @override
  String get anyStatus => 'Tous les statuts';

  @override
  String boxesSet(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boîtes définies',
      one: '1 boîte définie',
      zero: '0 boîte définie',
    );
    return '$_temp0';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get moveToTrash => 'Mettre à la corbeille';

  @override
  String get setBoxes => 'Définir les boîtes';

  @override
  String get box => 'Boîte';

  @override
  String get noAccountMatches => 'Aucun compte ne correspond à vos filtres';

  @override
  String get noGoogleAccountsYet => 'Aucun compte Google pour l\'instant';

  @override
  String get addFirstAccount => 'Ajoutez votre premier compte';

  @override
  String get enterGameName => 'Saisissez un nom de jeu';

  @override
  String couldNotAddGame(String error) {
    return 'Impossible d\'ajouter le jeu : $error';
  }

  @override
  String removeGameTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String removeGameWithAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes de jeu',
      one: '1 compte de jeu',
    );
    return '$name a $_temp0. Ils sont conservés, mais le jeu et ses boîtes seront masqués des listes.';
  }

  @override
  String get removeGameNoAccounts =>
      'Le jeu et ses boîtes seront masqués des listes.';

  @override
  String get remove => 'Retirer';

  @override
  String get newGameName => 'Nom du nouveau jeu';

  @override
  String get add => 'Ajouter';

  @override
  String get removeGame => 'Retirer le jeu';

  @override
  String get accountNoLongerAvailable => 'Ce compte n\'est plus disponible';

  @override
  String couldNotSetPhoto(String error) {
    return 'Impossible de définir la photo : $error';
  }

  @override
  String get changePhoto => 'Changer la photo';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get game => 'Jeu';

  @override
  String get removedGame => 'Jeu retiré';

  @override
  String get idCompte => 'ID compte';

  @override
  String get purchasePrice => 'Prix d\'achat';

  @override
  String get salePrice => 'Prix de vente';

  @override
  String get profit => 'Bénéfice';

  @override
  String get loss => 'Perte';

  @override
  String get enterNumber => 'Saisissez un nombre';

  @override
  String get mustBeZeroOrMore => 'Doit être supérieur ou égal à 0';

  @override
  String get chooseGame => 'Choisissez un jeu';

  @override
  String get editAccount => 'Modifier le compte';

  @override
  String get idCompteRequired => 'L\'ID compte est obligatoire';

  @override
  String get accountName => 'Nom du compte';

  @override
  String get nameRequired => 'Le nom est obligatoire';

  @override
  String get status => 'Statut';

  @override
  String get notesOptional => 'Notes (facultatif)';

  @override
  String get noAccountsYetShort => 'Aucun compte pour l\'instant';

  @override
  String get gameName => 'Nom du jeu';

  @override
  String get save => 'Enregistrer';

  @override
  String get addGame => 'Ajouter un jeu';

  @override
  String get renameGame => 'Renommer le jeu';

  @override
  String couldNotSetImage(String error) {
    return 'Impossible de définir l\'image : $error';
  }

  @override
  String removeGameKeepsAccounts(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes',
      one: '1 compte',
    );
    return '$name a $_temp0. Ils sont conservés, mais le jeu est masqué des listes.';
  }

  @override
  String get removeGameHidden => 'Le jeu sera masqué des listes.';

  @override
  String get noGamesYet => 'Aucun jeu pour l\'instant';

  @override
  String get rename => 'Renommer';

  @override
  String get changeGameImage => 'Changer l\'image du jeu';

  @override
  String get changeAccountPhoto => 'Changer la photo des comptes';

  @override
  String get resetImages => 'Réinitialiser les images';

  @override
  String get today => 'aujourd\'hui';

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String accountsForSaleList(int count) {
    return 'Comptes à vendre ($count) :';
  }

  @override
  String get listCopied => 'Liste copiée (sans les prix)';

  @override
  String forSaleCount(int count) {
    return 'À vendre ($count)';
  }

  @override
  String get copyListNoPrices => 'Copier la liste sans les prix';

  @override
  String get nothingForSale =>
      'Rien n\'est en vente.\nOuvrez un compte et choisissez « Mettre en vente ».';

  @override
  String get listed => 'En vente';

  @override
  String gamesWord(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jeux',
      one: 'Jeu',
    );
    return '$_temp0';
  }

  @override
  String get longestWait => 'Attente la plus longue';

  @override
  String get searchNameIdGame => 'Rechercher un nom, un ID ou un jeu';

  @override
  String allCount(int count) {
    return 'Tous ($count)';
  }

  @override
  String get noMatch => 'Aucun résultat';

  @override
  String waitingFor(String time) {
    return 'en attente depuis $time';
  }

  @override
  String get searchAccounts => 'Rechercher des comptes';

  @override
  String get clear => 'Effacer';

  @override
  String noAccountFoundFor(String query) {
    return 'Aucun compte trouvé pour « $query »';
  }

  @override
  String marginPct(String pct) {
    return 'marge de $pct %';
  }

  @override
  String get salesSalePrice => 'Ventes (prix de vente)';

  @override
  String get expensesPurchasePrice => 'Dépenses (prix d\'achat)';

  @override
  String get perGame => 'Par jeu';

  @override
  String salesAndExpenses(String sales, String expenses) {
    return 'Ventes $sales · Dépenses $expenses';
  }

  @override
  String get topProfit => 'Meilleurs bénéfices';

  @override
  String get losses => 'Pertes';

  @override
  String get todayCap => 'Aujourd\'hui';

  @override
  String get typeGoogle => 'Google';

  @override
  String get typeGaming => 'Jeux';

  @override
  String get typeGames => 'Liste des jeux';

  @override
  String get typeSystem => 'Système';

  @override
  String get last7Days => '7 jours';

  @override
  String get last30Days => '30 jours';

  @override
  String get allTypes => 'Tous les types';

  @override
  String get noActivityFromNow =>
      'Aucune activité pour l\'instant.\nVos prochaines actions apparaîtront ici.';

  @override
  String perfAddedVsPrev(int added, int prev, String prevLabel) {
    return '$added ajoutés · $prev $prevLabel';
  }

  @override
  String perfSameProfit(String prevLabel) {
    return 'Bénéfice identique ($prevLabel)';
  }

  @override
  String perfVsPrev(String amount, String prevLabel) {
    return '$amount vs $prevLabel';
  }

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get prevYesterday => 'hier';

  @override
  String get prevLastWeek => 'la semaine dernière';

  @override
  String get prevLastMonth => 'le mois dernier';

  @override
  String get goalReached => 'Atteint';

  @override
  String get goalOnTrack => 'En bonne voie';

  @override
  String get goalBehind => 'En retard';

  @override
  String goalProgress(String current, String target, String pct) {
    return '$current sur $target · $pct %';
  }

  @override
  String get performanceCenterTitle => 'Centre de performance';

  @override
  String get monthlyGoals => 'Objectifs mensuels';

  @override
  String get setGoals => 'Définir des objectifs';

  @override
  String get noGoalsYet =>
      'Aucun objectif pour l\'instant. Fixez un objectif mensuel de bénéfice ou de comptes pour suivre votre rythme.';

  @override
  String get accountsAdded => 'Comptes ajoutés';

  @override
  String get highlights => 'Points forts';

  @override
  String get addStreak => 'Série d\'ajouts';

  @override
  String get addStreakSub => 'Jours d\'affilée avec un nouveau compte';

  @override
  String get bestDay30 => 'Meilleur jour (30 jours)';

  @override
  String get bestWeek12 => 'Meilleure semaine (12 semaines)';

  @override
  String get bestMonth12 => 'Meilleur mois (12 mois)';

  @override
  String get perfNote =>
      'Les comptes comptent dans la période où ils ont été ajoutés. Les comptes À VENDRE n\'ont pas encore de bénéfice.';

  @override
  String profitGoalCurrency(String currency) {
    return 'Objectif de bénéfice ($currency)';
  }

  @override
  String get emptyNoGoal => 'Vide = pas d\'objectif';

  @override
  String get accountsToAdd => 'Comptes à ajouter';

  @override
  String googleAccountsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes Google',
      one: '1 compte Google',
      zero: '0 compte Google',
    );
    return '$_temp0';
  }

  @override
  String get googlePlayBoxes => 'Boîtes Google Play';

  @override
  String get gamingAccounts => 'Comptes de jeu';

  @override
  String get totalProfitLoss => 'Bénéfice / perte total';

  @override
  String get pricePerGame => 'Prix par jeu';

  @override
  String accountsIncluded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes inclus',
      one: '1 compte inclus',
      zero: '0 compte inclus',
    );
    return '$_temp0';
  }

  @override
  String get accountsPerGame => 'Nombre de comptes par jeu';

  @override
  String get statusPerGame => 'Statut des comptes par jeu';

  @override
  String get noAccountsInGrade => 'Aucun compte dans ce grade';

  @override
  String get noAccounts => 'Aucun compte';

  @override
  String get nothingHere => 'Rien ici';

  @override
  String get howMatchingWorks => 'Comment fonctionne la détection';

  @override
  String get matchingRules =>
      'Comptes Google : même e-mail (sans tenir compte des majuscules, des espaces et, pour Gmail, des points et des « +tags »).\nComptes de jeu : même ID compte dans le même jeu.\nLa détection par téléphone n\'est pas disponible : les numéros ne sont pas encore enregistrés.';

  @override
  String get nothingMergedAutomatically =>
      'Rien n\'est supprimé ni fusionné automatiquement. Vous vérifiez chaque compte vous-même.';

  @override
  String get noDuplicatesFound => 'Aucun doublon trouvé';

  @override
  String get googleAccountsSection => 'Comptes Google';

  @override
  String get gameAccountsSection => 'Comptes de jeu';

  @override
  String showDismissedAgain(int count) {
    return 'Réafficher les $count écartés';
  }

  @override
  String get markedNotDuplicates => 'Marqués comme non-doublons';

  @override
  String similarAccounts(int count) {
    return '$count comptes similaires';
  }

  @override
  String addedOn(String date) {
    return 'ajouté le $date';
  }

  @override
  String get openToReview => 'Ouvrir pour vérifier';

  @override
  String get notDuplicates => 'Pas des doublons';

  @override
  String accountsWithId(int count, String id) {
    return '$count comptes avec l\'ID $id';
  }

  @override
  String get unknownGame => 'Jeu inconnu';

  @override
  String buySell(String buy, String sell) {
    return 'achat $buy → vente $sell';
  }

  @override
  String get openGame => 'Ouvrir le jeu';

  @override
  String saleAmount(String amount) {
    return 'vente $amount';
  }

  @override
  String get addToVault => 'Ajouter au coffre';

  @override
  String get all => 'Tous';

  @override
  String get vaultEmpty => 'Votre coffre est vide';

  @override
  String get nothingWithTag => 'Rien avec cette étiquette';

  @override
  String get vaultHint =>
      'Appuyez sur « Ajouter au coffre » pour marquer les comptes favoris, rares ou de grande valeur.';

  @override
  String get search => 'Rechercher';

  @override
  String get highestSaleFirst => 'Prix de vente le plus élevé d\'abord';

  @override
  String get noAccount => 'Aucun compte';

  @override
  String get tagFavorite => 'Favori';

  @override
  String get tagRare => 'Rare';

  @override
  String get tagHighValue => 'Grande valeur';

  @override
  String get everythingGood => 'Tout semble en ordre';

  @override
  String itemsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments à vérifier',
      one: '1 élément à vérifier',
    );
    return '$_temp0';
  }

  @override
  String get basedOnDeviceData =>
      'D\'après les données enregistrées sur cet appareil.';

  @override
  String get dataHealth => 'Santé des données';

  @override
  String get duplicateAccounts => 'Comptes en double';

  @override
  String get noneFound => 'Aucun';

  @override
  String groupsToReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count groupes à vérifier',
      one: '1 groupe à vérifier',
    );
    return '$_temp0';
  }

  @override
  String get duplicateGameIds => 'ID compte de jeu en double';

  @override
  String get accountsWithoutId => 'Comptes de jeu sans ID compte';

  @override
  String get allHaveId => 'Tous ont un ID compte';

  @override
  String accountsMissingId(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes sans ID',
      one: '1 compte sans ID',
    );
    return '$_temp0';
  }

  @override
  String get invalidEmails => 'E-mails invalides';

  @override
  String get allEmailsValid => 'Tous les e-mails semblent valides';

  @override
  String accountsWrongEmail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes avec un e-mail mal formé',
      one: '1 compte avec un e-mail mal formé',
    );
    return '$_temp0';
  }

  @override
  String get accountsNoBoxes => 'Comptes sans boîte définie';

  @override
  String justInformational(int count) {
    return '$count (à titre indicatif)';
  }

  @override
  String get itemsInTrash => 'Éléments dans la corbeille';

  @override
  String trashKept(int count) {
    return '$count conservés, rien n\'est supprimé automatiquement';
  }

  @override
  String get protection => 'Protection';

  @override
  String get appLock => 'Verrouillage de l\'application';

  @override
  String get notEnabledYet => 'Pas encore activé';

  @override
  String get localStorage => 'Stockage local';

  @override
  String get dataStaysOnDevice => 'Vos données restent sur cet appareil';

  @override
  String get backup => 'Sauvegarde';

  @override
  String get noBackupYet =>
      'Aucune sauvegarde. La sauvegarde n\'est pas disponible dans cette version.';

  @override
  String get syncStatus => 'Synchronisation';

  @override
  String get cloudSync => 'Synchronisation cloud';

  @override
  String get localOnly =>
      'Local uniquement. La synchronisation n\'est pas encore connectée.';

  @override
  String get safetyRules => 'Règles de sécurité';

  @override
  String get noAutoDeletion => 'Aucune suppression automatique';

  @override
  String get nothingDeletedWithoutYou => 'Rien n\'est supprimé sans vous';

  @override
  String get noAutoMerging => 'Aucune fusion automatique';

  @override
  String get neverMerge =>
      'L\'analyse et le tri ne fusionnent jamais de comptes';

  @override
  String get manualReviewFirst => 'Vérification manuelle d\'abord';

  @override
  String get changesByYou =>
      'Chaque modification est faite par vous, après vérification';

  @override
  String get sortRecentActivity => 'Activité récente';

  @override
  String get sortOldestActivity => 'Activité la plus ancienne';

  @override
  String get sortNewestAdded => 'Ajoutés récemment';

  @override
  String get sortOldestAdded => 'Ajoutés en premier';

  @override
  String get sortEmailAz => 'E-mail A–Z';

  @override
  String get sortEmailZa => 'E-mail Z–A';

  @override
  String get sortGrade => 'Grade';

  @override
  String get sortNewest => 'Plus récents';

  @override
  String get sortOldest => 'Plus anciens';

  @override
  String get sortSaleHigh => 'Prix de vente le plus élevé';

  @override
  String get sortSaleLow => 'Prix de vente le plus bas';

  @override
  String get sortBuyHigh => 'Prix d\'achat le plus élevé';

  @override
  String get sortNameAz => 'Nom A–Z';

  @override
  String get sort => 'Trier';

  @override
  String get searchByNameOrId => 'Rechercher par nom ou ID compte';

  @override
  String get allGames => 'Tous les jeux';

  @override
  String shownOfTotal(int shown, int total) {
    return '$shown sur $total comptes';
  }

  @override
  String sortedBy(String sort) {
    return 'Tri : $sort';
  }

  @override
  String get noAccountMatchesShort => 'Aucun compte correspondant';

  @override
  String get noActivity => 'aucune activité';

  @override
  String get emptyTrashTitle => 'Vider la corbeille ?';

  @override
  String emptyTrashBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Les $count éléments seront supprimés définitivement. Cette action est irréversible.',
      one:
          '1 élément sera supprimé définitivement. Cette action est irréversible.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAll => 'Tout supprimer';

  @override
  String get emptyAction => 'Vider';

  @override
  String googleTabCount(int count) {
    return 'Google ($count)';
  }

  @override
  String gamesTabCount(int count) {
    return 'Jeux ($count)';
  }

  @override
  String googleAccountDeleted(String grade, String when) {
    return 'Compte Google · $grade\nSupprimé le $when';
  }

  @override
  String deletedWhen(String when) {
    return 'Supprimé le $when';
  }

  @override
  String get removedSuffix => ' (retiré)';

  @override
  String get restore => 'Restaurer';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get deletePermanentlyTitle => 'Supprimer définitivement ?';

  @override
  String deletedForGood(String name) {
    return '$name sera supprimé définitivement. Cette action est irréversible.';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get trashIsEmpty => 'La corbeille est vide';

  @override
  String get phoneNotifsMobileOnly =>
      'Les notifications du téléphone fonctionnent uniquement sur Android et iOS.';

  @override
  String get notifsBlocked =>
      'Les notifications sont bloquées pour SPHERA. Autorisez-les dans les réglages du téléphone, puis réessayez.';

  @override
  String get notifsSub => 'Alertes et rappels dans SPHERA';

  @override
  String get reminders => 'Rappels';

  @override
  String get remindersSub =>
      'Annonces À VENDRE anciennes, boîtes BIENTÔT, objectifs en retard';

  @override
  String get alertsNote =>
      'Les alertes apparaissent toujours dans le centre de notifications (icône cloche), avec un compteur rouge.';

  @override
  String get phoneNotifications => 'Notifications du téléphone';

  @override
  String get phoneNotificationsSub =>
      'Afficher les nouvelles alertes sur le téléphone quand vous quittez l\'application';

  @override
  String get dailySummary => 'Résumé quotidien';

  @override
  String get dailySummarySub =>
      'Alertes, bénéfice net et comptes, une fois par jour';

  @override
  String get summaryTime => 'Heure du résumé';

  @override
  String get sendTestNotification => 'Envoyer une notification de test';

  @override
  String get phoneNotifsNote =>
      'Les notifications sont créées sur cet appareil, sans compte ni internet. Le résumé quotidien peut arriver avec quelques minutes de retard pour économiser la batterie. Certains téléphones (Xiaomi, Huawei...) bloquent les notifications en arrière-plan si SPHERA n\'est pas autorisé dans les réglages de batterie.';

  @override
  String get notificationSettings => 'Réglages des notifications';

  @override
  String get notifsOff => 'Les notifications sont désactivées';

  @override
  String get turnOnInSettings =>
      'Activez-les dans les réglages des notifications.';

  @override
  String get allClear => 'Tout est en ordre';

  @override
  String get noWarningsNow => 'Aucune alerte ni aucun rappel pour l\'instant.';

  @override
  String get remindersMuted =>
      'Les rappels sont coupés dans les réglages des notifications.';

  @override
  String notificationsNew(int count) {
    return 'Notifications ($count nouvelles)';
  }

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get removePhoto => 'Retirer la photo';

  @override
  String get logOutTitle => 'Se déconnecter ?';

  @override
  String get logOutBody =>
      'Vous devrez vous reconnecter. Votre profil, vos comptes, jeux et statistiques restent sur cet appareil.';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get profileTitle => 'Profil';

  @override
  String get spheraUser => 'Utilisateur SPHERA';

  @override
  String rankPts(String rank, int points) {
    return '$rank · $points pts';
  }

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get activitySummary => 'Résumé d\'activité';

  @override
  String get googleAccountsLabel => 'Comptes Google';

  @override
  String get gameAccountsLabel => 'Comptes de jeu';

  @override
  String get profitLoss => 'Bénéfice / perte';

  @override
  String get rank => 'Rang';

  @override
  String rankName(String rank) {
    return 'Rang : $rank';
  }

  @override
  String rankPoints(int points) {
    return '$points points de rang';
  }

  @override
  String get topRankReached => 'Rang maximum atteint';

  @override
  String ptsToRank(int points, String rank) {
    return '$points pts avant $rank';
  }

  @override
  String unlockedOfTotal(int done, int total) {
    return '$done / $total débloqués';
  }

  @override
  String get allAchievementsUnlocked => 'Tous les succès sont débloqués.';

  @override
  String fraction(int a, int b) {
    return '$a / $b';
  }

  @override
  String get session => 'Session';

  @override
  String get currentSession => 'Session actuelle';

  @override
  String startedAt(String time) {
    return 'Commencée à $time';
  }

  @override
  String get dataOnDeviceOnly =>
      'Vos données sont enregistrées uniquement sur cet appareil.';

  @override
  String get name => 'Nom';

  @override
  String get profilePhotosPhoneOnly =>
      'Les photos de profil fonctionnent dans l\'application mobile, pas dans le navigateur.';

  @override
  String achievementPoints(int earned, int total) {
    return '$earned / $total points de succès';
  }

  @override
  String get achievementPointsNote =>
      'Les points de succès sont distincts des points de rang et des grades Google Play.';

  @override
  String get unlocked => 'Débloqués';

  @override
  String get inProgress => 'En cours';

  @override
  String get locked => 'Verrouillés';

  @override
  String get nothingHereYet => 'Rien ici pour l\'instant';

  @override
  String get achievementDatesNote =>
      'Les dates indiquent quand un succès a été détecté pour la première fois sur cet appareil. Les montants de bénéfice sont comptés en DH.';

  @override
  String unlockCondition(String condition) {
    return 'Pour débloquer : $condition';
  }

  @override
  String unlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String plusPts(int points) {
    return '+$points pts';
  }

  @override
  String progressPct(int a, int b, int pct) {
    return '$a / $b  ·  $pct %';
  }

  @override
  String get catAccounts => 'Comptes';

  @override
  String get catGames => 'Jeux';

  @override
  String get catSales => 'Ventes';

  @override
  String get catProfits => 'Bénéfices';

  @override
  String get catOrganization => 'Organisation';

  @override
  String get achAcc1 => 'Premier compte';

  @override
  String get achAcc1Desc => 'Ajoutez votre premier compte Google.';

  @override
  String get achAcc10 => 'Collectionneur';

  @override
  String get achAcc10Desc => 'Avoir 10 comptes Google.';

  @override
  String get achAcc25 => 'Grande collection';

  @override
  String get achAcc25Desc => 'Avoir 25 comptes Google.';

  @override
  String get achGacc10 => 'Comptes de jeu x10';

  @override
  String get achGacc10Desc => 'Avoir 10 comptes de jeu.';

  @override
  String get achGacc50 => 'Comptes de jeu x50';

  @override
  String get achGacc50Desc => 'Avoir 50 comptes de jeu.';

  @override
  String get achGacc100 => 'Comptes de jeu x100';

  @override
  String get achGacc100Desc => 'Avoir 100 comptes de jeu.';

  @override
  String get achGame1 => 'Premier jeu';

  @override
  String get achGame1Desc => 'Ajoutez votre premier jeu.';

  @override
  String get achGame5 => 'Étagère de jeux';

  @override
  String get achGame5Desc => 'Avoir 5 jeux.';

  @override
  String get achGame10 => 'Ludothèque';

  @override
  String get achGame10Desc => 'Avoir 10 jeux.';

  @override
  String get achSell1 => 'Première vente';

  @override
  String get achSell1Desc => 'Marquez votre premier compte comme VENDU.';

  @override
  String get achSell10 => 'Vendeur';

  @override
  String get achSell10Desc => 'Avoir 10 comptes marqués VENDU.';

  @override
  String get achSell50 => 'Grand vendeur';

  @override
  String get achSell50Desc => 'Avoir 50 comptes marqués VENDU.';

  @override
  String get achProfit1 => 'En bénéfice';

  @override
  String get achProfit1Desc => 'Atteignez un bénéfice total positif.';

  @override
  String get achProfit1k => '1 000 DH de bénéfice';

  @override
  String get achProfit1kDesc => 'Atteignez 1 000 DH de bénéfice total.';

  @override
  String get achProfit10k => '10 000 DH de bénéfice';

  @override
  String get achProfit10kDesc => 'Atteignez 10 000 DH de bénéfice total.';

  @override
  String get achProfitGames3 => 'Jeux gagnants';

  @override
  String get achProfitGames3Desc => 'Avoir 3 jeux avec un bénéfice positif.';

  @override
  String get achBoxes10 => 'Organisé';

  @override
  String get achBoxes10Desc => 'Définissez 10 boîtes de jeux (pas VIDE).';

  @override
  String get achBoxes50 => 'Très organisé';

  @override
  String get achBoxes50Desc => 'Définissez 50 boîtes de jeux (pas VIDE).';

  @override
  String get achFull => 'Couverture complète';

  @override
  String get achFullDesc =>
      'Avoir au moins un compte dans chaque jeu (3 jeux minimum).';

  @override
  String get askSpheraAnything => 'Demandez n\'importe quoi à SPHERA';

  @override
  String get aiModeOnHint =>
      'Le mode IA est activé : Claude répond à partir d\'un résumé de vos chiffres.';

  @override
  String get offlineHint =>
      'Votre bénéfice, vos jeux, comptes, grades, objectifs, problèmes, ou comment utiliser un écran. Fonctionne hors ligne, en anglais, français ou arabe.';

  @override
  String get askQuestionHint => 'Posez une question…';

  @override
  String get send => 'Envoyer';

  @override
  String get thinking => 'Réflexion…';

  @override
  String get sourceOffline => 'Hors ligne';

  @override
  String get sourceNotice => 'Info';

  @override
  String get aiMode => 'Mode IA';

  @override
  String get aiModeExplain =>
      'Hors ligne, l\'assistant répond à partir de vos données et du guide de l\'application. Avec le mode IA, Claude (Anthropic) répond à toute question, dans toutes les langues.';

  @override
  String get useClaudeAi => 'Utiliser Claude';

  @override
  String get apiKeySaved => 'Clé API enregistrée sur ce téléphone';

  @override
  String get addApiKeyFirst => 'Ajoutez d\'abord votre clé API';

  @override
  String get replaceApiKey => 'Remplacer la clé API';

  @override
  String get anthropicApiKey => 'Clé API Anthropic';

  @override
  String get keysStartWith => 'Les clés commencent par sk-ant-';

  @override
  String get hide => 'Masquer';

  @override
  String get show => 'Afficher';

  @override
  String get saveKey => 'Enregistrer la clé';

  @override
  String get removeKey => 'Supprimer la clé';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get aiPrivacyText =>
      'Quand le mode IA est activé, votre question et un résumé de vos chiffres (nombres, bénéfices, noms des jeux, noms des comptes, grades, alertes) sont envoyés à Anthropic pour rédiger la réponse. Les e-mails, ID compte, notes et photos ne sont jamais envoyés. La clé est chiffrée sur ce téléphone.\n\nObtenez une clé sur console.anthropic.com (l\'utilisation de l\'API est facturée sur votre compte Anthropic).';

  @override
  String get targetGoogleAccounts => 'Comptes Google';

  @override
  String get tournamentArena => 'Tournament Arena';

  @override
  String get newChat => 'Nouvelle discussion';

  @override
  String get aiModeOn => 'Mode IA : activé';

  @override
  String get aiModeOff => 'Mode IA : désactivé';

  @override
  String get ask => 'Demander';

  @override
  String get insights => 'Analyses';

  @override
  String get levelAttention => 'Attention';

  @override
  String get levelTips => 'Conseils';

  @override
  String get levelGood => 'Bonnes nouvelles';

  @override
  String insightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count analyses',
      one: '1 analyse',
      zero: '0 analyse',
    );
    return '$_temp0';
  }

  @override
  String attentionAndGood(int attention, int good) {
    return '$attention à surveiller · $good bonnes nouvelles';
  }

  @override
  String get nothingHereNow => 'Rien pour l\'instant.';

  @override
  String get analysisOnDevice =>
      'L\'analyse se fait sur cet appareil à partir de vos données et se met à jour quand vous modifiez des comptes.';

  @override
  String get contNorthAmerica => 'Amérique du Nord';

  @override
  String get contSouthAmerica => 'Amérique du Sud';

  @override
  String get contEurope => 'Europe';

  @override
  String get contAfrica => 'Afrique';

  @override
  String get contAsia => 'Asie';

  @override
  String get contOceania => 'Océanie';

  @override
  String get globeSemantics =>
      'Globe. Chaque continent est une section de l\'application. Utilisez le bouton « Toutes les sections » pour les lister.';

  @override
  String get backToGlobe => 'Retour au globe';

  @override
  String get allSections => 'Toutes les sections';

  @override
  String get close => 'Fermer';

  @override
  String get purpose => 'Rôle';

  @override
  String get tellWhereToGo => 'Dites-moi où vous voulez aller';

  @override
  String get explore => 'Explorer';

  @override
  String get seeAll => 'Tout voir';

  @override
  String openScreen(String name) {
    return 'Ouvrir $name';
  }

  @override
  String get screens => 'Écrans';

  @override
  String get smallerPanel => 'Panneau plus petit';

  @override
  String get biggerPanel => 'Panneau plus grand';

  @override
  String get nothingHereYetDot => 'Rien ici pour l\'instant.';

  @override
  String get noStatsForSection => 'Pas de statistiques pour cette section.';

  @override
  String get secStatsTagline => 'Analyses et performance';

  @override
  String get destPerformanceSub =>
      'Aujourd\'hui, cette semaine, ce mois-ci et objectifs';

  @override
  String get destGradeStatsSub => 'De Bronze à Diamant et Interdit';

  @override
  String get secCardsTagline => 'Outils intelligents et arène';

  @override
  String get secGamesTagline => 'Vos comptes de jeu';

  @override
  String get destAllGames => 'Tous les jeux';

  @override
  String get destForSaleSub => 'Comptes actuellement en vente';

  @override
  String get destGameSub => 'Comptes et statuts de ce jeu';

  @override
  String get secGoogle => 'Google';

  @override
  String get secGoogleTagline => 'Comptes Google Play';

  @override
  String get destGoogleAddSub => 'Ajouter un nouveau compte Google Play';

  @override
  String get destGrades => 'Grades';

  @override
  String get destGradesSub => 'Statistiques par grade';

  @override
  String get destBoxStatus => 'Statut des boîtes';

  @override
  String get destBoxStatusSub => 'Statistiques par statut de boîte';

  @override
  String get secProfileTagline => 'Vous et votre progression';

  @override
  String get destMyProfile => 'Mon profil';

  @override
  String get destMyProfileSub => 'Photo, infos, rang et session';

  @override
  String get destAchievementsSub => 'Badges, progression et dates de déblocage';

  @override
  String get secSettingsTagline => 'Préférences et sécurité';

  @override
  String get destSettingsSub => 'Apparence, langue, devise et données';

  @override
  String get destNotificationsSub => 'Alertes et rappels';

  @override
  String get destTrashSub => 'Restaurer les comptes retirés';

  @override
  String get orbScreens => 'Écrans';

  @override
  String get orbSystem => 'Système';

  @override
  String get orbNetProfit => 'Bénéfice net';

  @override
  String get orbAccounts => 'Comptes';

  @override
  String get orbSold => 'Vendus';

  @override
  String get orbForSale => 'À vendre';

  @override
  String get orbActive => 'Actifs';

  @override
  String get orbAddedThisMonth => 'Ajoutés ce mois-ci';

  @override
  String get orbGoogleAccounts => 'Comptes Google';

  @override
  String get orbGamingAccounts => 'Comptes de jeu';

  @override
  String get orbDuplicates => 'Doublons';

  @override
  String get orbInVault => 'Dans le coffre';

  @override
  String get orbClean => 'Sains';

  @override
  String get orbGoogleDuplicates => 'Doublons Google';

  @override
  String get orbSameAccountId => 'Même ID compte';

  @override
  String get orbGames => 'Jeux';

  @override
  String get orbListed => 'En vente';

  @override
  String get orbBoxesSet => 'Boîtes définies';

  @override
  String get orbDone => 'Faites';

  @override
  String get orbPremium => 'Premium';

  @override
  String get orbName => 'Nom';

  @override
  String get orbNotSet => 'Non défini';

  @override
  String get orbUnlocked => 'Débloqués';

  @override
  String get orbPoints => 'Points';

  @override
  String get orbNextGoal => 'Prochain objectif';

  @override
  String get orbAllDone => 'Tout est fait';

  @override
  String get orbTheme => 'Thème';

  @override
  String get orbMode => 'Mode';

  @override
  String get orbCurrency => 'Devise';

  @override
  String get orbLanguage => 'Langue';

  @override
  String get orbAlerts => 'Alertes';

  @override
  String get orbReminders => 'Rappels';

  @override
  String get orbNotifications => 'Notifications';

  @override
  String get orbOn => 'Activé';

  @override
  String get orbOff => 'Désactivé';

  @override
  String get orbInTrash => 'Dans la corbeille';

  @override
  String get orbDataIssues => 'Problèmes de données';

  @override
  String get orbNoMonthToCompare => 'Pas encore de mois à comparer';

  @override
  String orbPctOnLastMonth(String pct) {
    return '$pct % par rapport au mois dernier';
  }

  @override
  String get orbNothingListed => 'Rien en vente pour l\'instant';

  @override
  String get orbListedNoPrice => 'En vente, sans prix pour l\'instant';

  @override
  String get orbBestGame => 'Meilleur jeu';

  @override
  String get orbNoDataYet => 'Pas encore de données';

  @override
  String get orbAddToRank => 'Ajoutez un compte de jeu pour classer les jeux';

  @override
  String orbFromAccounts(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comptes',
      one: '1 compte',
    );
    return '$amount sur $_temp0';
  }

  @override
  String get orbDiamondAccounts => 'Comptes Diamant';

  @override
  String orbOutOfGoogle(int count) {
    return 'Sur $count comptes Google';
  }

  @override
  String get orbDataHealth => 'Santé des données';

  @override
  String get orbAllClear => 'Tout est en ordre';

  @override
  String orbToReview(int count) {
    return '$count à vérifier';
  }

  @override
  String get orbNoDuplicatesOrIds => 'Aucun doublon ni ID manquant';

  @override
  String get orbDuplicatesEmailsIds =>
      'Doublons, e-mails invalides ou ID manquants';

  @override
  String get orbAchievements => 'Succès';

  @override
  String get orbEveryBadge => 'Tous les badges débloqués';

  @override
  String orbNext(String title) {
    return 'Suivant : $title';
  }

  @override
  String get searchEveryScreen => 'Rechercher dans tous les écrans';

  @override
  String get howGlobeWorks => 'Comment fonctionne le globe';

  @override
  String percentSemantics(String label, String pct) {
    return '$label $pct pour cent';
  }

  @override
  String get open => 'Ouvrir';

  @override
  String get whereToGo => 'Où voulez-vous aller ?';

  @override
  String get searchScreenHint =>
      'Cherchez un écran, par exemple bénéfice ou coffre';

  @override
  String get noScreenMatches => 'Aucun écran ne correspond.';

  @override
  String screensCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count écrans',
      one: '1 écran',
    );
    return '$_temp0';
  }

  @override
  String get globeHelpDrag => 'Faites glisser le globe pour le tourner.';

  @override
  String get globeHelpTap =>
      'Touchez un point lumineux pour voir le contenu de ce continent.';

  @override
  String get globeHelpExplore =>
      'Appuyez sur Explorer pour plonger, puis touchez une carte pour ouvrir l\'écran.';

  @override
  String get globeHelpSearch =>
      'La barre du bas trouve n\'importe quel écran par son nom.';

  @override
  String get arenaStructSingleLeague => 'Ligue unique';

  @override
  String get arenaStructMultipleLeagues => 'Plusieurs ligues';

  @override
  String get arenaStructGroupsOnly => 'Groupes uniquement';

  @override
  String get arenaStructGroupsKnockout => 'Groupes + phase finale';

  @override
  String get arenaStructLeaguesGroupsKnockout =>
      'Ligues + groupes + phase finale';

  @override
  String get arenaStructKnockoutOnly => 'Élimination directe';

  @override
  String get arenaHintSingleLeague =>
      'Tout le monde affronte tout le monde dans un seul classement.';

  @override
  String get arenaHintMultipleLeagues =>
      'Les participants sont répartis dans plusieurs ligues indépendantes.';

  @override
  String get arenaHintGroupsOnly =>
      'Une ligue divisée en groupes, chacun avec son propre classement.';

  @override
  String get arenaHintGroupsKnockout =>
      'Phase de groupes, puis les meilleurs se qualifient pour un tableau à élimination directe.';

  @override
  String get arenaHintLeaguesGroupsKnockout =>
      'Plusieurs ligues, chacune avec des groupes ; les qualifiés se retrouvent dans une phase finale.';

  @override
  String get arenaHintKnockoutOnly =>
      'Tableau à élimination directe, avec exemptions si nécessaire.';

  @override
  String get arenaDetailUpTo48Players => 'jusqu\'à 48 joueurs';

  @override
  String get arenaDetailDuo => 'jusqu\'à 24 équipes · 2 joueurs chacune';

  @override
  String get arenaDetailSquad => 'jusqu\'à 12 équipes · 4 joueurs chacune';

  @override
  String get arenaDetailOnePerTeam => '1 joueur par équipe';

  @override
  String get arenaDetailUpTo2 => 'jusqu\'à 2 joueurs par équipe';

  @override
  String get arenaDetailUpTo4 => 'jusqu\'à 4 joueurs par équipe';

  @override
  String get arenaDetailUpTo8 => 'jusqu\'à 8 joueurs par équipe';

  @override
  String get arenaDetail1v1 => '1 contre 1';

  @override
  String get arenaDetailCoop =>
      'équipe contre équipe · jusqu\'à 3 joueurs par équipe';

  @override
  String get arenaDetailCustom => 'taille d\'équipe personnalisée';

  @override
  String get arenaTbHeadToHead => 'Confrontation directe';

  @override
  String get arenaTbGoalDifference => 'Différence de buts';

  @override
  String get arenaTbGoalsScored => 'Buts marqués';

  @override
  String get arenaTbGoalsAgainst => 'Buts encaissés';

  @override
  String get arenaTbShortH2h => 'Conf.';

  @override
  String get arenaTbShortGd => 'Diff';

  @override
  String get arenaTbShortGf => 'BP';

  @override
  String get arenaTbShortGa => 'BC';

  @override
  String get arenaTbExplainH2h =>
      'Les équipes à égalité de points sont départagées par leurs matchs entre elles : d\'abord les points, puis la différence de buts dans ces matchs.';

  @override
  String get arenaTbExplainGd =>
      'Buts marqués moins buts encaissés sur tous les matchs.';

  @override
  String get arenaTbExplainGf =>
      'L\'équipe qui a marqué le plus de buts est classée devant.';

  @override
  String get arenaTbExplainGa =>
      'L\'équipe qui a encaissé le moins de buts est classée devant.';

  @override
  String get arenaKoPenalties => 'Tirs au but';

  @override
  String get arenaKoExtraTime => 'Prolongation';

  @override
  String get arenaKoReplay => 'Match rejoué';

  @override
  String get arenaKoHintPenalties =>
      'Égalité à la fin du temps réglementaire : décidé aux tirs au but.';

  @override
  String get arenaKoHintExtraTime =>
      'Égalité à la fin du temps réglementaire : prolongation. En cas de nouvelle égalité, tirs au but.';

  @override
  String get arenaKoHintReplay =>
      'Égalité à la fin du temps réglementaire : le match est rejoué jusqu\'à ce qu\'il y ait un vainqueur.';

  @override
  String get arenaAet => 'a.p.';

  @override
  String get arenaPens => 't.a.b.';

  @override
  String get arenaColPldShort => 'J';

  @override
  String get arenaColWShort => 'G';

  @override
  String get arenaColDShort => 'N';

  @override
  String get arenaColLShort => 'P';

  @override
  String get arenaColGfShort => 'BP';

  @override
  String get arenaColGaShort => 'BC';

  @override
  String get arenaColGdShort => 'Diff';

  @override
  String get arenaColPtsShort => 'Pts';

  @override
  String get arenaColPlayed => 'Joués';

  @override
  String get arenaColWins => 'Victoires';

  @override
  String get arenaColDraws => 'Nuls';

  @override
  String get arenaColLosses => 'Défaites';

  @override
  String get arenaColGoalsFor => 'Buts pour';

  @override
  String get arenaColGoalsAgainst => 'Buts contre';

  @override
  String get arenaColGoalDifference => 'Différence de buts';

  @override
  String get arenaColPoints => 'Points';

  @override
  String arenaScorePens(String score, String pens) {
    return '$score ($pens t.a.b.)';
  }

  @override
  String get arenaErrKillPoints =>
      'Les points par élimination ne peuvent pas être négatifs.';

  @override
  String arenaErrPlacementRows(int slots, int count) {
    return 'Le tableau des places doit avoir exactement $slots lignes (une par participant ou équipe) ; il en a $count.';
  }

  @override
  String get arenaErrPlacementNegative =>
      'Les points de classement ne peuvent pas être négatifs.';

  @override
  String arenaErrPlacementOrder(int lower, int higher) {
    return 'Une place inférieure ne peut pas rapporter plus qu\'une place supérieure (#$lower rapporte plus que #$higher).';
  }

  @override
  String get arenaErrFirstPlace => 'La 1re place doit rapporter plus de 0.';

  @override
  String arenaErrZeroTail(int count) {
    return 'Les $count dernières places doivent rapporter 0 point de classement.';
  }

  @override
  String get arenaTbd => 'À déterminer';

  @override
  String get arenaUnknown => 'Inconnu';

  @override
  String get arenaErrNameRequired => 'Le nom du tournoi est obligatoire.';

  @override
  String get arenaErrMin2 => 'Ajoutez au moins 2 participants.';

  @override
  String arenaErrTooMany(int count, int max) {
    return 'Les participants ($count) dépassent le maximum ($max).';
  }

  @override
  String get arenaErrDeadline =>
      'La date limite d\'inscription doit être au plus tard la date de début.';

  @override
  String get arenaErrWinPoints =>
      'Les points de victoire doivent être au moins égaux aux points de nul.';

  @override
  String get arenaErrMinColumns =>
      'Affichez au moins 1 colonne dans le classement.';

  @override
  String arenaErrMaxColumns(int max) {
    return 'Le classement peut afficher au maximum $max colonnes.';
  }

  @override
  String get arenaErrMinRounds => 'Prévoyez au moins 1 manche.';

  @override
  String get arenaErrMinLeagues => 'Utilisez au moins 2 ligues.';

  @override
  String get arenaErrMinGroups => 'Utilisez au moins 2 groupes par ligue.';

  @override
  String arenaErrNotEnough(int leagues, int groups, int min) {
    return 'Pas assez de participants : $leagues ligue(s) x $groups groupe(s) en demandent au moins $min.';
  }

  @override
  String get arenaErrMinQualifier =>
      'Au moins 1 qualifié par groupe est nécessaire.';

  @override
  String arenaErrQualifiersExceed(int q, int min) {
    return 'Les qualifiés par groupe ($q) dépassent la taille du plus petit groupe ($min).';
  }

  @override
  String get arenaErrMin2Qualify =>
      'Au moins 2 participants doivent se qualifier pour la phase finale.';

  @override
  String arenaErrWinnerColumns(String mode, String columns) {
    return '$mode se décide par le vainqueur : choisissez au moins une colonne parmi $columns.';
  }

  @override
  String arenaErrMaxTeams(String mode, int cap, int count) {
    return '$mode accepte au maximum $cap équipes (vous en avez $count).';
  }

  @override
  String arenaErrMaxPlayers(String mode, int cap, int count) {
    return '$mode accepte au maximum $cap joueurs (vous en avez $count).';
  }

  @override
  String arenaErrMinTeamsBr(String mode, int min, int tail) {
    return '$mode nécessite au moins $min équipes (les $tail dernières places ne rapportent pas de points).';
  }

  @override
  String arenaErrMinPlayersBr(String mode, int min, int tail) {
    return '$mode nécessite au moins $min joueurs (les $tail dernières places ne rapportent pas de points).';
  }

  @override
  String arenaErrExactPlayers(String name, int size) {
    return '« $name » doit avoir exactement $size joueurs.';
  }

  @override
  String arenaErrBetweenPlayers(String name, int size) {
    return '« $name » doit avoir entre 1 et $size joueurs.';
  }

  @override
  String arenaErrAssignedTwice(String name) {
    return 'Le joueur « $name » est attribué deux fois.';
  }

  @override
  String arenaErrAppearsTwice(String name) {
    return 'Le joueur « $name » apparaît plus d\'une fois.';
  }

  @override
  String arenaErrMinTotalPlayers(int min, int total) {
    return 'Au moins $min joueurs doivent être inscrits au total (actuellement $total).';
  }

  @override
  String arenaLogCreatedBr(int count) {
    return 'Tournoi créé : $count manche(s) Battle Royale';
  }

  @override
  String get arenaLogCreatedKo => 'Tournoi créé : tableau final généré';

  @override
  String arenaLogCreatedFixtures(int count) {
    return 'Tournoi créé : $count matchs générés';
  }

  @override
  String get arenaLeague => 'Ligue';

  @override
  String arenaLeagueLetter(String letter) {
    return 'Ligue $letter';
  }

  @override
  String arenaGroupName(String name) {
    return 'Groupe $name';
  }

  @override
  String get arenaFinal => 'Finale';

  @override
  String get arenaSemiFinals => 'Demi-finales';

  @override
  String get arenaQuarterFinals => 'Quarts de finale';

  @override
  String arenaRoundOf(int count) {
    return '${count}es de finale';
  }

  @override
  String get arenaCritPoints => 'Points';

  @override
  String get arenaCritAllLevel =>
      'Égalité sur tous les critères (ordre alphabétique)';

  @override
  String arenaNoteMorePoints(String a, int pa, int pb) {
    return '$a a plus de points ($pa contre $pb).';
  }

  @override
  String arenaNoteH2hBeat(int points, String a, String b, String score) {
    return 'Égalité à $points pts. Confrontation directe : $a a battu $b $score lors de leur match.';
  }

  @override
  String arenaNoteH2hRecord(int points, String a) {
    return 'Égalité à $points pts. Confrontation directe : $a a le meilleur bilan dans les matchs entre les équipes à égalité.';
  }

  @override
  String arenaNoteGd(int points, String a, String va, String b, String vb) {
    return 'Égalité à $points pts. Différence de buts : $a $va contre $b $vb.';
  }

  @override
  String arenaNoteGf(int points, String a, int va, String b, int vb) {
    return 'Égalité à $points pts. Buts marqués : $a $va contre $b $vb.';
  }

  @override
  String arenaNoteGa(int points, String a, int va, String b, int vb) {
    return 'Égalité à $points pts. Buts encaissés : $a $va contre $b $vb (le moins est le mieux).';
  }

  @override
  String get arenaNoteByName =>
      'Égalité sur tous les critères : classement par nom.';

  @override
  String get arenaErrNoGroupStage =>
      'Ce tournoi n\'a pas de phase de groupes d\'où se qualifier.';

  @override
  String get arenaErrKoAlready => 'La phase finale a déjà été générée.';

  @override
  String get arenaErrConfirmGroups =>
      'Confirmez tous les matchs de groupe avant de générer la phase finale.';

  @override
  String get arenaErrMin2Qualified =>
      'Au moins 2 participants doivent se qualifier.';

  @override
  String arenaLogKoGenerated(int count) {
    return 'Phase finale générée à partir des classements de groupe ($count qualifiés)';
  }

  @override
  String get arenaErrScoredMode =>
      'Ce mode se joue avec un score, pas en choisissant un vainqueur.';

  @override
  String get arenaErrMatchNotFound => 'Match introuvable.';

  @override
  String get arenaErrWinnerSide =>
      'Le vainqueur doit être l\'un des deux camps.';

  @override
  String get arenaErrByeNoResult => 'Une exemption n\'a pas de résultat.';

  @override
  String get arenaErrCancelled => 'Ce match a été annulé.';

  @override
  String get arenaErrBothKnown =>
      'Les deux participants doivent d\'abord être connus.';

  @override
  String get arenaErrNegativeScore =>
      'Les scores ne peuvent pas être négatifs.';

  @override
  String get arenaErrKoLocksGroups =>
      'La phase finale est déjà générée. Réinitialisez les résultats pour modifier les scores de groupe.';

  @override
  String get arenaErrNextRoundPlayed =>
      'Le tour suivant a déjà été joué. Réinitialisez les résultats pour modifier ce score.';

  @override
  String arenaLogReplay(String score, String home, String away, int n) {
    return 'Nul $score : $home contre $away sera rejoué (match rejoué n°$n)';
  }

  @override
  String get arenaErrEnterPensAfterNormal =>
      'Égalité à la fin du temps réglementaire : saisissez le score des tirs au but.';

  @override
  String get arenaErrEnterPensAfterExtra =>
      'Égalité après prolongation : saisissez le score des tirs au but.';

  @override
  String get arenaErrNegativePens =>
      'Les scores des tirs au but ne peuvent pas être négatifs.';

  @override
  String get arenaErrPensWinner =>
      'Une séance de tirs au but doit avoir un vainqueur.';

  @override
  String arenaLogAmended(String names) {
    return 'Résultat modifié : $names';
  }

  @override
  String arenaLogConfirmed(String names) {
    return 'Résultat confirmé : $names';
  }

  @override
  String get arenaLockBrConfirmed =>
      'Une manche Battle Royale est déjà confirmée. Réinitialisez les résultats pour modifier les effectifs.';

  @override
  String get arenaLockPlayed =>
      'Un match de ces équipes a déjà été joué. Réinitialisez les résultats pour faire cette modification.';

  @override
  String get arenaErrParticipantNotFound => 'Participant introuvable.';

  @override
  String get arenaErrNameEmpty => 'Le nom ne peut pas être vide.';

  @override
  String arenaLogRenamed(String old, String name) {
    return 'Renommé : $old -> $name';
  }

  @override
  String get arenaErrNoRosters => 'Ce mode n\'a pas d\'effectifs d\'équipe.';

  @override
  String get arenaErrTeamNeedsPlayer =>
      'Une équipe doit avoir au moins 1 joueur.';

  @override
  String arenaErrMaxPerTeam(String mode, int size) {
    return '$mode accepte au maximum $size joueurs par équipe.';
  }

  @override
  String arenaErrExactPerTeam(int size) {
    return 'Chaque équipe doit avoir exactement $size joueurs.';
  }

  @override
  String get arenaErrPlayerNameEmpty =>
      'Les noms des joueurs ne peuvent pas être vides.';

  @override
  String arenaErrAlreadyInTeam(String name) {
    return '« $name » est déjà dans une équipe.';
  }

  @override
  String arenaErrAlreadyRegistered(String name) {
    return '« $name » est déjà inscrit.';
  }

  @override
  String arenaLogRoster(String team, int count) {
    return 'Effectif mis à jour : $team ($count joueurs)';
  }

  @override
  String get arenaErrChooseTwo => 'Choisissez deux éléments différents.';

  @override
  String arenaLogSwapped(String a, String b) {
    return 'Échangés : $a <-> $b';
  }

  @override
  String get arenaErrChooseTwoPlayers => 'Choisissez deux joueurs différents.';

  @override
  String get arenaErrPlayerNotInTeam => 'Joueur introuvable dans cette équipe.';

  @override
  String arenaLogPlayersSwapped(String a, String ta, String b, String tb) {
    return 'Joueurs échangés : $a ($ta) <-> $b ($tb)';
  }

  @override
  String get arenaErrOnlyBrRounds =>
      'Seuls les tournois Battle Royale ont des manches.';

  @override
  String arenaLogRoundAdded(int n) {
    return 'Manche $n ajoutée';
  }

  @override
  String get arenaErrRoundNotFound => 'Manche introuvable.';

  @override
  String get arenaErrUnknownInResults =>
      'Participant inconnu dans les résultats.';

  @override
  String get arenaErrEnterPlacements =>
      'Saisissez une place pour chaque participant.';

  @override
  String arenaErrPlacementRange(int n) {
    return 'Les places doivent être entre 1 et $n.';
  }

  @override
  String arenaErrSamePlacement(int n) {
    return 'Deux participants ont la place $n.';
  }

  @override
  String get arenaErrNegativeKills =>
      'Les éliminations ne peuvent pas être négatives.';

  @override
  String arenaLogRoundAmended(int n) {
    return 'Manche $n modifiée';
  }

  @override
  String arenaLogRoundConfirmed(int n) {
    return 'Manche $n confirmée';
  }

  @override
  String get arenaCritWins => 'Victoires';

  @override
  String get arenaCritKills => 'Éliminations';

  @override
  String get arenaCritLastRound => 'Place à la dernière manche';

  @override
  String get arenaCritNameOrder => 'Ordre alphabétique';

  @override
  String arenaBrNoteWins(int points, String a, int wa, String b, int wb) {
    return 'Égalité à $points pts. Victoires (1res places) : $a $wa contre $b $wb.';
  }

  @override
  String arenaBrNoteKills(int points, String a, int ka, String b, int kb) {
    return 'Égalité à $points pts et en victoires. Éliminations : $a $ka contre $b $kb.';
  }

  @override
  String arenaBrNoteLastRound(String a) {
    return 'Égalité en points, victoires et éliminations. Meilleure place à la dernière manche : $a.';
  }

  @override
  String get arenaLogReset =>
      'Tous les résultats ont été réinitialisés par l\'organisateur';

  @override
  String get create => 'Créer';

  @override
  String get noTournamentsYet => 'Aucun tournoi pour l\'instant';

  @override
  String get createFirstTournament =>
      'Créez votre première ligue, phase de groupes ou compétition à élimination directe.';

  @override
  String tournamentsOnDevice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tournois sur cet appareil',
      one: '1 tournoi sur cet appareil',
      zero: '0 tournoi sur cet appareil',
    );
    return '$_temp0';
  }

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count participants',
      one: '1 participant',
    );
    return '$_temp0';
  }

  @override
  String champion(String name) {
    return 'Champion : $name';
  }

  @override
  String roundsConfirmed(int done, int total) {
    return '$done / $total manches confirmées';
  }

  @override
  String matchesConfirmed(int done, int total) {
    return '$done / $total matchs confirmés';
  }

  @override
  String get confirm => 'Confirmer';

  @override
  String get renamePlayer => 'Renommer le joueur';

  @override
  String get nameUpdated => 'Nom mis à jour.';

  @override
  String get swapTeams => 'Échanger des équipes';

  @override
  String get swapPlayers => 'Échanger des joueurs';

  @override
  String get teamA => 'Équipe A';

  @override
  String get teamB => 'Équipe B';

  @override
  String get playerA => 'Joueur A';

  @override
  String get playerB => 'Joueur B';

  @override
  String get swap => 'Échanger';

  @override
  String swapQuestion(String a, String b) {
    return 'Échanger $a et $b ?';
  }

  @override
  String swapTeamsBody(String a, String b) {
    return '$a prend la place de $b dans le tirage, et inversement. Chaque équipe garde ses joueurs.';
  }

  @override
  String swapSoloBody(String a, String b) {
    return '$a prend la place de $b dans le tirage, et inversement.';
  }

  @override
  String swapped(String a, String b) {
    return '$a et $b échangés.';
  }

  @override
  String get addPlayersFirst =>
      'Ajoutez d\'abord des noms de joueurs à au moins deux places.';

  @override
  String swapPlayersBody(String a, String ta, String b, String tb) {
    return '$a ($ta) et $b ($tb) changent d\'équipe. La taille des équipes ne change pas.';
  }

  @override
  String get teamsAndPlayers => 'Équipes et joueurs';

  @override
  String get tournamentGone => 'Ce tournoi n\'existe plus.';

  @override
  String get players => 'Joueurs';

  @override
  String get searchTeamsOrPlayers => 'Rechercher des équipes ou des joueurs';

  @override
  String get searchPlayers => 'Rechercher des joueurs';

  @override
  String teamsAndPlayersCount(int teams, int players) {
    return '$teams équipes · $players joueurs';
  }

  @override
  String playersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs',
      one: '1 joueur',
    );
    return '$_temp0';
  }

  @override
  String get playedTeamsLocked => 'Les équipes ayant joué sont verrouillées';

  @override
  String get nothingFound => 'Aucun résultat.';

  @override
  String playersOfMax(int count, int max) {
    return '$count / $max joueurs';
  }

  @override
  String get noPlayerNamesTap =>
      'Pas encore de noms de joueurs. Touchez pour les ajouter.';

  @override
  String get teamNotFound => 'Équipe introuvable.';

  @override
  String get renameTeam => 'Renommer l\'équipe';

  @override
  String get teamName => 'Nom de l\'équipe';

  @override
  String get teamRenamed => 'Équipe renommée.';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String get playerName => 'Nom du joueur';

  @override
  String nameAdded(String name) {
    return '$name ajouté.';
  }

  @override
  String get playerRenamed => 'Joueur renommé.';

  @override
  String removeNameQ(String name) {
    return 'Retirer $name ?';
  }

  @override
  String leavesTeam(String name, String team) {
    return '$name quitte $team.';
  }

  @override
  String nameRemoved(String name) {
    return '$name retiré.';
  }

  @override
  String fixedTeamSizeNote(String mode, int size) {
    return 'Les équipes en $mode ont toujours exactement $size joueurs. Utilisez « Échanger des joueurs » pour changer les membres.';
  }

  @override
  String get noPlayerNamesYet => 'Pas encore de noms de joueurs.';

  @override
  String get tournament => 'Tournoi';

  @override
  String get tabStandings => 'Classement';

  @override
  String get tabRounds => 'Manches';

  @override
  String get tabMatches => 'Matchs';

  @override
  String get tabBracket => 'Tableau';

  @override
  String get tabInfo => 'Infos';

  @override
  String get resetAllResultsQ => 'Réinitialiser tous les résultats ?';

  @override
  String get resetBodyKo =>
      'Tous les résultats confirmés sont effacés et le tableau final est supprimé. La réinitialisation est inscrite dans l\'historique.';

  @override
  String get resetBody =>
      'Tous les résultats confirmés sont effacés. La réinitialisation est inscrite dans l\'historique.';

  @override
  String get deleteTournamentQ => 'Supprimer le tournoi ?';

  @override
  String get cannotBeUndone => 'Cette action est irréversible.';

  @override
  String get resetResults => 'Réinitialiser les résultats';

  @override
  String get deleteTournament => 'Supprimer le tournoi';

  @override
  String get knockoutStage => 'Phase finale';

  @override
  String topNOfEveryGroup(int n) {
    return 'Les $n premiers de chaque groupe se qualifient.';
  }

  @override
  String get generateKnockout => 'Générer la phase finale';

  @override
  String get confirmGroupMatchesFirst =>
      'Confirmez d\'abord tous les matchs de groupe';

  @override
  String get championCaps => 'CHAMPION';

  @override
  String topNQualify(int n) {
    return 'Les $n premiers se qualifient';
  }

  @override
  String get howTiesResolved => 'Comment les égalités ont été départagées';

  @override
  String matchday(int n) {
    return 'Journée $n';
  }

  @override
  String get toPlay => 'À jouer';

  @override
  String get filterPlayed => 'Joués';

  @override
  String get noMatchesHere => 'Aucun match ici.';

  @override
  String get bye => 'EXEMPT';

  @override
  String get win => 'Victoire';

  @override
  String get vs => 'vs';

  @override
  String get enterBothScores => 'Saisissez les deux scores en nombres entiers.';

  @override
  String get pickWinner => 'Choisissez le vainqueur.';

  @override
  String get amendResult => 'Modifier le résultat';

  @override
  String get whoWon => 'Qui a gagné ?';

  @override
  String get pickWinningSide => 'Choisissez le camp gagnant.';

  @override
  String get amendmentsRecorded =>
      'Les modifications sont inscrites dans l\'historique.';

  @override
  String get saveAmendment => 'Enregistrer la modification';

  @override
  String get confirmResult => 'Confirmer le résultat';

  @override
  String get enterResult => 'Saisir le résultat';

  @override
  String get decidedInExtraTime => 'Décidé en prolongation';

  @override
  String get penaltyShootout => 'Tirs au but';

  @override
  String get levelReplayNote =>
      'Score nul : ce match repasse « à jouer » et sera rejoué.';

  @override
  String earlierDraws(String list) {
    return 'Nuls précédents : $list';
  }

  @override
  String get overallStandings => 'Classement général';

  @override
  String brRoundsProgress(int done, int total) {
    return '$done / $total manches';
  }

  @override
  String brTotalFormula(int k) {
    return 'Total = points de place + éliminations x $k';
  }

  @override
  String get colRnd => 'Man.';

  @override
  String get colPlace => 'Place';

  @override
  String get colKills => 'Élim.';

  @override
  String get colKillPts => 'Pts élim.';

  @override
  String get colTotal => 'Total';

  @override
  String roundN(int n) {
    return 'Manche $n';
  }

  @override
  String get roundConfirmedTap => 'Confirmée · touchez pour modifier';

  @override
  String get roundTapToEnter =>
      'Touchez pour saisir les places et éliminations';

  @override
  String get addRound => 'Ajouter une manche';

  @override
  String enterPlacementKills(String name) {
    return 'Saisissez une place et un nombre d\'éliminations (0 ou plus) pour « $name ».';
  }

  @override
  String placementHelp(int n, int k) {
    return 'Place de 1 à $n (sans doublon). Chaque élimination = $k points.';
  }

  @override
  String get confirmRound => 'Confirmer la manche';

  @override
  String get bracketLater =>
      'Le tableau apparaît une fois la phase de groupes terminée.\nOuvrez Classement et touchez « Générer la phase finale ».';

  @override
  String get editParticipant => 'Modifier le participant';

  @override
  String get teamClub => 'Équipe / club';

  @override
  String logParticipantEdited(String old, String name) {
    return 'Participant modifié : $old -> $name';
  }

  @override
  String get rowScoring => 'Points';

  @override
  String scoringBr(int k, int n) {
    return 'Points de place + éliminations x $k ($n manches prévues)';
  }

  @override
  String get rowStructure => 'Structure';

  @override
  String get rowOrganizer => 'Organisateur';

  @override
  String get rowStart => 'Début';

  @override
  String get rowRegistration => 'Inscriptions';

  @override
  String untilDate(String date) {
    return 'jusqu\'au $date';
  }

  @override
  String pointsWinLoss(int w, int l) {
    return 'Victoire $w · Défaite $l';
  }

  @override
  String pointsWdl(int w, int d, int l) {
    return 'V $w · N $d · D $l';
  }

  @override
  String get rowRanking => 'Classement';

  @override
  String get rowIfLevel => 'En cas d\'égalité';

  @override
  String get rulesTitle => 'Règlement';

  @override
  String participantsTitle(int count) {
    return 'Participants ($count)';
  }

  @override
  String get editSwapPlayers => 'Modifier et échanger les joueurs';

  @override
  String get auditLog => 'Historique';

  @override
  String get noEventsYet => 'Aucun événement pour l\'instant.';

  @override
  String get room => 'Salle';

  @override
  String roomIdValue(String id) {
    return 'ID de la salle : $id';
  }

  @override
  String passwordValue(String pw) {
    return 'Mot de passe : $pw';
  }

  @override
  String get roomStoredNote =>
      'Enregistré uniquement sur cet appareil. Jamais partagé automatiquement.';

  @override
  String get stepSelectGame => 'Choix du jeu';

  @override
  String get stepTypeMode => 'Type et mode';

  @override
  String get stepSetup => 'Configuration';

  @override
  String get stepDetails => 'Détails et confirmation';

  @override
  String maxReached(int cap) {
    return 'Maximum atteint ($cap).';
  }

  @override
  String get enterTeamPlayers =>
      'Saisissez les joueurs de l\'équipe, séparés par des virgules.';

  @override
  String everyTeamExactly(int size) {
    return 'Chaque équipe doit avoir exactement $size joueurs.';
  }

  @override
  String get createTournament => 'Créer le tournoi';

  @override
  String get next => 'Suivant';

  @override
  String get selectGameTitle => 'Choisir le jeu';

  @override
  String get selectGameSub => 'Choisissez le jeu de votre tournoi.';

  @override
  String get selectTypeTitle => 'Choisir le type de tournoi';

  @override
  String selectTypeSub(String game) {
    return 'Choisissez le mode à organiser dans $game.';
  }

  @override
  String get selectModeTitle => 'Choisir le mode';

  @override
  String selectModeSub(String type) {
    return 'Choisissez le format de votre $type.';
  }

  @override
  String get infoPointsSystem => 'Système de points';

  @override
  String get infoTwoPlayers => 'Deux joueurs par match';

  @override
  String get infoMin2Teams => 'Minimum : 2 équipes';

  @override
  String infoMinPlayers(int n) {
    return 'Joueurs minimum : $n';
  }

  @override
  String get infoHowItWorks => 'Fonctionnement';

  @override
  String infoBrText(String detail) {
    return 'Total = points de place + 2 points par élimination. Les trois dernières places rapportent 0 point. $detail.';
  }

  @override
  String get infoCs1v1 =>
      'Chaque match nécessite deux joueurs. Inscrivez au moins 2 joueurs. Un match se gagne ou se perd : pas de buts, pas de nul.';

  @override
  String infoCsTeams(int size) {
    return 'Il faut au moins 2 équipes. Les équipes peuvent avoir un nombre de joueurs différent (par exemple 2 contre 1), jusqu\'à $size par équipe. Un match se gagne ou se perd : pas de buts, pas de nul.';
  }

  @override
  String infoMinTotal(int n, int size) {
    return 'Il faut $n joueurs inscrits au total pour commencer. La taille d\'équipe ($size) est un maximum : inutile de remplir toutes les places.';
  }

  @override
  String get info1v1 =>
      'Chaque match oppose deux joueurs. Les résultats font le classement.';

  @override
  String get setupSub => 'Inscriptions, format et règles.';

  @override
  String get setupValid =>
      'La configuration est valide. Passez à la dernière étape.';

  @override
  String get toContinue => 'Pour continuer';

  @override
  String get registrationPanel => 'Inscriptions';

  @override
  String get maxTeams => 'Équipes maximum';

  @override
  String get maxPlayers => 'Joueurs maximum';

  @override
  String limitTeams(int max, String detail) {
    return 'Limite : jusqu\'à $max équipes ($detail).';
  }

  @override
  String limitPlayers(int max, String detail) {
    return 'Limite : jusqu\'à $max joueurs ($detail).';
  }

  @override
  String atLeastPlayersTotal(int n) {
    return 'Au moins $n joueurs au total. Les équipes n\'ont pas à être complètes.';
  }

  @override
  String get playersCommaLabel => 'Joueurs (noms séparés par des virgules)';

  @override
  String get playersCommaHint => 'ex. Ali, Sara';

  @override
  String exactlyPerTeam(int size) {
    return 'Exactement $size joueurs par équipe.';
  }

  @override
  String oneToPerTeam(int size) {
    return '1 à $size joueurs par équipe. Les équipes n\'ont pas à être complètes.';
  }

  @override
  String teamsRegistered(int count, int cap, int players) {
    return '$count / $cap équipes · $players joueurs';
  }

  @override
  String playersRegistered(int count, int cap) {
    return '$count / $cap joueurs';
  }

  @override
  String get formatPanel => 'Format';

  @override
  String get tournamentFormat => 'Format du tournoi';

  @override
  String get numberOfLeagues => 'Nombre de ligues';

  @override
  String get groupsPerLeague => 'Groupes par ligue';

  @override
  String get qualifiersPerGroup => 'Qualifiés par groupe';

  @override
  String get doubleRoundRobin => 'Aller-retour';

  @override
  String get doubleRoundRobinSub =>
      'Aller et retour : chacun affronte tous les autres deux fois';

  @override
  String get randomDraw => 'Tirage au sort';

  @override
  String get randomDrawSub =>
      'Désactivé : les participants sont placés dans l\'ordre d\'ajout';

  @override
  String get ifKoLevel => 'Si un match à élimination finit à égalité';

  @override
  String get pointsAndRanking => 'Points et classement';

  @override
  String get draw => 'Nul';

  @override
  String get lossLabel => 'Défaite';

  @override
  String get tiebreakerOrder => 'Ordre de départage';

  @override
  String get directMatchFirst => 'Confrontation directe d\'abord';

  @override
  String get goalDiffFirst => 'Différence de buts d\'abord';

  @override
  String get rulesNoteWinnerOnly =>
      'Le vainqueur d\'un match prend les points de victoire. Les équipes à égalité sont départagées par leur confrontation directe, puis par nom. Verrouillé dès le début du tournoi.';

  @override
  String get rulesNote =>
      'Ces règles sont verrouillées dès le début du tournoi. Les équipes encore à égalité après tous les critères sont classées par nom.';

  @override
  String get standingsColumns => 'Colonnes du classement';

  @override
  String columnsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count colonnes choisies. Le rang et le nom sont toujours affichés.',
      one: '1 colonne choisie. Le rang et le nom sont toujours affichés.',
    );
    return '$_temp0';
  }

  @override
  String get roundsAndScoring => 'Manches et points';

  @override
  String get plannedRounds => 'Manches prévues';

  @override
  String get brFormulaTitle => 'Total = points de place + éliminations x 2';

  @override
  String get brFormulaText =>
      'En duo et en escouade, les éliminations de tous les membres de l\'équipe s\'additionnent.';

  @override
  String get placementPoints => 'Points de place';

  @override
  String registerTeamsFirst(int n) {
    return 'Inscrivez au moins $n équipes pour configurer le tableau (une ligne par équipe).';
  }

  @override
  String registerPlayersFirst(int n) {
    return 'Inscrivez au moins $n joueurs pour configurer le tableau (une ligne par joueur).';
  }

  @override
  String lastPlacementsZero(int n) {
    return 'Les $n dernières places rapportent toujours 0 point.';
  }

  @override
  String get resetToDefault => 'Valeurs par défaut';

  @override
  String get notSet => 'Non défini';

  @override
  String get tournamentSettings => 'Réglages du tournoi';

  @override
  String get tournamentSettingsSub =>
      'Définissez les derniers détails de votre tournoi.';

  @override
  String get tournamentNameReq => 'Nom du tournoi *';

  @override
  String get tournamentNameHint => 'ex. Coupe SPHERA';

  @override
  String get organizer => 'Organisateur';

  @override
  String get description => 'Description';

  @override
  String get startDateTime => 'Date et heure de début';

  @override
  String get registrationDeadline => 'Date limite d\'inscription';

  @override
  String get rulesAndPenalties => 'Règles et sanctions';

  @override
  String get roomIdOptional => 'ID de la salle (facultatif)';

  @override
  String get roomPasswordOptional => 'Mot de passe de la salle (facultatif)';

  @override
  String get review => 'Récapitulatif';

  @override
  String get participantsRow => 'Participants';

  @override
  String participantsSummaryTeams(int count, int players, int max) {
    return '$count ($players joueurs) · max $max';
  }

  @override
  String participantsSummary(int count, int max) {
    return '$count · max $max';
  }

  @override
  String get scoringBrShort => 'Points de place + éliminations x 2';

  @override
  String get columnsRow => 'Colonnes';

  @override
  String get readAndConfirm =>
      'Lisez et confirmez : les règles de classement se verrouillent au début du tournoi.';

  @override
  String get validRounds =>
      'Tout semble valide. La création génère les manches.';

  @override
  String get validFixtures =>
      'Tout semble valide. La création génère les matchs.';

  @override
  String stepOf(int step, int total, String title) {
    return 'Étape $step sur $total · $title';
  }

  @override
  String get rankingOrder => 'Ordre de classement';

  @override
  String get teamColumn => 'Équipe';

  @override
  String filterAllCount(int count) {
    return 'Tous $count';
  }

  @override
  String filterActiveCount(int count) {
    return 'Actifs $count';
  }

  @override
  String filterSoldCount(int count) {
    return 'Vendus $count';
  }

  @override
  String arenaLoadError(String error) {
    return 'Impossible de lire les tournois enregistrés ($error).';
  }

  @override
  String ratesServerError(int code) {
    return 'Le serveur des taux a répondu $code.';
  }

  @override
  String get ratesUnavailable =>
      'Les taux ne sont pas disponibles pour le moment.';

  @override
  String get ratesNoInternet =>
      'Impossible de mettre à jour les taux. Vérifiez votre connexion internet.';
}
