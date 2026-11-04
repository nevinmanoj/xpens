# Bill Split Rebuild + Receipt OCR — Plan

**Status (2026-11-01):** implemented. Where the build differs from the plan below:
- The add button adds an item manually. Scanning is in the AppBar and on the empty screen.
- Tapping a person chip (not long-pressing it) opens rename/remove.
- The receipt total isn't kept in the provider. The total check happens only on the review screen.
- New items, both manual and scanned dishes, start unassigned. Scanned tax, charge and discount lines start split equally across everyone.
- Parser tests include six of my real receipts, transcribed from photos in `test/fixtures/receipts/` (git-ignored).

## Decisions

- **OCR:** Google ML Kit text recognition, on-device and free. No backend.
- **Persistence:** none. The bill lives in memory until the app is closed, and leaving the screen and coming back keeps it.
- **"Me":** one person can be marked as me. When the split is done, a **preview** of my share opens on the normal expense form. Nothing is saved until I review it and tap Add.
- **Split modes:** Equal, Shares (e.g. 2:1), Exact amounts, and Percent. Quick tap assignment from the item list.
- **State:** a new `BillSplitProvider` (a `ChangeNotifier`), separate from `UserInfoProvider`. GetX is dropped from this feature.

## Why rebuild

The current module (`lib/screens/home/settings/billSplit/`) is commented out of Settings and has these bugs:

- `removeBillItem` looks up the item after it has already been removed, so deleting any item that has shares crashes with a `StateError`.
- `updateBillItem` overwrites the item before subtracting the old shares. It subtracts using the new cost, and renaming an item leaves its old shares orphaned, so person totals drift.
- Person totals are kept as running sums that are patched on every edit, which is the root cause of the drift above.
- Items and shares are linked by **name**. A duplicate name is silently rejected (only a `print`), and a rename breaks the link.
- `SplitEven` uses the original `widget.item.cost` instead of the edited cost.
- `removePerson` silently does nothing once any item exists.
- Three of the four split tabs say "coming soon".
- Amounts show as raw doubles (e.g. `₹ 33.333333333`).
- `Get.put(BillSplitController())` is called in the field of every widget.

## Design

### Data model: `lib/shared/dataModals/billSplitModels.dart`

This replaces `BillISplitModal.dart` and removes the `fraction` dependency, which nothing else uses.

```dart
class Person { final String id; String name; final bool isMe; }

enum SplitMode { equal, shares, exact, percent }

class BillItem {
  final String id;
  String name;
  int pricePaise;                 // money as int paise, so no float errors
  SplitMode mode;
  Map<String, num> weights;       // personId -> weight; the mode decides how it's read
}
```

A single `weights` map covers every mode:

| Mode    | Weight means          | A person's share                  | Valid when             |
|---------|-----------------------|-----------------------------------|------------------------|
| equal   | 1 if selected         | price ÷ number of selected people | ≥ 1 person selected    |
| shares  | integer shares        | price × w ÷ Σw                    | Σw > 0                 |
| exact   | amount in paise       | w                                 | Σw == price            |
| percent | percent               | price × w ÷ 100                   | Σw == 100              |

- **IDs, not names.** Duplicate item names are allowed, and renaming never breaks anything.
- **Derived totals, never cached.** `personTotal`, `billTotal` and `unassigned` are computed from `items` on every read. That is O(items × people), which costs nothing at receipt scale, and it removes the whole class of drift bugs.
- **Rounding:** split in paise with the largest-remainder method, so per-person shares always add up exactly to the item price. For example, ₹100 split three ways gives 33.34, 33.33 and 33.33, and the extra paisa goes deterministically to the first person in order.
- Switching mode resets the weights to a sensible default (equal, using the people already selected) instead of trying to convert them.

### State: `lib/services/providers/BillSplitProvider.dart`

- `class BillSplitProvider extends ChangeNotifier`. It holds `List<Person> people`, `List<BillItem> items` and an optional `int? receiptTotalPaise` taken from OCR, used for a mismatch check.
- Methods: `addPerson`, `renamePerson`, `removePerson` (also strips that person from item weights), `toggleMe`, `addItem`, `addItems` (bulk, from OCR), `updateItem`, `removeItem`, `togglePersonOnItem` (quick tap, equal mode), `setWeights`, and `clear`.
- Getters: `shareOf(item)`, `personTotal(id)`, `billTotal`, `assignedTotal`, `unassignedItems`, `invalidItems`, `me`.
- **Registration:** in `main.dart`, wrap the existing tree with a `ChangeNotifierProvider<BillSplitProvider>` above `MaterialApp`. It is created once per app run, so it lives "until the app is closed". It is not part of `UserInfoProvider`, so bill edits never rebuild the rest of the app.
- Pure split math (largest remainder and mode logic) lives in plain functions, which makes it easy to unit test.

### Screens (`lib/screens/home/settings/billSplit/`, old files deleted)

