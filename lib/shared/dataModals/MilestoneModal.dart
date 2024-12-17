import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/dataModals/subModals/PeriodDates.dart';

class Milestone {
  String title;
  DateRange dateRange;
  double? currentVal;
  double? endVal;
  Status currentStatus;
  String templateID;

  Milestone(
      {required this.dateRange,
      required this.title,
      required this.templateID,
      this.currentVal,
      required this.currentStatus,
      this.endVal});

  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'templateID': templateID,
      'startDate': dateRange.startDate.millisecondsSinceEpoch,
      'endDate': dateRange.endDate.millisecondsSinceEpoch,
      'currentStatus': serializeStatus(currentStatus),
      'endVal': endVal,
      'currentVal': currentVal
    };
  }

  // Create from JSON (Deserialization)
  factory Milestone.fromJson(json) {
    return Milestone(
      title: json['title'] as String,
      templateID: json['templateID'] as String,
      currentStatus:
          Status.values.firstWhere((e) => e.name == json['currentStatus']),
      currentVal: json['currentVal'] != null
          ? (json['currentVal'] as num).toDouble()
          : null,
      endVal:
          json['endVal'] != null ? (json['endVal'] as num).toDouble() : null,
      dateRange: DateRange(
          endDate: DateTime.fromMillisecondsSinceEpoch(json['endDate']),
          startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'])),
    );
  }
}
