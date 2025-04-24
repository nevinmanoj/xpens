import 'package:flutter/material.dart';

import 'package:xpens/screens/home/components/ItemInput/calendar.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/subModals/MilestoneValue.dart';
import 'package:xpens/shared/utils/safeParse.dart';

class MilestoneValueAddorEdit extends StatefulWidget {
  final MilestoneValue msv;
  final bool isAdd;
  final Function(MilestoneValue) submit;
  const MilestoneValueAddorEdit(
      {super.key,
      required this.msv,
      required this.submit,
      required this.isAdd});

  @override
  State<MilestoneValueAddorEdit> createState() =>
      _MilestoneValueAddorEditState();
}

class _MilestoneValueAddorEditState extends State<MilestoneValueAddorEdit> {
  late String value;
  late DateTime date;
  final _formKeyN = GlobalKey<FormState>();
  @override
  void initState() {
    value = widget.isAdd ? "" : widget.msv.value.toString();
    date = widget.msv.date;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    return StatefulBuilder(builder: (context, snapshot) {
      return AlertDialog(
        title: Center(child: Text("${widget.isAdd ? "Add" : "Edit"} Value")),
        content: SizedBox(
          height: 200,
          // width: wt * 0.8,
          child: SingleChildScrollView(
            child: Form(
              key: _formKeyN,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...textBoxInput(
                    onChange: (str) {
                      value = str;
                    },
                    wt: wt,
                    title: 'VALUE',
                    value: value,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: wt,
                    child: Text('DATE',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ),
                  Calendar(
                    onDateChanged: (DateTime? d) {
                      setState(() {
                        date = d!;
                      });
                    },
                    dateToDisplay: date,
                    isData: true,
                  )
                ],
              ),
            ),
          ),
        ),
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
                if (_formKeyN.currentState!.validate()) {
                  widget.submit(MilestoneValue(
                      date: date,
                      id: widget.msv.id,
                      value: safeDoubleParse(value)));
                }
              },
              child: Text(widget.isAdd ? "Add" : "Modify"))
        ],
      );
    });
  }
}

List<Widget> textBoxInput(
    {required double wt,
    required String title,
    required Function(String) onChange,
    required String value}) {
  return [
    SizedBox(
      width: wt,
      child:
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
    ),
    const SizedBox(
      height: 5,
    ),
    Container(
      padding: const EdgeInsets.only(left: 10),
      decoration: addInputDecoration,
      width: wt * 0.665,
      child: TextFormField(
          initialValue: value,
          validator: (value) =>
              value!.isEmpty ? '$title cannot be empty' : null,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.left,
          onChanged: (v) {
            onChange(v);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            constraints: BoxConstraints(maxWidth: 0.8 * wt),
          )),
    ),
  ];
}
