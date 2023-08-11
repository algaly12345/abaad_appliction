import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/notifi_widget.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButtonExist;
  final Function onBackPressed;
  final bool showCart;
  CustomAppBar({@required this.title, this.isBackButtonExist = true, this.onBackPressed, this.showCart = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: true,
      leading: isBackButtonExist ? IconButton(
        icon: Center(
          child:   Container(
              height: 27,
              width: 27,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 4,left: 4),
                child: Icon(Icons.arrow_back_ios,size: 23),
              )),
          //
          // child: Container(
          //   height: 27,
          //   width: 27,
          //   alignment: Alignment.center,
          //   decoration: BoxDecoration(
          //       border: Border.all(
          //         color: Theme.of(context).primaryColor,
          //         width: 1,
          //       ),
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 4,left: 4),
          //       child: Icon(Icons.arrow_back_ios,size: 22),
          //     )),
        ),
        color: Theme.of(context).textTheme.bodyText1.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
      actions: showCart ? [
        IconButton(onPressed: () =>
            null,
        icon: NotifIconWidget(color: Theme.of(context).textTheme.bodyText1.color, size: 25),
      )] : null,
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.WEB_MAX_WIDTH, GetPlatform.isDesktop ? 70 : 50);
}
