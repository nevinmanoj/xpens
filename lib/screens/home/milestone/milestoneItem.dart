import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';

class MilestoneItem extends StatelessWidget {
  final Milestone ms;
  const MilestoneItem({super.key, required this.ms});

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    double barWidth = wt;
    bool noVal = ms.currentVal == null || ms.endVal == null;
    if (!noVal) {
      if (ms.currentVal! < 0 || ms.endVal! < 0) {
        barWidth = 0;
      } else if (ms.currentVal! <= ms.endVal!) {
        barWidth = (barWidth * ms.currentVal!) / ms.endVal!;
      }
    }

    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
      height: noVal ? ht * 0.1 : ht * 0.15,
      margin: EdgeInsets.fromLTRB(wt * 0.05, 0, wt * 0.05, 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: wt * 0.8,
                height: ht * 0.04,
                child: Text(
                  overflow: TextOverflow.fade,
                  ms.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(101, 101, 101, 1)),
                ),
              ),
            ],
          ),
          const Spacer(),
          noVal
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ms.currentVal.toString(),
                      style: const TextStyle(color: secondaryAppColor),
                    ),
                    Text(ms.endVal.toString())
                  ],
                ),
          noVal
              ? Container()
              : Stack(
                  children: [
                    Container(
                      color: primaryAppColor,
                      height: 5,
                      width: wt,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: secondaryAppColor,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      height: 5,
                      width: barWidth,
                    ),
                  ],
                ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 00),
            // color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(ms.dateRange.startDate),
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 65, 65, 65)),
                ),
                Text(
                  ms.dateRange.timeLeftString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color.fromARGB(255, 170, 170, 170)),
                ),
                Text(
                  DateFormat.yMMMd().format(ms.dateRange.endDate),
                  style: const TextStyle(
                      fontSize: 15, color: Color.fromARGB(255, 65, 65, 65)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
