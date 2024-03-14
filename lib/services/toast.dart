import 'package:flutter/material.dart';

import 'package:xpens/shared/constants.dart';

void showToast({required BuildContext context, required String msg}) {
  try {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2, milliseconds: 500),
        backgroundColor: primaryAppColor,
        content: Text(msg),
      ),
    );
  } catch (e) {
    print("failed toast");
  }
}
