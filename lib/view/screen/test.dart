import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MapPage> {
// created controller to display Google Maps
  Completer<GoogleMapController> _controller = Completer();

// on below line we have set the camera position
  static final CameraPosition _kGoogle = const CameraPosition(
    target: LatLng(19.0759837, 72.8776559),
    zoom: 14,
  );

  Set<Polygon> _polygon = HashSet<Polygon>();

// created list of locations to display polygon
  List<LatLng> points = [
    LatLng(19.0759837, 72.8776559),
    LatLng(28.679079, 77.069710),
    LatLng(26.850000, 80.949997),
    LatLng(19.0759837, 72.8776559),
    LatLng(49.607619550646, 25.36209824499),
  LatLng(49.61637428087, 25.351704995791),
  LatLng(49.643668439806, 25.361012424932),
  LatLng(49.611052778185, 25.364580082778),
  LatLng(49.607619550646, 25.36209824499)
  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //initialize polygon

    print("----------------------omeromer${points}");
    _polygon.add(
        Polygon(
          // given polygonId
          polygonId: PolygonId('1'),
          // initialize the list of points to display polygon
          points: points,
          // given color to polygon
          fillColor: Colors.green.withOpacity(0.3),
          // given border color to polygon
          strokeColor: Colors.green,
          geodesic: true,
          // given width of border
          strokeWidth: 4,
        )
    );



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0F9D58),
        // title of app
        title: Text("GFG"),
      ),
      body: Container(
        child: SafeArea(
          child: GoogleMap(
            //given camera position
            initialCameraPosition: _kGoogle,
            // on below line we have given map type
            mapType: MapType.normal,
            // on below line we have enabled location
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            // on below line we have enabled compass location
            compassEnabled: true,
            // on below line we have added polygon
            polygons: _polygon,
            // displayed google map
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
      ),
    );
  }
}
