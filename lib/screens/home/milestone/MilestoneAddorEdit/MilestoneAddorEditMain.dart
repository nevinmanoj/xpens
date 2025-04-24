import 'package:flutter/material.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneAddorEdit.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/dbModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';

import 'MilestoneListValues.dart';

class MilestoneAddorEditMain extends StatefulWidget {
  final bool isAdd;
  final Milestone? inputms;

  final Function(
      {required Milestone? newms,
      required MilestoneTemplate newmst,
      required BuildContext bc}) submit;
  const MilestoneAddorEditMain(
      {super.key,
      required this.isAdd,
      required this.submit,
      required this.inputms});

  @override
  State<MilestoneAddorEditMain> createState() => _MilestoneAddorEditMainState();
}

class _MilestoneAddorEditMainState extends State<MilestoneAddorEditMain> {
  @override
  Widget build(BuildContext context) {
    bool needSecondTab =
        widget.inputms != null && widget.inputms!.values.isNotEmpty;
    return DefaultTabController(
      length: needSecondTab ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryAppColor,
          bottom: widget.isAdd
              ? null
              : TabBar(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 3,
                  indicatorColor: secondaryAppColor,
                  labelColor: secondaryAppColor,
                  unselectedLabelColor: const Color(0xff778585),
                  tabs: ["Template", if (needSecondTab) "Values"]
                      .map((e) => Tab(
                            child: Text(e),
                          ))
                      .toList(),
                ),
        ),
        body: TabBarView(children: [
          MilestoneAddorEdit(
            isAdd: widget.isAdd,
            submit: (
                    {required BuildContext bc,
                    required Milestone? newms,
                    required MilestoneTemplate newmst}) =>
                widget.submit(newmst: newmst, newms: newms, bc: context),
            inputms: widget.inputms,
          ),
          if (needSecondTab)
            MilestoneListValues(
              ms: widget.inputms!,
            )
        ]),
      ),
    );
  }
}
