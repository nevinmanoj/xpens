import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemQuantity extends StatefulWidget {
  // final Function(String) onCostChanged;
  final String costs;
  final Function(TextEditingController) onctrlchange;
  final bool enabled;
  final req;
  final String hint;

  const ItemQuantity(
      {super.key,
      // required this.onCostChanged,
      required this.costs,
      required this.req,
      required this.onctrlchange,
      required this.enabled,
      required this.hint});

  @override
  State<ItemQuantity> createState() => _ItemQuantityState();
}

class _ItemQuantityState extends State<ItemQuantity> {
  TextEditingController? costController;

  @override
  void initState() {
    costController = TextEditingController(text: widget.costs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.onctrlchange(costController!);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.width;
    return Container(
      height: ht * 0.13,
      width: wt * 0.8,
      decoration: addInputDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          enabled: widget.enabled,
          controller: costController,
          // initialValue: widget.costs,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            // widget.onCostChanged(value);
            widget.onctrlchange(costController!);
          },

          validator: (value) => value!.isEmpty && widget.req
              ? '${widget.hint} must not be null'
              : null,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
            hintText: widget.hint,
          ),
        ),
      ),
    );
  }
}
