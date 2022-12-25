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
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      child: Row(
         children: [
          Text("for reposn real estate ")
      ],
      ),
    ));
  }
  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, 70);
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isCart;
  final Function onTap;
  MenuButton({@required this.icon, @required this.title, this.isCart = false, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(children: [
        SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

        Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
      ]),
    );
  }
}

