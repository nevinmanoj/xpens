import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/placeholder.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    String month = DateFormat.MMM().format(DateTime.now()).toString();
    String year = DateTime.now().year.toString();

    String Today = DateTime.now().day.toString();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('UserInfo/${user!.uid}/list')
            .where('month', isEqualTo: month)
            .where('year', isEqualTo: year)
            .where('day', isEqualTo: Today)
            .snapshots(),
        builder: (context, listSnapshot) {
          var list = listSnapshot.data?.docs;

          if (listSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (list == null) {
            return Container();
          }

          List<Map<String, dynamic>> data = list
              .map((document) => document.data() as Map<String, dynamic>)
              .toList();

          double sum = 0;
          Map<String, double> ranks = {};
          for (var item in data) {
            {
              sum += item['cost'];
              if (ranks[item['itemName']] == null) {
                ranks[item['itemName']] = 0;
              }
              ranks[item['itemName']] =
                  (ranks[item['itemName']]! + item['cost']);
            }
          }
          List<MapEntry<String, double>> sortedList = ranks.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return Container(
            margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            // height: 200,
            width: 0.9 * wt,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "TOTAL:  ${sum.toInt().toString()} ₹ ",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  for (int i = 0;
                      i < sortedList.length;
                      // i < ((sortedList.length < 3) ? sortedList.length : 3);
                      i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "${sortedList[i].key}:   ${sortedList[i].value.toInt()} ₹",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
    ;
  }
}
