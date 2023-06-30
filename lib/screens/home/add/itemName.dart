import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemName extends StatefulWidget {
  final Function(String) onNameChange;
  String itemName;

  ItemName({required this.onNameChange, required this.itemName});

  @override
  State<ItemName> createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: addInputDecoration,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value:
                  cItems.contains(widget.itemName) ? widget.itemName : "Other",
              validator: (value) =>
                  value!.isEmpty ? ' Must select a category for item' : null,
              decoration: InputDecoration(border: InputBorder.none),
              hint: Text(
                "Category of Item",
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
              onChanged: (value) {
                widget.onNameChange(value!);
              },
              items: cItems.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
        (widget.itemName == "Other" || !cItems.contains(widget.itemName))
            ? Container(
                height: 50,
                width: 300,
                decoration: addInputDecoration,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    onChanged: (value) {
                      widget.onNameChange(value);
                    },
                    validator: (value) =>
                        value!.isEmpty ? ' Name cannot be empty' : null,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: 'Item Name',
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
