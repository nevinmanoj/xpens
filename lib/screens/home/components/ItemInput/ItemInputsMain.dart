import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/expenseDefault.dart';

import '../../../../shared/dataModals/AddItemModal.dart';
import 'formFields.dart';

/// Expense form used by Add, Edit, Add-from-calendar, bill split and
/// Defaults. With [isData] false it edits a default view (cost and date
/// optional) and passes an [ExpenseDefault] instead of an [AddItem].
class ItemInputs extends StatefulWidget {
  final bool isData;
  final String itemName;
  final DateTime? date;
  final TimeOfDay time;
  final String costS;
  final String remarks;
  final String location;
  final String buttonLabel;
  final String group;
  final Function buttonfunc;
  final dynamic optionDefault;

  const ItemInputs(
      {super.key,
      required this.optionDefault,
      required this.isData,
      required this.group,
      required this.itemName,
      required this.costS,
      required this.date,
      required this.location,
      required this.remarks,
      required this.time,
      required this.buttonLabel,
      required this.buttonfunc});
  @override
  State<ItemInputs> createState() => _ItemInputsState();
}

class _ItemInputsState extends State<ItemInputs> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _cost =
      TextEditingController(text: widget.costS);

  late String itemName = widget.itemName;
  late DateTime? date = widget.date;
  late TimeOfDay time = widget.time;
  late String location = widget.location;
  late String group = widget.group;
  late String remarks = widget.remarks;
  bool loading = false;

  /// Bumped after each add so text fields rebuild with the reset values.
  int _generation = 0;

  @override
  void dispose() {
    _cost.dispose();
    super.dispose();
  }

  String _default(String key, Object fallback) {
    final d = widget.optionDefault;
    return d == null || d[key] == null ? fallback.toString() : d[key].toString();
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void _resetAfterAdd(List allItems) {
    final now = TimeOfDay.now();
    _cost.text = _default("cost", "");
    itemName = _default("itemName", allItems[0]);
    group = _default("group", "none");
    location = _default("location", locationList[0]);
    remarks = _default("remarks", "");
    date = DateTime.parse(_default("date", DateTime.now()));
    time = _parseTime(_default("time", "${now.hour}:${now.minute}"));
    _generation++;
  }

  void _submit(List allItems) {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);
    final cost = double.tryParse(_cost.text.trim());

    if (widget.isData) {
      widget.buttonfunc(AddItem(
          group: group,
          isOther: !allItems.contains(itemName.trim()) || itemName == "Other",
          location: location,
          remarks: remarks.trim(),
          cost: cost!,
          date: date!,
          itemName: itemName.trim(),
          time: time));
    } else {
      widget.buttonfunc(ExpenseDefault(
        location: location,
        date: date,
        cost: cost,
        itemName: itemName.trim(),
        time: time,
        group: group,
        remarks: remarks.trim(),
      ));
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      if (widget.isData) _resetAfterAdd(allItems);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInfoProvider>(context);
    final List allItems = userInfo.items;
    final List docs = userInfo.docs;
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
                FieldLabel(widget.isData ? "Amount" : "Amount (optional)"),
                AmountField(
                    controller: _cost, isRequired: widget.isData, prefix: "₹"),
                gap,
                const FieldLabel("Category"),
                CategoryPicker(
                  items: allItems,
                  value: itemName,
                  docs: docs,
                  onChanged: (v) => setState(() => itemName = v),
                ),
                gap,
                const FieldLabel("Remarks"),
                SuggestField(
                  docs: docs,
                  tag: "remarks",
                  value: remarks,
                  hint: "Optional note",
                  onChanged: (v) => remarks = v,
                ),
                gap,
                const FieldLabel("Location"),
                LocationToggle(
                  value: location,
                  onChanged: (v) => setState(() => location = v),
                ),
                gap,
                const FieldLabel("When"),
                DateTimeRow(
                  date: date,
                  time: time,
                  allowNoDate: !widget.isData,
                  onDateChanged: (d) => setState(() => date = d),
                  onTimeChanged: (t) => setState(() => time = t),
                ),
                const SizedBox(height: 14),
                GroupField(
                  group: group,
                  docs: docs,
                  onChanged: (g) => setState(() => group = g),
                ),
                const SizedBox(height: 28),
                SubmitButton(
                  label: widget.buttonLabel,
                  loading: loading,
                  onPressed: () => _submit(allItems),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
