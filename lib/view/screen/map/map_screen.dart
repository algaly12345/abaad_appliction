import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/screen/map/widget/zone_sheet.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abaad/util/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget/estate_details_sheet.dart';

class MapScreen extends StatefulWidget {
  ZoneModel mainCategory;
   MapScreen({Key key,@required this.mainCategory}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    Get.find<AuthController>().getZoneList();
    if(Get.find<EstateController>().estateModel == null) {
      Get.find<EstateController>().getEstateList(1, false);
    }
    Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
  }

  @override
  State<MapScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapScreen> {
  GoogleMapController _controller;
  List<MarkerData> _customMarkers = [];

  List<MarkerData> _customMarkersZone = [];
  int _reload = 0;
  Set<Polygon> _polygon = HashSet<Polygon>();
  int visable=0;


  @override
  void initState() {
    super.initState();
    MapScreen.loadData(false);
    print("awad zone${widget.mainCategory.name}");
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
  get borderRadius => BorderRadius.circular(8.0);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(child: Column(
          children: const [
            Text("المدينة", textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
            Text("حي احد شارع 71", textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
          ],
        )),
        leading: GestureDetector(
          onTap: () {

          },
          child: const Icon(
            Icons.menu,
            color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.all(7),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.notifications_active,
                  color: Colors.blue,
                ),
              )
          ),
        ],
      ),


      body: GetBuilder<EstateController>(builder: (restController) {
        return restController.estateModel != null ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkers,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
                      26.451363,
                      50.109046
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
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
                initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
                  // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                  // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                    26.451363,
                    50.109046
                )),
                markers: markers,
                myLocationEnabled: false,
                compassEnabled: false,
                zoomControlsEnabled: true,
                onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
                minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                  if(restController.estateModel != null ) {
                    _setMarkers(restController.estateModel.estates);
                  }
                },
              ),

              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 7.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: <Widget>[
                            Row(
                              children: [
                                _textField(
                                    label: 'search',
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.my_location,color: Colors.blue),
                                      onPressed: () {
                                        showCustomSnackBar("message");
                                      },
                                    ),
                                    width: width,
                                    locationCallback: (String value) {
                                      setState(() {
                                      });
                                    }),
                                Container(
                                  margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue,
                                      )),


                                  child: const Icon(Icons.qr_code, size: 25 ,   color: Colors.blue,),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(9),
                                  margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      )),


                                  child: const Icon(Icons.filter_list_alt, size: 25 ,   color: Colors.white,),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          heroTag: 'recenterr',
                          onPressed: () {

                          },
                          child: Icon(
                            Icons.content_cut,
                            color: Colors.grey,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFECEDF1))),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          heroTag: 'recenterr',
                          onPressed: () {

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Color(0xFFECEDF1))),
                          child: const Icon(
                            Icons.layers_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        padding: EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          heroTag: 'recenterr',
                          onPressed: () {

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Color(0xFFECEDF1))),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
          },
        ) : Center(child: CircularProgressIndicator());
      }),
    );
  }
  void _setMarkers(List<Estate> estate) async {
    List<LatLng> _latLngs = [];
    _customMarkers = [];
    _customMarkers.add(MarkerData(
      marker: const Marker(markerId: MarkerId('id-0'), position: LatLng(
        // double.parse(Get.find<LocationController>().getUserAddress().latitude),
        // double.parse(Get.find<LocationController>().getUserAddress().longitude),
          26.451363,
          50.109046
      )),
      child: Image.asset(Images.estate_default, height: 32, width: 20),
    ));
    int _index = 0;
    for(int index=0; index<estate.length; index++) {
      _index++;
      LatLng _latLng = LatLng(double.parse(estate[index].latitude), double.parse(estate[index].longitude));
      _latLngs.add(_latLng);

      _customMarkers.add(MarkerData(
        marker: Marker(markerId: MarkerId('id-$_index'), position: _latLng, onTap: () {
          Get.find<SplashController>().setNearestEstateIndex(index);
        }),
        child: Image.asset(Images.estate_default, height: 32, width: 20),
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
  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.7,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }}

