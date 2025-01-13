import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemRemark extends StatefulWidget {
  // final Function(String) onRemarkChanged;
  final String remarks;
  final String hint;
  final bool required;
  final Function(TextEditingController) onctrlchange;

  const ItemRemark(
      {super.key,
      //  required this.onRemarkChanged,
      required this.onctrlchange,
      required this.remarks,
      required this.hint,
      required this.required});

  @override
  State<ItemRemark> createState() => _ItemRemarkState();
}

class _ItemRemarkState extends State<ItemRemark> {
  TextEditingController? remarksController;
  @override
  void initState() {
    remarksController = TextEditingController(text: widget.remarks);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.onctrlchange(remarksController!);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.width;
    return Container(
      height: ht * 0.13,
      width: wt * 0.8,
      decoration: addInputDecoration,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          controller: remarksController,
          // initialValue: remarks,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            widget.onctrlchange(remarksController!);
            // widget.onRemarkChanged(value);
          },
          validator: (value) =>
              (value == null || value == '') && (widget.required)
                  ? "This Cannot be empty"
                  : null,
          keyboardType: TextInputType.text,
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
