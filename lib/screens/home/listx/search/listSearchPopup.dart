// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class ListSearchPopup extends StatefulWidget {
  final Function(String?) onValueChange;
  String selectedOption;
  ListSearchPopup(
      {super.key, required this.onValueChange, required this.selectedOption});
  @override
  State<ListSearchPopup> createState() => _MyWidgetState();
}

// /new Function

class _MyWidgetState extends State<ListSearchPopup> {
  String option = "itemName";
  @override
  void initState() {
    option = widget.selectedOption;
    super.initState();
  }

  void onOptionChange(String? val) {
    if (val == null) return;
    setState(() {
      option = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return Center(
        child: SizedBox(
      width: wt * 0.9,
      height: ht * 0.5,
      child: AlertDialog(
          insetPadding: EdgeInsets.fromLTRB(
            0,
            0,
            0,
            ht * 0.1,
          ),
          title: const Center(
              child: Text(
            "Search Expenses by",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          actions: [
            OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "cancel",
                  style: TextStyle(color: secondaryAppColor),
                )),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(primaryAppColor),
                ),
                onPressed: () {
                  widget.onValueChange(option);
                  Navigator.pop(context);
                },
                child: const Text("Save"))
          ],
          content:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RadioListTile(
              activeColor: primaryAppColor,
              title: const Text("Item Name"),
              value: "itemName",
              groupValue: option,
              onChanged: (value) {
                onOptionChange(value);
              },
            ),
            RadioListTile(
              activeColor: primaryAppColor,
              title: const Text("Remarks"),
              value: "remarks",
              groupValue: option,
              onChanged: (value) {
                onOptionChange(value);
              },
            ),
          ])),
    ));
  }
}
