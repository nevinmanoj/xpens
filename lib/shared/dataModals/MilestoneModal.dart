import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';

class Milestone {
  String selfId;
  String title;
  bool skipFirst;
  DateRange dateRange;
  double? currentVal;
  double? endVal;
  Status currentStatus;
  String templateID;
  Period period;

  Milestone(
      {required this.dateRange,
      required this.selfId,
      required this.title,
      required this.period,
      required this.templateID,
      this.currentVal,
      required this.currentStatus,
      required this.skipFirst,
      this.endVal});

  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'skipFirst': skipFirst,
      'templateID': templateID,
      'startDate': dateRange.startDate.millisecondsSinceEpoch,
      'endDate': dateRange.endDate.millisecondsSinceEpoch,
      'currentStatus': serializeStatus(currentStatus),
      'endVal': endVal,
      'currentVal': currentVal,
      'period': serializePeriod(period)
    };
  }

  // Create from JSON (Deserialization)
  factory Milestone.fromJson(json) {
    return Milestone(
      period: deserializePeriod(json['period']),
      selfId: json.id,
      title: json['title'] as String,
      templateID: json['templateID'] as String,
      currentStatus: deserializeStatus(json['currentStatus']),
      currentVal: json['currentVal'] != null
          ? (json['currentVal'] as num).toDouble()
          : null,
      endVal:
          json['endVal'] != null ? (json['endVal'] as num).toDouble() : null,
      dateRange: DateRange(
          endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
          startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'])),
      skipFirst: json['skipFirst'],
    );
  }
}
