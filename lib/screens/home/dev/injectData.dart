import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:xpens/services/Excel.dart';
import 'package:xpens/services/database.dart';
import 'package:xpens/services/dev.dart';
import 'package:xpens/services/toast.dart';

import 'package:xpens/shared/constants.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
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
var x = Icon(Icons.logo_dev);
const countList = ["2", "25", "50", "75", "100"];
String selectCount = countList[0];
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

class InjectTestData extends StatefulWidget {
  @override
  State<InjectTestData> createState() => _InjectTestDataState();
}

class _InjectTestDataState extends State<InjectTestData> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
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
                          height: ht * 0.6,
                          child: AlertDialog(
                              insetPadding: EdgeInsets.fromLTRB(
                                0,
                                0,
                                0,
                                ht * 0.1,
                              ),
                              title: Center(
                                  child: Text(
                                "Inject Random test data to DB",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              content: Column(
                                children: [
                                  years(),
                                  months(),
                                  Count(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(primaryAppColor)),
                                          onPressed: () async {
                                            await DevDatabaseService(
                                                    uid: user!.uid)
                                                .injectTestData(
                                                    year: selectYear,
                                                    month: selectMonth,
                                                    count: double.parse(
                                                        selectCount));
                                          },
                                          child: Text('Inject data')),
                                    ],
                                  )
                                ],
                              ))));
                });
          },
          child: Text('Select month-year to inject test data')),
    );
  }
}

class Count extends StatefulWidget {
  @override
  State<Count> createState() => _CountState();
}

class _CountState extends State<Count> {
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
              value: selectCount,
              validator: (value) =>
                  value!.isEmpty ? ' Must select a count' : null,
              decoration: InputDecoration(border: InputBorder.none),
              onChanged: (Value) {
                setState(() {
                  selectCount = Value!;
                });
              },
              items: countList.map<DropdownMenuItem<String>>((value) {
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
