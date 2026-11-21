# SPHERA (Flutter)

Run these once after copying the files over your `sphera_flutter` project:

    flutter pub get
    dart run build_runner build --delete-conflicting-outputs   # generates lib/data/database.g.dart
    flutter test
    flutter run

Stage 1 status: theme, logo reveal splash, home with live counts, Drift schema + 2 tests.

Stage 2 (Google accounts): repository + form + inventory (search, grade/status filters, trash with undo), game repository (add/rename). Not yet compiled or tested - run the commands above.

## Dotted-Earth engine

`lib/features/earth/` holds the engine the Orbit tab is built on (the old standalone Earth screen was removed).

- `earth_sections.dart`: which section lives on which continent (`kSectionContinent`).
- `earth_continents.dart`: continent borders, anchors, zoom, colors and translated names.
- `earth_scene.dart`: projection, dotted Earth, drawing and hit-testing.

## Orbit tab: the gold Earth (current center tab)

`OrbitScreen` (`lib/features/orbit/orbit_screen.dart`) is now a glowing gold dotted Earth, built on the
dotted-Earth engine in `features/earth/` and styled after the reference design. `shell/main_shell.dart` is unchanged.

Flow: whole Earth (drag to turn it) -> tap a node: glass info card with live stats, light beam, **Explore** ->
camera dives in, bottom sheet with gauges, **Screens** / **Stats** tabs and one card per screen of the section.

- `widgets/globe_scene.dart`: renderer (gold dots, sun flare, arcs, nodes, beam) + hit-testing.
  `kOrbitContinent` says which section lives on which continent (one line per section).
- `widgets/orbit_glass.dart`: glass buttons, search bar, gauges, cards. `OrbitText.family` sets the font everywhere.
- `widgets/orbit_sheets.dart`: search, all sections, all insights, help.
- `orbit_insights.dart`: live stats per section and the Insights row (from the same providers as Home/Stats).
- Screens still come from `orbit_sections.dart`: add a screen there once and it appears as a card and a node.
- `widgets/planet_painters.dart`: palette, stars, nav bar icon.

Not yet compiled: run `flutter analyze && flutter test test/orbit_globe_test.dart`.

## Performance Center, SPHERA Intelligence, Notifications

All three run offline, from the local database. Nothing leaves the device.

- `data/performance.dart`: today / week / month vs the period before, add streak, best periods,
  monthly goals (profit + accounts, saved in SharedPreferences). Screen: `features/stats/performance_center_screen.dart`.
- `data/insights.dart`: rule-based insights (best / losing games, sold at a loss, priced under cost,
  average margin, stale FOR SALE listings, COMING boxes, duplicates, invalid emails, goal pace).
  Screen: `features/intelligence/intelligence_screen.dart`.
- Notifications = the insights that are warnings or reminders, filtered by Settings > Notifications.
  `NotificationBell` (in `features/notifications/notifications_screen.dart`) shows the unread count;
  opening the center marks them read. A notification comes back when its numbers change.

Android: the project uses built-in Kotlin (`android.builtInKotlin=true`, AGP 9, Flutter 3.47+).

Tests: `flutter test` (includes `performance_insights_test.dart` and `new_screens_test.dart`).

## SPHERA Assistant (Intelligence > Ask) and phone notifications

- `data/assistant/offline_brain.dart`: answers questions offline (English, French, Arabic, some Darija):
  profit by period, a game by name, best/losing games and accounts, counts, grades, boxes, goals,
  streak, alerts, data health, advice, summary, and "how do I..." from the app guide.
- `data/assistant/app_knowledge.dart`: the app guide (one `HelpTopic` per feature). Add a topic here when
  you add a screen: the offline brain and Claude both use it.
- `data/assistant/assistant_data.dart`: the data snapshot. Never contains emails, Account IDs or notes.
- AI mode (optional): `data/assistant/claude_client.dart` calls the Claude API (`claude-opus-5-5`, raw HTTP
  streaming, server-side refusal fallback on) with the user's own API key, stored with flutter_secure_storage.
  The system prompt is frozen; live data goes in a mid-conversation system message, sent only when it changed;
  the conversation is replayed unchanged (Opus 5.5 checks replayed thinking blocks). If Claude fails, the
  offline answer is shown.
- `data/phone_notifications.dart` + `features/notifications/notification_sync.dart`: local phone
  notifications (flutter_local_notifications). Unread alerts become one notification when you leave the app;
  a daily summary repeats at the chosen time; tapping opens the Notifications center. No server involved,
  so new alerts cannot be detected while the app is closed.
- Android: compileSdk 37, core library desugaring, INTERNET + POST_NOTIFICATIONS + RECEIVE_BOOT_COMPLETED,
  scheduled-notification receivers, status-bar icon `res/drawable/ic_stat_sphera.xml`. App name is now "SPHERA".

## Languages (English, Français, العربية)

Settings > Language switches the app; Arabic turns the layout right-to-left.
Texts live in `lib/l10n/app_en.arb`, `app_fr.arb` and `app_ar.arb` (same keys in all three;
`test/l10n_test.dart` fails if one is missing). In a widget: `context.l10n.navHome`
(import `core/l10n.dart`). After editing an `.arb` file, `flutter run` regenerates the code,
or run `flutter gen-l10n`.

Translated so far: bottom bar, Home, Stats tab, Cards tab, Settings. Still English: the other
screens, the assistant's answers, insights and notifications.
