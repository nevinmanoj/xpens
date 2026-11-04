# Gaps

Context: xpens is a personal app built around my own habits, so I'm the only user. These gaps leave out multi-user, store and onboarding concerns, and each item ends with the action I should take.

## Technical

- **No automated tests**
  Only bill split and the receipt parser have tests (`test/`), so bugs like the recent points one are only caught by hand.
  Action: add unit tests for `filterFunction`, `getDateTimesFromPeriod`, the milestone rollover logic and the cost formatters.

- **Untyped data layer**
  Expenses and points are passed around as raw `Map<String, dynamic>` or Firestore docs, so key typos only fail at runtime.
  Action: add typed models with `fromJson`/`toJson` for expenses and points, like the ones milestones and cards already have.

- **God-object provider**
  `UserInfoProvider` fetches every collection, runs milestone scheduling and checks for updates, so any change rebuilds the whole app.
  Action: split it into feature providers (expenses, points, milestones, streaks, settings).

- **Mixed state management**
  Provider and GetX are used side by side, and `Get.put` is called from inside widget fields.
  Bill split now uses its own Provider (`BillSplitProvider`).
  Action: migrate the milestone controller to Provider too.

- **Firestore listeners never cancelled**
  `snapshots().listen()` subscriptions are never cancelled, and `setUser` → `init()` stacks duplicate listeners after logging out and back in.
  Action: store the `StreamSubscription`s, cancel them on sign-out or user change, and clear cached data.

- **Full history loaded into memory**
  Every expense and point is streamed on launch, and all totals are computed on the client.
  Action: query by date range for the screens that need it, and paginate the list view, before my history grows enough to slow things down or hit Firestore free-tier read limits.

- **Weak date and ID modelling**
  Dates are stored as strings with duplicated `day`/`month`/`year` fields, and doc IDs come from `DateTime.now().toString()`.
  Action: store dates as `Timestamp`, use auto-IDs, and write a one-off migration script for my existing data.

- **Milestones only roll over on app open**
  The upcoming → active → closed transitions run on the client with many sequential reads and writes.
  Action: move this to a scheduled Cloud Function or at least batch the writes, so the data stays right even if I skip opening the app for a few days.

- **Errors are swallowed**
  Most failures are only `print`ed, and some async calls (e.g. `permaDelete`) aren't awaited, so a failed save can go unnoticed.
  Action: show a toast on failure and await every Firestore write.

- **No crash logging**
  I have no record of crashes or errors that happen on my phone outside debug sessions.
  Action: add Firebase Crashlytics, which is free and fits the existing Firebase setup.

- **Manual dev/prod switch**
  Dev and prod are selected by commenting lines in `Db.dart`, so a dev build can easily write test data into my real data.
  Action: switch to `--dart-define` or build flavours, with prod as the default for release builds.

- **Version drift**
  The provider hard-codes the version (`3.2.1`) while `pubspec.yaml` says `1.0.0`, and the update check compares the versions as plain strings.
  Action: read the version with `package_info_plus` and compare semantic versions.

- **CI only builds**
  The workflows build the APK but don't run `flutter analyze` or tests, and lints are silenced with `ignore_for_file`.
  Action: add analyze and test steps to `pull_req.yml` and gradually remove the ignores.

- **Outdated toolchain**
  CI is pinned to Flutter `3.19.0`, the lints are `flutter_lints ^2`, and the UI uses Material 2.
  Action: bump Flutter and the lints, then fix the deprecations (e.g. `withOpacity` and `MaterialStateProperty`).

- **Inconsistent naming**
  File and class names mix styles (`addMain.dart`, `ItemInputsMain.dart`, `milesstoneDatabase.dart`, `wrapper`, `listx`).
  Action: rename everything to `snake_case` files and `PascalCase` classes in a single refactor commit.

- **Dead code**
  `dev/test.dart` and other commented-out code are still in the repo.
  Action: either finish these or delete them, since git history keeps a copy.

- **No backup outside Firestore**
  All my data lives only in a single Firebase project, with no export I can restore from.
  Action: add a periodic full JSON export (or Firestore scheduled export) to Drive or local storage.

## Product

- **Streaks are hard to reach**
  The Streaks screen can only be opened from the Add welcome screen.
  Action: add it to Settings or as a card on the Analyze tab.

- **No budgets**
  There are no monthly or per-item spending limits and nothing warns me when I'm about to overspend.
  Action: build budgets on top of the milestone period engine, which already handles periods.

- **No recurring expenses**
  I have to enter rent, subscriptions and EMIs by hand every period.
  Action: add recurring templates that create the entries automatically, reusing the milestone template pattern.

- **No reminders**
  Nothing reminds me to log the day's spending, warns me when a streak is at risk, or flags a milestone that's about to close.
  Action: add local notifications with `flutter_local_notifications`.

- **No income tracking**
  The app only records outflows, so I can't see my monthly savings or net cash flow.
  Action: add an "Income" input type next to Expense and Points.

- **Basic analytics**
  The Analyze tab shows monthly and yearly totals and one graph, with no breakdown by item or group over time.
  Action: add item and group trend charts plus a month-over-month comparison.

- **Limited export**
  The Excel export covers one month only, has fixed columns, and leaves out points.
  Action: support a custom date range, the current list filter, and points in the export.

- **Trash never auto-purges**
  `deleteDate` is saved but never used, so the trash keeps growing and is fetched on every launch.
  Action: auto-delete items after N days, and only load the trash when the Trash screen is opened.

- **Search is exact-word only**
  Search only matches whole lowercase words from the name and remark tags.
  Action: add prefix matching and an amount-range filter.

- **No dark mode**
  The app has a single light theme with hard-coded colours.
  Action: move the colours into the `ThemeData` and add a dark theme that follows the system setting.
