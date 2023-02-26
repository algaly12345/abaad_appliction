import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/profile/widget/profile_button.dart';
import 'package:abaad/view/screen/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../util/images.dart';
import 'widget/profile_bg_widget.dart';
import 'widget/profile_button_mode.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
     _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:  CustomAppBar(title: 'profile'.tr),
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) : ProfileBgWidget(
          backButton: true,
          circularImage: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.topRight,
                  child: ClipOval(child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                        '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                    height: 100, width: 100, fit: BoxFit.cover,
                  )),
                ),
              ),

              Container(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    Text(
                      _isLoggedIn ? '${userController.userInfoModel.name}' : 'guest'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                    ),

                    // Text(
                    //   _isLoggedIn&& userController.userInfoModel.userinfo.membershipType==null? '${userController.userInfoModel.userinfo.membershipType}' : 'guest'.tr,
                    //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: Center(child: Container(

            width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: Column(children: [


              SizedBox(height: 10),

              _isLoggedIn ? Column(children: [


                Row(children: [
                  ProfileCard(title: 'setting_profile'.tr, image: Images.setting_profile),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  ProfileCard(title: 'wallet'.tr, image: Images.property_profile),
                ]),
              ]) : SizedBox(),
              SizedBox(height: _isLoggedIn ? 30 : 0),
              ProfileButton(icon: Icons.language, title: 'language'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              ProfileButtonMode(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),

              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              ProfileButton(icon: Icons.generating_tokens, title: 'your_rating'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),




              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              ProfileButton(icon: Icons.supervised_user_circle_outlined, title: 'membership_modification'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.toNamed(RouteHelper.getAgentRegister());
              }),


              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              ProfileButton(icon: Icons.subscriptions_outlined, title: 'subscribe_type'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              ProfileButton(icon: Icons.share, title: 'share_app'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              // _isLoggedIn ? GetBuilder<AuthController>(builder: (authController) {
              //   return ProfileButton(
              //     icon: Icons.notifications, title: 'notification'.tr,
              //     isButtonActive: authController.notification, onTap: () {
              //     authController.setNotificationActive(!authController.notification);
              //   },
              //   );
              // }) : SizedBox(),
              // SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : 0),
              //

              ProfileButton(icon: Icons.edit, title: 'edit_profile'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }),

              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_SMALL : Dimensions.PADDING_SIZE_LARGE),

              ProfileButton(icon: Icons.list_alt, title: 'terms_conditions'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              // _isLoggedIn ? ProfileButton(
              //   icon: Icons.delete, title: 'delete_account'.tr,
              //   onTap: () {
              //     // Get.dialog(ConfirmationDialog(icon: Images.support,
              //     //   title: 'are_you_sure_to_delete_account'.tr,
              //     //   description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
              //     //   onYesPressed: () => userController.removeUser(),
              //     // ), useSafeArea: false);
              //   },
              // ) : SizedBox(),
              SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_LARGE : 0),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}
