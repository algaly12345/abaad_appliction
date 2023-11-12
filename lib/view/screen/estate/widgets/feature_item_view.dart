import 'dart:async';
import 'dart:math';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/image_view_dialog.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/screen/estate/web_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_street_view/flutter_google_street_view.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'video_view.dart';
class FeatureScreen extends StatefulWidget {
  final featureId;
  final Estate estate;
  String path ;
  String pathVideo;
  FeatureScreen({@required this.featureId,this.estate,this.path,this.pathVideo});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  //String selectedUrl;
  double value = 0.0;

  VideoPlayerController _controller;
  String selectedUrl;
  WebViewController controllerGlobal;
  bool _isLoading = true;
  PullToRefreshController pullToRefreshController;

  StreetViewController streetViewController;
  VideoPlayerController _controller1;
  VideoPlayerController _controller2;

  bool streetViewAvailable = true;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id:widget.estate.id));
   // selectedUrl = '${AppConstants.BASE_URL}/payment-mobile/pyment?order_id=${widget.orderModel.id}&customer_id=${widget.orderModel.userId}';

     print("-------------------------------${widget.featureId}");
    _controller1=VideoPlayerController.network("${ Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/skey3.mp4")
      ..initialize().then((_){
        setState(() {

        });
      });

    _controller2=VideoPlayerController.network("${ Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/vedio5.mp41")
      ..initialize().then((_){
        setState(() {

        });
      });
    _controller = VideoPlayerController.network(
      '${AppConstants.BASE_URL}/storage/app/public/videos/${widget.pathVideo}',
    )..initialize().then((_) {
      setState(() {});
    });
    if(widget.featureId=="6"){

    }else if(widget.featureId=="5"){
      _controller2.value.isPlaying?_controller2.pause():_controller2.play();
    }
    else if(widget.featureId=="2"){

      _initData();
    }



    print("-----------------------------${widget.pathVideo}");




  }


  void _initData() async {

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



  }





  Future<bool> isStreetViewAvailable(double latitude, double longitude) async {
    final apiKey = 'AIzaSyCQD6nS0Jb0KzzGTts-uLXahVh7o4taUPY'; // Replace with your Google Maps API key
    final url = 'https://maps.googleapis.com/maps/api/streetview/metadata?location=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // If Street View metadata is available, Street View is likely available
      return true;
    } else {

      showCustomSnackBar("not aviale");
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
      if(widget.featureId=="6") {
        _controller.pause();
      }
        return true;
      },
      child: Scaffold(
        appBar: CustomAppBar(title: widget.featureId=="1" ? 'images'.tr :widget.featureId=="2"?"virtual_ture".tr:widget.featureId=="3"?"street_view".tr:widget.featureId=="4"?"planned".tr:widget.featureId=="6"?"video".tr:widget.featureId=="5"?"sky_view".tr:""),
        body: SafeArea(
          child:  GetBuilder<EstateController>(builder: (estateController) {
            return !estateController.isLoading    ? Center(
              child:  widget.featureId=="1" ? Container(
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
              ):widget.featureId=="2"?Center(
                child: Container(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child:WebViewScreen(  url: widget.path),
                ),
              ):widget.featureId=="3"?Column(
                children: [
                  Get.find<AuthController>().isLoggedIn() ?    Expanded(
                    child: streetViewAvailable
                        ?  FlutterGoogleStreetView(
              initSource: StreetViewSource.outdoor,
                  // initBearing: 30,
                  zoomGesturesEnabled: false,
                  initPos:LatLng(double.parse(widget.estate.latitude),double.parse(widget.estate.longitude)),
                  onStreetViewCreated: (StreetViewController controller) async {
                    //save controller for late using
                    streetViewController = controller;
                    controller.animateTo(
                        duration: 3000,
                        camera: StreetViewPanoramaCamera(
                            bearing: 200, tilt: 3));


                    //change position by controller
                    controller.setPosition(position:LatLng(double.parse(widget.estate.latitude),double.parse(widget.estate.longitude)));
                  }
              )

                        : Center(
                      child: Text(
                        "Street View is not available for this location.",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ): NotLoggedInScreen(),
                ],
              ):widget.featureId=="4"?Container(
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
              ):widget.featureId=="6"?Container(
                child: Center(
                  child: widget.pathVideo == ""||widget.pathVideo ==null
                    ? NoDataScreen(
                    text: 'no_data_available',
                  )// Display a message when video path is null
                      : _controller.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                      : CircularProgressIndicator(),
                )
              ):widget.featureId=="5"? Container(
            child:Center(
              child: widget.pathVideo == ""
                  ? NoDataScreen(
                text: 'no_data_available',
              ) // Display a message when video path is null
                  : _controller.value.isInitialized
                  ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
                  : CircularProgressIndicator(),
            ),
            ):NoDataScreen(
              text: 'no_data_available',
            ),
            )  : Center(child: CircularProgressIndicator());
          }),
        ),
        floatingActionButton: widget.featureId=="6"?Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                });
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
            SizedBox(height: 16),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  }
                  _controller.seekTo(Duration.zero);
                });
              },
              child: Icon(Icons.stop),
            ),


          ],
        ):Container(),
      ),
    );
  }



}












