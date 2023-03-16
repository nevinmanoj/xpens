import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

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

class MarketLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100]?.withOpacity(0.5),
      child: Center(
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_2KNQ1X.json",
              repeat: true,
              animate: true)),
    );
  }
}

class WalletLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100]?.withOpacity(0.5),
      child: Center(
          child: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_2KNQ1X.json",
              repeat: true,
              animate: true)),
    );
  }
}
