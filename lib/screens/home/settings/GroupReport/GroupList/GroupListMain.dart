import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../../services/providers/UserInfoProvider.dart';

class GroupListMain extends StatefulWidget {
  final Function(String) setGroup;
  const GroupListMain({super.key, required this.setGroup});

  @override
  State<GroupListMain> createState() => _GroupListMainState();
}

class _GroupListMainState extends State<GroupListMain> {
  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    Map<String, double> groupSummary = {};
    for (var doc in userInfo.docs) {
      String groupName = doc['group'];
      if (groupName == 'none') {
        continue;
      }
      double amount = doc['cost']?.toDouble() ?? 0.0;
      if (groupSummary.containsKey(groupName)) {
        groupSummary[groupName] = groupSummary[groupName]! + amount;
      } else {
        groupSummary[groupName] = amount;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        backgroundColor: primaryAppColor,
      ),
      body: ListView.builder(
        itemCount: groupSummary.keys.length,
        itemBuilder: (context, index) {
          String groupName = groupSummary.keys.elementAt(index);
          double totalAmount = groupSummary[groupName]!;
          double containerWidth = wt * 0.5 - 30;
          return Container(
            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
            height: 45,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                    color: const Color.fromARGB(255, 197, 197, 197),
                    style: BorderStyle.solid,
                    width: 0.5)),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: containerWidth,
                        child: Text(
                          groupName,
                          overflow: TextOverflow.ellipsis,
                        )),
                    SizedBox(
                        width: containerWidth,
                        child: Text(
                          '${totalAmount.toStringAsFixed(2)} ₹',
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
              onTap: () {
                widget.setGroup(groupName);
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
