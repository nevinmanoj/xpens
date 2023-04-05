import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100]?.withOpacity(0.5),
      child: Center(
        child: SpinKitFadingCircle(
          color: Color(0xFF7C7C7C),
          size: 70.0,
        ),
      ),
    );
  }
}
