import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/image_view_dialog.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class FeatureScreen extends StatefulWidget {
  final featureId;
  final Estate estate;
  String path ;
   FeatureScreen({@required this.featureId,this.estate,this.path});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  //String selectedUrl;
  double value = 0.0;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  String selectedUrl;
  bool _isLoading = true;
  PullToRefreshController pullToRefreshController;
  MyInAppBrowser browser;

  StreetViewController streetViewController;
  VideoPlayerController _controller1;
  VideoPlayerController _controller2;
  




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id:widget.estate.id));
   // selectedUrl = '${AppConstants.BASE_URL}/payment-mobile/pyment?order_id=${widget.orderModel.id}&customer_id=${widget.orderModel.userId}';


    _controller1=VideoPlayerController.network("${ Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/skey3.mp4")
      ..initialize().then((_){
        setState(() {

        });
      });

    _controller2=VideoPlayerController.network("${ Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/vedio5.mp4")
      ..initialize().then((_){
        setState(() {

        });
      });
    if(widget.featureId=="فبديو"){
      _controller1.value.isPlaying?_controller1.pause():_controller1.play();
    }else if(widget.featureId=="منظور جوي"){
      _controller2.value.isPlaying?_controller2.pause():_controller2.play();
    }
    else if(widget.featureId=="تجوال افتراضي"){
      selectedUrl =widget.path;
      _initData();
    }

  }


  void _initData() async {
    browser = MyInAppBrowser();

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      bool swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(AndroidServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            print(request);
            return null;
          },
        ));
      }
    }

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(urlRequest: URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );
    browser.pullToRefreshController = pullToRefreshController;

    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(selectedUrl)),
      options: InAppBrowserClassOptions(
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, useOnLoadResource: true)),
        crossPlatform: InAppBrowserOptions(hideUrlBar: true, hideToolbarTop: GetPlatform.isAndroid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.featureId=="صور" ? 'صور'.tr :widget.featureId=="تجوال افتراضي"?"تجوال افتراضي":widget.featureId=="منظور الشارع"?"عرض الشارع":widget.featureId=="المخطط"?"المخطط":widget.featureId=="فبديو"?"فبديو":widget.featureId=="منظور جوي"?"منظور جوي":""),
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
                    _isLoading ? Center(
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                    ) : SizedBox.shrink(),
                  ],
                ),
              ),
            ):widget.featureId=="منظور الشارع"?SafeArea(
              child: Center(
                child: FlutterGoogleStreetView(
                    initPos:LatLng(double.parse(estateController.estate.latitude),double.parse(estateController.estate.longitude)),
                    onStreetViewCreated: (StreetViewController controller) async {
                      //save controller for late using
                      streetViewController = controller;
                      //change position by controller
                      controller.setPosition(position:LatLng(double.parse(estateController.estate.latitude),double.parse(estateController.estate.longitude)));
                    }
                ),
              ),
            ):widget.featureId=="المخطط"?Container(
              width: Dimensions.WEB_MAX_WIDTH,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),



                Expanded(
                  child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: estateController.estate.planned.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                      childAspectRatio: (1/0.80),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.dialog(ImageViewDiloag(estate:estateController.estate));
                        },
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
                                image: '$_baseUrl/${estateController.estate.planned[index]}',
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
            ):widget.featureId=="فبديو"?Container(
              child: Center(
                child: Container(
                  child:_controller1.value.isInitialized? VideoPlayer(_controller1):Container(),
                ),
              ),
            ):widget.featureId=="منظور جوي"? Container(
          child: Center(
          child: Container(
              child:_controller2.value.isInitialized? VideoPlayer(_controller2):Container(),
          ),
          ),
          ):Container(),
          ) : NoDataScreen(text: 'no_category_found'.tr) : Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }



}












class MyInAppBrowser extends InAppBrowser {

  MyInAppBrowser({ int windowId, UnmodifiableListView<UserScript> initialUserScripts})
      : super(windowId: windowId, initialUserScripts: initialUserScripts);

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    print("\n\nStarted: $url\n\n");
    //_redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped: $url\n\n");
   // _redirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    print("Can't load [$url] Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    print("Progress: $progress");
  }

  @override
  void onExit() {
    if(_canRedirect) {
    //  Get.back();
    }
    print("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {
    print("Started at: " + response.startTime.toString() + "ms ---> duration: " + response.duration.toString() + "ms " + (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
  }
  //
  // void _redirect(String url) {
  //   if(_canRedirect) {
  //
  //       _canRedirect = false;
  //       close();
  //     }
  //
  //   }
 }