1. **`billSplitMain.dart`: one main screen, no tabs**
   - **People bar** at the top: a horizontal row of chips with an add-person chip, plus an "Add me" chip that is shown until I've been added. Long-press a chip to rename or remove that person.
   - **Item list:** each card shows the name, price, a mode badge and a row of person chips. **Tapping a chip toggles that person (equal mode)**, which is the quick-tap assignment. Cards with no people assigned, or with invalid exact/percent weights, are highlighted.
   - **Add button** with two options: *Add item* and *Scan receipt*.
   - **Footer:** bill total, an "₹X unassigned" warning when needed, and a **Summary** button.
   - AppBar action: **New bill** (clear), with a confirmation dialog.
2. **`billItemEditSheet.dart`: bottom sheet opened by tapping a card's body**
   - Name and price fields, a segmented control for Equal / Shares / Exact / %, and a per-person input list for the chosen mode.
   - Live "remaining ₹X / X%" indicator. Save is disabled while the item is invalid. Delete button.
3. **`receiptReview.dart`: after scanning**
   - Editable list of the detected lines. Each line has an include checkbox and editable name and price.
   - Banner comparing the sum of the selected items with the receipt total detected by OCR (e.g. "Items ₹1,240 vs receipt ₹1,302: ₹62 missing, likely tax"). Tax, service charge and similar lines are detected and listed as normal items so I can include them. They default to Equal across everyone.
   - **Add to bill** calls `addItems`.
4. **`billSummary.dart`**
   - Per-person totals, each expandable to show its item breakdown with the per-item share.
   - Warning if any items are unassigned or invalid.
   - If "me" exists: a **Preview my expense** button.
5. **`myExpensePreview.dart`: review before adding**
   - Pushes a page that reuses the existing `ItemInputs` widget (as in `addMain.dart`) with these values:
     - `costS` = my total
     - `remarks` = e.g. `"Bill split (4 people): Paneer tikka, Naan ×2, Tax"`
     - `date` and `time` = now
     - `itemName` and `group` from my Expense defaults (same lookup as `addMain.dart`)
   - Every field stays editable. **Only tapping Add** calls `DatabaseService.addItem`, then shows a toast and pops. Nothing is written automatically.

Re-enable the Settings entry in `settings.dart` (currently commented out at lines 88–95).

### OCR pipeline

**Packages:** `google_mlkit_text_recognition` and `image_picker` (camera and gallery).
- Android `minSdk` is already 23, which is fine (ML Kit needs 21 or higher).
- The bundled Latin model adds roughly a few MB to the APK.

**Flow:** pick or take a photo → `TextRecognizer(script: latin).processImage` → `ReceiptParser.parse(recognizedText)` → `receiptReview.dart`.

**`lib/shared/utils/receiptParser.dart`** is pure Dart and unit-testable. It takes the lines with their bounding boxes and returns `ParsedReceipt { items, charges, total }`.

1. **Rebuild rows.** ML Kit often returns the item name and price as separate blocks (two columns). Merge text lines whose vertical centres overlap into one row, then sort each row left to right.
2. **Find the amount.** The last money-looking token on the row is the amount (`\d[\d,]*[.,]\d{2}` or a plain integer at the end). This handles "Qty Rate Amount" layouts, where the last number is the line total.
3. **Classify each row by keyword (case-insensitive):**
   - `grand total`, `net amount`, `total`, `amount payable` → receipt total (take the largest or last match)
   - `sub total` → ignored, used only as a cross-check
   - `cgst`, `sgst`, `gst`, `vat`, `service charge`, `tax`, `round off` → charges (imported as items)
   - `discount` → negative item
   - Header and footer noise is dropped: `gstin`, `bill no`, `table`, `date`, `time`, phone numbers, `thank you`, `cash`, `card`, `change`.
4. **Quantity:** detect `2 x 120`, `2 @ 60` and a leading quantity column, and fold the quantity into the name (`Naan ×2`) while keeping the line total as the price.
5. Anything ambiguous is still shown in the review screen, unticked, rather than dropped.

## Implementation order

1. **Models, math and provider.** Write `billSplitModels.dart`, the split functions and `BillSplitProvider`. Add `test/bill_split_test.dart` to cover each mode, the rounding (shares always sum to the price), and removing a person.
2. **Main screen and edit sheet** with manual items, quick tap and all four modes. Register the provider in `main.dart` and re-enable the Settings entry.
3. **Summary, "me" and the expense preview** reusing `ItemInputs`.
4. **OCR.** Add the packages, write `receiptParser.dart` with tests that use text fixtures from a few of my real receipts, then build `receiptReview.dart`.
5. **Cleanup.**
   - Delete `billSplitGetxController.dart`, `billSplitFooter.dart`, `billItems/` and `persons/`.
   - Delete `BillISplitModal.dart` and the `fraction` dependency.
   - Keep `get`, because `firstWhereOrNull` and other code still use it.
   - Update `gap.md` (bill split shipped; one fewer GetX controller) and `future.md` (receipt OCR now lives in bill split).

## Out of scope (possible later)

- Proportional tax/tip distribution, i.e. spreading charges by each person's subtotal instead of equally. The model supports it later as a bill-level field.
- Sharing the summary as text via `share_plus` (already a dependency).
- Saving bills, or attaching the receipt image to the expense.
- A "parse with AI" fallback for receipts ML Kit can't parse well.

## Need from me

- 3–5 photos of typical receipts (restaurant, supermarket, a printed GST bill) to build the parser test fixtures and tune its keywords.
