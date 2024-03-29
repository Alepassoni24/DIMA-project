import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Spinning circle used when waiting for Firebase data to be loaded
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange[50],
      child: SpinKitFadingCircle(
        color: Colors.orange[400],
        size: 60.0,
      ),
    );
  }
}
