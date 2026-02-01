import 'package:flutter/material.dart';

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
  GroupSortBy selectedSort = GroupSortBy.latest;
  void setSort(GroupSortBy sort) {
    setState(() {
      selectedSort = sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    UserInfoProvider userInfo = Provider.of<UserInfoProvider>(context);
    Map<String, double> groupSummary = {};
    List sortedKeys = [];

    for (var doc in userInfo.docs) {
      String groupName = doc['group'];
      if (groupName == 'none') {
        continue;
      }
      double amount = doc['cost']?.toDouble() ?? 0.0;
      //cost summary
      if (groupSummary.containsKey(groupName)) {
        groupSummary[groupName] = groupSummary[groupName]! + amount;
      } else {
        groupSummary[groupName] = amount;
      }
    }

    if (selectedSort == GroupSortBy.latest ||
        selectedSort == GroupSortBy.oldest) {
      Map<String, DateTime> groupDateSummary = {};
      for (var doc in userInfo.docs) {
        String groupName = doc['group'];
        if (groupName == 'none') {
          continue;
        }
        DateTime date = DateTime.parse(doc['date']);
        //date Summary
        if (groupDateSummary.containsKey(groupName)) {
          bool conditon = selectedSort == GroupSortBy.oldest
              ? date.isBefore(groupDateSummary[groupName]!)
              : date.isAfter(groupDateSummary[groupName]!);
          if (conditon) {
            groupDateSummary[groupName] = date;
          }
        } else {
          groupDateSummary[groupName] = date;
        }
      }
      sortedKeys = sortGroupData(selectedSort, groupDateSummary);
    } else {
      sortedKeys = sortGroupData(selectedSort, groupSummary);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groups'),
        backgroundColor: primaryAppColor,
      ),
      body: Stack(
        children: [
          SizedBox(
            height: 100,
            child: Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.4),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonFormField<GroupSortBy>(
                value: selectedSort,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Sort By',
                    labelStyle: TextStyle(color: Colors.grey)),
                hint: Text(
                  "Sort By",
                  style: TextStyle(color: Colors.grey.withOpacity(0.8)),
                ),
                onChanged: (value) {
                  setSort(value!);
                },
                items: GroupSortBy.values
                    .map<DropdownMenuItem<GroupSortBy>>((value) {
                  return DropdownMenuItem<GroupSortBy>(
                    value: value,
                    child: Text(getGroupSortByName(value)),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 90),
            child: ListView.builder(
              itemCount: sortedKeys.length,
              itemBuilder: (context, index) {
                String groupName = sortedKeys[index] as String;
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
          ),
        ],
      ),
    );
  }
}

enum GroupSortBy { nameAsc, nameDesc, costAsc, costDesc, latest, oldest }

String getGroupSortByName(GroupSortBy sort) {
  switch (sort) {
    case GroupSortBy.nameAsc:
      return 'Name Asceding';
    case GroupSortBy.nameDesc:
      return 'Name Descending';
    case GroupSortBy.costAsc:
      return 'Cost Asceding';
    case GroupSortBy.costDesc:
      return 'Cost Descending';
    case GroupSortBy.latest:
      return 'Latest First';
    case GroupSortBy.oldest:
      return 'Oldest First';
  }
}

List sortGroupData(GroupSortBy sort, Map<String, dynamic> data) {
  switch (sort) {
    case GroupSortBy.nameAsc:
      return data.keys.toList()..sort();
    case GroupSortBy.nameDesc:
      return data.keys.toList()..sort((a, b) => b.compareTo(a));
    case GroupSortBy.costAsc:
    case GroupSortBy.oldest:
      var sortedEntries = data.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      return sortedEntries.map((e) => e.key).toList();
    case GroupSortBy.costDesc:
    case GroupSortBy.latest:
      var sortedEntries = data.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      return sortedEntries.map((e) => e.key).toList();
  }
}
