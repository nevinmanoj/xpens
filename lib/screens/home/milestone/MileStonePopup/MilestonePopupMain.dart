// ignore_for_file: use_build_context_synchronously, file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:xpens/screens/home/components/ActionConfirm.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneAddorEditMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneEditPopup.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneValueAddorEdit.dart';
import 'package:xpens/services/milesstoneDatabase.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';

import '../../../../shared/dataModals/subModals/MilestoneValue.dart';
import '../MilestoneGetx.dart';

class MilestonePopup extends StatefulWidget {
  const MilestonePopup({
    super.key,
  });

  @override
  State<MilestonePopup> createState() => _MilestonePopupState();
}

class _MilestonePopupState extends State<MilestonePopup> {
  final popupController = Get.put(MilestonePopupController());
  double _height = 0;
  double target = 100;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MilestonePopupController>(builder: (ctx) {
      double wt = MediaQuery.of(context).size.width;
      double ht = MediaQuery.of(context).size.height;

      var user = Provider.of<User?>(context);
      void toggleAdd() {
        showDialog(
            context: context,
            builder: ((context) => MilestoneValueAddorEdit(
                  msv: MilestoneValue(
                      date: DateTime.now(), id: "place_holder", value: 0.0),
                  submit: (MilestoneValue newmv) {
                    if (popupController.ms != null) {
                      newmv.id = (popupController.ms!.idCount + 1).toString();
                      popupController.ms!.values.add(newmv);
                      popupController.ms!.idCount += 1;

                      MilestoneDatabaseService(uid: user!.uid)
                          .editMilestone(item: popupController.ms!);
                      popupController.setMS(null);
                    }
                    Navigator.pop(context);
                  },
                  isAdd: true,
                )));
      }

      Future popDeletebox() {
        return showDialog(
            context: context,
            builder: (BuildContext context) {
              return ActionConfirm(
                  title: "Delete this milestone?",
                  msg: popupController.ms!.isOrphan
                      ? ""
                      : "Deleting this will delete ${popupController.ms!.currentStatus == Status.active ? "active and " : ""}upcomming milestones",
                  cancel: () => Navigator.pop(context),
                  confirm: () async {
                    if (popupController.ms != null) {
                      if (popupController.ms!.currentStatus != Status.closed) {
                        await MilestoneDatabaseService(uid: user!.uid)
                            .deleteTemplateandCurrentMilestone(
                          status: popupController.ms!.currentStatus,
                          templateid: popupController.ms!.templateID,
                        );
                      }
                    }
                    Navigator.pop(context);

                    popupController.setMS(null);
                  });
            });
      }

      void markasDoneOrRedo() async {
        if (popupController.ms != null) {
          popupController.ms!.currentStatus = popupController
                  .ms!.isPrematureClosure
              ? DateTime.now().isBefore(popupController.ms!.dateRange.startDate)
                  ? Status.upcoming
                  : Status.active
              : Status.closed;

          await MilestoneDatabaseService(uid: user!.uid)
              .editMilestone(item: popupController.ms!);
        }
        popupController.setMS(null);
      }

      void editms() {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => MilestoneAddorEditMain(
                      submit: (
                          {required Milestone? newms,
                          required MilestoneTemplate newmst,
                          required BuildContext bc}) async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return MilestoneChooseEdit(
                                isOrphan: popupController.ms!.isOrphan,
                                current: () {
                                  if (newms != null) {
                                    MilestoneDatabaseService(uid: user!.uid)
                                        .editMilestone(
                                      item: newms,
                                    );
                                  }
                                  popupController.setMS(null);
                                },
                                all: () {
                                  MilestoneDatabaseService(uid: user!.uid)
                                      .editAllMilestonesOftemplate(
                                          item: newms!, template: newmst);
                                  popupController.setMS(null);
                                },
                              );
                            });
                      },
                      isAdd: false,
                      inputms: popupController.ms,
                    )));
      }

      _height = popupController.ms == null ? 0 : target;
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
                        _height == target
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (popupController.ms!.endVal != null &&
                                      popupController.ms!.currentStatus !=
                                          Status.upcoming)
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: wt * 0.3,
                                      height: ht * 0.045,
                                      child: OutlinedButton(
                                        style: ButtonStyle(
                                          side: MaterialStateProperty.all(
                                              const BorderSide(
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
                                        onPressed: toggleAdd,
                                        child: const Center(
                                            child: Text(
                                          "Add Value",
                                          style: TextStyle(
                                              color: secondaryAppColor,
                                              fontSize: 15),
                                        )),
                                      ),
                                    ),
                                  if ((popupController.ms!.currentStatus ==
                                          Status.active ||
                                      popupController.ms!.isPrematureClosure))
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
                                                MaterialStateProperty.all<
                                                    Color>(primaryAppColor)),
                                        onPressed: markasDoneOrRedo,
                                        child: Center(
                                            child: Text(
                                          popupController.ms!.isPrematureClosure
                                              ? "Mark to Redo"
                                              : "Mark as done",
                                          style: const TextStyle(
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
                            f: () => popupController.setMS(null),
                            i: Icons.arrow_back,
                          ),
                          SizedBox(
                            // color: Colors.amber,
                            width: wt * 0.45,
                            child: Text(popupController.ms!.title,
                                style: const TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis),
                          ),
                          const Spacer(),
                          if (popupController.ms!.currentStatus !=
                              Status.closed) ...[
                            getIconButtons(
                              f: popDeletebox,
                              i: Icons.delete,
                            ),
                          ],
                          getIconButtons(
                            f: editms,
                            i: Icons.edit,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
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
