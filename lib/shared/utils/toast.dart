import 'package:flutter/material.dart';

import 'package:xpens/shared/constants.dart';

void showToast(
    {required BuildContext context,
    required String msg,
    Duration duration = const Duration(seconds: 2, milliseconds: 500)}) {
  try {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: primaryAppColor,
        content: Text(msg),
      ),
    );
  } catch (e) {
    print("failed toast");
  }
}
