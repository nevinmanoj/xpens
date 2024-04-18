import 'package:get/get.dart';

import '../../../../shared/dataModals/BillISplitModal.dart';

class BillSplitController extends GetxController {
  Map<String, double> persons = {};
  List<BillItem> billItems = [];
  List<Share> shareList = [];
  double total = 0;
  void addPerson(name) {
    persons[name] = 0.0;
    update();
  }

  void removePerson(String name) {
    if (billItems.isEmpty) {
      persons.remove(name);
      update();
    }
  }

  void addBillItem(BillItem I, List<Share> shares) {
    billItems.add(I);
    shareList.addAll(shares);
    total = total + I.cost;
    for (var share in shares) {
      double cost = (billItems
              .firstWhere((item) => item.itemName == share.itemName)
              .cost) *
          share.fraction.toDouble();
      persons[share.person] = persons[share.person]! + cost;
    }
    update();
  }

  void updateBillItem(BillItem I, List<Share> shares) {
    total = total + I.cost;

    for (var item in billItems) {
      if (item.itemName == I.itemName) {
        total = total + I.cost - item.cost;
        item = I;

        shareList.removeWhere((e) {
          if (e.itemName == I.itemName) {
            double cost = (billItems
                    .firstWhere((item) => item.itemName == e.itemName)
                    .cost) *
                e.fraction.toDouble();
            persons[e.person] = persons[e.person]! - cost;
            return true;
          }
          return false;
        });
        for (var share in shares) {
          double cost = (billItems
                  .firstWhere((item) => item.itemName == share.itemName)
                  .cost) *
              share.fraction.toDouble();
          persons[share.person] = persons[share.person]! + cost;
        }

        update();
        return;
      }
    }
  }

  void removeBillItem(String name) {
    billItems.removeWhere((element) {
      if (element.itemName == name) {
        total = total - element.cost;
        return true;
      }
      return false;
    });
    shareList.removeWhere((e) {
      if (e.itemName == name) {
        double cost =
            (billItems.firstWhere((item) => item.itemName == e.itemName).cost) *
                e.fraction.toDouble();
        persons[e.person] = persons[e.person]! - cost;
        return true;
      }
      return false;
    });
    update();
  }

  void discardBill() {
    persons = {};
    billItems = [];
    shareList = [];
    total = 0;
    update();
  }
}
