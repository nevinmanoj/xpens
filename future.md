# Future Features

Context: xpens is a personal app, so these features are tailored to my own habits. Budgets, recurring expenses, reminders, income tracking, dark mode and backups already appear in [gap.md](gap.md), so they aren't repeated here.

- **Smart time-based defaults**
  Prefill the item from the time of day (Breakfast in the morning, Lunch at midday) and from my most frequent entry in that time slot.
  This cuts most entries down to typing the amount.

- **Home screen widget & quick add**
  An Android widget shows today's and this month's spend, with a one-tap button that opens Add with defaults filled in.
  This lets me log an expense without going through the app's navigation.

- **Bank SMS auto-capture**
  Parse my bank and card transaction SMS into draft expenses, then confirm or edit each one with a swipe.
  This is the biggest reduction in manual entry possible on Android.

- **Receipt photo on expenses**
  Receipt OCR now lives in Bill Split (scan → review → split). Still to do: attach the receipt image to an expense, and an optional "parse with AI" fallback for receipts ML Kit reads badly.
  This is handy for group expenses I need to reconcile later.

- **IOU tracker**
  Keep a simple ledger of money I've lent or borrowed per person, linked to expenses and groups.
  Bill Split's per-person totals could feed straight into it.

- **Subscription tracker**
  Keep a dedicated view of active subscriptions with their renewal dates, monthly and yearly cost, and a "still using?" prompt.
  This helps me spot subscriptions I've forgotten about.

- **Credit card points optimiser**
  Using my card earn rates from Points, suggest which card to use for each item or group, and track point expiry.
  This builds on the existing point-source data.

- **Savings goals**
  Set goals such as a trip or a gadget, tag contributions toward them, and show progress on the Analyze tab.
  This extends milestones beyond expense limits.

- **Plain-language insights**
  Generate an auto summary each month, e.g. "Petrol up 30%, eating out down ₹1,200 vs last month".
  It would appear as a card on the Analyze tab or as a monthly notification.

- **Ask my data**
  A natural-language query box answers questions like "how much on petrol since June?" and "biggest group spend this year".
  An LLM would translate each question into a filter over my expenses.

- **Voice entry**
  Saying "Lunch 250 yesterday, office" gets parsed into a structured expense.
  This is quicker than the form when I'm on the move.

- **Year in review**
  A Wrapped-style recap of the year: top items, busiest day, longest streak, milestones hit and total points used.
  It's a fun way to look back on the year's spending.

- **Investments & net worth snapshot**
  Track Investments entries as holdings rather than spend, with a manual monthly net-worth snapshot.
  This gives a single view of my financial position.

- **Google Sheets sync**
  Mirror my expenses into a personal Google Sheet for ad-hoc pivots, using the `googleapis` dependency that's already present.
  This makes it easy to run analysis outside the app.

- **Web dashboard**
  A Flutter web build of the Analyze and List screens lets me review, bulk edit and fix data on my laptop.
  It reuses the same Firestore backend.

- **Biometric app lock**
  Require a fingerprint unlock before the app opens.
  This keeps my finances private if someone else is using my phone.
