import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/milestone/MilestoneAddorEdit.dart';
import 'package:xpens/shared/dataModals/MilestoneTemplateModal.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';

import '../../../services/milesstoneDatabase.dart';

class MilestoneHeader extends StatelessWidget {
  const MilestoneHeader({super.key});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User?>(context);
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MilestoneAddorEdit(
                            submit: (
                                {required String title,
                                required double? curVal,
                                required Period period,
                                required double? endVal,
                                required bool skipFirst,
                                required BuildContext bc}) async {
                              await MilestoneDatabaseService(uid: user!.uid)
                                  .addMilestoneTemplate(
                                item: MilestoneTemplate(
                                    addedDate: DateTime.now(),
                                    title: title,
                                    templateId: 'place_holder',
                                    period: period,
                                    skipFirst: skipFirst,
                                    endVal: endVal),
                              );
                              Navigator.pop(bc);
                            },
                            isAdd: true,
                            curVal: null,
                            title: '',
                            period: Period.daily,
                            skipFirst: false,
                          )));
            },
            icon: const Icon(Icons.add))
      ],
    );
  }
}
