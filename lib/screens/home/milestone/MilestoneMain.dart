import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/MileStonePopup/MilestonePopupMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneFilter/milestoneFilterMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneGetx.dart';
import 'package:xpens/screens/home/milestone/MilestoneHeader.dart';
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
  final controller = Get.put(MilestoneController());
  Milestone? expandedMS;

  bool filterEnabled = false;

  void setFilterEnabled(bool val) {
    setState(() {
      filterEnabled = val;
    });
  }

  bool areSetsEqual(List a, List b) {
    return Set.from(a).containsAll(b) && Set.from(b).containsAll(a);
  }

  @override
  Widget build(BuildContext context) {
    List milestones = Provider.of<UserInfoProvider>(context).milestones;
    List templates = Provider.of<UserInfoProvider>(context).milestoneTemplates;
    List<Milestone> mslist =
        milestones.map((e) => Milestone.fromJson(e)).toList();
    List<MilestoneTemplate> mstList =
        templates.map((e) => MilestoneTemplate.fromJson(e)).toList();

    double wt = MediaQuery.of(context).size.width;

    return GetBuilder<MilestoneController>(builder: (context) {
      bool filterApplied =
          !areSetsEqual(controller.mainPeriodList, [...Period.values]);
      return DefaultTabController(
        length: 3,
        child: Stack(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => setState(() => expandedMS = null),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 100,
                ),
                width: wt,
                color: const Color.fromARGB(255, 233, 233, 233),
                padding: const EdgeInsets.only(top: 10),
                child: TabBarView(
                    children: Status.values.map((sts) {
                  List<Milestone> newmslist = applyMSFilter(
                      data: mslist,
                      periodList: controller.mainPeriodList,
                      currentStatus: sts,
                      templates: mstList);
                  return ListView.builder(
                      itemCount: newmslist.length,
                      itemBuilder: ((context, i) {
                        return InkWell(
                            onTap: (() {
                              if (expandedMS == null ||
                                  expandedMS?.selfId != newmslist[i].selfId) {
                                setState(() => expandedMS = newmslist[i]);
                              } else {
                                setState(() => expandedMS = null);
                              }
                            }),
                            child: MilestoneItem(
                              ms: newmslist[i],
                              isSelected:
                                  expandedMS?.selfId == newmslist[i].selfId,
                            ));
                      }));
                }).toList()),
              ),
            ),
            SizedBox(
                height: 100,
                child: MilestoneHeader(
                  enableFilter: () => setFilterEnabled(true),
                  filterApplied: filterApplied,
                )),
            MilestonePopup(
              clearMs: () => setState(() => expandedMS = null),
              ms: expandedMS,
            ),
            MilestonesFilterMain(
              filterEnabled: filterEnabled,
              dissableFilter: () => setFilterEnabled(false),
            )
          ],
        ),
      );
    });
  }
}
