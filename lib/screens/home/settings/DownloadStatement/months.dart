import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

class Month extends StatefulWidget {
  final Function(String) setVal;
  final String month;
  Month({required this.setVal, required this.month});
  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200]?.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value: widget.month,
              validator: (value) =>
                  value!.isEmpty ? ' Must select a month' : null,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (val) {
                widget.setVal(val!);
              },
              items: monthList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
