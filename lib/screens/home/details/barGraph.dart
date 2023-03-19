// ignore: file_names
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  DashboardScreen({required this.seriesList, required this.animate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: charts.BarChart(
          seriesList,
          animate: animate,
          barGroupingType: charts.BarGroupingType.groupedStacked,
          vertical: true,
        ),
      ),
    );
  }
}
