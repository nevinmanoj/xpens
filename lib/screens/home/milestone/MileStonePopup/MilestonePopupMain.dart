// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneAddorEdit.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneEditPopup.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
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
  double target = 100;
  String newval = "";
  FocusNode? newnode = FocusNode();

  bool showAdd = false;
  void toggleFilter() {
    if (_height == target) {
      setState(() {
        widget.clearMs();
        showAdd = false;
      });
    }
  }

  void toggleAdd() {
    setState(() {
      showAdd = !showAdd;
    });
    if (showAdd) {
      newnode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;
    var user = Provider.of<User?>(context);
    void addValueToTotal() async {
      if (widget.ms != null) {
        double initval = 0;
        if (widget.ms!.currentVal != null) {
          initval = widget.ms!.currentVal!;
        }
        widget.ms!.currentVal = initval + safeDoubleParse(newval);
        await MilestoneDatabaseService(uid: user!.uid)
            .editMilestone(item: widget.ms!);
        toggleFilter();
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
                    }
                  }
                  Navigator.pop(context);
                  toggleFilter();
                });
          });
    }

    void editms() {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => MilestoneAddorEdit(
                    submit: (
                        {required Milestone? newms,
                        required MilestoneTemplate newmst,
                        required BuildContext bc}) async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return MilestoneChooseEdit(
                              current: () {
                                if (newms != null) {
                                  MilestoneDatabaseService(uid: user!.uid)
                                      .editMilestone(
                                    item: newms,
                                  );
                                }
                                toggleFilter();
                              },
                              all: () {
                                MilestoneDatabaseService(uid: user!.uid)
                                    .editAllMilestonesOftemplate(
                                        item: newms!, template: newmst);
                                toggleFilter();
                              },
                            );
                          });
                    },
                    isAdd: false,
                    inputms: widget.ms,
                  )));
    }

    _height = widget.ms == null ? 0 : target;
    return SizedBox(
      height: ht,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(_height == target ? 1 : 0),
              ),
              height: _height,
              width: wt,
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastEaseInToSlowEaseOut,
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 55, left: 20, right: 10),
                    child: ListView(children: [
                      _height == target &&
                              widget.ms!.currentStatus != Status.closed
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (showAdd && widget.ms!.endVal != null) ...[
                                  Container(
                                    height: 35,
                                    width: wt * 0.54,
                                    padding: const EdgeInsets.only(left: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255)),
                                    ),
                                    child: TextField(
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      focusNode: newnode,
                                      cursorColor: secondaryAppColor,
                                      keyboardType: TextInputType.number,
                                      cursorWidth: 1,
                                      decoration: const InputDecoration(
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 136, 136, 136),
                                              fontSize: 12),
                                          hintText:
                                              "Enter number to add to total",
                                          border: InputBorder.none),
                                      style:
                                          const TextStyle(color: Colors.white),
                                      onChanged: (value) =>
                                          setState(() => newval = value),
                                    ),
                                  ),
                                  const Spacer()
                                ],
                                if (widget.ms!.endVal != null)
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: wt * 0.3,
                                    height: ht * 0.045,
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all(
                                            BorderSide(
                                                color: Color.fromARGB(
                                                    255, 79, 79, 79),
                                                width: 2)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                      ),
                                      onPressed:
                                          showAdd ? addValueToTotal : toggleAdd,
                                      child: Center(
                                          child: Text(
                                        showAdd ? "Add to Total" : "Add Value",
                                        style: const TextStyle(
                                            color: secondaryAppColor,
                                            fontSize: 15),
                                      )),
                                    ),
                                  ),
                                if (!showAdd)
                                  SizedBox(
                                    // margin: const EdgeInsets.only(right: 10),
                                    width: wt * 0.35,
                                    height: ht * 0.045,
                                    child: OutlinedButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  primaryAppColor)),
                                      onPressed: markasDone,
                                      child: const Center(
                                          child: Text(
                                        "Mark as done",
                                        style: TextStyle(
                                            color: secondaryAppColor,
                                            fontSize: 15),
                                      )),
                                    ),
                                  ),
                              ],
                            )
                          : Container()
                    ]),
                  ),
                  //topbar
                  if (_height == target)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getIconButtons(
                          f: showAdd ? toggleAdd : toggleFilter,
                          i: Icons.arrow_back,
                        ),
                        SizedBox(
                          // color: Colors.amber,
                          width: wt * 0.6,
                          child: Text(widget.ms!.title,
                              style: const TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis),
                        ),
                        if (!showAdd &&
                            widget.ms!.currentStatus != Status.closed) ...[
                          const Spacer(),
                          getIconButtons(
                            f: popDeletebox,
                            i: Icons.delete,
                          ),
                          getIconButtons(
                            f: editms,
                            i: Icons.edit,
                          ),
                        ]
                      ],
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

Widget getIconButtons({required IconData i, required Function() f}) {
  return IconButton(
    iconSize: 26,
    color: Colors.white,
    icon: Icon(i),
    onPressed: f,
  );
}
