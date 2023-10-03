// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:xpens/services/Excel.dart';
import 'package:xpens/services/toast.dart';

import 'package:xpens/shared/constants.dart';
import 'package:intl/intl.dart';

const monthList = [
  "All",
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

class DOwnloadDetails extends StatefulWidget {
  final List data;

  DOwnloadDetails({required this.data});
  @override
  State<DOwnloadDetails> createState() => _DOwnloadDetailsState();
}

class _DOwnloadDetailsState extends State<DOwnloadDetails> {
  String selectYear = DateTime.now().year.toString();
  String selectMonth = DateFormat.MMM().format(DateTime.now()).toString();
  void setSelectYear(String year) {
    setState(() {
      selectYear = year;
    });
  }

  void setselectMonth(String month) {
    setState(() {
      selectMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    // double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    final formKey = GlobalKey<FormState>();
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
                          child: SingleChildScrollView(
                            clipBehavior: Clip.none,
                            child: AlertDialog(
                                insetPadding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  ht * 0.1,
                                ),
                                title: Center(
                                    child: Text(
                                  "Download Statement",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      Year(
                                        year: selectYear,
                                        setVal: setSelectYear,
                                      ),
                                      Month(
                                        month: selectMonth,
                                        setVal: setselectMonth,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              style: buttonDecoration,
                                              onPressed: () async {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  await jsonToExcel(
                                                      list: widget.data,
                                                      year: selectYear,
                                                      month: selectMonth);
                                                  Navigator.pop(context);
                                                  showToast(
                                                      context: context,
                                                      msg:
                                                          "Excel sheet for $selectMonth $selectYear Saved to storage");
                                                }
                                              },
                                              child: Text('Download details')),
                                          ElevatedButton(
                                              style: buttonDecoration,
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  shareFile(
                                                      list: widget.data,
                                                      month: selectMonth,
                                                      year: selectYear);
                                                }
                                              },
                                              child: const Text("Share"))
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          )));
                });
          },
          child: const Icon(Icons.description)),
    );
  }
}

class Year extends StatefulWidget {
  final Function(String) setVal;
  final String year;
  Year({required this.setVal, required this.year});
  @override
  State<Year> createState() => _YearState();
}

class _YearState extends State<Year> {
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
            child: TextFormField(
              keyboardType: TextInputType.number,
              // validator: (value) => value.contains(other) ? ' Must enter year' : null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Year is required';
                }

                int? year = int.tryParse(value);

                if (year == null) {
                  return 'Invalid year';
                }

                if (year < 1200) {
                  return 'Year must be above 1200';
                }

                // Validation passed
                return null;
              },
              decoration:
                  InputDecoration(hintText: "Year", border: InputBorder.none),
              onChanged: (val) {
                widget.setVal(val);
              },
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

class Month extends StatefulWidget {
  final Function(String) setVal;
  final String month;
  Month({required this.setVal, required this.month});
  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
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
              value: widget.month,
              validator: (value) =>
                  value!.isEmpty ? ' Must select a month' : null,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (val) {
                widget.setVal(val!);
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
