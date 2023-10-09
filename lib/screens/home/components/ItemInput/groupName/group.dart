import 'package:flutter/material.dart';

import '../../../../../shared/constants.dart';
import 'groupAuto.dart';

class ItemGroup extends StatefulWidget {
  ItemGroup({
    required this.itemGroup,
    required this.onGroupChange,
  });
  final Function(String) onGroupChange;
  final String itemGroup;

  @override
  State<ItemGroup> createState() => _ItemGroupState();
}

class _ItemGroupState extends State<ItemGroup> {
  // bool addToGroup = false;
  late bool addToGroup;

  @override
  void initState() {
    // addToGroup = widget.addToGroup;
    addToGroup = widget.itemGroup != "none";

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemGroup oldWidget) {
    // TODO: implement didUpdateWidget
    addToGroup = widget.itemGroup != "none";
    super.didUpdateWidget(oldWidget);
  }

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
                    if (!value!) {
                      widget.onGroupChange("none");
                    } else {
                      widget.onGroupChange("");
                    }
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
            ? GroupAuto(
                onGroupChange: widget.onGroupChange,
                itemGroup: widget.itemGroup,
              )
            : Container(),
        // addToGroup
        //     ? Container(
        //         height: 50,
        //         width: 300,
        //         decoration: addInputDecoration,
        //         child: Padding(
        //           padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        //           child: TextFormField(
        //             initialValue:
        //                 widget.itemGroup == "none" ? "" : widget.itemGroup,
        //             onChanged: (value) {
        //               print("hcnaging grp val");
        //               widget.onGroupChange(value);
        //             },
        //             validator: (value) => value!.isEmpty
        //                 ? ' Group Tag Name cannot be empty'
        //                 : null,
        //             keyboardType: TextInputType.name,
        //             decoration: InputDecoration(
        //               border: InputBorder.none,
        //               hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
        //               hintText: 'Group Tag Name',
        //             ),
        //           ),
        //         ),
        //       )
        //     : Container(),
      ],
    );
  }
}
