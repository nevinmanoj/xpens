import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'ExpenseItem.dart';

class ExpenseAccordion extends StatefulWidget {
  final String group;
  final List list;
  const ExpenseAccordion({required this.group, required this.list});
  @override
  State<ExpenseAccordion> createState() => _ExpenseAccordionState();
}

class _ExpenseAccordionState extends State<ExpenseAccordion> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;

    String curDate = "";
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      // padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
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
                    return const ListTile(
                      title: Text(
                        'Expenses',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                  body: SizedBox(
                    height: ht * 0.5,
                    child: ListView.builder(
                      itemCount: widget.list.length,
                      itemBuilder: (context, i) {
                        bool dispDate = false;
                        String iDate = DateFormat.yMMMd()
                            .format(DateTime.parse(widget.list[i]['date']))
                            .toString();
                        if (iDate != curDate) {
                          curDate = iDate;
                          dispDate = true;
                        }

                        return item(widget.list[i].id, widget.list[i], context,
                            dispDate);
                      },
                    ),
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
