import 'package:abaad/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoDataScreen extends StatelessWidget {
  final bool isCart;
  final String text;
  NoDataScreen({@required this.text, this.isCart = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

        Text("no data ")
      ]),
    );
  }
}
