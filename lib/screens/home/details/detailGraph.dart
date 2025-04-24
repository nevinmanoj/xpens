import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:xpens/shared/constants.dart';
import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';
import 'package:xpens/shared/utils/CapsFirst.dart';
import 'package:xpens/shared/utils/formatCostToShortFormat.dart';
import 'package:xpens/shared/utils/getDateTimesFromPeriod.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

class DetailGraph extends StatefulWidget {
  final List data;
  const DetailGraph({super.key, required this.data});

  @override
  State<DetailGraph> createState() => _DetailGraphState();
}

class _DetailGraphState extends State<DetailGraph> {
  Period gMode = Period.year;
  int offset = 0;
  DateRange dateRange =
      getDateTimesFromPeriod(date: DateTime.now(), p: Period.year, offset: 0);

  void handleOffsetChange(bool isReduce) {
    setState(
      () {
        offset += isReduce ? -1 : 1;
        dateRange = getDateTimesFromPeriod(
            date: DateTime.now(), p: gMode, offset: offset);
      },
    );
  }

  void handleModeChange(Period newMode) {
    // Period newMode = getNextPeriod(gMode);
    if (newMode != gMode) {
      setState(
        () {
          gMode = newMode;
          offset = 0;
          dateRange = getDateTimesFromPeriod(
              date: DateTime.now(), p: newMode, offset: 0);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double wt = MediaQuery.of(context).size.width;

    Map<String, double> formattedData = {};
    double highest = 0;

    double sum = 0;
    List keys =
        getKeys(gMode, dateRange.startDate.year, dateRange.startDate.month);

    for (var key in keys) {
      formattedData[key] = 0;
    }

    for (var item in widget.data) {
      try {
        if (DateTime.parse(item["date"]).millisecondsSinceEpoch >=
                dateRange.startDate.millisecondsSinceEpoch &&
            DateTime.parse(item["date"]).millisecondsSinceEpoch <=
                dateRange.endDate.millisecondsSinceEpoch) {
          sum += item["cost"];

          formattedData[getKey(gMode, item)] =
              formattedData[getKey(gMode, item)]! + item["cost"];
          if (highest < formattedData[getKey(gMode, item)]!) {
            highest = formattedData[getKey(gMode, item)]!;
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    double avg = sum / keys.length;
    double highestNiceValue = roundToNice(highest);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, right: 0),
            width: wt * 0.9,
            alignment: Alignment.centerRight,
            child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 24),
                height: 30,
                decoration: BoxDecoration(
                  // color: Colors.amber,

                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Period>(
                    customButton: Container(
                      // width: 35,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: Text(
                        capsFirst(gMode.name),
                      ),
                    ),
                    // isExpanded: true,
                    isDense: true,
                    items: Period.values
                        .where((element) => element != Period.daily)
                        .map((item) => DropdownMenuItem<Period>(
                              value: item,
                              child: Text(
                                capsFirst(item.name),
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: gMode,
                    onChanged: (Period? value) {
                      handleModeChange(value!);
                    },
                  ),
                )),
          ),
          SizedBox(
            height: 300,
            width: wt * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 24,
                left: 12,
                top: 10,
                bottom: 12,
              ),
              child: LineChart(LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color.fromARGB(83, 0, 0, 0),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine();
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: calcHorizIntervalSkip(gMode),
                      getTitlesWidget: (d, m) => bottomTitleWidgets(d, m, keys),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (d, t) =>
                          leftTitleWidgets(d, t, highestNiceValue),
                      reservedSize: 42,
                    ),
                  ),
                ),
                // borderData: FlBorderData(
                //   show: true,
                //   border: Border.all(color: const Color(0xff37434d)),
                // ),
                minX: 0,
                maxX: keys.length - 1,
                minY: 0,
                maxY: 5,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        // if (spot.barIndex == 1) {
                        //   return null;
                        // }
                        final index = spot.x.toInt();
                        final label = keys[index];
                        final cost =
                            spot.barIndex == 0 ? formattedData[label] : avg;
                        return LineTooltipItem(
                          '${spot.barIndex == 0 ? label : "Avg"}  ${cost!.toStringAsFixed(0)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: getCoords(formattedData, highestNiceValue, keys),
                    isCurved: false,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 0, 0, 0),
                        Color.fromARGB(255, 0, 0, 0)
                      ],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: false,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                  LineChartBarData(
                    spots: getAvgCoords(highestNiceValue, avg, keys.length),
                    isCurved: false,
                    gradient: const LinearGradient(
                      colors: [secondaryAppColor, secondaryAppColor],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: false,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                ],
              )),
            ),
          ),
          SizedBox(
            // margin: const EdgeInsets.only(top: 10, bottom: 10, left: 0),
            height: 50,
            width: wt * 0.9,
            // color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () => handleOffsetChange(true),
                    child: Container(
                      margin: EdgeInsets.only(right: 5),
                      child: const Icon(
                        Icons.chevron_left,
                        size: 30,
                      ),
                    )),
                Text(
                  offsetChangerTitle(gMode, dateRange),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                InkWell(
                    onTap: () => handleOffsetChange(false),
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: const Icon(
                        Icons.chevron_right,
                        size: 30,
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> getCoords(formattedData, highestNiceValue, List keyList) {
    if (highestNiceValue == 0) {
      highestNiceValue = 1.0;
    }
    List<FlSpot> res = [];

    for (int index = 0; index < keyList.length; index++) {
      res.add(FlSpot(index.toDouble(),
          (formattedData[keyList[index]] / highestNiceValue) * 5));
    }

    return res;
  }

  List<FlSpot> getAvgCoords(highestNiceValue, avg, xlength) {
    if (highestNiceValue == 0) {
      highestNiceValue = 1.0;
    }
    List<FlSpot> res = [];
    for (int index = 0; index < xlength; index++) {
      res.add(FlSpot(index.toDouble(), (avg / highestNiceValue) * 5));
    }
    return res;
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, List keyList) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text = Text(
      keyList[value.toInt()],
      style: style,
    );

    return SideTitleWidget(
      axisSide: AxisSide.left,
      child: text,
    );
  }

  Widget leftTitleWidgets(
      double value, TitleMeta meta, double highestNiceValue) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    if (highestNiceValue != 0 || value == 5.0) {
      text = formatCostToShortFormat((value / 5) * highestNiceValue,
          roundToNice: false);
    } else {
      text = "";
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }
}

List<String> getKeys(Period gMode, int year, int month) {
  switch (gMode) {
    case Period.halfYear:
      return month <= 6 ? monthList.sublist(0, 6) : monthList.sublist(6, 12);
    case Period.quarter:
      int quarter = ((month - 1) ~/ 3) + 1;
      return monthList.sublist((quarter - 1) * 3, quarter * 3);
    case Period.year:
      return monthList;
    case Period.monthly:
      int daysInMonth = DateTime(year, month + 1, 0).day;
      return List.generate(daysInMonth, (index) => '${index + 1}');
    case Period.weekly:
      return weekList;
    case Period.daily:
      return [];
  }
}

String getKey(Period gMode, item) {
  switch (gMode) {
    case Period.year:
    case Period.halfYear:
    case Period.quarter:
      return item["month"];
    case Period.monthly:
      return item["day"];
    case Period.weekly:
      return weekList[DateTime.parse(item["date"]).weekday - 1];
    case Period.daily:
      return "";
  }
}

double calcHorizIntervalSkip(Period gMode) {
  switch (gMode) {
    case Period.monthly:
      return 7.5;
    case Period.year:
      return 3;
    case Period.halfYear:
    case Period.quarter:
    case Period.weekly:
    case Period.daily:
      return 1;
  }
}

String offsetChangerTitle(Period gMode, DateRange range) {
  switch (gMode) {
    case Period.monthly:
      return "${monthList[range.startDate.month - 1]} ${range.startDate.year.toString()}";
    case Period.year:
      return range.startDate.year.toString();
    case Period.halfYear:
      int half = ((range.startDate.month - 1) ~/ 6) + 1;
      return "${range.startDate.year.toString()} H$half";
    case Period.quarter:
      int quarter = ((range.startDate.month - 1) ~/ 3) + 1;
      return "${range.startDate.year.toString()} Q$quarter";
    case Period.weekly:
      return "${DateFormat('dd MMM yyyy').format(range.startDate)} - ${DateFormat('dd MMM yyyy').format(range.endDate)}";
    case Period.daily:
      return "";
  }
}

Period getNextPeriod(Period gMode) {
  List values = Period.values.where((e) => e != Period.daily).toList();
  final nextIndex = (gMode.index + 1) % values.length;
  // return values[nextIndex];
  return values[nextIndex];
}
