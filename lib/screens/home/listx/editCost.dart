import 'package:flutter/material.dart';

class ItemQuantity extends StatefulWidget {
  final Function(String) onCostChanged;
  String cost;
  ItemQuantity({required this.onCostChanged, required this.cost});
  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
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
        child: TextFormField(
          initialValue: widget.cost.toString(),
          onChanged: (value) {
            // costS = value;
            if (value != null) {
              widget.cost = value;
            }

            setState(() {
              // itemName = Value!;

              widget.onCostChanged(value);
            });
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
