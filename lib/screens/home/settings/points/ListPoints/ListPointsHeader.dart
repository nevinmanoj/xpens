import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

class ListPointsHeader extends StatefulWidget {
  final String card;
  final Function(String) onValChange;
  ListPointsHeader({super.key, required this.card, required this.onValChange});

  @override
  State<ListPointsHeader> createState() => _ListPointsHeaderState();
}

class _ListPointsHeaderState extends State<ListPointsHeader> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    List allItems = userInfo.cards;
    return DropdownButtonFormField<String>(
      value: widget.card,
      validator: (value) =>
          value!.isEmpty ? ' Must select a category for item' : null,
      decoration: InputDecoration(border: InputBorder.none),
      hint: Text(
        "Category of Item",
        style: TextStyle(color: Colors.grey.withOpacity(0.8)),
      ),
      onChanged: (value) {
        widget.onValChange(value!);
      },
      items: ["All", ...allItems].map<DropdownMenuItem<String>>((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
