import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: Dimensions.WEB_MAX_WIDTH,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(top: 40 ,right: 7,left: 7),
      child:   Row(
        children: [
          InkWell(
            onTap: (){
              // Push.to(context, const ProfileScreen())
            },
            child:  Image.asset(Images.menu, width: 30.0, height: 30.0),
          ),
          const Spacer(),
          Center(
            child:  Text(
              ' المنطقة الشرقية - الدمام ',style: robotoBlack.copyWith(fontSize: 11)
          ),
          ),
          const Spacer(),
          Image.asset(Images.notification, width: 30.0, height: 30.0),
        ],
      ),
    ));
  }
  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, 55);
}


