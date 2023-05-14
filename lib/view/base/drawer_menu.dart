import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/confirmation_dialog.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DrawerMenu extends StatelessWidget {

  DrawerMenu();

  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return GetBuilder<UserController>(builder: (userController) {
      return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) :Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:  ListView(
            children: <Widget>[

              UserAccountsDrawerHeader(
                accountName:  Text(
                  _isLoggedIn ? '${userController.userInfoModel.name}' : 'guest'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color:  Colors.grey), ),

                accountEmail:   Text(
                  _isLoggedIn ? '${userController.userInfoModel.phone}' : 'guest'.tr,
                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.grey),
                ),
                onDetailsPressed: (){
                  Get.toNamed(RouteHelper.getProfileRoute());
                },
                decoration:  const BoxDecoration(
                    color: Colors.white

                  // image:  DecorationImage(
                  //   image: ExactAssetImage(Images.placeholder),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                currentAccountPicture:  ClipOval(child: CustomImage(
                  image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                      '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                  height: 100, width: 100, fit: BoxFit.cover,
                )),
              ),
              listItem(1,Icons.manage_accounts_outlined, 'my_account'.tr, Colors.blueAccent,(){
                Get.toNamed(RouteHelper.getProfileRoute());
              }),
              listItem(1,Icons.language, 'language'.tr, Colors.green,(){
                Get.toNamed(RouteHelper.getLanguageRoute("menu"));
              }),
              Divider(height: 1),

              listItem(2,Icons.support_agent_outlined, 'help_support'.tr, Colors.orange,(){
                Get.toNamed( RouteHelper.getSupportRoute());
              }),
              Divider(height: 1),

              listItem(3,Icons.policy, 'privacy_policy'.tr, Colors.pink,(){
                 Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
              }),
              Divider(height: 1),

              listItem(4,Icons.info, 'about_us'.tr, Colors.deepPurple,(){
                  Get.toNamed(RouteHelper.getHtmlRoute("about-us"));
              }),
              Divider(height: 1),

              listItem(5,Icons.list_alt, 'terms_conditions'.tr, Colors.grey,(){

                     Get.toNamed(RouteHelper.getHtmlRoute("terms_conditions"));
              }),
              Divider(height: 1),

              listItem(6,Icons.account_balance_wallet_outlined, 'wallet'.tr, Colors.green,(){
                Get.toNamed(RouteHelper.getWalletRoute(true));
              }),

              Divider(height: 1),
              Divider(height: 1),

              listItem(4,Icons.share, 'share_app'.tr, Colors.deepOrangeAccent,(){

                if (Platform.isIOS) {
                  // print('is a IOS');
                  Share.share('https://play.google.com/store/apps/details?id=sa.pdm.abaad.abaad', subject: 'Look what I made!');

                } else if (Platform.isAndroid) {
                  Share.share('https://play.google.com/store/apps/details?id=sa.pdm.abaad.abaad', subject: 'Look what I made!');
                } else {
                }
              }),

              listItem(8,Icons.logout,  _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, Colors.orange,(){


                if(Get.find<AuthController>().isLoggedIn()) {
                  Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                    Get.find<AuthController>().clearSharedData();
                    // Get.find<WishListController>().removeWishes();
                    Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                  }), useSafeArea: false);
                }else {
                  //   Get.find<WishListController>().removeWishes();
                  Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                }
              }),
            ],
          ),
        ),
      );

    });
  }
}
