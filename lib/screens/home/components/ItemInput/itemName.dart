import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ItemInput/dropDown.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

import 'inputAutofill.dart';

class ItemName extends StatefulWidget {
  final Function(String) onNameChange;
  final String itemName;

  const ItemName(
      {super.key, required this.onNameChange, required this.itemName});

  @override
  State<ItemName> createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {
  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    List allItems = userInfo.items;
    return Column(
      children: [
        DropDownItems(
          enabled: true,
          onValueChange: (String? value) {
            widget.onNameChange(value!);
          },
          valueList: allItems,
          value: allItems.contains(widget.itemName) ? widget.itemName : "Other",
          heading: 'Category of Item',
        ),
        const SizedBox(height: 10),
        (widget.itemName == "Other" || !allItems.contains(widget.itemName))
            ? InputAutoFill(
                docs: userInfo.docs,
                value: widget.itemName == "Other" ? "" : widget.itemName,
                onValueChange: widget.onNameChange,
                tag: "itemName",
              )
            : Container(),
      ],
    );
  }
}
