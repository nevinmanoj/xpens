import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../shared/Db.dart';
import '../../../../shared/constants.dart';

class ListSearchMain extends StatefulWidget {
  const ListSearchMain({super.key, required this.onStreamChange});
  final Function(dynamic) onStreamChange;

  @override
  State<ListSearchMain> createState() => _ListSearchMainState();
}

class _ListSearchMainState extends State<ListSearchMain> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 40,
              color: primaryAppColor,
            ),
            Container(),
          ],
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            height: 50,
            width: 350,
            decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 167, 167, 167)),
              borderRadius: BorderRadius.circular(10),
              // color: Colors.grey[200]?.withOpacity(0.6),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFCCCCCC).withOpacity(0.5), //color of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextFormField(
                // controller: costController,
                // initialValue: widget.costs,
                cursorColor: primaryAppColor,
                cursorWidth: 1,
                onChanged: (value) {
                  // widget.onCostChanged(value);
                  // widget.onctrlchange(costController!);
                },
                onFieldSubmitted: (value) {
                  // print(value);
                  final List<String> tags = value
                      .split(' ')
                      .map((word) => word.toLowerCase())
                      .toList();
                  var base = FirebaseFirestore.instance
                      .collection(
                          '$db/${FirebaseAuth.instance.currentUser!.uid}/list')
                      .orderBy('date', descending: true)
                      .where("tags", arrayContainsAny: tags);

                  widget.onStreamChange(base);
                },

                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.8)),
                  hintText: 'Search Expenses',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
