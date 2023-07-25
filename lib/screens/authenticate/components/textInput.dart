import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class TextInput extends StatefulWidget {
  final Function(String) onValueChange;
  final String label;
  TextInput({required this.onValueChange, required this.label});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            textAlign: TextAlign.center,
            validator: (value) =>
                value!.isEmpty ? '${widget.label}cannot be empty' : null,
            onChanged: (value) => widget.onValueChange(value),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: widget.label,
            )));
  }
}
