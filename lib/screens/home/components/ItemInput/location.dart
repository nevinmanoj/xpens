import 'package:flutter/material.dart';
import 'package:xpens/shared/constants.dart';

class Location extends StatefulWidget {
  final String location;
  final Function(String) onLocationChanged;
  const Location({super.key, required this.location, required this.onLocationChanged});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.width;
    return SizedBox(
        // color: Colors.amber,
        width: wt * 0.8,
        height: ht * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var loc in locationList)
              Padding(
                padding: EdgeInsets.fromLTRB(
                    wt * 0.05, ht * 0.01, wt * 0.05, ht * 0.01),
                // padding: EdgeInsets.fromLTRB(
                //     wt * 0.01, ht * 0.01, wt * 0.01, ht * 0.01),
                child: InkWell(
                  onTap: () {
                    widget.onLocationChanged(loc);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        color: loc == widget.location
                            ? primaryAppColor
                            : Colors.white),

                    // height: ht * 0.05,
                    // width: wt * 0.185,
                    width: wt * 0.3,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          wt * 0.025, ht * 0.01, wt * 0.025, ht * 0.01),
                      child: Center(
                          child: Text(
                        loc,
                        style: TextStyle(
                            fontSize: 18,
                            color: loc == widget.location
                                ? Colors.white
                                : primaryAppColor),
                      )),
                    ),
                  ),
                ),
              )
          ],
        ));
  }
}
