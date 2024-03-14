import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/providers/UserInfoProvider.dart';
import 'TrashItem.dart';
import 'package:intl/intl.dart';

class TrashBody extends StatefulWidget {
  final String type;
  const TrashBody({super.key, required this.type});

  @override
  State<TrashBody> createState() => _TrashBodyState();
}

class _TrashBodyState extends State<TrashBody> {
  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<UserInfoProvider>(context);
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List list = [];
    switch (widget.type) {
      case "Expense":
        list = listData.eTrash;
        break;
      case "Points":
        list = listData.pTrash;
        break;
    }

    Map groupedList = {};
    for (var item in list) {
      if (groupedList[DateFormat.yMMMd()
              .format(DateTime.parse(item['deleteDate']))
              .toString()] ==
          null) {
        groupedList[DateFormat.yMMMd()
            .format(DateTime.parse(item['deleteDate']))
            .toString()] = [item];
      } else {
        groupedList[DateFormat.yMMMd()
                .format(DateTime.parse(item['deleteDate']))
                .toString()]
            .add(item);
      }
    }
    return ListView.builder(
      // itemCount: list.length + 2,
      itemCount: groupedList.keys.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) {
          return Container(
            height: ht * 0.095,
          );
        }
        String iDate = groupedList.keys.toList()[i - 1];
        return Column(
          children: [
            Container(
              width: wt,
              color: const Color.fromARGB(255, 232, 232, 232),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      iDate,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Icon(Icons.delete_outline)
                  ],
                ),
              ),
            ),
            for (var item in groupedList[iDate])
              trashItemWidget(
                context: context,
                iDate: iDate,
                item: item,
                type: widget.type,
              )
            // Text("data")
          ],
        );
      },
    );
  }
}
