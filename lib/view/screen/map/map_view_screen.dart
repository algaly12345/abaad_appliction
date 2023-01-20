import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/helper/route_helper.dart';
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

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key key}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    Get.find<AuthController>().getZoneList();
    if(Get.find<EstateController>().estateModel == null) {
      Get.find<EstateController>().getEstateList(1, false);
    }
    Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
  }

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController _controller;
 List<MarkerData> _customMarkers = [];
  Timer _timer;

  List<MarkerData> _customMarkersZone = [];
  int _reload = 0;
  Set<Polygon> _polygon = HashSet<Polygon>();
  int visable=0;


  @override
  void initState() {
    super.initState();
    MapViewScreen.loadData(false);
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

      body: GetBuilder<AuthController>(builder: (authController) {

        // print("zone_list${authController.zoneList}");
        List<int> _zoneIndexList = [];
        if(authController.zoneList != null) {
        //  print("zone_list${authController.zoneModel.name}");
          for(int index=0; index<authController.zoneList.length; index++) {
            _zoneIndexList.add(index);
          }
        }
    return authController.zoneList  != null ? CustomGoogleMapMarkerBuilder(
    customMarkers: _customMarkersZone,
    builder: (context, markers) {
      if (markers == null) {

        return Stack(children: [

          GoogleMap(
            initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
                24.263867,
                45.033284
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


        ]);
      }
        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(zoom: 5, target: LatLng(
                // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                  24.263867,
                  45.033284
              )),
              markers: markers,
              myLocationEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: true,
              onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
              minMaxZoomPreference: MinMaxZoomPreference(0, 16),
              polygons: _polygon,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                if(authController.zoneList != null ) {
                 // print("zonelist${authController.zoneList.length}");

                     _setMarkersZone(authController.zoneList);

                 // _setPolygo(authController.zoneList);
                //  _setMarkers(authController.estateModel.estates);
                }
              },
            ),

          ],
        );
    },
    ) : Center(child: CircularProgressIndicator());

  })
      ,




    );
  }


void _setMarkersZone(List<ZoneModel> zone) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<LatLng> _latLngs = [];
  _customMarkersZone = [];
  await prefs.setInt("visible", 0);

  _customMarkersZone.add(MarkerData(
    marker: const Marker(markerId: MarkerId('id-0'), position: LatLng(
      // double.parse(Get.find<LocationController>().getUserAddress().latitude),
      // double.parse(Get.find<LocationController>().getUserAddress().longitude),
        24.263867,
        45.033284
    )),
    child: Image.asset(Images.mail, height: 20, width: 20),
  ));
  int _index = 0;
  for(int index=0; index<zone.length; index++) {
    _index++;
    LatLng _latLng = LatLng(double.parse(zone[index].latitude), double.parse(zone[index].longitude));
    _latLngs.add(_latLng);

    _customMarkersZone.add(MarkerData(
      marker: Marker(markerId: MarkerId('id-$_index'), position: _latLng, onTap: () async {


        await prefs.setInt("visible", 1);
        _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
          double.parse(zone[index].latitude),
          double.parse(zone[index].longitude),

        ), zoom: 11)));
        // Future.delayed(Duration(seconds: 1), () {
          Get.offNamed(RouteHelper.getCategoryRoute(2));
          // Get.offNamed(RouteHelper.getInitialRoute());
        // });

    setState(() {
      visable=1;
    });

      }),
      child:prefs.getInt('visible')==0?Row(
        children: [
      Center(
      child: Material(
      elevation: 10,
        borderRadius: borderRadius,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(0.0),
            height: 23.0,//MediaQuery.of(context).size.width * .08,
            width: 75.0,//MediaQuery.of(context).size.width * .3,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: borderRadius,
            ),
            child: GestureDetector(
              onTap: (){
                showCustomSnackBar("omer abdall");
              },
              child: Row(
                children: <Widget>[

                   Expanded(
                    child: Center(child: Text(zone[index].name,style: robotoBlack.copyWith(fontSize: 7,color:Colors.white))),
                  ),
                  LayoutBuilder(builder: (context, constraints) {
                    return Container(
                      alignment: Alignment.center,
                      height: constraints.maxHeight,
                      width: constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                      ),
                      child: Text("4",style: robotoBlack.copyWith(fontSize: 7 )),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
        ],
      ):Container(),
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
    _reload = 2;
  }
}

  void _setMarkers(List<Estate> restaurants) async {
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
    for(int index=0; index<restaurants.length; index++) {
      _index++;
      LatLng _latLng = LatLng(double.parse(restaurants[index].latitude), double.parse(restaurants[index].longitude));
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

