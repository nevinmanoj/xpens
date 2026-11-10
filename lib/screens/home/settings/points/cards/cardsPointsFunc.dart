// ignore_for_file: file_names

import 'package:intl/intl.dart';
import 'package:xpens/shared/dataModals/dbModals/card.dart';

double calcCardpoints(
    {required DateTime? start,
    required DateTime? end,
    required var data,
    required String sourceId}) {
  var filteredData = data.where((element) => element['sourceId'] == sourceId);
  double sum = 0;
  if (start != null && end != null) {
    //limited points
    filteredData = filteredData.where((doc) =>
        DateTime.parse(doc['date']).isAfter(start) &&
        DateTime.parse(doc['date']).isBefore(end));
  }

  for (var d in filteredData) {
    sum += d['points'];
  }

  return sum;
}

final _points = NumberFormat.decimalPattern('en_IN')..maximumFractionDigits = 2;

/// "1,200 pts"
String formatPoints(num v) => "${_points.format(v)} pts";

/// Rupee value of one point on [card] (0 when the card has no rate).
double rupeesPerPoint(PointSource card) =>
    card.points == 0 ? 0 : card.rupees / card.points;

/// The card an entry was logged against, matched by id, falling back to
/// the stored name for entries from before cards had ids.
PointSource? cardOf(dynamic entry, List<PointSource> cards) {
  final data = entry.data() as Map;
  final id = data['sourceId'];
  for (final c in cards) {
    if (c.selfId == id) return c;
  }
  for (final c in cards) {
    if (c.name == data['cardName']) return c;
  }
  return null;
}

double pointsOf(dynamic entry) =>
    ((entry.data() as Map)['points'] as num?)?.toDouble() ?? 0;
