import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:xpens/shared/datamodals.dart';

class CalendarExp extends StatefulWidget {
  String date;
  List data;
  List keys;
  CalendarExp(
      {super.key, required this.data, required this.date, required this.keys});
  @override
  State<CalendarExp> createState() => _CalendarExpState();
}

class _CalendarExpState extends State<CalendarExp> {
  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (int i = 0; i < widget.data.length; i++) {
      items.add(buildItem(data: widget.data[i], key: widget.keys[i]));
    }
    return AlertDialog(
      title: Center(child: Text(widget.date)),
      content: Container(
        // height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: items,
          ),
        ),
      ),
    );
  }
}

Widget buildItem({required var data, required var key}) {
  return Row(
    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(data['itemName']),
      Spacer(),
      Text(data['cost'].toString()),
      Spacer(),
      IconButton(onPressed: () {}, icon: Icon(Icons.info_outline)),
      IconButton(onPressed: () {}, icon: Icon(Icons.info_outline))
    ],
  );
}
