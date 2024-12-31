import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/milestones/milestoneItem.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/dataModals/MilestoneModal.dart';

class MilestonesMain extends StatefulWidget {
  const MilestonesMain({super.key});

  @override
  State<MilestonesMain> createState() => _MilestonesMainState();
}

class _MilestonesMainState extends State<MilestonesMain> {
  @override
  Widget build(BuildContext context) {
    List milestones = Provider.of<UserInfoProvider>(context).milestones;
    return Container(
      color: Color.fromARGB(255, 227, 227, 227),
      // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListView.builder(
          itemCount: milestones.length,
          itemBuilder: ((context, i) {
            return MilestoneItem(ms: Milestone.fromJson(milestones[i]));
          })),
    );
  }
}
