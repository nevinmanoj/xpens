import 'package:flutter/material.dart';
import 'package:xpens/screens/home/settings/points/ListPoints/ListPointsBody.dart';

import 'ListPointsHeader.dart';

class ListPointsMain extends StatefulWidget {
  const ListPointsMain({super.key});

  @override
  State<ListPointsMain> createState() => _ListPointsMainState();
}

class _ListPointsMainState extends State<ListPointsMain> {
  String card = "All";
  void changeCard(c) {
    setState(() {
      card = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListPointsBody(card: card),
        ListPointsHeader(
          onValChange: changeCard,
          card: card,
        ),
      ],
    );
  }
}
