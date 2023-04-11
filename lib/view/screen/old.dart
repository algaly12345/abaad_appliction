// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:abaad/data/repository/nearbyplacesmodel.dart';
// import 'package:abaad/util/images.dart';
// import 'package:custom_info_window/custom_info_window.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:ui' as ui;
//
// class _HomePageState extends State<HomePage> {
//   String _active;
//   int iter = 0;
//   String activeButton;
//   List<String> selectBarData = ['dasdasdas'];
//   List<String> modes = ['deep-sleep', 'pain-relief'];
//   List<String> sounds = ['campfire', 'rain'];
//
//   // ValueChanged<String> callback
//   void active(String btn) {
//     setState(() => _active = btn);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: Column(
//             children: <Widget>[
//               Container(
//                   padding: EdgeInsets.only(left: 25, right: 25, top: 60),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <CircleButton>[
//                       new CircleButton(
//                         action: active, //pass data from child to parent
//                         tag: "button1", //specifies attribute of button
//                         active: _active == "button1" ? true : false, //set button active based on value in this parent
//                         imageData: 'assets/body-organ.png',
//                         buttonName: 'Mode',
//                       ),
//                       new CircleButton(
//                         action: active,
//                         tag: "button2",
//                         active: _active == "button2" ? true : false,
//                         imageData: 'assets/audio.png',
//                         buttonName: 'Sounds',
//                       ),
//                       new CircleButton(
//                         action: active,
//                         tag: "button3",
//                         active: _active == "button2" ? true : false,
//                         imageData: 'assets/speaker.png',
//                         buttonName: 'Volume',
//                       )
//                     ],
//                   )),
//               selectBar()
//             ],
//           )),
//     );
//   }
// }