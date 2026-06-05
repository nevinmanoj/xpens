class CreditCard {
  String id;
  String cardName;
  double creditLimit;
  double annualFee;
  int statementDay;
  int dueInDays;
  DateTime joiningDate;
  CreditCard({
    required this.id,
    required this.cardName,
    required this.creditLimit,
    required this.annualFee,
    required this.statementDay,
    required this.dueInDays,
    required this.joiningDate,
  });
  // Convert to JSON (Serialization)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardName': cardName,
      'creditLimit': creditLimit,
      'annualFee': annualFee,
      'statementDay': statementDay,
      'dueInDays': dueInDays,
      'joiningDate': joiningDate.toString(),
    };
  }

  // Create from JSON (Deserialization)
  factory CreditCard.fromJson(json) {
    return CreditCard(
      id: json.id,
      cardName: json['cardName'] as String,
      creditLimit: (json['creditLimit'] as num).toDouble(),
      annualFee: (json['annualFee'] as num).toDouble(),
      statementDay: json['statementDay'] as int,
      dueInDays: json['dueInDays'] as int,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
    );
  }
}
