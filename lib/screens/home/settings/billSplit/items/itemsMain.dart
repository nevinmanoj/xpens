import 'package:flutter/material.dart';

import '../billSplitFooter.dart';

class ItemsMain extends StatefulWidget {
  const ItemsMain({super.key});

  @override
  State<ItemsMain> createState() => _ItemsMainState();
}

class _ItemsMainState extends State<ItemsMain> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BillSplitFooter(
          value: 2000,
        )
      ],
    );
  }
}
