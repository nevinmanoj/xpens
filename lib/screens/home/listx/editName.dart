import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemName extends StatefulWidget {
  final Function(String) onNameChanged;
  String name;

  ItemName({required this.onNameChanged, required this.name});
  @override
  State<ItemName> createState() => _ItemNameState();
}

class _ItemNameState extends State<ItemName> {
  @override
  Widget build(BuildContext context) {
    TextEditingController otherController = new TextEditingController();
    otherController.text = allItems.contains(widget.name) ? "" : widget.name;
    otherController.selection = TextSelection.fromPosition(
        TextPosition(offset: otherController.text.length));

    // print(
    //     "rebuilding..${widget.name} with ${cItems.contains(widget.name)} in $cItems");
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
                // spreadRadius: 4, blurRadius: 4,
                // offset: Offset(6, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value: allItems.contains(widget.name) ? widget.name : "Other",
              validator: (value) =>
                  value!.isEmpty ? ' Must select a category for item' : null,
              decoration: InputDecoration(border: InputBorder.none),
              hint: Text(
                "Category of Item",
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
              onChanged: (value) {
                setState(() {
                  widget.name = value!;
                });
                // widget.name = value!;
                // if (widget.name != "Other") {
                widget.onNameChanged(widget.name);
                // }
              },
              items: allItems.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
        (widget.name == "Other" || !(allItems.contains(widget.name)))
            ? Container(
                height: 50,
                width: 300,
                decoration: addInputDecoration,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    controller: otherController,

                    //  initialValue: cItems.contains(widget.name) ? "" : widget.name,
                    // initialValue: initOtherVal,
                    onChanged: (value) {
                      widget.name = value;
                      widget.onNameChanged(otherController.text);
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
            : Container(child: Text(otherController.text)),
      ],
    );
  }
}
