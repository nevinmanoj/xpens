// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xpens/shared/Db.dart';
import 'package:xpens/shared/dataModals/dbModals/creditCard.dart';

class CreditPaymentDatabaseService {
  final String uid;
  CreditPaymentDatabaseService({required this.uid});

  Future<void> addCreditCard(CreditCard cardDetails) async {
    try {
      await FirebaseFirestore.instance
          .collection('$db/$uid/credit-cards')
          .doc()
          .set(cardDetails.toJson(), SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updateCreditCard(CreditCard updatedCard) async {
    // Implement the logic to update a credit card in the database
  }
  Future<void> deleteCreditCard(String idToDelete) async {
    // Implement the logic to delete a credit card from the database
  }
}
