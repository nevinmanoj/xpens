// Turns OCR'd receipt text into bill lines. Pure Dart (no ML Kit types) so it
// can be unit tested with text fixtures.

/// One line of recognised text with its bounding box.
class OcrLine {
  final String text;
  final double left, top, right, bottom;
  const OcrLine(this.text,
      {required this.left,
      required this.top,
      required this.right,
      required this.bottom});

  double get centerY => (top + bottom) / 2;
  double get height => bottom - top;
}

enum ReceiptLineKind { item, charge, discount }

class ParsedLine {
  final String name;
  final int pricePaise;
  final ReceiptLineKind kind;

  /// Whether the review screen should tick this line by default.
  final bool suggested;
  const ParsedLine(this.name, this.pricePaise, this.kind,
      {this.suggested = true});

  @override
  String toString() => "ParsedLine($name, $pricePaise, ${kind.name})";
}

class ParsedReceipt {
  final List<ParsedLine> lines;
  final int? totalPaise;
  final int? subtotalPaise;
  const ParsedReceipt(this.lines, {this.totalPaise, this.subtotalPaise});
}

/// A visual row: OCR lines at the same height, joined left to right.
class ReceiptRow {
  final String text;
  final double left;
  final double height;
  const ReceiptRow(this.text, this.left, this.height);
}

// ---- Keywords (matched on lowercase text) ----------------------------------

final _subtotal = RegExp(r'sub\s*-?\s*total');
final _strongTotal = RegExp(
    r'grand\s*total|net\s*(amount|amt|payable|total)|amount\s*payable|bill\s*amount|total\s*(amount|amt|payable|due)|to\s*pay|\bbl\.?\s*tot\b');
final _total = RegExp(r'\btotal\b|^\s*amount\b');
// Rows that say "total" but aren't the bill total.
final _notTotal = RegExp(
    r'total\s*(qty|quantity|items?|no|gst|tax|vat|discount|savings)|no\.?\s*of\s*items');
final _charge = RegExp(
    r'\b(c\s*gst|s\s*gst|i\s*gst|u\s*gst|gst|vat|cess|tax|service\s*(charge|chg|tax)|round(ed)?\s*(off|ing)|packing|delivery|tip)\b');
final _discount = RegExp(r'\b(discount|disc|offer|savings?|coupon|promo)\b');
final _noise = RegExp(r'gstin|fssai|\bhsn\b|\bsac\b|\bbill\s*no|\binvoice\b'
    r'|\border\s*(no|id)\b|\bkot\b|\btoken\b|\btable\b|\btbl\b|\bdate\b'
    r'|\btime\b|\bphone\b|\bph\b|\bmob(ile)?\b|\btel\b|\bcontact\b'
    r'|\bcashier\b|\bwaiter\b|\bsteward\b|\bserver\b|\bcovers?\b|\bpax\b'
    r'|\bthank|\bvisit\b|\bcash\b|\bcard\b|\bupi\b|\bpaid\b|\breceived\b'
    r'|\bpayment\b|\bchange\b|\btender(ed)?\b|\bbalance\b|\binclusive\b'
    r'|\bpowered\b|m/c|www\.|\.com\b'
    // Column headers: "Qty Rate", "Qty. Price", "Price Amount", "Rate Total"
    r'|\bqty\.?\s+(rate|price)\b|\b(rate|price)\s+(amount|total)\b'
    // Counters: "Item: 5", "Qty: 5"
    r'|\b(qty|quantity|items?)\s*[:.]\s*\d');
// A label for a number: "Bill No.:", "M/C NO"
final _endsWithNo = RegExp(r'\bno\.?\s*[:.]?\s*$');

// A money amount at the end of a row, preceded by a space, a label colon
// ("Total:1302") or start of line, so times (12:45), dates (01/11) and IDs
// (A-102) aren't read as prices. ₹ is often misread as z or ?. Some printers
// use a dash for the decimal point ("547-00").
final _trailingAmount = RegExp(
    r'(?:^|\s|(?<!\d):)[zZ?]?([-+]?\d[\d,]*(?:[.,]\d{1,2}|-\d{2})?)\s*[*]?\s*$');
final _qtyByRate = RegExp(r'(\d{1,3})\s*[xX×@]\s*(\d[\d,]*(?:\.\d{1,2})?)');
final _qtyUnit =
    RegExp(r'\b(\d{1,3})\s*(nos?|pcs?)\b\.?', caseSensitive: false);
final _trailingNumbers = RegExp(r'(?:(?:^|\s+)\d[\d,]*(?:\.\d{1,2})?)+\s*$');
final _currency = RegExp(r'₹|\brs\.?|\binr\b', caseSensitive: false);
final _wordTail = RegExp(r'^[A-Za-z]{1,2}$');

class _Draft {
  String name;
  final int qty;
  final int price;
  final ReceiptLineKind kind;
  final double left;
  int row;
  _Draft(this.name, this.qty, this.price, this.kind, this.left, this.row);
}

