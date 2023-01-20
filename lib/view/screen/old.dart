// import 'package:abaad/controller/estate_controller.dart';
// import 'package:abaad/controller/location_controller.dart';
// import 'package:abaad/controller/splash_controller.dart';
// import 'package:abaad/data/model/response/estate_model.dart';
// import 'package:abaad/view/base/custom_app_bar.dart';
// import 'package:abaad/view/base/custom_image.dart';
// import 'package:abaad/view/base/custom_snackbar.dart';
// import 'package:abaad/view/screen/map/widget/estate_details_sheet.dart';
// import 'package:custom_map_markers/custom_map_markers.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:abaad/util/images.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
//
// class MapViewScreen extends StatefulWidget {
//   const MapViewScreen({Key key}) : super(key: key);
//
//   @override
//   State<MapViewScreen> createState() => _MapViewScreenState();
// }
//
// class _MapViewScreenState extends State<MapViewScreen> {
//   GoogleMapController _controller;
//   List<MarkerData> _customMarkers = [];
//   List<MarkerData> _custZoneomMarkers = [];
//   int _reload = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     if(Get.find<EstateController>().estateModel == null) {
//       Get.find<EstateController>().getEstateList(1, false);
//     }
//     Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
//
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//
//     _controller?.dispose();
//   }
//
//   Widget _customMarker(String path) {
//     return Stack(
//       children: [
//         Image.asset(Images.mail, height: 40, width: 40),
//         Positioned(top: 3, left: 0, right: 0, child: Center(
//           child: ClipOval(child: CustomImage(image: path, placeholder: Images.mail, height: 20, width: 20, fit: BoxFit.cover)),
//         )),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Center(child: Column(
//           children: [
//             Text("المدينة", textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
//             Text("حي احد شارع 71", textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black),),
//           ],
//         )),
//         leading: GestureDetector(
//           onTap: () {
//
//           },
//           child: const Icon(
//             Icons.menu,
//             color: Colors.blue,
//           ),
//         ),
//         actions: <Widget>[
//           Padding(
//               padding: EdgeInsets.all(7),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: const Icon(
//                   Icons.notifications_active,
//                   color: Colors.blue,
//                 ),
//               )
//           ),
//         ],
//       ),
//       body:  Container(
//         height: 200,
//         padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL) : null,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
//           color: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
//           boxShadow: ResponsiveHelper.isDesktop(context) ? [BoxShadow(
//             color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5,
//           )] : null,
//         ),
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//
//           Expanded(child: Padding(
//             padding: EdgeInsets.symmetric(vertical: _desktop ? 0 : Dimensions.PADDING_SIZE_EXTRA_SMALL),
//             child: Row(children: [
//
//               Stack(children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                   child: CustomImage(
//                     image: '',
//                     height: _desktop ? 120 : 65, width: _desktop ? 120 : 80, fit: BoxFit.cover,
//                   ),
//                 ),
//                 DiscountTag(
//                   discount: 5,
//                   freeDelivery:  false,
//                 ),
//
//               ]),
//               SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//
//               Expanded(
//                 child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//
//                   Text(
//                     "sdfd",
//                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
//                     maxLines: _desktop ? 2 : 1, overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL ),
//
//                   Text(
//                     'name',
//                     style: robotoRegular.copyWith(
//                       fontSize: Dimensions.fontSizeExtraSmall,
//                       color: Theme.of(context).disabledColor,
//                     ),
//                     maxLines: 1, overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height:  5),
//
//                   RatingBar(
//                     rating: 15 ,
//                     ratingCount: 4,
//                   ),
//                   SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL ),
//
//                   RatingBar(
//                     rating: 12,
//                     ratingCount: 6,
//                   ) ,
//
//                 ]),
//               ),
//
//               Column(mainAxisAlignment:MainAxisAlignment.center, children: [
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
//                   child: Icon(Icons.add, size: _desktop ? 30 : 25),
//                 ) ,
//
//                 Padding(
//                   padding: EdgeInsets.symmetric(vertical: _desktop ? Dimensions.PADDING_SIZE_SMALL : 0),
//                   child: Icon(
//                     Icons.favorite_border,  size:  25,
//                   ),
//                 ),
//
//               ]),
//
//             ]),
//           )),
//
//           _desktop ? SizedBox() : Padding(
//             padding: EdgeInsets.only(left: _desktop ? 130 : 90),
//             child: Divider(color: Colors.transparent),
//           ),
//
//         ]),
//       ),
//     );
//   }
//
//   void _setMarkers(List<Estate> restaurants) async {
//     List<LatLng> _latLngs = [];
//     _customMarkers = [];
//     _customMarkers.add(MarkerData(
//       marker: const Marker(markerId: MarkerId('id-0'), position: LatLng(
//         // double.parse(Get.find<LocationController>().getUserAddress().latitude),
//         // double.parse(Get.find<LocationController>().getUserAddress().longitude),
//           26.451363,
//           50.109046
//       )),
//       child: Image.asset(Images.mail, height: 20, width: 20),
//     ));
//     int _index = 0;
//
//     for(int index=0; index<restaurants.length; index++) {
//       _index++;
//       LatLng _latLng = LatLng(double.parse(restaurants[index].latitude), double.parse(restaurants[index].longitude));
//       _latLngs.add(_latLng);
//
//       _customMarkers.add(MarkerData(
//         marker: Marker(markerId: MarkerId('id-$_index'), position: _latLng, onTap: () {
//           Get.find<SplashController>().setNearestEstateIndex(index);
//         }),
//         child: _customMarker('https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Location_icon_from_Noun_Project.png/800px-Location_icon_from_Noun_Project.png'),
//       ));
//     }
//     // if(!ResponsiveHelper.isWeb() && _controller != null) {
//     //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
//     // }
//     await Future.delayed(Duration(milliseconds: 500));
//     if(_reload == 0) {
//       setState(() {});
//       _reload = 1;
//     }
//
//     await Future.delayed(Duration(seconds: 3));
//     if(_reload == 1) {
//       setState(() {});
//       _reload = 2;
//     }
//   }
//
// }
//
// Widget _textField({
//   TextEditingController controller,
//   FocusNode focusNode,
//   String label,
//   String hint,
//   double width,
//   Icon prefixIcon,
//   suffixIcon,
//   Function(String) locationCallback,
// }) {
//   return Container(
//     width: width * 0.7,
//     child: TextField(
//       onChanged: (value) {
//         locationCallback(value);
//       },
//       controller: controller,
//       focusNode: focusNode,
//       decoration: InputDecoration(
//         prefixIcon: prefixIcon,
//         suffixIcon: suffixIcon,
//         labelText: label,
//         filled: true,
//         fillColor: Colors.white,
//         enabledBorder: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(5.0),
//           ),
//           borderSide: BorderSide(
//             color: Colors.blue,
//             width: 2,
//           ),
//         ),
//         focusedBorder: const OutlineInputBorder(
//           borderRadius:BorderRadius.all(
//             Radius.circular(10.0),
//           ),
//           borderSide: BorderSide(
//             color: Colors.blue,
//             width: 2,
//           ),
//         ),
//         contentPadding:const EdgeInsets.all(15),
//         hintText: hint,
//       ),
//     ),
//   );
// }