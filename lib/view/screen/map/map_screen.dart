import 'dart:async';
import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/cached_img.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/discount_tag.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/map/widget/zone_sheet.dart';
import 'package:abaad/view/screen/test.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:abaad/util/images.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widget/estate_details_sheet.dart';
import 'widget/location_search_dialog.dart';
import 'widget/permission_dialog.dart';
import 'widget/service_offer.dart';

class MapScreen extends StatefulWidget {
  ZoneModel mainCategory;
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController googleMapController;
  MapScreen({Key key,@required this.mainCategory,@required this.fromSignUp, @required this.fromAddAddress, @required this.canRoute,
    @required this.route, this.googleMapController,}) : super(key: key);
  static Future<void> loadData(bool reload) async {
    Get.find<AuthController>().getZoneList();
    if(Get.find<EstateController>().estateModel == null) {
      Get.find<EstateController>().getEstateList(1, false);
    }
    Get.find<SplashController>().setNearestEstateIndex(-1, notify: false);
  }

  @override
  State<MapScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapScreen> {
  GoogleMapController _controller;
  List<MarkerData> _customMarkers = [];
  List<Marker> _markers = <Marker>[];
  CameraPosition _cameraPosition;


  int _reload = 0;
  Set<Polygon> _polygon = HashSet<Polygon>();
  bool cardTapped = false;
  LatLng _initialPosition;
  final bool _ltr = Get.find<LocalizationController>().isLtr;


  @override
  void initState() {
    super.initState();
    MapScreen.loadData(false);
    cardTapped = false;
    if(widget.fromAddAddress) {
      Get.find<LocationController>().setPickData();
    }
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    _initialPosition = LatLng(
        26.451363,
        50.109046
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  get borderRadius => BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: WebMenuBar(),
        body: GetBuilder<EstateController>(builder: (restController) {
     return   GetBuilder<LocationController>(builder: (locationController) {
        return restController.estateModel != null
            ? CustomGoogleMapMarkerBuilder(
          customMarkers: _customMarkers,
          builder: (context, markers) {
            if (markers == null) {
              return Stack(children: [

                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: widget.fromAddAddress ? LatLng(locationController.position.latitude, locationController.position.longitude)
                        : _initialPosition,
                    zoom: 16,
                  ),
                  myLocationEnabled: false,
                  compassEnabled: false,
                  zoomControlsEnabled: true,
                  onTap: (position) =>
                      Get.find<SplashController>()
                          .setNearestEstateIndex(-1),
                  minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                  onMapCreated: (GoogleMapController controller) {

                  },
                ),
                cardTapped
                    ? Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: FlipCard(
                      front: Container(
                        height: 250.0,
                        width: 175.0,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0))),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              height: 150.0,
                              width: 175.0,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage('https://cdn.dribbble.com/users/234969/screenshots/5404808/medallion_burst_animation.gif'),
                                      fit: BoxFit.cover)),
                            ),
                            Container(
                              padding:
                              const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children:  [
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "يضمن هذا العرض عروض وخصومانت من مقدمين خدمة في عدد من الخدمات موفرة داخل العرض",style: robotoBlack.copyWith(fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                      back: Container(
                        height: 300.0,
                        width: 225.0,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            _buildReviewItem(),

                            _buildReviewItem(),


                            // Container(
                            //   height: 250.0,
                            //   child: isReviews
                            //       ? ListView(
                            //     children: [
                            //       if (isReviews &&
                            //           tappedPlaceDetail['reviews'] !=
                            //               null)
                            //         ...tappedPlaceDetail['reviews']!
                            //             .map((e) {
                            //           return _buildReviewItem(e);
                            //         })
                            //     ],
                            //   )
                            //       : _buildPhotoGallery(
                            //       tappedPlaceDetail['photos'] ?? []),
                            // )
                          ],
                        ),
                      ),
                    ))
                    : Container(),
                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 7.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: <Widget>[
                              Row(
                                children: [

                                  InkWell(
                                    onTap: () => Get.dialog(LocationSearchDialog(mapController: _controller)),
                                    child: Container(
                                      height: 43,
                                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                                      width: width-130,
                                      child:  Row(children: [
                                        Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                                        const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        Expanded(
                                          child: Text(
                                            locationController.pickAddress,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                        Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyText1.color),
                                      ]),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.blue,
                                        )),


                                    child: const Icon(Icons.qr_code, size: 25,
                                      color: Colors.blue,),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(7),
                                    margin: const EdgeInsets.only(
                                        left: 4.0, right: 4.0),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.white,
                                        )),


                                    child: const Icon(
                                      Icons.filter_list_alt, size: 25,
                                      color: Colors.white,),
                                  ),
                                ],
                              ),
                              GetBuilder<CategoryController>(builder: (categoryController) {
                                return   (categoryController.categoryList != null ) ?

                                SizedBox(

                                  height: 30,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categoryController.categoryList.length,
                                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return  Column(
                                          children: [

                                            Row(
                                              children: [
                                                Container(
                                                  height: 26,
                                                    child: Text(categoryController.categoryList[index].name),
                                                  color: Colors.white,
                                                ),

                                                CachedImage(
                                                  imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Rubio_Circle.png",
                                                  width: 30.0,
                                                  height: 30.0,
                                                ),
                                              ],
                                            )
                                          ],
                                        );

                                      }),
                                ):Container();

                              })

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                GetBuilder<SplashController>(builder: (splashController) {
                  return splashController.nearestEstateIndex != -1 ? Positioned(
                    bottom: 0,
                    child: EstateDetailsSheet(callback: (int index) =>
                        _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                CameraPosition(target: LatLng(
                                  double.parse(
                                      restController.estateModel.estates[index]
                                          .latitude),
                                  double.parse(
                                      restController.estateModel.estates[index]
                                          .longitude),
                                ), zoom: 16)))),
                  ) : const SizedBox();
                }),

              ]);
            }
            return Stack(children: [
            GoogleMap(
            initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
              // double.parse(Get.find<LocationController>().getUserAddress().latitude),
              // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                26.451363,
                50.109046
            )),
            markers: markers,
            myLocationEnabled: false,
            compassEnabled: false,
            zoomControlsEnabled: true,
            onTap: (position) => Get.find<SplashController>().setNearestEstateIndex(-1),
            minMaxZoomPreference: MinMaxZoomPreference(0, 16),
            onMapCreated: (GoogleMapController controller) {
            _controller = controller;
            if(restController.estateModel != null ) {
            _setMarkers(restController.estateModel.estates);
            }
            },
            ),

              cardTapped
                  ? Positioned(
                  top: 100.0,
                  left: 15.0,
                  child: FlipCard(
                    front: Container(
                      height: 250.0,
                      width: 175.0,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Container(
                            height: 150.0,
                            width: 175.0,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                image: DecorationImage(
                                    image: NetworkImage('https://cdn.dribbble.com/users/234969/screenshots/5404808/medallion_burst_animation.gif'),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            padding:
                            const EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                            width: 175.0,
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children:  [
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    "يضمن هذا العرض عروض وخصومانت من مقدمين خدمة في عدد من الخدمات موفرة داخل العرض",style: robotoBlack.copyWith(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
                    ),
                    back: Container(
                      height: 300.0,
                      width: 225.0,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Column(
                        children: [
                          _buildReviewItem(),

                           _buildReviewItem(),


                          // Container(
                          //   height: 250.0,
                          //   child: isReviews
                          //       ? ListView(
                          //     children: [
                          //       if (isReviews &&
                          //           tappedPlaceDetail['reviews'] !=
                          //               null)
                          //         ...tappedPlaceDetail['reviews']!
                          //             .map((e) {
                          //           return _buildReviewItem(e);
                          //         })
                          //     ],
                          //   )
                          //       : _buildPhotoGallery(
                          //       tappedPlaceDetail['photos'] ?? []),
                          // )
                        ],
                      ),
                    ),
                  ))
                  : Container(),

              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 7.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: <Widget>[
                            Row(
                              children: [

                                InkWell(
                                  onTap: () => Get.dialog(LocationSearchDialog(mapController: _controller)),
                                  child: Container(
                                    height: 43,
                                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                                    width: width-130,
                                    child:  Row(children: [
                                      Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Expanded(
                                        child: Text(
                                      locationController.pickAddress,
                                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyText1.color),
                                    ]),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.blue,
                                      )),


                                  child: const Icon(Icons.qr_code, size: 25,
                                    color: Colors.blue,),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  margin: const EdgeInsets.only(
                                      left: 4.0, right: 4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.white,
                                      )),


                                  child: const Icon(
                                    Icons.filter_list_alt, size: 25,
                                    color: Colors.white,),
                                ),
                              ],
                            ),
                            GetBuilder<CategoryController>(builder: (categoryController) {
                              return   (categoryController.categoryList != null ) ?

                              SizedBox(
height: 30,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categoryController.categoryList.length,
                                    padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return  Column(
                                        children: [

                                          Row(
                                            children: [
                                              Container(
                                                height: 26,
                                                child: Text(categoryController.categoryList[index].name),
                                                color: Colors.white,
                                              ),

                                              CachedImage(
                                                imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Rubio_Circle.png",
                                                width: 30.0,
                                                height: 30.0,
                                              ),
                                            ],
                                          )
                                        ],
                                      );

                                    }),
                              ):Container();

                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  height: 200,
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(10.0),
                        child:  FloatingActionButton(
                          child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                          mini: true, backgroundColor: Theme.of(context).cardColor,
                          onPressed: () => _checkPermission(() {
                            Get.find<LocationController>().getCurrentLocation(false, mapController: _controller);
                          }),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          heroTag: 'recenterr',
                          onPressed: () {

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Color(0xFFECEDF1))),
                          child: const Icon(
                            Icons.layers_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 60,
                        padding: const EdgeInsets.all(10.0),
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          heroTag: 'recenterr',
                          onPressed: () {

                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Color(0xFFECEDF1))),
                          child: const Icon(
                            Icons.my_location,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              GetBuilder<SplashController>(builder: (splashController) {
                return splashController.nearestEstateIndex != -1 ? Positioned(
                  bottom: 0,
                  child: EstateDetailsSheet(callback: (int index) =>
                      _controller.animateCamera(CameraUpdate.newCameraPosition(
                          CameraPosition(target: LatLng(
                            double.parse(
                                restController.estateModel.estates[index]
                                    .latitude),
                            double.parse(
                                restController.estateModel.estates[index]
                                    .longitude),
                          ), zoom: 16))), onPressed: () {

                   setState(() {
                     cardTapped = true;
                   });

                  },),
                ) : const SizedBox();
              }),

            ]);
          },
        )
            : const Center(child: CircularProgressIndicator());
      });
        }),
    );
  }
  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar('you_have_to_allow'.tr);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(PermissionDialog());
    }else {
      onTap();
    }
  }
  void _setMarkers(List<Estate> estate) async {
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
    for (int index = 0; index < estate.length; index++) {
      _index++;
      LatLng _latLng = LatLng(double.parse(estate[index].latitude),
          double.parse(estate[index].longitude));
      _latLngs.add(_latLng);

      _customMarkers.add(MarkerData(
        marker: Marker(
            markerId: MarkerId('id-$_index'), position: _latLng, onTap: () {


          Get.find<SplashController>().setNearestEstateIndex(index);
          setState(() {
            cardTapped = false;
          });
        }),
        child: Image.asset(Images.estate_default, height: 32, width: 20),
      ));
    }
    // if(!ResponsiveHelper.isWeb() && _controller != null) {
    //   Get.find<LocationController>().zoomToFit(_controller, _latLngs, padding: 0);
    // }
    await Future.delayed(const Duration(milliseconds: 500));
    if (_reload == 0) {
      setState(() {});
      _reload = 1;
    }

    await Future.delayed(const Duration(seconds: 3));
    if (_reload == 1) {
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
      height: 44,
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
              Radius.circular(3.0),
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
  }
}

