import 'package:intl/intl.dart';

class Person {
  final String id;
  final String name;
  final bool isMe;
  const Person({required this.id, required this.name, this.isMe = false});

  Person copyWith({String? name}) =>
      Person(id: id, name: name ?? this.name, isMe: isMe);
}

enum SplitMode { equal, shares, exact, percent }

extension SplitModeLabel on SplitMode {
  String get label => switch (this) {
        SplitMode.equal => "Equal",
        SplitMode.shares => "Shares",
        SplitMode.exact => "Exact",
        SplitMode.percent => "%",
      };
}

/// One line on the bill. Money is stored as int paise.
///
/// [weights] maps personId -> weight, read according to [mode]:
/// - equal:   1 for each selected person
/// - shares:  integer shares (2:1 etc.)
/// - exact:   amount in paise
/// - percent: percentage
class BillItem {
  final String id;
  final String name;
  final int pricePaise;
  final SplitMode mode;
  final Map<String, num> weights;

  const BillItem({
    required this.id,
    required this.name,
    required this.pricePaise,
    this.mode = SplitMode.equal,
    this.weights = const {},
  });

  BillItem copyWith({
    String? name,
    int? pricePaise,
    SplitMode? mode,
    Map<String, num>? weights,
  }) =>
      BillItem(
        id: id,
        name: name ?? this.name,
        pricePaise: pricePaise ?? this.pricePaise,
        mode: mode ?? this.mode,
        weights: weights ?? this.weights,
      );

  /// People with a non-zero weight on this item.
  List<String> get participants => [
        for (final e in weights.entries)
          if (e.value != 0) e.key
      ];

  bool get isAssigned => participants.isNotEmpty;
}

// ---------------------------------------------------------------------------
// Split math. Pure functions so they can be unit tested.
// ---------------------------------------------------------------------------

/// Splits [total] paise across [weights] proportionally using the
/// largest-remainder method, so the parts always sum exactly to [total].
/// Ties go to the earlier key, making the result deterministic.
Map<String, int> allocate(int total, Map<String, num> weights) {
  final entries = [
    for (final e in weights.entries)
      if (e.value > 0) e
  ];
  final sum = entries.fold<num>(0, (a, e) => a + e.value);
  if (entries.isEmpty || sum <= 0) return {};

  final sign = total < 0 ? -1 : 1;
  final abs = total.abs();
  final floors = <int>[];
  final remainders = <double>[];
  var allocated = 0;
  for (final e in entries) {
    final exact = abs * e.value / sum;
    // Small epsilon so 2999.9999999 from float error floors to 3000.
    final floor = (exact + 1e-9).floor();
    floors.add(floor);
    remainders.add(exact - floor);
    allocated += floor;
  }

  final order = List<int>.generate(entries.length, (i) => i)
    ..sort((a, b) {
      final c = remainders[b].compareTo(remainders[a]);
      return c != 0 ? c : a.compareTo(b);
    });
  for (var i = 0; i < abs - allocated; i++) {
    floors[order[i % order.length]] += 1;
  }

  return {
    for (var i = 0; i < entries.length; i++) entries[i].key: floors[i] * sign
  };
}

/// Sum of the weights that are entered for [item] (paise for exact,
/// percent for percent mode).
num weightSum(BillItem item) =>
    item.weights.values.fold<num>(0, (a, b) => a + b);

/// How far the entered weights are from what the mode requires:
/// paise left for exact, percent left for percent, 0 for other modes.
num remaining(BillItem item) => switch (item.mode) {
      SplitMode.exact => item.pricePaise - weightSum(item),
      SplitMode.percent => 100 - weightSum(item),
      _ => 0,
    };

/// True when the item's weights describe a complete split.
bool isValidSplit(BillItem item) {
  if (!item.isAssigned) return false;
  return switch (item.mode) {
    SplitMode.equal || SplitMode.shares => true,
    SplitMode.exact => remaining(item) == 0,
    SplitMode.percent => remaining(item).abs() < 0.005,
  };
}

/// Each person's share of [item] in paise, or null if the split is
/// unassigned or invalid.
Map<String, int>? splitItem(BillItem item) {
  if (!isValidSplit(item)) return null;
  return switch (item.mode) {
    SplitMode.equal =>
      allocate(item.pricePaise, {for (final id in item.participants) id: 1}),
    SplitMode.shares ||
    SplitMode.percent =>
      allocate(item.pricePaise, item.weights),
    SplitMode.exact => {
        for (final e in item.weights.entries)
          if (e.value != 0) e.key: e.value.round()
      },
  };
}

/// Default weights when switching [item] to [mode]: the current
/// participants (or [everyone] if none) split evenly, so the item is
/// valid straight away.
Map<String, num> defaultWeights(
    BillItem item, SplitMode mode, List<String> everyone) {
  final ids = item.isAssigned ? item.participants : everyone;
  if (ids.isEmpty) return {};
  final even = {for (final id in ids) id: 1};
  return switch (mode) {
    SplitMode.equal || SplitMode.shares => even,
    SplitMode.exact => allocate(item.pricePaise, even),
    // Percent in hundredths, e.g. 33.34 / 33.33 / 33.33.
    SplitMode.percent =>
      allocate(10000, even).map((k, v) => MapEntry(k, v / 100)),
  };
}

// ---------------------------------------------------------------------------
// Money helpers
// ---------------------------------------------------------------------------

int toPaise(double rupees) => (rupees * 100).round();

/// Parses user input like "250", "1,250.50" into paise. Null if invalid.
int? parsePaise(String input) {
  final cleaned = input.replaceAll(',', '').replaceAll('₹', '').trim();
  final value = double.tryParse(cleaned);
  return value == null ? null : toPaise(value);
}

final _inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

String formatPaise(int paise) => _inr.format(paise / 100);

/// Plain number for prefilling inputs: "250" or "33.33".
String paiseToInput(int paise) {
  if (paise % 100 == 0) return (paise ~/ 100).toString();
  return (paise / 100).toStringAsFixed(2);
}
