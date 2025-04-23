import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneValueAddorEdit.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/subModals/MilestoneValue.dart';
import 'package:xpens/shared/utils/formatCost.dart';

class MilestoneListValues extends StatefulWidget {
  final Milestone ms;
  const MilestoneListValues({super.key, required this.ms});

  @override
  State<MilestoneListValues> createState() => _MilestoneListValuesState();
}

class _MilestoneListValuesState extends State<MilestoneListValues> {
  late Milestone ms;
  @override
  void initState() {
    ms = widget.ms;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    void deleteMSV(id) {
      List<MilestoneValue> newmsvlist =
          ms.values.where((v) => v.id != id).toList();
      setState(() {
        ms.values = newmsvlist;
      });
      MilestoneDatabaseService(uid: user!.uid).editMilestone(item: ms);
      Navigator.pop(context);
    }

    void editMSV(MilestoneValue msv) {
      List<MilestoneValue> newmsvlist =
          ms.values.map((v) => v.id != msv.id ? v : msv).toList();
      setState(() {
        ms.values = newmsvlist;
      });
      MilestoneDatabaseService(uid: user!.uid).editMilestone(item: ms);
      Navigator.pop(context);
    }

    Widget getValueItem(MilestoneValue msv) {
      return Container(
        // width: wt * 0.1,
        height: 50,
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
        decoration: BoxDecoration(
            // border: isSelected ? Border.all(color: Colors.amber, width: 2) : null,
            // color: Colors.amber,
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().format(msv.date).toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  formatDouble(msv.value),
                  style: const TextStyle(fontSize: 18),
                )
              ],
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: ((context) {
                        return MilestoneValueAddorEdit(
                          isAdd: false,
                          msv: msv,
                          submit: (MilestoneValue msv) {
                            editMSV(msv);
                          },
                        );
                      }));
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return ActionConfirm(
                            title: "Delete",
                            msg:
                                "Delete ${formatDouble(msv.value)} on ${DateFormat.yMMMd().format(msv.date).toString()}",
                            cancel: () {
                              Navigator.pop(ctx);
                            },
                            confirm: () => deleteMSV(msv.id));
                      });
                },
                icon: const Icon(Icons.delete))
          ],
        ),
      );
    }

    double wt = MediaQuery.of(context).size.width;
    return Container(
      color: const Color.fromARGB(255, 233, 233, 233),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: wt * 0.95,
            alignment: Alignment.center,
            child: ListView.builder(
                itemCount: ms.values.length,
                itemBuilder: (bc, i) {
                  return getValueItem(ms.values[i]);
                })),
      ),
    );
  }
}
