import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemRemark extends StatefulWidget {
  // final Function(String) onRemarkChanged;
  String remarks;
  final Function(TextEditingController) onctrlchange;

  ItemRemark(
      {super.key,
      //  required this.onRemarkChanged,
      required this.onctrlchange,
      required this.remarks});

  @override
  State<ItemRemark> createState() => _ItemRemarkState();
}

class _ItemRemarkState extends State<ItemRemark> {
  TextEditingController? remarksController;
  @override
  void initState() {
    remarksController = TextEditingController(text: widget.remarks);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.onctrlchange(remarksController!);
    return Container(
      height: 50,
      width: 300,
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
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
            hintText: 'Remarks',
          ),
        ),
      ),
    );
  }
}
