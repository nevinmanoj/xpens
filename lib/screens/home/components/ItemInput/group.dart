import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/UserInfoProvider.dart';
import '../../../../shared/constants.dart';
import 'inputAutofill.dart';

class ItemGroup extends StatefulWidget {
  const ItemGroup({
    super.key,
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
    addToGroup = widget.itemGroup != "none";
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var userInfo = Provider.of<UserInfoProvider>(context);
    double wt = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: wt * 0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text("Add Group Tag"),
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
            ? InputAutoFill(
                onValueChange: widget.onGroupChange,
                value: widget.itemGroup,
                tag: "group",
                docs: userInfo.docs,
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
