// ignore: file_names
import 'package:xpens/shared/dataModals/enums/Period.dart';

class MilestoneTemplate {
  String title;
  DateTime addedDate;
  Period period;
  double? endVal;
  bool skipFirst;

  MilestoneTemplate(
      {required this.addedDate,
      required this.title,
      required this.period,
      required this.skipFirst,
      required this.endVal});

  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'addedDate': addedDate.millisecondsSinceEpoch,
      'period': serializePeriod(period),
      'endVal': endVal,
      'skipFirst': skipFirst,
    };
  }

  // Create from JSON (Deserialization)
  factory MilestoneTemplate.fromJson(json) {
    return MilestoneTemplate(
      title: json['title'] as String,
      addedDate: DateTime.fromMillisecondsSinceEpoch(json['addedDate']),
      period: Period.values.firstWhere((e) => e.name == json['period']),
      endVal:
          json['endVal'] != null ? (json['endVal'] as num).toDouble() : null,
      skipFirst: json['skipFirst'] as bool,
    );
  }
}
