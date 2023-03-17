import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ItemRemark extends StatefulWidget {
  final Function(String) onRemarkChanged;
  String remark;
  ItemRemark({required this.onRemarkChanged, required this.remark});
  @override
  State<ItemRemark> createState() => _ItemRemarkState();
}

class _ItemRemarkState extends State<ItemRemark> {
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
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: TextFormField(
          initialValue: widget.remark,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          onChanged: (value) {
            widget.remark = value;

            setState(() {
              // itemName = Value!;

              widget.onRemarkChanged(value);
            });
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
