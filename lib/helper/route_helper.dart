
import 'dart:convert';

import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/util/html_type.dart';
import 'package:abaad/view/base/custom_dialog_box.dart';
import 'package:abaad/view/base/not_found.dart';
import 'package:abaad/view/screen/agent/agent_profile_screen.dart';
import 'package:abaad/view/screen/auth/agent_registration_screen.dart';
import 'package:abaad/view/screen/auth/sign_in_screen.dart';
import 'package:abaad/view/screen/auth/sign_up_screen.dart';
import 'package:abaad/view/screen/auth/verification_screen.dart';
import 'package:abaad/view/screen/chat/chat_screen.dart';
import 'package:abaad/view/screen/chat/conversation_screen.dart';
import 'package:abaad/view/screen/estate/UploadScreen.dart';
import 'package:abaad/view/screen/estate/ad_license_screen.dart';
import 'package:abaad/view/screen/estate/add_estate_screen.dart';
import 'package:abaad/view/screen/estate/confiram_screen.dart';
import 'package:abaad/view/screen/estate/business_plan/business_plan.dart';
import 'package:abaad/view/screen/estate/estate_details.dart';
import 'package:abaad/view/screen/estate/success_screen2.dart';
import 'package:abaad/view/screen/estate/web_view_screen.dart';
import 'package:abaad/view/screen/estate/widgets/feature_item_view.dart';
import 'package:abaad/view/screen/html/html_viewer_screen.dart';
import 'package:abaad/view/screen/language/language_screen.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:abaad/view/screen/map/map_screen.dart';
import 'package:abaad/view/screen/map/pick_map_screen.dart';
import 'package:abaad/view/screen/notification/notification_screen.dart';
import 'package:abaad/view/screen/onboard/on_boarding_page.dart';
import 'package:abaad/view/screen/profile/edit_dilog.dart';
import 'package:abaad/view/screen/profile/profile_screen.dart';
import 'package:abaad/view/screen/profile/update_profile_screen.dart';
import 'package:abaad/view/screen/splash/splash_screen.dart';
import 'package:abaad/view/screen/support/support_screen.dart';
import 'package:abaad/view/screen/update/update_screen.dart';
import 'package:abaad/view/screen/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screen/estate/success_screen.dart';
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
  static const String updateProfile = '/update-profile';
  static const String categories = '/categories';
  static const String notification = '/notification';
  static const String estate = '/estate';
  static const String addEstate = '/add-estate';
  static const String addEstateTow = '/add-estate-tow';
  static const String agent = '/agent';
  static const String businessPlan = '/business-plan';
  static const String success = '/success';
  static const String messages = '/messages';
  static const String conversation = '/conversation';
  static const String wallet = '/wallet';
  static const String feature = '/feature';
  static const String marketer = '/profile-agent';
  static const String html = '/html';
  static const String webview = '/webview';
  static const String support = '/help-and-support';
  static const String payment = '/payment';


  static const String upload_screen = '/upload_screen';



  static const String sucess2 = '/success';

  static const String addLicense = '/add-license';

  static const String editEstate = '/edite-estate';





  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getProfileRoute() => '$profile';
  static String getInitialRoute() => '$initial';
  static String getCategoryRoute(int id ,String  longitude,String latitude ) => '$categories?id=$id&latitude=$latitude&longitude=$longitude';
  static String getNotificationRoute() => '$notification';
  static String getUpdateProfileRoute() => '$updateProfile';
  static String getConversationRoute(int id) => '$conversation';
  static String getWalletRoute(bool fromWallet) => '$wallet?page=${fromWallet ? 'wallet' : 'loyalty_points'}';
  static String getPickMapRoute(String page, bool canRoute) => '$pickMap?page=$page&route=${canRoute.toString()}';
  static String getSupportRoute() => '$support';
  static String getSuccess() => '$success';
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
  static String getDetailsRoute(int id) => '$estate?id=$id';
  // static String getWebViewRoute(String ar_path) => 'ar_path=$webview';
  static String getWebViewRoute(String page) => '$webview?url=$page';
  static String getFeatureRoute(int id,String  featureId ,String path,String video_path, String latitude, String longitude ,String sky_view) => '$feature?id=$id&feature_id=$featureId&path=$path&path_video=$video_path&latitude=$latitude&longitude=$longitude&sky_view=$sky_view';

  static String getAccessLocationRoute(String page) => '$accessLocation?page=$page';
  static String getAddEstateRoute() => '$addEstate';
  static String getAddLicenseRoute() => '$addLicense';
  static String getAddEstateRouteTow() => '$addEstateTow';
  static String getAgentRegister() => '$agent';
  static String getBusinessPlanRoute(int restaurantId) => '$businessPlan?id=$restaurantId';

  static String getPaymentRoute(int id) => '$payment?id=$id';


  static String getUploadRoute(int id) => '$upload_screen?id=$id';



  static String getSuccesstRoute(int id) => '$sucess2?id=$id';

  static String getEditEstatRoute(Estate estate) {
    String data = base64Url.encode(utf8.encode(jsonEncode(estate.toJson())));
    return '$editEstate?item=$data';
  }




  static String getChatRoute({required NotificationBody notificationBody, Userinfo user, int conversationID, int index,int estate_id,String link, Estate estate,}) {
    String _notificationBody = 'null';
    if(notificationBody != null) {
      _notificationBody = base64Encode(utf8.encode(jsonEncode(notificationBody.toJson())));
    }
    String _user = 'null';
    if(user != null) {
      _user = base64Encode(utf8.encode(jsonEncode(user.toJson())));
    }


    String _estate = 'null';
    if(estate != null) {
      _estate = base64Encode(utf8.encode(jsonEncode(estate.toJson())));
    }
    return '$messages?notification=$_notificationBody&user=$_user&conversation_id=$conversationID&index=$index&estate_id=$estate_id&link=$link&estate=$_estate';
  }
  static String getProfileAgentRoute(int id,int isMyProfile) => '$marketer?id=$id&isMyProfile=$isMyProfile';
  static List<GetPage> routes = [
     GetPage(name: initial, page: () => DashboardScreen(pageIndex: 0)),
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
    GetPage(name: addEstate, page: () => AddEstateScreen()),

    GetPage(name: addLicense, page: () => AdLicenseScreen()),
    GetPage(name: addEstateTow, page: () => AddEstateScreenTow()),

    GetPage(name: agent, page: () => AgentRegistrationScreen()),
    GetPage(name: success, page: () => ScreenSuccess()),
    GetPage(name: wallet, page: () => WalletScreen(fromWallet: Get.parameters['page'] == 'wallet')),

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

    GetPage(name: support, page: () => SupportScreen()),
    GetPage(name: notification, page: () =>NotificationScreen()),
    GetPage(name: update, page: () => UpdateScreen(isUpdate: Get.parameters['update'] == 'true')),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: updateProfile, page: () => UpdateProfileScreen()),
    GetPage(name: conversation, page: () => ConversationScreen()),
    GetPage(name: categories, page: () {
      MapScreen _pickMapScreen = Get.arguments;
      bool _fromAddress = Get.parameters['page'] == 'add-address';
      return (_fromAddress && _pickMapScreen == null) ? NotFound() : _pickMapScreen ?? MapScreen(mainCategory:ZoneModel(id: int.parse(Get.parameters['id']),latitude:Get.parameters['latitude'],longitude: Get.parameters['longitude'] ) ,
         fromSignUp: Get.parameters['page'] == signUp, fromAddAddress: _fromAddress, route: Get.parameters['page'],
        canRoute: Get.parameters['route'] == 'true',
      );
    }),
    GetPage(name: html, page: () => HtmlViewerScreen(
      htmlType: Get.parameters['page'] == 'terms-and-condition' ? HtmlType.TERMS_AND_CONDITION
          : Get.parameters['page'] == 'privacy-policy' ? HtmlType.PRIVACY_POLICY
          : Get.parameters['page'] == 'shipping-policy' ? HtmlType.SHIPPING_POLICY
          : Get.parameters['page'] == 'cancellation-policy' ? HtmlType.CANCELLATION_POLICY
          : Get.parameters['page'] == 'refund-policy' ? HtmlType.REFUND_POLICY : HtmlType.ABOUT_US,
    )),
   GetPage(name: webview, page: () => WebViewScreen(url: Get.parameters['url'])),
    GetPage(name: pickMap, page: () {
      PickMapScreen _pickMapScreen = Get.arguments;
      bool _fromAddress = Get.parameters['page'] == 'add-address';
      return (_fromAddress && _pickMapScreen == null) ? NotFound() : _pickMapScreen != null ? _pickMapScreen
          : PickMapScreen(
        fromSignUp: Get.parameters['page'] == signUp, fromAddAddress: _fromAddress, route: Get.parameters['page'],
        canRoute: Get.parameters['route'] == 'true',
      );
    }),
    GetPage(name: messages, page: () {
      NotificationBody _notificationBody;
      if(Get.parameters['notification'] != 'null') {
        _notificationBody = NotificationBody.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['notification'].replaceAll(' ', '+')))));
      }
      Userinfo _user;
      Estate _estate;
      if(Get.parameters['user'] != 'null') {
        _user = Userinfo.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['user'].replaceAll(' ', '+')))));
      }
      return ChatScreen(
        notificationBody: _notificationBody,
        user: _user, index: Get.parameters['index'] != 'null' ? int.parse(Get.parameters['index']) : null,
        conversationID: (Get.parameters['conversation_id'] != null && Get.parameters['conversation_id'] != 'null') ? int.parse(Get.parameters['conversation_id']) : null,
        estate_id:  Get.parameters['estate_id'] != 'null' ?Get.parameters['estate_id']: null ,link:Get.parameters['like'] != 'null' ?Get.parameters['link']: null,estate: _estate, );
    }),
    GetPage(name: estate, page: () {
      return Get.arguments ?? EstateDetails(estate: Estate(id: int.parse(Get.parameters['id'])) ,);
    }),




    GetPage(name: editEstate, page: () => EditDialog(
      estate: Estate.fromJson(jsonDecode(utf8.decode(base64Url.decode(Get.parameters['item'].replaceAll(' ', '+'))))),
    )),

    GetPage(name: feature, page: () {
      return Get.arguments ?? FeatureScreen(estate: Estate(id: int.parse(Get.parameters['id']),latitude:Get.parameters['latitude'],longitude: Get.parameters['longitude']),featureId:Get.parameters['feature_id'],path:Get.parameters['path'] ,pathVideo:Get.parameters['path_video'],skyView: Get.parameters['sky_view'],);
    }),
    GetPage(name: businessPlan, page: () => BusinessPlanScreen(estateId: int.parse(Get.parameters['id']))),
   // GetPage(name: categories, page: () =>MapScreen(mainCategory: ZoneModel(id: int.parse(Get.parameters['id'])))),

    GetPage(name: marketer, page: () {
      return Get.arguments ?? AgentProfileScreen(userInfo: Userinfo(id: int.parse(Get.parameters['id'])) ,isMyProfile:int.parse(Get.parameters['isMyProfile']));
    }),

    GetPage(name: payment, page: () => SuccessScreen(estate_id: int.parse(Get.parameters['id']),)),

    GetPage(name: upload_screen, page: () => UploadScreen(estateId: int.parse(Get.parameters['id']),)),

    GetPage(name: sucess2, page: () => SuccessScreen2(estate_id: int.parse(Get.parameters['id']),)),
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
    //     : Get.find<SplashController>().configModel.maintenanceMode ? UpdateScreen(isUpdate: false));

  }
}