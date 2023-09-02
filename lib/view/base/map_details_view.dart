import 'dart:typed_data';

import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapDetailsView extends StatefulWidget {
  final bool fromView;
  final GoogleMapController mapController;

  const MapDetailsView({@required this.fromView, this.mapController});

  @override
  State<MapDetailsView> createState() => _MapDetailsViewState();
}

class _MapDetailsViewState extends State<MapDetailsView> {
  CameraPosition _cameraPosition;
  GoogleMapController _mapController;
  Uint8List imageDataBytes;
  var markerIcon;
  GlobalKey iconKey = GlobalKey();


  @override
  Widget build(BuildContext context) {

    return GetBuilder<EstateController>(builder: (estateController) {
      return  (estateController.estate != null && estateController.estate.shortDescription != null) ?

       Card(
        elevation: 0,
        child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
          padding: EdgeInsets.all(widget.fromView ? 0 : Dimensions.PADDING_SIZE_SMALL),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text("location  ".tr,
                style: robotoBlack.copyWith(fontSize: 14)),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),


            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

       Container(
              height: widget.fromView ? 200 : (context.height * 0.70),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: Stack(clipBehavior: Clip.none, children: [
                  GoogleMap(
                    initialCameraPosition:  CameraPosition(
                      target: LatLng(
                     double.parse(  estateController.estate.latitude),
                        double.parse(  estateController.estate.longitude)

                      ), zoom: 16,
                    ),
         markers: <Marker>{
             Marker(
                 draggable: false,
                 markerId: MarkerId("1"),
                 position: LatLng(double.parse(estateController.estate.latitude),
                     double.parse(estateController.estate.longitude)),
                 // icon: currentLocationIcon,
                 icon: markerIcon ?? BitmapDescriptor.defaultMarker),
           },

                    minMaxZoomPreference: MinMaxZoomPreference(0, 20),
                    zoomControlsEnabled: true,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: false,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    onCameraIdle: () {
                      if(!widget.fromView) {
                        widget.mapController.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                      }
                    },
                    onCameraMove: ((position) => _cameraPosition = position),
                    onMapCreated: (GoogleMapController controller) {
                      if(widget.fromView) {
                        _mapController = controller;
                      }else {
                      }
                    },
                  ),
                  widget.fromView ? Positioned(
                    top: 10, right: 0,
                    child: InkWell(
                      onTap: () {
                        Get.to(MapDetailsView(fromView: false, mapController: _mapController));
                      },
                      child: Container(
                        width: 30, height: 30,
                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                        child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                      ),
                    ),
                  ) : SizedBox(),
                ]),
              ),
            ) ,

         SizedBox(height: 10),
            !widget.fromView ? CustomButton(
              buttonText: 'back'.tr,
              onPressed: () {
                Get.back();
              },
            ) : SizedBox()

          ]),
        )),
      ): const Center(child: CircularProgressIndicator());
    });

  }
}