ParsedReceipt parseReceipt(List<OcrLine> ocrLines) {
  final rows = groupRows(ocrLines);
  final drafts = <_Draft>[];
  final strongTotals = <int>[];
  final totals = <int>[];
  int? subtotal;

  // Name-only rows waiting for a price row below them ("ICED TEA" then
  // "1NO 40.00 40.00"), or to be appended to the item above as a wrapped
  // second line ("Spicy Kanthari ... 210.00" then "Chicken Mandi").
  String? pending;
  var pendingFirstRow = -1;
  var pendingLastRow = -1;
  var pendingLeft = 0.0;

  // A total label whose amount is on the next row ("BL.TOT (ROUNDED)" then
  // "CASH ₹ 547-00").
  var expectTotal = false;

  _Draft? lastItem() {
    for (final d in drafts.reversed) {
      if (d.kind == ReceiptLineKind.item) return d;
    }
    return null;
  }

  bool alignedWith(_Draft d, double left, double height) =>
      (d.left - left).abs() <= height * 2;

  void flushPending(double height) {
    final last = lastItem();
    if (pending != null &&
        last != null &&
        last.row == pendingFirstRow - 1 &&
        alignedWith(last, pendingLeft, height)) {
      last.name = "${last.name} $pending";
      last.row = pendingLastRow;
    }
    pending = null;
  }

  for (var r = 0; r < rows.length; r++) {
    final row = rows[r];
    final text = row.text
        .replaceAll(_currency, ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final lower = text.toLowerCase();
    final found = _findAmount(text);

    if (found == null) {
      final tidy = _tidy(text);
      final last = lastItem();
      if (last != null &&
          last.row == r - 1 &&
          _wordTail.hasMatch(tidy) &&
          alignedWith(last, row.left, row.height)) {
        // A word broken across lines: "Omelett" + "e".
        last.name += tidy;
        last.row = r;
      } else if (_isTotalLabel(lower)) {
        flushPending(row.height);
        expectTotal = true;
      } else if (_looksLikeName(lower)) {
        if (pending != null &&
            pendingLastRow == r - 1 &&
            (pendingLeft - row.left).abs() <= row.height * 2) {
          pending = "$pending $tidy";
        } else {
          flushPending(row.height);
          pending = tidy;
          pendingFirstRow = r;
          pendingLeft = row.left;
        }
        pendingLastRow = r;
      } else {
        flushPending(row.height);
      }
      continue;
    }

    final (amount, start) = found;
    final name = text.substring(0, start).trim();
    final nameLower = name.toLowerCase();

    if (expectTotal &&
        !_isKeyword(nameLower) &&
        (name.isEmpty || _noise.hasMatch(nameLower))) {
      flushPending(row.height);
      strongTotals.add(amount);
    } else if (_subtotal.hasMatch(nameLower)) {
      flushPending(row.height);
      subtotal = amount;
    } else if (_notTotal.hasMatch(nameLower)) {
      flushPending(row.height);
    } else if (_strongTotal.hasMatch(nameLower)) {
      flushPending(row.height);
      strongTotals.add(amount);
    } else if (_total.hasMatch(nameLower)) {
      flushPending(row.height);
      totals.add(amount);
    } else if (_charge.hasMatch(nameLower)) {
      flushPending(row.height);
      if (amount != 0) {
        drafts.add(_Draft(
            _tidy(name), 1, amount, ReceiptLineKind.charge, row.left, r));
      }
    } else if (_discount.hasMatch(nameLower)) {
      flushPending(row.height);
      if (amount != 0) {
        drafts.add(_Draft(_tidy(name), 1, -amount.abs(),
            ReceiptLineKind.discount, row.left, r));
      }
    } else if (_noise.hasMatch(lower) || _endsWithNo.hasMatch(nameLower)) {
      // Header/footer text that happens to end in a number.
      flushPending(row.height);
    } else {
      final (itemName, qty) = _parseItem(name, amount);
      if (itemName.isEmpty && pending != null) {
        // Price row under its name row.
        if (amount != 0) {
          drafts.add(_Draft(
              pending!, qty, amount, ReceiptLineKind.item, pendingLeft, r));
        }
        pending = null;
      } else {
        flushPending(row.height);
        if (itemName.isNotEmpty && amount != 0) {
          drafts.add(
              _Draft(itemName, qty, amount, ReceiptLineKind.item, row.left, r));
        }
      }
    }
    expectTotal = false;
  }
  if (rows.isNotEmpty) flushPending(rows.last.height);

  int? maxOf(List<int> xs) =>
      xs.isEmpty ? null : xs.reduce((a, b) => a > b ? a : b);

  return ParsedReceipt(
    [
      for (final d in drafts)
        ParsedLine(d.qty > 1 ? "${d.name} ×${d.qty}" : d.name, d.price, d.kind,
            suggested: d.kind != ReceiptLineKind.item ||
                (_looksLikeName(d.name.toLowerCase()) && d.price > 0))
    ],
    totalPaise: maxOf(strongTotals) ?? maxOf(totals),
    subtotalPaise: subtotal,
  );
}

/// Merges OCR lines that sit on the same visual row (ML Kit often returns
/// the item name and its price as separate blocks) and orders each row
/// left to right.
List<ReceiptRow> groupRows(List<OcrLine> lines) {
  if (lines.isEmpty) return [];
  final sorted = [...lines]..sort((a, b) => a.centerY.compareTo(b.centerY));
  final rows = <List<OcrLine>>[];
  for (final line in sorted) {
    if (rows.isNotEmpty) {
      final row = rows.last;
      final rowCenter =
          row.fold<double>(0, (a, l) => a + l.centerY) / row.length;
      final h = [line.height, ...row.map((l) => l.height)]
          .reduce((a, b) => a < b ? a : b);
      if ((line.centerY - rowCenter).abs() < h * 0.5) {
        row.add(line);
        continue;
      }
    }
    rows.add([line]);
  }
  return [
    for (final row in rows)
      () {
        final cells = [...row]..sort((a, b) => a.left.compareTo(b.left));
        return ReceiptRow(
          cells.map((l) => l.text.trim()).join(' '),
          cells.first.left,
          cells.map((l) => l.height).reduce((a, b) => a < b ? a : b),
        );
      }()
  ];
}

/// The trailing amount in paise and where it starts, or null if the row
/// doesn't end in a price.
(int, int)? _findAmount(String text) {
  final m = _trailingAmount.firstMatch(text);
  if (m == null) return null;
  final raw = m.group(1)!;
  // Phone numbers, FSSAI and other long IDs.
  if (RegExp(r'^[-+]?\d{7,}$').hasMatch(raw)) return null;
  final paise = _parseAmount(raw);
  return paise == null ? null : (paise, m.start);
}

/// Splits "Paneer Tikka 2 125.00" into the name and quantity. The amount
/// passed in is the line total (last number on the row).
(String, int) _parseItem(String name, int amount) {
  int? qty;

  final qr = _qtyByRate.firstMatch(name);
  if (qr != null) {
    qty = int.parse(qr.group(1)!);
    name = name.replaceRange(qr.start, qr.end, ' ');
  }
  // "1NO", "2 Nos", "3 pcs"
  final unit = _qtyUnit.firstMatch(name);
  if (unit != null) {
    qty ??= int.parse(unit.group(1)!);
    name = name.replaceRange(unit.start, unit.end, ' ');
  }
  // Column layout: "<name> <qty> <rate>" or "<name> <qty>".
  final tail = _trailingNumbers.firstMatch(name);
  if (tail != null) {
    if (qty == null) {
      final nums = tail
          .group(0)!
          .trim()
          .split(RegExp(r'\s+'))
          .map(_parseAmount)
          .whereType<int>()
          .toList();
      if (nums.isNotEmpty && nums.first % 100 == 0) {
        final q = nums.first ~/ 100;
        final rateMatches = nums.length >= 2 &&
            (q * nums[1] - amount).abs() <= q; // allow paise rounding
        if (q >= 1 && q <= 99 && (nums.length == 1 || rateMatches)) qty = q;
      }
    }
    name = name.substring(0, tail.start);
  }
  return (_tidy(name), qty ?? 1);
}

int? _parseAmount(String raw) {
  var s = raw.replaceFirst('+', '');
  // "547-00": dash as the decimal point.
  s = s.replaceFirst(RegExp(r'(?<=\d)-(?=\d{2}$)'), '.');
  // "250,00" with no dot: comma is the decimal separator.
  if (!s.contains('.') && RegExp(r',\d{2}$').hasMatch(s)) {
    s = s.replaceFirst(RegExp(r',(?=\d{2}$)'), '.');
  }
  s = s.replaceAll(',', '');
  final v = double.tryParse(s);
  return v == null ? null : (v * 100).round();
}

bool _isKeyword(String lower) =>
    _subtotal.hasMatch(lower) ||
    _notTotal.hasMatch(lower) ||
    _strongTotal.hasMatch(lower) ||
    _total.hasMatch(lower) ||
    _charge.hasMatch(lower) ||
    _discount.hasMatch(lower);

bool _isTotalLabel(String lower) =>
    (_strongTotal.hasMatch(lower) || _total.hasMatch(lower)) &&
    !_notTotal.hasMatch(lower) &&
    !_noise.hasMatch(lower);

bool _looksLikeName(String lower) =>
    RegExp(r'[a-z]{2}').hasMatch(lower) &&
    !_noise.hasMatch(lower) &&
    !_isKeyword(lower);

String _tidy(String s) => s
    // Leading serial number ("1. Naan", "1.pad thai", "12 Paneer Tikka"),
    // but not "7 Up".
    .replaceAll(RegExp(r'^\s*\d{1,3}(?:[.)]\s*|\s+)(?=[A-Za-z]{3})'), '')
    .replaceAll(RegExp(r'^[\s\-:*#]+'), '')
    .replaceAll(RegExp(r'[\s:\-.*]+$'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim();
