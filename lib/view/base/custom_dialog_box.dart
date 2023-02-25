// ignore_for_file: prefer_const_constructors

import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ScreenSuccess extends StatefulWidget {
  const ScreenSuccess({Key key,  this.title}) : super(key: key);

  final String title;

  @override
  State<ScreenSuccess> createState() => _ScreenSuccessState();
}

Color themeColor = const Color(0xFF43D19E);

class _ScreenSuccessState extends State<ScreenSuccess> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                Images.success,
                fit: BoxFit.contain,
                color: Theme.of(context).primaryColor,

              ),
            ),

            Text(
              "شكرا",
              style:  robotoBold.copyWith(
              fontSize: 40,
              color: Theme.of(context).primaryColor,
            ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              "تمت عملية اضافة العقار بنجاح",
              style: robotoBold.copyWith(
                fontSize: 20,
                color: Theme.of(context).primaryColor),
            ),

            SizedBox(height: screenHeight * 0.01),
            Text(
              "بيانات االأن تحت المراجعة  يستغرف الوقت نص ساعة\n كافترة اقصي  ومن ثم تتم الموافقة",
              textAlign: TextAlign.center,
              style: robotoBold.copyWith(
                  fontSize: 15,
                  color: Theme.of(context).primaryColor),
            ),
            SizedBox(height: screenHeight * 0.04),
        SizedBox(height: 40),
        Container(
          height: 45,
          margin: EdgeInsets.symmetric(horizontal: 40),
          child: CustomButton(
            onPressed: () async {


            },
            buttonText: 'ok'.tr,
          ),
        ),

          ],
        ),
      ),
    );
  }
}