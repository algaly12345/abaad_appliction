// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController _mapController;
//   List<Marker> _markers = [];
//
//   final LatLng _initialPosition = const LatLng(37.7749, -122.4194);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: LatLng(37.7749, -122.4194), // San Francisco, CA
//               zoom: 12,
//             ),
//             markers: Set.of([
//               Marker(
//                 markerId: MarkerId('san_francisco'),
//                 position: LatLng(37.7749, -122.4194),
//                 infoWindow: InfoWindow(title: 'San Francisco'),
//               ),
//             ]),
//
//             // other options here
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child:   Padding(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => _searchNearby('school'),
//                     child: Text('Find schools nearby'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () => _searchNearby('hospital'),
//                     child: Text('Find hospitals nearby'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _searchNearby(String type) async {
//     final location = LatLng(37.7749, -122.4194);
//     final radius = 10000;
//     final result = await PlacesNearby.searchNearbyWithRadius(
//       location: location,
//       radius: radius,
//       type: type,
//     );
//     if (result.status == PlacesNearbyStatus.ok) {
//       setState(() {
//         _markers.addAll(result.results.map((place) => Marker(
//           markerId: MarkerId(place.id),
//           position: place.geometry.location.toLatLng(),
//           infoWindow: InfoWindow(title: place.name),
//         )));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//   }
//
// }
