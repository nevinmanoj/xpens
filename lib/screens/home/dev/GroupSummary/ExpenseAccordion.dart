import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xpens/services/providers/UserInfoProvider.dart';

class ExpenseAccordion extends StatefulWidget {
  List<Map<String, dynamic>> data;
  ExpenseAccordion({required this.data});
  @override
  State<ExpenseAccordion> createState() => _ExpenseAccordionState();
}

class _ExpenseAccordionState extends State<ExpenseAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List allItems = Provider.of<UserInfoProvider>(context).items;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionPanelList(
              elevation: 0,
              expandedHeaderPadding: EdgeInsets.all(0),
              expansionCallback: (int index, bool _isExpanded) {
                setState(() {
                  // Update the selected option when an accordion is expanded
                  isExpanded = !_isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool _isExpanded) {
                    return ListTile(
                      title: Text(
                        'Expenses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  body: Column(
                    children: [
                      for (int i = 0; i < allItems.length; i++)
                        Text(allItems[i])
                    ],
                  ),
                  isExpanded: isExpanded,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
