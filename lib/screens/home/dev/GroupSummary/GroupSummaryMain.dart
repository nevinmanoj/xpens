import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/shared/constants.dart';

import '../../../../services/providers/ExpenseDataProvider.dart';
import 'ExpenseAccordion.dart';

class GroupSummaryMain extends StatefulWidget {
  const GroupSummaryMain({super.key});

  @override
  State<GroupSummaryMain> createState() => _GroupSummaryMainState();
}

class _GroupSummaryMainState extends State<GroupSummaryMain> {
  @override
  Widget build(BuildContext context) {
    // final listData = Provider.of<ExpenseDataProvider>(context);
    // List list = listData.docs;
    List<Map<String, dynamic>> data = [];
    // List<Map<String, dynamic>> data = list
    //     .map((document) => document.data() as Map<String, dynamic>)
    //     .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryAppColor,
      ),
      body: Column(
        children: [
          ExpenseAccordion(
            data: data,
          )
        ],
      ),
    );
  }
}
