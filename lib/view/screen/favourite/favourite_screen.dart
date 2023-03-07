import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/estate_item.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/screen/favourite/widget/favourite_view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Get.find<WishListController>().getWishList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Get.find<AuthController>().isLoggedIn() ? Container(child:      GetBuilder<WishListController>(builder: (wishController) {
        return RefreshIndicator(
          onRefresh: () async {
            await wishController.getWishList();
          },
          child:ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount:  wishController.wishRestList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return  GetBuilder<WishListController>(builder: (wishController) {
                return  EstateItem(estate: wishController.wishRestList[index],onPressed: (){
                  Get.toNamed(RouteHelper.getDetailsRoute( wishController.wishRestList[index].estate_id));
                },fav: true,);
              });
            },
          ),
        );
      })) : NotLoggedInScreen(),
    );
  }
}













