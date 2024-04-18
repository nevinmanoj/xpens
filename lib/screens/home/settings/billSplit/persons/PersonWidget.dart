import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonWidget extends StatelessWidget {
  final String name;
  final String amnt;
  const PersonWidget({super.key, required this.name, required this.amnt});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    return Container(
      height: ht * 0.05,
      width: wt,
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(wt * 0.04, 0, 0, 0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, wt * 0.04, 0),
            child: Text(
              "₹ ${amnt}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 60, 60, 60)),
            ),
          )
        ],
      ),
    );
  }
}
