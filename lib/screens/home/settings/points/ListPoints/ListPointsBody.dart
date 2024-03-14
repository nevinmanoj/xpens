import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:xpens/screens/home/settings/points/ListPoints/ListPointItem.dart';
import '../../../../../services/providers/UserInfoProvider.dart';

class ListPointsBody extends StatefulWidget {
  final String card;
  const ListPointsBody({super.key, required this.card});

  @override
  State<ListPointsBody> createState() => _ListPointsBodyState();
}

class _ListPointsBodyState extends State<ListPointsBody> {
  @override
  Widget build(BuildContext context) {
    final listData = Provider.of<UserInfoProvider>(context);
    double ht = MediaQuery.of(context).size.height;
    double wt = MediaQuery.of(context).size.width;
    List list = listData.pointDocs;
    switch (widget.card) {
      case "All":
        break;
      case "Other":
        list = list
            .where((item) => !listData.cards.contains(item['cardName']))
            .toList();
        break;
      default:
        list = list.where((item) {
          return item['cardName'] == widget.card;
        }).toList();
    }

    Map groupedList = {};
    for (var item in list) {
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
                child: Text(
                  iDate,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            for (var item in groupedList[iDate])
              pointItemWidget(context: context, iDate: iDate, item: item)
            // Text("data")
          ],
        );
      },
    );
  }
}
