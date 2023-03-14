import 'dart:async';

import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class FeatureScreen extends StatefulWidget {
  final featureId;
  final Estate estate;
  const FeatureScreen({@required this.featureId,this.estate});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  //String selectedUrl;
  double value = 0.0;
  bool _canRedirect = true;
  bool _isLoading = true;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController controllerGlobal;
  StreetViewController streetViewController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id:widget.estate.id));
   // selectedUrl = '${AppConstants.BASE_URL}/payment-mobile/pyment?order_id=${widget.orderModel.id}&customer_id=${widget.orderModel.userId}';



    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.featureId=="صور" ? 'صور'.tr :widget.featureId=="تجوال افتراضي"?"تجوال افتراضي":widget.featureId=="عرض الشارع"?"عرض الشارع":widget.featureId=="المخطط"?"المخطط":""),
      body: SafeArea(
        child:  GetBuilder<EstateController>(builder: (estateController) {
          return !estateController.isLoading   ? estateController.estate.images.length > 0 ? Center(
            child:  widget.featureId=="صور" ? Container(
              width: Dimensions.WEB_MAX_WIDTH,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),



                Expanded(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: estateController.estate.images.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                      childAspectRatio: (1/0.80),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child:   Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            child: GetBuilder<SplashController>(builder: (splashController) {
                              String _baseUrl = Get.find<SplashController>().configModel.baseUrls.estateImageUrl;
                              return CustomImage(
                                image: '$_baseUrl/${estateController.estate.images[index]}',
                                fit: BoxFit.cover,
                              );
                            },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),



              ]),
            ):widget.featureId=="تجوال افتراضي"?Center(
              child: Container(
                width: Dimensions.WEB_MAX_WIDTH,
                child: Stack(
                  children: [
                    WebView(

                      javascriptMode: JavascriptMode.unrestricted,
                      initialUrl: estateController.estate.arPath,
                      zoomEnabled: false,
                      gestureNavigationEnabled: true,
                      userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.future.then((value) => controllerGlobal = value);
                        _controller.complete(webViewController);
                      },
                      onPageStarted: (String url) {
                        print('Page started loading: $url');
                        setState(() {
                          _isLoading = true;
                        });
                    //    _redirect(url);
                      },
                      onPageFinished: (String url) {
                        print('Page finished loading: $url');
                        setState(() {
                          _isLoading = false;
                        });
                       // _redirect(url);
                      },
                    ),
                    _isLoading ? Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ):widget.featureId=="عرض الشارع"?SafeArea(
              child: Center(
                child: FlutterGoogleStreetView(
                    initPos:LatLng(26.2804875,50.1838648),
                    onStreetViewCreated: (StreetViewController controller) async {
                      //save controller for late using
                      streetViewController = controller;
                      //change position by controller
                      controller.setPosition(position:LatLng(26.2804875,50.1838648));
                    }
                ),
              ),
            ):widget.featureId=="المخطط"?ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              child: GetBuilder<SplashController>(builder: (splashController) {
                String _baseUrl = Get.find<SplashController>().configModel.baseUrls.estateImageUrl;
                return CustomImage(
                  image: '$_baseUrl/${estateController.estate.planned}',
                  fit: BoxFit.cover,
                );
              },
              ),
            ):Container(),
          ) : NoDataScreen(text: 'no_category_found'.tr) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }


}
