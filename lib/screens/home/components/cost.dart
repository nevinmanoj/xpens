import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemQuantity extends StatefulWidget {
  // final Function(String) onCostChanged;
  final String costs;
  final Function(TextEditingController) onctrlchange;

  const ItemQuantity(
      {super.key,
      // required this.onCostChanged,
      required this.costs,
      required this.onctrlchange});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  TextEditingController? costController;

  @override
  void initState() {
    costController = TextEditingController(text: widget.costs);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.onctrlchange(costController!);

    return Container(
      height: 50,
      width: 300,
      decoration: addInputDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          controller: costController,
          // initialValue: widget.costs,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            // widget.onCostChanged(value);
            widget.onctrlchange(costController!);
          },

          validator: (value) => value!.isEmpty ? 'Cost must not be null' : null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
            hintText: 'Cost',
          ),
        ),
      ),
    );
  }
}
