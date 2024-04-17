import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../components/addItem.dart';

class PersonsMain extends StatefulWidget {
  const PersonsMain({super.key});

  @override
  State<PersonsMain> createState() => _PersonsMainState();
}

class _PersonsMainState extends State<PersonsMain> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          top: ht * 0.16,
          child: AddItemWidget(tag: 'itemName', addFunc: (name) async {}),
        ),
      ],
    );
  }
}
