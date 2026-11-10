import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

import '../../../../shared/dataModals/AddPointModal.dart';
import '../ItemInput/formFields.dart';

/// Points form used by Add and by editing a points entry.
class PointInputMain extends StatefulWidget {
  final String sourceId;
  final String cardName;
  final DateTime date;
  final TimeOfDay time;
  final String costS;
  final String itemName;
  final String location;
  final String buttonLabel;
  final String group;
  final Function(AddPoint) buttonfunc;

  const PointInputMain(
      {super.key,
      required this.group,
      required this.costS,
      required this.date,
      required this.location,
      required this.itemName,
      required this.time,
      required this.buttonLabel,
      required this.buttonfunc,
      required this.cardName,
      required this.sourceId});
  @override
  State<PointInputMain> createState() => _PointInputMainState();
}

class _PointInputMainState extends State<PointInputMain> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _points =
      TextEditingController(text: widget.costS);

  late String sourceId = widget.sourceId;
  late DateTime date = widget.date;
  late TimeOfDay time = widget.time;
  late String itemName = widget.itemName;
  bool loading = false;
  int _generation = 0;

  @override
  void dispose() {
    _points.dispose();
    super.dispose();
  }

  void _submit(List<PointSource> cards) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    widget.buttonfunc(AddPoint(
        cardName: cards.firstWhere((e) => e.selfId == sourceId).name,
        sourceId: sourceId,
        time: time,
        date: date,
        point: double.parse(_points.text.trim()),
        itemName: itemName.trim()));

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _points.clear();
      sourceId = cards[0].selfId;
      date = widget.date;
      time = TimeOfDay.now();
      loading = false;
      _generation++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final cards = userInfo.cards.map((e) => PointSource.fromJson(e)).toList();
    final unknownCard = !cards.any((c) => c.selfId == sourceId);
    const gap = SizedBox(height: 22);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKey,
        child: KeyedSubtree(
          key: ValueKey(_generation),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const FieldLabel("Points"),
                AmountField(controller: _points, isRequired: true),
                gap,
                const FieldLabel("Card"),
                if (unknownCard)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      "The card on this entry is no longer available. Pick another.",
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                DropdownButtonFormField<String>(
                  value: unknownCard ? null : sourceId,
                  hint: const Text("Choose a card"),
                  decoration: fieldDecoration(),
                  borderRadius: BorderRadius.circular(12),
                  validator: (v) => v == null ? "Choose a card" : null,
                  items: [
                    for (final c in cards)
                      DropdownMenuItem(value: c.selfId, child: Text(c.name)),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => sourceId = v);
                  },
                ),
                gap,
                const FieldLabel("Spent on"),
                SuggestField(
                  docs: userInfo.pointDocs,
                  tag: "itemName",
                  value: itemName,
                  hint: "What did you redeem?",
                  isRequired: true,
                  onChanged: (v) => itemName = v,
                ),
                gap,
                const FieldLabel("When"),
                DateTimeRow(
                  date: date,
                  time: time,
                  onDateChanged: (d) {
                    if (d != null) setState(() => date = d);
                  },
                  onTimeChanged: (t) => setState(() => time = t),
                ),
                const SizedBox(height: 28),
                SubmitButton(
                  label: widget.buttonLabel,
                  loading: loading,
                  onPressed: () => _submit(cards),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
