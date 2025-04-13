import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';

class MilestoneItem extends StatelessWidget {
  final Milestone ms;
  final bool isSelected;
  const MilestoneItem({super.key, required this.ms, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    double barWidth = wt;
    bool noVal = ms.endVal == null;
    DateTime today = DateTime.now();
    bool prematureClosure = ms.currentStatus == Status.closed &&
        today.isBefore(ms.dateRange.endDate);
    if (!noVal && ms.currentVal != null) {
      if (ms.currentVal! < 0 || ms.endVal! <= 0) {
        barWidth = 0;
      } else if (ms.currentVal! <= ms.endVal!) {
        barWidth = (barWidth * ms.currentVal!) / ms.endVal!;
      }
      prematureClosure = prematureClosure && ms.currentVal! <= ms.endVal!;
    } else if (!noVal) {
      barWidth = 0;
    }
    void markasDoneRedo() async {
      ms.currentStatus = prematureClosure
          ? today.isBefore(ms.dateRange.startDate)
              ? Status.upcoming
              : Status.active
          : Status.closed;
      await MilestoneDatabaseService(uid: user!.uid).editMilestone(item: ms);
    }

    return Container(
      decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.amber, width: 2) : null,
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10)),
      // height: noVal ? ht * 0.1 : ht * 0.15,
      height: ht * 0.15,

      margin: EdgeInsets.fromLTRB(wt * 0.025, 0, wt * 0.025, 10),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                // color: Colors.amber,
                width: wt * 0.7,
                height: ht * 0.04,
                child: Text(
                  overflow: TextOverflow.fade,
                  ms.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(101, 101, 101, 1)),
                ),
              ),
              ms.currentStatus == Status.active || prematureClosure
                  ? SizedBox(
                      height: ht * 0.04,
                      child: OutlinedButton(
                        // style: buttonDecoration,
                        onPressed: () => markasDoneRedo(),
                        child: Text(
                          prematureClosure ? "Redo" : "Done",
                          style: const TextStyle(color: secondaryAppColor),
                        ),
                      ))
                  : Container(),
            ],
          ),
          const Spacer(),
          noVal
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ms.currentVal == null ? "0" : ms.currentVal.toString(),
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
                      decoration: BoxDecoration(
                          color: secondaryAppColor,
                          borderRadius: ms.currentStatus != Status.closed
                              ? const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )
                              : null),
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
