import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../listx/listStream/ListItem.dart';

class ExpenseAccordion extends StatefulWidget {
  final List list;
  const ExpenseAccordion({required this.list});
  @override
  State<ExpenseAccordion> createState() => _ExpenseAccordionState();
}

class _ExpenseAccordionState extends State<ExpenseAccordion> {
  bool isExpanded = false;

  @override
  @override
  Widget build(BuildContext context) {
    // print(groupedList);
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    Map groupedList = {};
    for (var item in widget.list) {
      if (groupedList[DateFormat.yMMMd()
              .format(DateTime.parse(item['date']))
              .toString()] ==
          null) {
        groupedList[DateFormat.yMMMd()
            .format(DateTime.parse(item['date']))
            .toString()] = [item];
      } else {
        groupedList[DateFormat.yMMMd()
                .format(DateTime.parse(item['date']))
                .toString()]
            .add(item);
      }
    }

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
                      itemCount: groupedList.keys.length,
                      itemBuilder: (context, i) {
                        // print(i);
                        // return null;
                        String iDate = DateFormat.yMMMd()
                            .format(DateTime.parse(widget.list[i]['date']))
                            .toString();
                        return Column(
                          children: [
                            Container(
                              width: wt,
                              color: const Color.fromARGB(255, 232, 232, 232),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: Text(
                                  iDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            for (var item in groupedList[iDate])
                              itemWidget(
                                  context: context, iDate: iDate, item: item)
                          ],
                        );
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
