import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/config_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abaad/util/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'widget/estate_details_sheet.dart';
class MapScreen extends StatefulWidget {
  const MapScreen({Key key}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    Get.find<CategoryController>().getCategoryList(false);
    Get.find<AuthController>().getZoneList();
    // Get.find<EstateController>().getRestaurantList(1, false);
    if(Get.find<EstateController>().estateModel == null) {
      Get.find<EstateController>().getEstateList(1, false);
    }
    // Get.find<SplashController>().setNearestRestaurantIndex(-1, notify: false);
  }

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController _controller;
  List<MarkerData> _customMarkers = [];
  int _reload = 0;

  @override
  void initState() {
    super.initState();

    if(Get.find<EstateController>().estateModel == null) {
      Get.find<EstateController>().getEstateList(1, false);
    }
    Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
  }

  @override
  void dispose() {
    super.dispose();

    _controller?.dispose();
  }

  Widget _customMarker(String path) {
    return Stack(
      children: [
        Image.asset(Images.mail, height: 40, width: 40),
        Positioned(top: 3, left: 0, right: 0, child: Center(
          child: ClipOval(child: CustomImage(image: path, placeholder: Images.mail, height: 20, width: 20, fit: BoxFit.cover)),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'nearby_restaurants'.tr),
      body: GetBuilder<EstateController>(builder: (restController) {
        return restController.estateModel != null ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkers,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                      26.451363,
                      50.109046
                  )),
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
                  minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController controller) {

                  },
                ),

                GetBuilder<SplashController>(builder: (splashController) {
                  return splashController.nearestRestaurantIndex != -1 ? Positioned(
                    bottom: 0,
                    child: RestaurantDetailsSheet(callback: (int index) => _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                      double.parse(restController.estateModel.estates[index].latitude),
                      double.parse(restController.estateModel.estates[index].longitude),
                    ), zoom: 16)))),
                  ) : SizedBox();
                }),

              ]);
            }
            return Stack(children: [

              GoogleMap(
                initialCameraPosition: CameraPosition(zoom: 12, target: LatLng(
                    26.451363,
                    50.109046


                  // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                  // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                )),
                markers: markers,
                myLocationEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: true,
                onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
                minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  if(restController.estateModel != null && restController.estateModel.estates.isNotEmpty) {
                    _setMarkers(restController.estateModel.estates);
                  }
                },
              ),

              GetBuilder<SplashController>(builder: (splashController) {
                return splashController.nearestRestaurantIndex != -1 ? Positioned(
                  bottom: 0,
                  child: Container(),
                  // RestaurantDetailsSheet(callback: (int index) => _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                  //   double.parse(restController.restaurantModel.restaurants[index].latitude),
                  //   double.parse(restController.restaurantModel.restaurants[index].longitude),
                  // ), zoom: 16)))),
                ) : SizedBox();
              }),

            ]);
          },
        ) : Center(child: CircularProgressIndicator());
      }),
    );
  }

  void _setMarkers(List<Estate> restaurants) async {
    List<LatLng> _latLngs = [];
    _customMarkers = [];
    _customMarkers.add(MarkerData(
      // marker: Marker(markerId: MarkerId('id-0'), position: LatLng(
      //   double.parse(Get.find<LocationController>().getUserAddress().latitude),
      //   double.parse(Get.find<LocationController>().getUserAddress().longitude),
      // )),
      child: Image.asset(Images.mail, height: 20, width: 20),
    ));
    int _index = 0;
    for(int index=0; index<restaurants.length; index++) {
      _index++;
      LatLng _latLng = LatLng(double.parse(restaurants[index].latitude), double.parse(restaurants[index].longitude));
      _latLngs.add(_latLng);

      _customMarkers.add(MarkerData(
        marker: Marker(markerId: MarkerId('id-$_index'), position: _latLng, onTap: () {
          Get.find<SplashController>().setNearestEstateIndex(index);

        }),
        child:Container(),


       //_customMarker('${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${restaurants[index].images}'),
      ));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(Duration(milliseconds: 500));
    if(_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(Duration(seconds: 3));
    if(_reload == 1) {
      setState(() {});
      _reload = 2;
    }
  }

}

