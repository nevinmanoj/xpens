class Streak {
  List<DateTime> list;
  DateTime addedDate;
  String title;
  String selfId;
  bool selectRed;
  String verb;
  Streak({
    required this.addedDate,
    required this.selectRed,
    required this.list,
    required this.selfId,
    required this.title,
    required this.verb,
  });
  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'list': list.map((e) => e.toString()).toList(),
      'addedDate': addedDate.toString(),
      'title': title,
      'verb': verb,
      'selectRed': selectRed
    };
  }

  // Create from JSON (Deserialization)
  factory Streak.fromJson(json) {
    return Streak(
      verb: json["verb"],
      selectRed: json['selectRed'],
      selfId: json.id,
      title: json['title'] as String,
      addedDate: DateTime.parse(json['addedDate']),
      list: (json['list'] as List).map((e) => DateTime.parse(e)).toList(),
    );
  }
}
