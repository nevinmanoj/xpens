import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class Password extends StatefulWidget {
  final Function(String) passChange;
  const Password({super.key, required this.passChange});

  @override
  State<Password> createState() => _passState();
}

class _passState extends State<Password> {
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 300,
        decoration: authInputDecoration,
        child: TextFormField(
            onChanged: (value) => widget.passChange(value),
            validator: (value) => value!.isEmpty ? 'Enter password' : null,
            // obscureText: true,
            textAlign: TextAlign.center,
            obscureText: _isObscure,
            decoration: InputDecoration(
              prefix: const SizedBox(
                width: 70,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  color: Colors.black.withOpacity(0.5),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
              hintText: 'Password',
            )));
  }
}
