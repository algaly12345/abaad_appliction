import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/screen/map/widget/location_search_dialog.dart';
import 'package:abaad/view/screen/map/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:abaad/data/repository/nearbyplacesmodel.dart';
import 'package:abaad/util/images.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:marker_icon/marker_icon.dart';

class NearByView extends StatefulWidget {
  Estate esate;
   NearByView({@required this.esate});

  @override
  State<NearByView> createState() => _NearByViewState();
}

class _NearByViewState extends State<NearByView> {
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();
  final List<Marker> _marker = [];
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  double currentLat = 0.0;
  double currentLng = 0.0;
  String type = 'restaurant';
  String type_value;

  Uint8List imageDataBytes;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor hospitalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor restlIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor mosqueIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor schoolIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor pharmacylIcon = BitmapDescriptor.defaultMarker;
  var markerIcon;
  GlobalKey iconKey = GlobalKey();
  List<RadioModel> sampleData = <RadioModel>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLat=double.parse(widget.esate.latitude);
    currentLng=double.parse(widget.esate.longitude);
    navigateToCurrentPosition();
    setCustomMarkerIcon();
    setHospitalMarkerIcon();
    setRestMarkerIcon();
    setMosqueMarkerIcon();
    setSchoolMarkerIcon();
    setParmceyIcon();

    _marker.add(
        Marker(markerId: MarkerId('id-0'),
            icon:sourceIcon,
            position: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
              double.parse(widget.esate.latitude),
              double.parse(widget.esate.longitude),
            ))
    );
    sampleData.add( RadioModel(false, 'مطعم', Images.restaurant));
    sampleData.add( RadioModel(false, 'مسجد', Images.mosque));
    sampleData.add( RadioModel(false, 'مستشفى',Images.hosptial));
    sampleData.add( RadioModel(false, 'مدارس',Images.hosptial));
    sampleData.add( RadioModel(false, 'صيدليات',Images.heart));
    // getNearbyPlaces();
    // loadData();
  }

  loadData() {
    if (nearbyPlacesResponse.results != null) {
      for (int i = 0; i < nearbyPlacesResponse.results.length; i++) {
        addMarkers(nearbyPlacesResponse.results[i], i);
      }
    }
  }

  void addMarkers(Results results, int i) {
    _marker.add(Marker(
      markerId: MarkerId(i.toString()),
      onTap: (){

      },
      infoWindow: InfoWindow( //popup info
    title: '${results.name}',
    ) ,
      icon: type=="restaurant"?restlIcon:type=="mosque"?mosqueIcon:type=="hospital"?hospitalIcon:type=="school"?schoolIcon:type=="pharmacy"?pharmacylIcon: sourceIcon ,

        position: LatLng(
          results.geometry.location.lat, results.geometry.location.lng),
    ));

    _marker.add(
        Marker(markerId: MarkerId('id-0'),
            icon: sourceIcon,
            position: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
               double.parse(widget.esate.latitude),
              double.parse(widget.esate.longitude),
            ))
    );

    setState(() {});
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint('error in getting current location');
      debugPrint(error.toString());
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void navigateToCurrentPosition() {

      debugPrint('My current location');
      debugPrint(widget.esate.latitude + widget.esate.longitude);


      _marker.add(Marker(
          markerId: MarkerId("yeiuwe87"),
          position: LatLng(double.parse(widget.esate.latitude), double.parse(widget.esate.longitude)),
          icon:  BitmapDescriptor.defaultMarker,

          infoWindow: InfoWindow(
            title: 'My current location',
          )));



      setState(() {
        currentLat =double.parse(widget.esate.latitude);
        currentLng = double.parse(widget.esate.longitude);
        getNearbyPlaces(type);
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: 'المرافق'.tr),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:  CameraPosition(zoom: 14.4, target: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                double.parse(widget.esate.latitude),
                double.parse(widget.esate.longitude)
            )),
            myLocationEnabled: true,

            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_marker),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 0,
            width: 0,
            offset: 0,
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: sampleData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return   InkWell(
                      //highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () async{

                          sampleData.forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;




                          if (sampleData[index].buttonText=='مطعم') {
                            type = 'restaurant';
                            getNearbyPlaces(type);

                          } else if (sampleData[index].buttonText=='مستشفى') {

                            type = 'hospital';
                            getNearbyPlaces(type);
                          } else if (sampleData[index].buttonText=='مسجد') {
                            type = 'mosque';
                            getNearbyPlaces(type);
                          }else if (sampleData[index].buttonText=='مدارس') {
                            type = 'school';
                            getNearbyPlaces(type);
                          }else if (sampleData[index].buttonText=='صيدليات') {
                            type = 'pharmacy';
                            getNearbyPlaces(type);
                          }


                      },
                      child: new RadioItem(sampleData[index]),
                    );
                  },
                ),
              ),
            ),
          ),


        ],

      ),

    );
  }
  Future<void> getCustomMarkerIcon(GlobalKey iconKey) async {
    RenderRepaintBoundary boundary = iconKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(pngBytes);
    });
  }

  void getNearbyPlaces(String type) async {
    _marker.clear();
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            widget.esate.latitude +
            ',' +
            widget.esate.longitude +
            '&radius=1500&type=' +
            type +
            '&key=AIzaSyDa4Ng7nNB5EkPqvcI1yaxcl8QE1Ja-tPA');

    var response = await http.post(url);

    print("printing latlng");
    print(jsonDecode(response.body));
    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    print("printing latlng");
    print(jsonDecode(response.body));

    loadData();
    setState(() {});
  }


  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.near)
        .then(
          (icon) {
        sourceIcon = icon;
      },
    );
  }

  void setHospitalMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_hosiptal)
        .then(
          (icon) {
        hospitalIcon = icon;
      },
    );
  }


  void setRestMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_restaurant)
        .then(
          (icon) {
        restlIcon = icon;
      },
    );
  }
  void setMosqueMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_mosque)
        .then(
          (icon) {
            mosqueIcon = icon;
      },
    );
  }


  void setSchoolMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_school)
        .then(
          (icon) {
        schoolIcon = icon;
      },
    );
  }


  void setParmceyIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, Images.mark_pharmcy)
        .then(
          (icon) {
        pharmacylIcon = icon;
      },
    );
  }


}


class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}


class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return  Container(
      height: 34,
      decoration:  BoxDecoration(
        color: _item.isSelected
            ?  Theme.of(context).primaryColor
            : Colors.transparent,
        border:  Border.all(
            width: 2.0,
            color: _item.isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey),
        borderRadius: const BorderRadius.all(const Radius.circular(8.0)),
      ),
      margin:  EdgeInsets.only(bottom: 7,top: 7,right: 4,left: 4),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 30.0,
            width: 50.0,

            child:  Center(
              child:  Image.asset(_item.text,height: 24,width: 24,color: _item.isSelected
                  ? Theme.of(context).backgroundColor
                  : Colors.grey)),
            ),
          Container(
            margin:  EdgeInsets.all( 7.0),
            child:  Text(_item.buttonText,style: robotoBlack.copyWith(fontSize: 11, color: _item.isSelected
                ? Theme.of(context).backgroundColor
                : Colors.grey)),
          )
        ],
      ),
    );
  }
}