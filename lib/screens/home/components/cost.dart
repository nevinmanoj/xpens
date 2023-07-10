import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemQuantity extends StatefulWidget {
  final Function(String) onCostChanged;
  String costs;

  ItemQuantity({super.key, required this.onCostChanged, required this.costs});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 300,
      decoration: addInputDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          initialValue: widget.costs,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            widget.onCostChanged(value);
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
