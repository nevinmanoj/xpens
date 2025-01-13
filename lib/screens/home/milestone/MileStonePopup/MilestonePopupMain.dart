// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/milestone/MileStonePopup/MileStonePopUpAddVal.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneEditPopup.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/utils/safeParse.dart';

class MilestonePopup extends StatefulWidget {
  final Milestone? ms;
  final Function() clearMs;

  const MilestonePopup({
    super.key,
    required this.ms,
    required this.clearMs,
  });

  @override
  State<MilestonePopup> createState() => _MilestonePopupState();
}

class _MilestonePopupState extends State<MilestonePopup> {
  double _height = 0;

  void toggleFilter() {
    if (_height == 400) {
      setState(() {
        widget.clearMs();
        showAdd = false;
      });
    }
  }

  bool showAdd = false;

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    var user = Provider.of<User?>(context);
    void addValueToTotal(newval) async {
      if (widget.ms != null) {
        widget.ms!.currentVal =
            widget.ms!.currentVal! + safeDoubleParse(newval);
        await MilestoneDatabaseService(uid: user!.uid)
            .editMilestone(item: widget.ms!);
        setState(() {
          showAdd = false;
        });
      }
    }

    void markasDone() async {
      if (widget.ms != null) {
        widget.ms!.currentStatus = Status.closed;
        await MilestoneDatabaseService(uid: user!.uid)
            .editMilestone(item: widget.ms!);
      }
      toggleFilter();
    }

    Future popDeletebox() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return ActionConfirm(
                title: "Delete this milestone?",
                msg:
                    "Deleting this will delete active and upcomming milestones",
                cancel: () => Navigator.pop(context),
                confirm: () async {
                  if (widget.ms != null) {
                    if (widget.ms!.currentStatus != Status.closed) {
                      await MilestoneDatabaseService(uid: user!.uid)
                          .deleteTemplateandCurrentMilestone(
                        templateid: widget.ms!.templateID,
                      );
                    } else {
                      // await MilestoneDatabaseService(uid: user!.uid)
                      //     .deleteMilestone(
                      //   selfID: widget.ms!.selfId,
                      // );
                    }
                  }
                  Navigator.pop(context);
                  toggleFilter();
                });
          });
    }

    _height = widget.ms == null ? 0 : 400;
    return SizedBox(
      height: ht,
      child: Stack(
        children: [
          _height == 400
              ? InkWell(
                  onTap: toggleFilter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    color: const Color.fromARGB(144, 196, 196, 196),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              // padding: EdgeInsets.only(top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              height: _height,
              width: wt,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.fastOutSlowIn,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ListView(children: [
                      _height == 400 ? Text(widget.ms!.title) : Container(),
                      _height == 400
                          ? Text(widget.ms!.currentVal.toString())
                          : Container(),
                      _height == 400
                          ? Text(widget.ms!.endVal.toString())
                          : Container(),
                      showAdd
                          ? MilestonePopupAddVal(
                              addVal: addValueToTotal,
                              cancel: () {
                                setState(() {
                                  showAdd = false;
                                });
                              },
                            )
                          : _height == 400 &&
                                  widget.ms!.currentStatus != Status.closed
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: wt * 0.3,
                                      height: ht * 0.045,
                                      child: ElevatedButton(
                                        style: buttonDecoration,
                                        onPressed: () {
                                          setState(() {
                                            showAdd = true;
                                          });
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Add Value",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        )),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: wt * 0.35,
                                      height: ht * 0.045,
                                      child: OutlinedButton(
                                        // style: buttonDecoration,
                                        onPressed: () => markasDone(),
                                        child: const Center(
                                            child: Text(
                                          "Mark as done",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        )),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: wt * 0.15,
                                      height: ht * 0.045,
                                      child: OutlinedButton(
                                        // style: buttonDecoration,
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder:
                                                      (context) =>
                                                          MilestoneAddorEdit(
                                                              submit: ({
                                                                required String
                                                                    title,
                                                                required double?
                                                                    curVal,
                                                                required Period
                                                                    period,
                                                                required double?
                                                                    endVal,
                                                                required bool
                                                                    skipFirst,
                                                                required BuildContext
                                                                    bc,
                                                              }) async {
                                                                await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return MilestoneChooseEdit(
                                                                        current:
                                                                            () {
                                                                          if (widget.ms !=
                                                                              null) {
                                                                            MilestoneDatabaseService(uid: user!.uid).editMilestone(
                                                                              item: Milestone(currentVal: curVal, endVal: endVal, dateRange: widget.ms!.dateRange, selfId: widget.ms!.selfId, title: title, period: period, templateID: widget.ms!.templateID, currentStatus: widget.ms!.currentStatus, skipFirst: skipFirst),
                                                                            );
                                                                          }
                                                                        },
                                                                        all:
                                                                            () {},
                                                                      );
                                                                    });
                                                              },
                                                              isAdd: false,
                                                              curVal: widget.ms!
                                                                  .currentVal,
                                                              title: widget
                                                                  .ms!.title,
                                                              period: widget
                                                                  .ms!.period,
                                                              skipFirst: widget
                                                                  .ms!
                                                                  .skipFirst)));
                                        },
                                        child: const Center(
                                            child: Text(
                                          "Edit",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        )),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: wt * 0.35,
                                      height: ht * 0.045,
                                      child: OutlinedButton(
                                        // style: buttonDecoration,
                                        onPressed: () => popDeletebox(),
                                        child: const Center(
                                            child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        )),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                    ]),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, ht * 0.02, wt * 0.08, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: toggleFilter,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
