import 'package:abaad/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class StreetViewDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
         buttonText: 'Click to open streetview',
          onPressed: () {
            StreetViewer.showStreetView("50.0635836395458", "19.94512172576971", "139.26709247816694", "8.931085777681233");
          },
        ),
      ),
    );
  }
}



class StreetViewer {
  static const _platform = const MethodChannel('streetView');

  static Future<void> showStreetView(
      String lat, String lng, String heading, String pitch) async {
    final arguments = <String, dynamic>{
      'latitude': lat,
      'longitude': lng,
      'heading': heading,
      'pitch': pitch,
    };
    await _platform.invokeMethod('viewStreetView',arguments);
  }
}