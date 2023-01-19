import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({this.child,
    this.padding,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
      padding: padding ?? const EdgeInsets.all(20.0),
      // padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.02),
            blurRadius: 10.0,
            spreadRadius: 10.0,
          )
        ],
      ),
      child: child,
    );
  }
}
