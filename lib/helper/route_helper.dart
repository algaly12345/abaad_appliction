
import 'dart:convert';

import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/view/base/not_found.dart';
import 'package:abaad/view/screen/auth/sign_in_screen.dart';
import 'package:abaad/view/screen/auth/sign_up_screen.dart';
import 'package:abaad/view/screen/auth/verification_screen.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:abaad/view/screen/language/language_screen.dart';
import 'package:abaad/view/screen/locationlocation/access_location_screen.dart';
import 'package:abaad/view/screen/locationlocation/pick_map_screen.dart';
import 'package:abaad/view/screen/onboard/onboarding_screen.dart';
import 'package:abaad/view/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get.dart';


class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String onBoarding = '/on-boarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String verification = '/verification';
  static const String accessLocation = '/access-location';
  static const String update = '/update';
  static const String pickMap = '/pick-map';
  static const String interest = '/interest';
  static const String main = '/main';










  static String getInitialRoute() => '$initial';
  static String getSplashRoute(NotificationBody body) {
    String _data = 'null';
    if(body != null) {
      List<int> _encoded = utf8.encode(jsonEncode(body.toJson()));
      _data = base64Encode(_encoded);
    }
    return '$splash?data=$_data';
  }
  static String getLanguageRoute(String page) => '$language?page=$page';
  static String getOnBoardingRoute() => '$onBoarding';
  static String getSignInRoute(String page) => '$signIn?page=$page';
  static String getSignUpRoute() => '$signUp';
  static String getVerificationRoute(String number, String token, String page, String pass) {
    return '$verification?page=$page&number=$number&token=$token&pass=$pass';
  }
  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';



  static List<GetPage> routes = [
    //GetPage(name: initial, page: () => getRoute(DashboardScreen(pageIndex: 0))),
    GetPage(name: splash, page: () {
      NotificationBody _data;
      if(Get.parameters['data'] != 'null') {
        List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
        _data = NotificationBody.fromJson(jsonDecode(utf8.decode(_decode)));
      }
      return SplashScreen(body: _data);
    }),
    GetPage(name: language, page: () => ChooseLanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: onBoarding, page: () => OnBoardingScreen()),
    GetPage(name: signIn, page: () => SignInScreen(
      exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash || Get.parameters['page'] == onBoarding,
    )),
    GetPage(name: signUp, page: () => SignUpScreen()),
    GetPage(name: verification, page: () {
      List<int> _decode = base64Decode(Get.parameters['pass'].replaceAll(' ', '+'));
      String _data = utf8.decode(_decode);
      return VerificationScreen(
        number: Get.parameters['number'], fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'],
        password: _data,
      );
    }),
    GetPage(name: accessLocation, page: () => AccessLocationScreen(
      fromSignUp: Get.parameters['page'] == signUp, fromHome: Get.parameters['page'] == 'home', route: null,
    )),
    GetPage(name: pickMap, page: () {
      PickMapScreen _pickMapScreen = Get.arguments;
      bool _fromAddress = Get.parameters['page'] == 'add-address';
      return (_fromAddress && _pickMapScreen == null) ? NotFound() : _pickMapScreen != null ? _pickMapScreen
          : PickMapScreen(
        fromSignUp: Get.parameters['page'] == signUp, fromAddAddress: _fromAddress, route: Get.parameters['page'],
        canRoute: Get.parameters['route'] == 'true',
      );
    }),
    GetPage(name: main, page: () => getRoute(DashboardScreen(
      pageIndex: Get.parameters['page'] == 'home' ? 0 : Get.parameters['page'] == 'favourite' ? 1
          : Get.parameters['page'] == 'cart' ? 2 : Get.parameters['page'] == 'order' ? 3 : Get.parameters['page'] == 'menu' ? 4 : 0,
    ))),
  ];


  static String getUpdateRoute(bool isUpdate) => '$update?update=${isUpdate.toString()}';


  static getRoute(Widget navigateTo) {
    int _minimumVersion = 0;
    if(GetPlatform.isAndroid) {
      _minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    }else if(GetPlatform.isIOS) {
      _minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionIos;
    }
    // return AppConstants.APP_VERSION < _minimumVersion ? UpdateScreen(isUpdate: true)
    //     : Get.find<SplashController>().configModel.maintenanceMode ? UpdateScreen(isUpdate: false)
    //     : Get.find<LocationController>().getUserAddress() != null ? navigateTo
    //     : AccessLocationScreen(fromSignUp: false, fromHome: false, route: Get.currentRoute);
  }
}