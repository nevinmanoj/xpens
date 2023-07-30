import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/constants.dart';

class FilterBtns extends StatefulWidget {
  final Function() clearFilters;
  final Function() toggleFilter;
  final Function(dynamic) onStreamChange;
  String? name;
  String order;
  String? location;
  FilterBtns(
      {required this.clearFilters,
      required this.order,
      required this.onStreamChange,
      required this.name,
      required this.location,
      required this.toggleFilter});

  @override
  State<FilterBtns> createState() => _FilterBtnsState();
}

class _FilterBtnsState extends State<FilterBtns> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          width: wt * 0.4,
          height: ht * 0.06,
          child: OutlinedButton(
            // style: buttonDecoration,
            onPressed: widget.clearFilters,
            child: Center(
                child: Text(
              "Clear",
              style: TextStyle(color: Colors.black, fontSize: 17),
            )),
          ),
        ),
        SizedBox(
          width: wt * 0.4,
          height: ht * 0.06,
          child: ElevatedButton(
            style: buttonDecoration,
            onPressed: () {
              var base;
              if (widget.order == "Spent Date") {
                base = FirebaseFirestore.instance
                    .collection(
                        '$db/${FirebaseAuth.instance.currentUser!.uid}/list')
                    .orderBy('date', descending: true);
              } else {
                base = FirebaseFirestore.instance
                    .collection(
                        '$db/${FirebaseAuth.instance.currentUser!.uid}/list')
                    .orderBy(FieldPath.documentId, descending: false);
              }
              if (widget.name != null) {
                if (widget.name != 'Other') {
                  base = base.where("itemName", isEqualTo: widget.name);
                } else {
                  //others
                  print(widget.name);
                  base = base.where("isOther", isEqualTo: true);
                }
              }
              if (widget.location != null) {
                base = base.where('location', isEqualTo: widget.location);
              }

              widget.onStreamChange(base);
              widget.toggleFilter();
            },
            child: Center(
                child: Text(
              "Apply",
              style: TextStyle(color: Colors.white, fontSize: 17),
            )),
          ),
        )
      ],
    );
  }
}
