
import 'package:abaad/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileBgWidget extends StatelessWidget {
  final Widget circularImage;
  final Widget mainWidget;
  final bool backButton;
  ProfileBgWidget({@required this.mainWidget, @required this.circularImage, @required this.backButton});

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
          children: [

        Stack(clipBehavior: Clip.none, children: [

          SizedBox(
            width: context.width, height: 100,
           // child: Center(child: Image.asset(Images.profile_bg, height: 260, width: Dimensions.WEB_MAX_WIDTH, fit: BoxFit.fill)),
          ),

          Positioned(
            top: 20, left: 0, right: 0, bottom: 0,
            child: Center(
              child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: circularImage,
          ),

        ]),

        Expanded(
          child: mainWidget,
        ),

      ]),
    );
  }
}
