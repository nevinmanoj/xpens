class PointSource {
  String name;
  double points;
  double rupees;
  String selfId;
  PointSource({
    required this.name,
    required this.rupees,
    required this.points,
    required this.selfId,
  });
  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
      'rupees': rupees,
    };
  }

  // Create from JSON (Deserialization)
  factory PointSource.fromJson(json) {
    return PointSource(
      selfId: json.id,
      points: (json['points'] as num).toDouble(),
      rupees: (json['rupees'] as num).toDouble(),
      name: json['name'] as String,
    );
  }
}
