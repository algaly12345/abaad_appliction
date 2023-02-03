import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/notification_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebMenuBar extends StatelessWidget implements PreferredSizeWidget {
  final Function ontop;
  WebMenuBar({@required this.ontop});
  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: Dimensions.WEB_MAX_WIDTH,
      color: Theme.of(context).cardColor,
      padding: EdgeInsets.only(top: 42 ,right: 7,left: 7),
      child:   Row(
        children: [
          InkWell(
            onTap:ontop,
            child:  Image.asset(Images.menu, width: 30.0, height: 33.0),
          ),
          const Spacer(),
          Center(
            child:  Column(
              children: [
                Text(
                    'موقعك',style: robotoBlack.copyWith(fontSize: 11)
                ),
                Text(
                  ' المنطقة الشرقية - الدمام ',style: robotoBlack.copyWith(fontSize: 12)
          ),
              ],
            ),
          ),
          const Spacer(),
          InkWell(
            child: GetBuilder<NotificationController>(builder: (notificationController) {
              return Stack(children: [
                Icon(Icons.notifications_active_outlined, size: 30, color: Theme.of(context).textTheme.bodyText1.color),
                notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : SizedBox(),
              ]);
            }),
            onTap: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
        ],
      ),
    ));
  }
  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, 55);
}


