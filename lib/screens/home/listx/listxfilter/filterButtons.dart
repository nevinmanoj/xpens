import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class FilterBtns extends StatelessWidget {
  final Function() toggleFilter;
  final Function(dynamic) onFilterChange;
  String? name;
  String order;
  String? location;
  FilterBtns(
      {required this.order,
      required this.onFilterChange,
      required this.name,
      required this.location,
      required this.toggleFilter});

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
            onPressed: () => onFilterChange({'order': 'new'}),
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
              var base = {};
              base['order'] = order;

              if (name != null) {
                base['itemName'] = name;
              }
              if (location != null) {
                base['location'] = location;
              }

              onFilterChange(base);
              toggleFilter();
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
