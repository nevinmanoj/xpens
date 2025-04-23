class MilestoneValue {
  double value;
  DateTime date;
  String id;
  MilestoneValue._({
    required this.date,
    required this.id,
    required this.value,
  });

  factory MilestoneValue({
    required date,
    required id,
    required value,
  }) {
    return MilestoneValue._(
      date: date,
      id: id,
      value: value,
    );
  }

  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'id': id,
      'value': value,
    };
  }

  // Create from JSON (Deserialization)
  factory MilestoneValue.fromJson(json) {
    return MilestoneValue(
        id: json['id'],
        date: DateTime.fromMillisecondsSinceEpoch(json['date']),
        value: (json['value'] as num).toDouble());
  }
}
