import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/MileStonePopup/MilestonePopupMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneHeader.dart';
import 'package:xpens/screens/home/milestone/MilestonePills.dart';
import 'package:xpens/screens/home/milestone/milestoneItem.dart';
import 'package:xpens/screens/home/milestone/msFilterFunction.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';

class MilestonesMain extends StatefulWidget {
  const MilestonesMain({super.key});

  @override
  State<MilestonesMain> createState() => _MilestonesMainState();
}

class _MilestonesMainState extends State<MilestonesMain> {
  Milestone? expandedMS;
  List periodList = [...Period.values];
  Status currentStatus = Status.active;
  void setPeriodList(item) {
    Period p = deserializePeriod(item);

    if (periodList.contains(p)) {
      setState(() {
        periodList.remove(p);
      });
      // periodList.remove(p);
    } else {
      setState(() {
        periodList.add(p);
      });
    }
  }

  void setStatusList(item) {
    Status p = deserializeStatus(item);
    setState(() {
      currentStatus = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    List milestones = Provider.of<UserInfoProvider>(context).milestones;
    List templates = Provider.of<UserInfoProvider>(context).milestoneTemplates;
    List<Milestone> mslist =
        milestones.map((e) => Milestone.fromJson(e)).toList();
    List<MilestoneTemplate> mstList =
        templates.map((e) => MilestoneTemplate.fromJson(e)).toList();
    mslist = applyMSFilter(
        data: mslist,
        periodList: periodList,
        currentStatus: currentStatus,
        templates: mstList);

    double ht = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Column(
          children: [
            MilestoneHeader(),
            MilestonePills(
              names: Status.values.map((e) => e.name).toList(),
              selected: Status.values.map((e) => e == currentStatus).toList(),
              toggle: setStatusList,
              items: Status.values,
            ),
            MilestonePills(
              names: Period.values.map((e) => e.name).toList(),
              selected:
                  Period.values.map((e) => periodList.contains(e)).toList(),
              toggle: setPeriodList,
              items: Period.values,
            ),
            Container(
              height: ht * 0.6,
              color: const Color.fromARGB(255, 227, 227, 227),
              // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ListView.builder(
                  itemCount: mslist.length,
                  itemBuilder: ((context, i) {
                    return InkWell(
                        onTap: (() => setState(() => expandedMS = mslist[i])),
                        child: MilestoneItem(ms: mslist[i]));
                  })),
            ),
          ],
        ),
        MilestonePopup(
          clearMs: () => setState(() => expandedMS = null),
          ms: expandedMS,
        ),
      ],
    );
  }
}
