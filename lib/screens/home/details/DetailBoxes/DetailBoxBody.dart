import 'package:flutter/material.dart';

import '../../../../shared/constants.dart';

class DetailBoxBody extends StatelessWidget {
  final bool showAll;
  final String heading;
  final List sortedList;
  final double sum;
  final Function() toggleShowAll;
  const DetailBoxBody(
      {super.key, required this.heading,
      required this.showAll,
      required this.sortedList,
      required this.sum,
      required this.toggleShowAll});

  @override
  Widget build(BuildContext context) {
    bool showShowAll = sortedList.length > 5;
    double wt = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.fromLTRB(wt * 0.05, 10, wt * 0.05, 0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      // height: 200,
      width: 0.9 * wt,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  heading,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "TOTAL:  ${sum.toInt().toString()} ₹ ",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            const SizedBox(
              height: 5,
            ),
            for (int i = 0;
                showAll
                    ? (i < sortedList.length)
                    : (i < sortedList.length && i < 5);
                i++)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  "${sortedList[i].key}:   ${sortedList[i].value.toInt()} ₹",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            showShowAll
                ? InkWell(
                    onTap: () => {toggleShowAll()},
                    child: Center(
                        child: Text(
                      showAll ? "Show Less" : "Show More",
                      style: TextStyle(
                          // color: Color.fromARGB(255, 135, 135, 135)),
                          color: secondaryAppColor.withOpacity(0.3)),
                    )),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
