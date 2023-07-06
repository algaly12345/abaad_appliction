import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/no_internet_screen.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:abaad/view/screen/estate/estate_details.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody body;
  SplashScreen({@required this.body});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;
  Timer _timer;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    if(Get.find<LocationController>().getUserAddress() != null && (Get.find<LocationController>().getUserAddress().zoneIds == null
        || Get.find<LocationController>().getUserAddress().zoneData == null)) {
      Get.find<AuthController>().clearSharedAddress();
    }
  // Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(Duration(seconds: 1), () async {
          initDynamicLinks();
          double _minimumVersion = 0;
          if(GetPlatform.isAndroid) {
         //   _minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionAndroid;
          }else if(GetPlatform.isIOS) {
          //  _minimumVersion = Get.find<SplashController>().configModel.appMinimumVersionIos;
          }
          if(AppConstants.APP_VERSION < _minimumVersion || Get.find<SplashController>().configModel.maintenanceMode) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.APP_VERSION < _minimumVersion));
          }else {
            if(widget.body != null) {
              if (widget.body.notificationType == NotificationType.order) {

              }else if(widget.body.notificationType == NotificationType.general){
                Get.offNamed(RouteHelper.getNotificationRoute());
              }else {
                Get.offNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationID: widget.body.conversationId));
              }
            }else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
             //   await Get.find<WishListController>().getWishList();
                if (Get.find<LocationController>().getUserAddress() != null) {
                  Get.offNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                if (Get.find<SplashController>().showIntro()) {
                  if(AppConstants.languages.length > 1) {
                    Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                  }else {
                    Get.offNamed(RouteHelper.getOnBoardingRoute());
                  }
                } else {
                  Get.offNamed(RouteHelper.getInitialRoute());
                 // Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Image.asset(Images.background).color,

      body: GetBuilder<SplashController>(builder: (splashController) {
        return Container(
          decoration:  BoxDecoration(
              image:  DecorationImage(
                image:  AssetImage(Images.background),
                fit: BoxFit.fill,
              )
          ),
          child: Center(

            child: splashController.hasConnection ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(Images.logo_an, width: 150),
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                Text("abaad".tr, style: robotoMedium.copyWith(fontSize: 25,color: Theme.of(context).primaryColor)),
                Text("optimal_real_estate_marketing".tr, style: robotoMedium.copyWith(fontSize: 25,color: Theme.of(context).primaryColor)),
                // Container(
                //
                //   child: ColorizeAnimatedTextKit(
                //     onTap: () {
                //       print("Tap Event");
                //     },
                //     text:  [
                //       "abaad".tr,
                //       'optimal_real_estate_marketing'.tr,
                //     ],
                //     textStyle: const TextStyle(
                //         fontSize: 40.0,
                //         fontFamily: "Horizon",
                //     ),
                //     alignment: Alignment.center,
                //     colors: const [
                //       Colors.blueGrey,
                //       Colors.blue,
                //     ],
                //   ),
                // ),

                /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),*/
              ],
            ) : NoInternetScreen(child: SplashScreen(body: widget.body)),
          ),
        );
      }),
    );
  }


  void initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink)async{
          final Uri deeplink = dynamicLink.link;

          if(deeplink != null){
            handleMyLink(deeplink);
          }
        },
        onError: (OnLinkErrorException e)async{
          print("We got error $e");

        }

    );
  }



  void handleMyLink(Uri url){
    List<String> sepeatedLink = [];
    /// osama.link.page/Hellow --> osama.link.page and Hellow
    sepeatedLink.addAll(url.path.split('/'));

    print("The Token that i'm interesed in is ${sepeatedLink[1]}");
    Get.find<EstateController>().getEstateDetails(Estate(id:  int.parse(sepeatedLink[1])));
    Get.toNamed(RouteHelper.getDetailsRoute(  int.parse(sepeatedLink[1])));

  }



}