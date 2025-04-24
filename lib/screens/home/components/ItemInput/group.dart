import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';
import 'inputAutofill.dart';

class ItemGroup extends StatefulWidget {
  const ItemGroup({
    super.key,
    required this.itemGroup,
    required this.onGroupChange,
    required this.docs,
    required this.avoidValue,
  });
  final Function(String?) onGroupChange;
  final String? itemGroup;
  final List docs;
  final String? avoidValue;

  @override
  State<ItemGroup> createState() => _ItemGroupState();
}

class _ItemGroupState extends State<ItemGroup> {
  // bool addToGroup = false;
  late bool addToGroup;

  @override
  void initState() {
    // addToGroup = widget.addToGroup;
    addToGroup = widget.itemGroup != widget.avoidValue;

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ItemGroup oldWidget) {
    addToGroup = widget.itemGroup != widget.avoidValue;
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
              const Text("Add Group Tag"),
              Checkbox(
                checkColor: secondaryAppColor,
                activeColor: primaryAppColor,
                value: addToGroup,
                onChanged: (bool? value) {
                  try {
                    if (!value!) {
                      widget.onGroupChange(widget.avoidValue);
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
                value: widget.itemGroup ?? '',
                tag: "group",
                docs: widget.docs,
                avoidValue: widget.avoidValue,
              )
            : Container(),
      ],
    );
  }
}
