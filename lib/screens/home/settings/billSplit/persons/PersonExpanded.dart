import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonExpanded extends StatelessWidget {
  final String name;
  const PersonExpanded({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(name)],
      ),
    );
  }
}
