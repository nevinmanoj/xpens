import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

class CardName extends StatefulWidget {
  final Function(String) onNameChange;
  final String itemName;

  const CardName(
      {super.key, required this.onNameChange, required this.itemName});

  @override
  State<CardName> createState() => _CardNameState();
}

class _CardNameState extends State<CardName> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    double wt = MediaQuery.of(context).size.width;
    // double ht = MediaQuery.of(context).size.width;
    List cards = userInfo.cardss.map((e) => PointSource.fromJson(e)).toList();
    return Column(
      children: [
        Container(
          width: wt * 0.8,
          decoration: addInputDecoration,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: InputBorder.none),
              hint: Text(
                "Category of Item",
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
              onChanged: userInfo.cardss.isEmpty
                  ? null
                  : (value) {
                      widget.onNameChange(value!);
                    },
              value: widget.itemName,
              items: cards.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value.selfId,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
