import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/MileStonePopup/MilestonePopupMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneFilter/milestoneFilterMain.dart';
import 'package:xpens/screens/home/milestone/MilestoneHeader.dart';
import 'package:xpens/screens/home/milestone/milestoneItem.dart';
import 'package:xpens/screens/home/milestone/msFilterFunction.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

class MilestonesMain extends StatefulWidget {
  const MilestonesMain({super.key});

  @override
  State<MilestonesMain> createState() => _MilestonesMainState();
}

class _MilestonesMainState extends State<MilestonesMain> {
  Milestone? expandedMS;
  List periodList = [...Period.values];

  bool filterEnabled = false;
  void clearFilter() {
    setState(() {
      periodList = [...Period.values];
    });
  }

  void setPeriodList(list) {
    setState(() {
      periodList = list;
    });
  }

  void setFilterEnabled(bool val) {
    setState(() {
      filterEnabled = val;
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

    double wt = MediaQuery.of(context).size.width;
    double ht = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Container(
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
                  periodList: periodList,
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
                          isSelected: expandedMS?.selfId == newmslist[i].selfId,
                        ));
                  }));
            }).toList()),
          ),
          SizedBox(
              height: 100,
              child:
                  MilestoneHeader(enableFilter: () => setFilterEnabled(true))),
          MilestonePopup(
            clearMs: () => setState(() => expandedMS = null),
            ms: expandedMS,
          ),
          MilestonesFilterMain(
            filterEnabled: filterEnabled,
            dissableFilter: () => setFilterEnabled(false),
            setPeriodList: (p) => setPeriodList(p),
            periodList: periodList,
            clearFilter: () => clearFilter(),
          )
        ],
      ),
    );
  }
}
