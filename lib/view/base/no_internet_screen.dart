import 'package:flutter/material.dart';
class NoInternetScreen extends StatelessWidget {
  final Widget child;
  NoInternetScreen({this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.height*0.025),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("not internet"),
          ],
        ),
      ),
    );
  }
}
