import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class DropDownItems extends StatelessWidget {
  final Function(String) onValueChange;
  final List valueList;
  final String value;
  final String heading;
  final bool enabled;
  const DropDownItems(
      {super.key,
      required this.onValueChange,
      required this.valueList,
      required this.value,
      required this.heading,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    return Container(
      width: wt * 0.8,
      decoration: addInputDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: DropdownButtonFormField<String>(
          value: value,
          validator: (value) => value!.isEmpty ? ' Must select a value' : null,
          decoration: const InputDecoration(border: InputBorder.none),
          hint: Text(
            heading,
            style: TextStyle(color: Colors.grey.withOpacity(0.8)),
          ),
          onChanged: enabled
              ? (value) {
                  onValueChange(value!);
                }
              : null,
          items: valueList.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
