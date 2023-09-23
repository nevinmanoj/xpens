import 'package:flutter/material.dart';
import 'package:xpens/services/Excel.dart';
import 'package:xpens/services/toast.dart';

import 'package:xpens/shared/constants.dart';
import 'package:intl/intl.dart';

String selectYear = DateTime.now().year.toString();
String selectMonth = DateFormat.MMM().format(DateTime.now()).toString();

const monthList = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];
const yearList = [
  '2023',
  '2024',
  '2025',
  '2026',
  '2027',
  '2028',
  '2029',
  '2030'
];

class DOwnloadDetails extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  DOwnloadDetails({required this.data});
  @override
  State<DOwnloadDetails> createState() => _DOwnloadDetailsState();
}

class _DOwnloadDetailsState extends State<DOwnloadDetails> {
  @override
  Widget build(BuildContext context) {
    // double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return SizedBox(
      // height: 50,
      child: ElevatedButton(
          style: buttonDecoration,
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                      child: SizedBox(
                          height: ht * 0.5,
                          child: AlertDialog(
                              insetPadding: EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                ht * 0.1,
                              ),
                              title: Center(
                                  child: Text(
                                "Download month Statement",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              content: Column(
                                children: [
                                  years(),
                                  months(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: buttonDecoration,
                                          onPressed: () async {
                                            await jsonToExcel(
                                                list: widget.data,
                                                year: selectYear,
                                                month: selectMonth);

                                            Navigator.pop(context);

                                            showToast(
                                                context: context,
                                                msg:
                                                    "Excel sheet for $selectMonth $selectYear Saved to storage");
                                          },
                                          child: Text('Download details')),
                                      ElevatedButton(
                                          style: buttonDecoration,
                                          onPressed: () {
                                            shareFile(
                                                list: widget.data,
                                                month: selectMonth,
                                                year: selectYear);
                                          },
                                          child: Text("Share"))
                                    ],
                                  )
                                ],
                              ))));
                });
          },
          child: Text('Select month-year to download details or share ')),
    );
  }
}

class years extends StatefulWidget {
  @override
  State<years> createState() => _yearsState();
}

class _yearsState extends State<years> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200]?.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value: selectYear,
              validator: (value) =>
                  value!.isEmpty ? ' Must select a year' : null,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (Value) {
                setState(() {
                  selectYear = Value!;
                });
              },
              items: yearList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class months extends StatefulWidget {
  @override
  State<months> createState() => _monthsState();
}

class _monthsState extends State<months> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[200]?.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: DropdownButtonFormField<String>(
              value: selectMonth,
              validator: (value) =>
                  value!.isEmpty ? ' Must select a month' : null,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (Value) {
                setState(() {
                  selectMonth = Value!;
                });
              },
              items: monthList.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
