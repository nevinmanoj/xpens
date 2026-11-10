import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/formFields.dart';
import 'package:xpens/screens/home/listx/listStream/listStream.dart'
    show formatRupee;
import 'package:xpens/services/database.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';
import 'package:xpens/shared/utils/toast.dart';

import 'cardsPointsFunc.dart';

const _sheetShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)));

Widget _handle() => Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

DatabaseService _db() =>
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid);

// ---------------------------------------------------------------------------
// Add / edit

/// Sheet to add a card, or edit [card]'s name and rate.
void showCardEditor(BuildContext context, {PointSource? card}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: _sheetShape,
    builder: (_) => _CardEditor(card: card),
  );
}

class _CardEditor extends StatefulWidget {
  final PointSource? card;
  const _CardEditor({this.card});

  @override
  State<_CardEditor> createState() => _CardEditorState();
}

class _CardEditorState extends State<_CardEditor> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.card?.name ?? "");
  late final _points = TextEditingController(text: _num(widget.card?.points));
  late final _rupees = TextEditingController(text: _num(widget.card?.rupees));
  bool _saving = false;

  static String _num(double? v) {
    if (v == null) return "";
    return v == v.roundToDouble() ? v.toInt().toString() : v.toString();
  }

  @override
  void dispose() {
    _name.dispose();
    _points.dispose();
    _rupees.dispose();
    super.dispose();
  }

  String? _positive(String? v) {
    final n = double.tryParse((v ?? "").trim());
    if (n == null) return "Enter a number";
    if (n <= 0) return "Must be more than 0";
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final card = PointSource(
      name: _name.text.trim(),
      points: double.parse(_points.text.trim()),
      rupees: double.parse(_rupees.text.trim()),
      selfId: widget.card?.selfId ?? "",
    );
    final ok = widget.card == null
        ? await _db().addPointSource(card)
        : await _db().updatePointSource(card);
    if (!mounted) return;
    Navigator.pop(context);
    showToast(
        context: context,
        msg: ok
            ? (widget.card == null ? "Card added" : "Card updated")
            : "Couldn't save the card");
  }

  @override
  Widget build(BuildContext context) {
    final p = double.tryParse(_points.text.trim()) ?? 0;
    final r = double.tryParse(_rupees.text.trim()) ?? 0;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _handle(),
                const SizedBox(height: 16),
                Text(widget.card == null ? "Add card" : "Edit card",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                const FieldLabel("Name"),
                TextFormField(
                  controller: _name,
                  autofocus: widget.card == null,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: primaryAppColor,
                  decoration: fieldDecoration(hint: "e.g. HDFC Regalia"),
                  validator: (v) =>
                      (v ?? "").trim().isEmpty ? "Enter a name" : null,
                ),
                const SizedBox(height: 20),
                const FieldLabel("Rate"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _points,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        cursorColor: primaryAppColor,
                        onChanged: (_) => setState(() {}),
                        validator: _positive,
                        decoration: fieldDecoration(hint: "Points"),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, 14, 10, 0),
                      child: Text("≈", style: TextStyle(fontSize: 18)),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _rupees,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        cursorColor: primaryAppColor,
                        onChanged: (_) => setState(() {}),
                        validator: _positive,
                        decoration: fieldDecoration(hint: "Rupees").copyWith(
                          prefixText: "₹ ",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p > 0 && r > 0
                      ? "1 point is worth ₹${(r / p).toStringAsFixed(2)}"
                      : "How many points are worth how many rupees",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                SubmitButton(
                  label: widget.card == null ? "Add card" : "Save",
                  loading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Details

/// Sheet with a card's rate, points used (all time and over a chosen
/// range), and Edit / Delete.
void showCardDetails(BuildContext context, PointSource card) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: _sheetShape,
    builder: (_) => _CardDetails(cardId: card.selfId),
  );
}

class _CardDetails extends StatefulWidget {
  final String cardId;
  const _CardDetails({required this.cardId});

  @override
  State<_CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<_CardDetails> {
  late DateTimeRange _range = DateTimeRange(
    start: DateUtils.dateOnly(DateTime(
        DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)),
    end: DateUtils.dateOnly(DateTime.now()),
  );

  Future<void> _pickRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange: _range,
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: primaryAppColor,
            onPrimary: secondaryAppColor,
            onSurface: primaryAppColor,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _range = picked);
  }

  Future<void> _delete(PointSource card) async {
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete ${card.name}?"),
        content: const Text(
            "The card is removed. Points you logged against it stay in your history."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            style: TextButton.styleFrom(foregroundColor: Colors.black87),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
            child: const Text("Delete",
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await _db().deletePointSource(card.selfId);
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = context.watch<UserInfoProvider>();
    final cards = userInfo.cards.map((e) => PointSource.fromJson(e)).toList();
    final card = cards.where((c) => c.selfId == widget.cardId).firstOrNull;
    if (card == null) return const SizedBox(height: 120);

    final entries = userInfo.pointDocs
        .where((e) => cardOf(e, cards)?.selfId == card.selfId);
    final rate = rupeesPerPoint(card);
    double all = 0, inRange = 0;
    final from = _range.start;
    final to = _range.end.add(const Duration(days: 1));
    for (final e in entries) {
      final pts = pointsOf(e);
      all += pts;
      final d = DateTime.parse(e['date']);
      if (!d.isBefore(from) && d.isBefore(to)) inRange += pts;
    }
    String rangeLabel() {
      final f = DateFormat(
          _range.start.year == _range.end.year ? "d MMM" : "d MMM y");
      return "${f.format(_range.start)} – ${DateFormat("d MMM y").format(_range.end)}";
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _handle(),
            const SizedBox(height: 20),
            Row(
              children: [
                const CardIcon(size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                      Text(
                          "${formatPoints(card.points)} ≈ ${formatRupee(card.rupees)}",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Used in total",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            Text(formatPoints(all),
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w700, height: 1.2)),
            Text("≈ ${formatRupee((all * rate).round())}",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: _pickRange,
                          borderRadius: BorderRadius.circular(6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(rangeLabel(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(width: 4),
                              const Icon(Icons.edit_calendar_outlined,
                                  size: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(formatPoints(inRange),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Text("≈ ${formatRupee((inRange * rate).round())}",
                      style: TextStyle(color: Colors.grey.shade700)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _delete(card),
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text("Delete"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      showCardEditor(context, card: card);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text("Edit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAppColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Black rounded square with a card glyph, used for every card.
class CardIcon extends StatelessWidget {
  final double size;
  const CardIcon({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: primaryAppColor,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child:
          Icon(Icons.credit_card, color: secondaryAppColor, size: size * 0.5),
    );
  }
}
