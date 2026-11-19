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
}
