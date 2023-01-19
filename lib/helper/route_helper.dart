
import 'dart:convert';

import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/view/screen/auth/sign_in_screen.dart';
import 'package:abaad/view/screen/auth/sign_up_screen.dart';
import 'package:abaad/view/screen/auth/verification_screen.dart';
import 'package:abaad/view/screen/language/language_screen.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:abaad/view/screen/map/map_screen.dart';
import 'package:abaad/view/screen/onboard/old/onboarding_screen.dart';
import 'package:abaad/view/screen/onboard/on_boarding_page.dart';
import 'package:abaad/view/screen/splash/splash_screen.dart';
import 'package:abaad/view/screen/test.dart';
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
  static const String profile = '/profile';
  static const String mapView = '/map-view';




  static String getProfileRoute() => '$profile';
  static String getInitialRoute() => '$initial';
  static String getMapViewRoute() => '$mapView';
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
    // GetPage(name: initial, page: () => getRoute(DashboardScreen(pageIndex: 0))),
    GetPage(name: splash, page: () {
      NotificationBody _data;
      if(Get.parameters['data'] != 'null') {
        List<int> _decode = base64Decode(Get.parameters['data'].replaceAll(' ', '+'));
        _data = NotificationBody.fromJson(jsonDecode(utf8.decode(_decode)));
      }
      return SplashScreen(body: _data);
    }),
    GetPage(name: language, page: () => ChooseLanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),

    GetPage(name: onBoarding, page: () => OnboardingScreen()),
    GetPage(name: mapView, page: () => getRoute(MapScreen())),

    GetPage(name: signIn, page: () => SignInScreen(
      exitFromApp: Get.parameters['page'] == signUp || Get.parameters['page'] == splash || Get.parameters['page'] == onBoarding
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
    GetPage(name: accessLocation, page: () => DashboardScreen(
      fromSignUp: Get.parameters['page'] == signUp, fromHome: Get.parameters['page'] == 'home', route: null,pageIndex: 0,
    )),


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