import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class FilterDetails extends StatefulWidget {
  String filter;
  final Function(String) onFilterChanged;
  FilterDetails({required this.onFilterChanged, required this.filter});
  @override
  State<FilterDetails> createState() => _FilterDetailsState();
}

class _FilterDetailsState extends State<FilterDetails> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List<bool> _selectedfilter = [];
    for (int i = 0; i < filterList.length; i++) {
      _selectedfilter.add(widget.filter == filterList[i]);
    }
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        widget.onFilterChanged(filterList[index]);
        // setState(() {
        //   for (int i = 0; i < _selectedfilter.length; i++) {
        //     _selectedfilter[i] = i == index;
        //   }
        // });
      },
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: primaryAppColor,
      selectedColor: Colors.white,
      fillColor: primaryAppColor,
      color: primaryAppColor,
      constraints: BoxConstraints(
        minHeight: ht * 0.05,
        minWidth: wt * 0.28,
      ),
      isSelected: _selectedfilter,
      children: widgetList(filterList),
    );
  }
}

List<Widget> widgetList(List<String> list) {
  List<Widget> res = [];
  for (String item in list) {
    res.add(Container(child: Text(item)));
  }
  return res;
}