_buildReviewItem() {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 8.0),
        child: Row(
          children: [
            Container(
              height: 35.0,
              width: 35.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(width: 4.0),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 160.0,
                child:  Text(
                  'دهانات الجزيرة',
                  style: robotoBlack.copyWith(fontSize: 11),
                ),
              ),
              const SizedBox(height: 3.0),
          SizedBox(
            height: 16,
             width: 44,
            child: CustomPaint(
              painter: PriceTagPaint(),
              child: Center(
                child: Text(
                  "20%",
                  style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                ),
              ),
            ),
          )
              // const RatingStars(
              //   value: 3* 1.0,
              //   starCount: 5,
              //   starSize: 7,
              //   valueLabelColor: Color(0xff9b9b9b),
              //   valueLabelTextStyle: TextStyle(
              //       color: Colors.white,
              //       fontFamily: 'WorkSans',
              //       fontWeight: FontWeight.w400,
              //       fontStyle: FontStyle.normal,
              //       fontSize: 9.0),
              //   valueLabelRadius: 7,
              //   maxValue: 5,
              //   starSpacing: 2,
              //   maxValueVisibility: false,
              //   valueLabelVisibility: true,
              //   animationDuration: Duration(milliseconds: 1000),
              //   valueLabelPadding:
              //   EdgeInsets.symmetric(vertical: 1, horizontal: 4),
              //   valueLabelMargin: EdgeInsets.only(right: 4),
              //   starOffColor: Color(0xffe7e8ea),
              //   starColor: Colors.yellow,
              // )
            ])
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: const Text(
           "كن أول من يعلم عن عروضنا المميزة وأحدث أفكار  دهانات الجزيرة",
            style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 11.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
      Divider(color: Colors.grey.shade600, height: 1.0)
    ],
  );
}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
  }
}