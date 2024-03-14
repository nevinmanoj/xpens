import 'package:flutter/material.dart';
import '../../../../shared/constants.dart';

class TrashSelector extends StatefulWidget {
  final String value;
  final Function(String) onValChange;
  const TrashSelector(
      {super.key, required this.value, required this.onValChange});

  @override
  State<TrashSelector> createState() => _TrashSelectorState();
}

class _TrashSelectorState extends State<TrashSelector> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField<String>(
        value: widget.value,
        validator: (value) =>
            value!.isEmpty ? ' Must select a Type for item' : null,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(
          "Type of Item",
          style: TextStyle(color: Colors.grey.withOpacity(0.8)),
        ),
        onChanged: (value) {
          widget.onValChange(value!);
        },
        items: inputTypes.map<DropdownMenuItem<String>>((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
