import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xpens/shared/constants.dart';

class Location extends StatefulWidget {
  final String location;
  final Function(String) onLocationChanged;
  Location({required this.location, required this.onLocationChanged});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.amber,
      width: 300,
      height: ht * 0.12,
      child: Center(
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: locationList.length,
            itemBuilder: ((context, i) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                    wt * 0.05, ht * 0.01, wt * 0.005, ht * 0.01),
                child: InkWell(
                  onTap: () {
                    widget.onLocationChanged(locationList[i]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        color: locationList[i] == widget.location
                            ? primaryAppColor
                            : Colors.white),

                    height: ht * 0.05,
                    // width: wt * 0.185,
                    width: 120,
                    child: Center(
                        child: Text(
                      locationList[i],
                      style: TextStyle(
                          fontSize: 18,
                          color: locationList[i] == widget.location
                              ? Colors.white
                              : primaryAppColor),
                    )),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
