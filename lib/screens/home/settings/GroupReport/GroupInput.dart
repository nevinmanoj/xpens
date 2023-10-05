import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

class GroupInput extends StatefulWidget {
  final Function(String) setGroup;
  const GroupInput({required this.setGroup});

  @override
  State<GroupInput> createState() => _GroupInputState();
}

class _GroupInputState extends State<GroupInput> {
  TextEditingController ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      height: 50,
      width: 350,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
        borderRadius: BorderRadius.circular(10),
        // color: Colors.grey[200]?.withOpacity(0.6),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: TextFormField(
          controller: ctrl,
          onFieldSubmitted: widget.setGroup,
          cursorColor: primaryAppColor,
          cursorWidth: 1,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            suffixIcon: ctrl.text != ""
                ? IconButton(
                    icon: Icon(Icons.clear),
                    color: Colors.black.withOpacity(0.5),
                    onPressed: () {
                      widget.setGroup("");
                      ctrl.clear();
                    })
                : null,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
            hintText: 'Enter Group Name',
          ),
        ),
      ),
    );
  }
}
