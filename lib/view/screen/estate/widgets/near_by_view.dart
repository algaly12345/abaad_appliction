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

  Uint8List imageDataBytes;
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  var markerIcon;
  GlobalKey iconKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLat=double.parse(widget.esate.latitude);
    currentLng=double.parse(widget.esate.longitude);
    navigateToCurrentPosition();
    setCustomMarkerIcon();

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
      icon:  BitmapDescriptor.defaultMarker,

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
    getUserCurrentLocation().then((value) async {
      debugPrint('My current location');
      debugPrint(value.latitude.toString() + value.longitude.toString());


      _marker.add(Marker(
          markerId: MarkerId("yeiuwe87"),
          position: LatLng(value.latitude, value.longitude),
          icon:  BitmapDescriptor.defaultMarker,

          infoWindow: InfoWindow(
            title: 'My current location',
          )));


      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {
        currentLat = value.latitude;
        currentLng = value.longitude;
        getNearbyPlaces(type);
      });
    });
  }

     CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(76575, 3242342),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            // add icon, by default "3 dot" icon
            // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Restaurant"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Hospital"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Mosque"),
                  ),
                ];
              }, onSelected: (value) {
            if (value == 0) {
              type = 'restaurant';
              getNearbyPlaces(type);
            } else if (value == 1) {
              type = 'hospital';
              getNearbyPlaces(type);
            } else if (value == 2) {
              type = 'mosque';
              getNearbyPlaces(type);
            }
          }),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:  CameraPosition(zoom: 12, target: LatLng(
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
          )
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


}
