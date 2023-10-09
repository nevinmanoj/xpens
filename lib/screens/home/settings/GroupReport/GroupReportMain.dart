import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import 'ExpenseAccordion/ExpenseAccordion.dart';
import 'GroupInput/GroupInput.dart';
import 'GroupSummary.dart';

class GroupReportMain extends StatefulWidget {
  const GroupReportMain({super.key});

  @override
  State<GroupReportMain> createState() => _GroupReportMainState();
}

class _GroupReportMainState extends State<GroupReportMain> {
  String group = "";
  void setGroup(value) {
    setState(() {
      group = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<UserInfoProvider>(context);
    List list = listData.docs;
    list = list.where((item) {
      return item['group'] == group;
    }).toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupInput(
              setGroup: setGroup,
            ),
            GroupSummary(
              data: list,
              group: group,
            ),
            ExpenseAccordion(
              list: list,
            ),
          ],
        ),
      ),
    );
  }
}
