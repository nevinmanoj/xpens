import 'package:fraction/fraction.dart';

class BillItem {
  double cost;
  String itemName;
  SplitType splitType = SplitType.equal;
  BillItem({
    required this.cost,
    required this.splitType,
    required this.itemName,
  });
}

enum SplitType {
  equal,
  fraction,
  percentage,
}

class Share {
  String person;
  String itemName;
  Fraction fraction;
  Share({required this.person, required this.fraction, required this.itemName});
}
