import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:abaad/util/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapViewScreen extends StatefulWidget {
  late GoogleMapController mapController;
  List<LatLng> polygonLatLngs = [
    LatLng(24.7136, 46.6753), // Riyadh, Saudi Arabia
    LatLng(24.7743, 46.7381),
    LatLng(24.7345, 46.8350),
    LatLng(24.6893, 46.7939),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps App with Polygon'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(24.7136, 46.6753), // Center the map on Riyadh
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          mapController = controller;
        },
        polygons: <Polygon>[
          Polygon(
            polygonId: PolygonId('zone_polygon'),
            points: polygonLatLngs,
            strokeWidth: 2,
            strokeColor: Colors.blue,
            fillColor: Colors.blue.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}