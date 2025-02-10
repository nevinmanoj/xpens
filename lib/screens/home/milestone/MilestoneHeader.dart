import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit/MilestoneAddorEdit.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';

import '../../../services/milesstoneDatabase.dart';
import 'MilestoneGetx.dart';

class MilestoneHeader extends StatelessWidget {
  final Function enableFilter;
  final bool filterApplied;

  MilestoneHeader({
    super.key,
    required this.enableFilter,
    required this.filterApplied,
  });
  final controller = Get.put(MilestoneFilterController());
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: const Text(
                "Milestones",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            if (filterApplied)
              TextButton(
                  onPressed: () => controller.clearFilter(),
                  child: const Text(
                    "Clear Filter",
                    style: TextStyle(color: secondaryAppColor),
                  )),
            IconButton(
                onPressed: () => enableFilter(),
                icon: Icon(
                  size: 25,
                  Icons.filter_alt_outlined,
                  color: filterApplied ? secondaryAppColor : null,
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MilestoneAddorEdit(
                                submit: (
                                    {required Milestone? newms,
                                    required MilestoneTemplate newmst,
                                    required BuildContext bc}) async {
                                  await MilestoneDatabaseService(uid: user!.uid)
                                      .addMilestoneTemplate(
                                    item: newmst,
                                  );
                                  Navigator.pop(bc);
                                },
                                isAdd: true,
                                inputms: null,
                              )));
                },
                icon: const Icon(
                  Icons.add,
                  size: 25,
                ))
          ],
        ),
        SizedBox(
          height: 50,
          child: TabBar(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            indicatorColor: secondaryAppColor,
            labelColor: secondaryAppColor,
            unselectedLabelColor: const Color(0xff778585),
            tabs: Status.values
                .map((e) => Tab(
                      child: Text(capsFirst(serializeStatus(e))),
                    ))
                .toList(),
          ),
        )
      ],
    );
  }
}
