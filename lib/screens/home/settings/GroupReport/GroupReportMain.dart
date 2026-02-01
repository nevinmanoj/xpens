import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/screens/home/settings/GroupReport/GroupList/GroupListMain.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';
import 'package:xpens/shared/constants.dart';

import 'ExpenseAccordion/ExpenseAccordion.dart';
import 'GroupInput/GroupInput.dart';
import 'GroupSummary.dart';

class GroupReportMain extends StatefulWidget {
  const GroupReportMain({
    super.key,
  });

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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => GroupListMain(
                              setGroup: setGroup,
                            )));
              },
              icon: const Icon(Icons.list))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GroupInput(
              group: group,
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
