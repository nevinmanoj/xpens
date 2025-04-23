import 'package:xpens/shared/dataModals/enums/Period.dart';
import 'package:xpens/shared/dataModals/enums/Status.dart';
import 'package:xpens/shared/dataModals/subModals/MilestoneValue.dart';
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
  bool isOrphan;
  bool isPrematureClosure;
  int idCount;
  List<MilestoneValue> values;
  Milestone._(
      {required this.dateRange,
      required this.isOrphan,
      required this.selfId,
      required this.title,
      required this.period,
      required this.templateID,
      required this.isPrematureClosure,
      this.currentVal,
      required this.currentStatus,
      required this.skipFirst,
      required this.values,
      required this.idCount,
      this.endVal});

  factory Milestone(
      {required dateRange,
      required isOrphan,
      required selfId,
      required title,
      required period,
      required templateID,
      currentVal,
      required currentStatus,
      required skipFirst,
      required List<MilestoneValue> values,
      required idCount,
      endVal}) {
    bool prematureClosure = currentStatus == Status.closed &&
        DateTime.now().isBefore(dateRange.endDate);
    if (endVal != null && currentVal != null) {
      prematureClosure = prematureClosure && currentVal! <= endVal!;
    }

    return Milestone._(
        currentVal: currentVal,
        endVal: endVal,
        currentStatus: currentStatus,
        dateRange: dateRange,
        isOrphan: isOrphan,
        selfId: selfId,
        title: title,
        period: period,
        templateID: templateID,
        isPrematureClosure: prematureClosure,
        skipFirst: skipFirst,
        values: values,
        idCount: idCount);
  }

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
      'isOrphan': isOrphan,
      'period': serializePeriod(period),
      'values': values.map((e) => e.toJson()),
      'idCount': idCount
    };
  }

  // Create from JSON (Deserialization)
  factory Milestone.fromJson(json) {
    return Milestone(
      period: deserializePeriod(json['period']),
      selfId: json.id,
      title: json['title'] as String,
      templateID: json['templateID'] as String,
      isOrphan: json['isOrphan'] as bool,
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
      values: (json["values"] as List)
          .map((e) => MilestoneValue.fromJson(e))
          .toList(),
      idCount: json["idCount"],
    );
  }
}
