import 'package:flutter/material.dart';

import '../../../shared/constants.dart';

class ItemGroup extends StatefulWidget {
  ItemGroup(
      {required this.itemGroup,
      required this.onGroupChange,
      required this.addToGroup});
  final Function(String) onGroupChange;
  final bool addToGroup;
  final String itemGroup;

  @override
  State<ItemGroup> createState() => _ItemGroupState();
}

class _ItemGroupState extends State<ItemGroup> {
  // bool addToGroup = false;
  late bool addToGroup;

  @override
  void initState() {
    addToGroup = widget.addToGroup;

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   print("asda");
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: wt * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Add Group Tag"),
              Checkbox(
                checkColor: secondaryAppColor,
                activeColor: primaryAppColor,
                value: addToGroup,
                onChanged: (bool? value) {
                  try {
                    if (!value!) widget.onGroupChange("none");
                  } catch (e) {}

                  setState(() {
                    addToGroup = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        addToGroup
            ? Container(
                height: 50,
                width: 300,
                decoration: addInputDecoration,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: TextFormField(
                    initialValue:
                        widget.itemGroup == "none" ? "" : widget.itemGroup,
                    onChanged: (value) {
                      widget.onGroupChange(value);
                    },
                    validator: (value) => value!.isEmpty
                        ? ' Group Tag Name cannot be empty'
                        : null,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                      hintText: 'Group Tag Name',
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
