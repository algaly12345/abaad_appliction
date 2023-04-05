import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'dart:ui' as ui;
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/cached_img.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/discount_tag.dart';
import 'package:abaad/view/base/estate_item.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:abaad/view/screen/fillter/fillter_estate_sheet.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/map/widget/estate_by_category.dart';
import 'package:abaad/view/screen/map/widget/zone_sheet.dart';
import 'package:abaad/view/screen/test.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'widget/service_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MapScreen extends StatefulWidget {
  ZoneModel mainCategory;
  final bool fromSignUp;
  final bool fromAddAddress;
  final bool canRoute;
  final String route;
  final GoogleMapController googleMapController;
  MapScreen({Key key,@required this.mainCategory,@required this.fromSignUp, @required this.fromAddAddress, @required this.canRoute,
    @required this.route, this.googleMapController,}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapScreen> {
  GoogleMapController _controller;
  List<MarkerData> _customMarkers = [];
  CameraPosition _cameraPosition;
  final ScrollController scrollController = ScrollController();
  Uint8List imageDataBytes;
  var markerIcon;
  GlobalKey iconKey = GlobalKey();


  int _reload = 0;
  Set<Polygon> _polygon = HashSet<Polygon>();
  bool cardTapped = false;
  LatLng _initialPosition;
  var photoGalleryIndex = 0;
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  MapType _currentMapType = MapType.normal;
  // Set<Marker> _markers = Set<Marker>();
  var tappedPoint;
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

   PageController _pageController;
  int prevPage = 0;
  bool showBlankCard = false;
  bool pressedNear = false;
  bool radiusSlider = false;
  var radiusValue = 3000.0;
  Timer _debounce;
  String tokenKey = '';
  int index;
  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      cardTapped = false;
      photoGalleryIndex = 1;
      showBlankCard = false;
      // goToTappedPlace();
      // fetchImage();
    }
  }
  int selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    Get.find<AuthController>().getZoneList();
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    // Get.find<CategoryController>().getSubCategoryList("0");
    int offset = 1;
    // Get.find<ZoneController>().geZonesList();
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryProductList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList("0", 0,'0',"0","0","0", offset.toString());
        }
      }
    });
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

  Future<void> getCustomMarkerIcon(GlobalKey iconKey) async {
    RenderRepaintBoundary boundary = iconKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    setState(() {
      markerIcon = BitmapDescriptor.fromBytes(pngBytes);
    });
  }



  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
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
        body:
          GetBuilder<CategoryController>(builder: (categoryController) {
            return GetBuilder<LocationController>(builder: (locationController) {

              List<Estate> _products;
              if(categoryController.categoryProductList != null) {
                _products = [];
                if (categoryController.isSearching) {

                } else {
                  _products.addAll(categoryController.categoryProductList);
                }
              }


              _isNull = _products == null;
              if(!_isNull) {
                _length = _products.length;
              }

              _setMarkers(_products);
              return         !_isNull ?_products.length>0?    CustomGoogleMapMarkerBuilder (
                  customMarkers: _customMarkers,
                  builder: (context, markers) {
                    if (markers == null) {
                      return    Stack(children: [
                        !_isNull ?_products.length>0?

                        GoogleMap(
                          initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
                            // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                            // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                              26.451363,
                              50.109046
                          )),
                          // myLocationEnabled: false,
                          // compassEnabled: false,
                          zoomControlsEnabled: true,
                          mapType: _currentMapType,
                          onTap: (point) {
                            tappedPoint = point;
                          },
                          minMaxZoomPreference: MinMaxZoomPreference(0, 40),
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            if(_products.length > 0) {
                              _setMarkers(_products);
                            }
                          },
                        ):Center(
                          child: NoDataScreen(
                            text: 'no_data_available',
                          ),
                        ):const SizedBox(),

                        categoryController.isLoading ? Center(child: Padding(
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                        )) : SizedBox(),



                        SafeArea(
                          child: Align(
                            alignment: Alignment.topCenter,
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
                                              Container(
                                                child: Expanded(
                                                  child: Text(
                                                    locationController.pickAddress,
                                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  ),
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
                                        GestureDetector(
                                          onTap: (){
                                            Get.dialog(FiltersScreen());
                                          },
                                          child: Container(
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
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,),
                                    GetBuilder<CategoryController>(builder: (categoryController) {
                                      return   (categoryController.categoryList != null ) ?

                                      SizedBox(
                                        child:
                                        (categoryController.subCategoryList != null ) ? Center(child: Container(
                                            height: 40,

                                            child:
                                            ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: categoryController.subCategoryList.length,
                                              padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {

                                                return Padding(
                                                  padding: const EdgeInsets.only(right: 6,left: 6),
                                                  child: InkWell(
                                                    onTap: (){
                                                      _customMarkers=[];
                                                      // _customMarkers.clear();


                                                      categoryController.setSubCategoryIndex(index);

                                                      setState(() {



                                                        _setMarkers(_products);




                                                      });



                                                    },
                                                    child: Container(

                                                      padding: EdgeInsets.only(
                                                        left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                                                        right: index == categoryController.subCategoryList.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                                                        //   top: Dimensions.PADDING_SIZE_SMALL,
                                                      ),


                                                      decoration:
                                                      BoxDecoration(
                                                        border: Border.all(
                                                            color:index == categoryController.subCategoryIndex ? Theme.of(
                                                                context)
                                                                .primaryColor
                                                                : Colors
                                                                .black12,
                                                            width: 2),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            2.0),
                                                        color: Colors.white,
                                                      ),


                                                      child: Row(children: [
                                                        Text(
                                                          categoryController.subCategoryList[index].name,
                                                          style: index == categoryController.subCategoryIndex
                                                              ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                                              : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                                        ),

                                                        SizedBox(width: 5),
                                                        index==0?Container():  CustomImage(
                                                            image:
                                                            '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.subCategoryList[index].image}',
                                                            height: 25,
                                                            width: 25,
                                                            colors:index ==
                                                                categoryController.subCategoryIndex  ? Theme.of(
                                                                context)
                                                                .primaryColor
                                                                : Colors
                                                                .black12),

                                                      ]),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )  )) : SizedBox(),


                                      ):Container();

                                    })
                                  ],
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
                                    onPressed:_onMapTypeButtonPressed,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        side: const BorderSide(color: Color(0xFFECEDF1))),
                                    child:  Icon(
                                      Icons.layers_outlined,
                                      color: Theme.of(context).primaryColor,
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

                        pressedNear
                            ? Positioned(
                            bottom: 20.0,
                            child: Container(
                              height: 200.0,
                              width: MediaQuery.of(context).size.width,
                              child:nearbyPlacesList(_products),
                            ))
                            : Container(),
                        cardTapped
                            ? Positioned(
                            top: 100.0,
                            left: 15.0,
                            child: FlipCard(
                              front: Container(
                                height: 250.0,
                                width: 175.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    Container(
                                      height: 150.0,
                                      width: 175.0,

                                    ),
                                    Container(
                                      padding: EdgeInsets.all(7.0),
                                      width: 175.0,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Address: ',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),

                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                      EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                                      width: 175.0,
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Contact: ',
                                            style: TextStyle(
                                                fontFamily: 'WorkSans',
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Container(
                                              width: 105.0,
                                              child: Text(
                                                'none given',
                                                style: TextStyle(
                                                    fontFamily: 'WorkSans',
                                                    fontSize: 11.0,
                                                    fontWeight: FontWeight.w400),
                                              ))
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
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // isReviews = true;
                                                // isPhotos = false;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: Duration(milliseconds: 700),
                                              curve: Curves.easeIn,
                                              padding: EdgeInsets.fromLTRB(
                                                  7.0, 4.0, 7.0, 4.0),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // isReviews = false;
                                                // isPhotos = true;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              duration: Duration(milliseconds: 700),
                                              curve: Curves.easeIn,
                                              padding: EdgeInsets.fromLTRB(
                                                  7.0, 4.0, 7.0, 4.0),
                                              child: Text(
                                                'Photos',
                                                style: TextStyle(
                                                    color:  Colors.black87,
                                                    fontFamily: 'WorkSans',
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                            : Container(),

                        GetBuilder<SplashController>(builder: (splashController) {
                          // for (int i = 0; i < _products.length; i++) {
                          // Estate currentCoordinate = _products[i];
                          // print('Coordinate ${i+1}: (${currentCoordinate.id}, ${currentCoordinate.title})');
                          // }
                          return splashController.nearestEstateIndex != -1 ? nearbyPlacesList(_products): const SizedBox();
                        }),

                      ]);
                    }
                    return
                      Stack(children: [
                !_isNull ?_products.length>0?

                GoogleMap(
                  initialCameraPosition: const CameraPosition(zoom: 12, target: LatLng(
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                      26.451363,
                      50.109046
                  )),
                  markers: markers,
                  // myLocationEnabled: false,
                  // compassEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: _currentMapType,
                  onTap: (point) {
                    tappedPoint = point;
                  },
                  minMaxZoomPreference: MinMaxZoomPreference(0, 40),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                    if(_products.length > 0) {
                      _setMarkers(_products);
                    }
                  },
                ):Center(
                  child: NoDataScreen(
                    text: 'no_data_available',
                  ),
                ):const SizedBox(),

                categoryController.isLoading ? Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                )) : SizedBox(),



                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
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
                                      Container(
                                        child: Expanded(
                                          child: Text(
                                            locationController.pickAddress,
                                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge), maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
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
                                GestureDetector(
                                  onTap: (){
                                    Get.dialog(FiltersScreen());
                                  },
                                  child: Container(
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,),
                            GetBuilder<CategoryController>(builder: (categoryController) {
                              return   (categoryController.categoryList != null ) ?

                              SizedBox(
                                child:
                                (categoryController.subCategoryList != null ) ? Center(child: Container(
                                    height: 40,

                                    child:
                                    ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: categoryController.subCategoryList.length,
                                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {

                                        return Padding(
                                          padding: const EdgeInsets.only(right: 6,left: 6),
                                          child: InkWell(
                                            onTap: (){
                                              _customMarkers=[];
                                              // _customMarkers.clear();


                                              categoryController.setSubCategoryIndex(index);

                                              setState(() {




                                                _setMarkers(_products);




                                              });



                                            },
                                            child: Container(

                                              padding: EdgeInsets.only(
                                                left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                                                right: index == categoryController.subCategoryList.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                                                //   top: Dimensions.PADDING_SIZE_SMALL,
                                              ),


                                              decoration:
                                              BoxDecoration(
                                                border: Border.all(
                                                    color:index == categoryController.subCategoryIndex ? Theme.of(
                                                        context)
                                                        .primaryColor
                                                        : Colors
                                                        .black12,
                                                    width: 2),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    2.0),
                                                color: Colors.white,
                                              ),


                                              child: Row(children: [
                                                Text(
                                                  categoryController.subCategoryList[index].name,
                                                  style: index == categoryController.subCategoryIndex
                                                      ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                                      : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                                ),

                                                SizedBox(width: 5),
                                                index==0?Container():  CustomImage(
                                                    image:
                                                    '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.subCategoryList[index].image}',
                                                    height: 25,
                                                    width: 25,
                                                    colors:index ==
                                                        categoryController.subCategoryIndex  ? Theme.of(
                                                        context)
                                                        .primaryColor
                                                        : Colors
                                                        .black12),

                                              ]),
                                            ),
                                          ),
                                        );
                                      },
                                    )  )) : SizedBox(),


                              ):Container();

                            })
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                Container(height: 200,
                    child:   nearbyPlacesList(_products))

                  // Container(
                  //   height: 200,
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         height: 60,
                  //         width: 60,
                  //         padding: const EdgeInsets.all(10.0),
                  //         child:  FloatingActionButton(
                  //           child: Icon(Icons.my_location, color: Theme.of(context).primaryColor),
                  //           mini: true, backgroundColor: Theme.of(context).cardColor,
                  //           onPressed: () => _checkPermission(() {
                  //             Get.find<LocationController>().getCurrentLocation(false, mapController: _controller);
                  //           }),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 60,
                  //         width: 60,
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: FloatingActionButton(
                  //           backgroundColor: Colors.white,
                  //           heroTag: 'recenterr',
                  //           onPressed:_onMapTypeButtonPressed,
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               side: const BorderSide(color: Color(0xFFECEDF1))),
                  //           child:  Icon(
                  //             Icons.layers_outlined,
                  //             color: Theme.of(context).primaryColor,
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 60,
                  //         width: 60,
                  //         padding: const EdgeInsets.all(10.0),
                  //         child: FloatingActionButton(
                  //           backgroundColor: Colors.white,
                  //           heroTag: 'recenterr',
                  //           onPressed: () {
                  //
                  //           },
                  //           shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               side: const BorderSide(color: Color(0xFFECEDF1))),
                  //           child: const Icon(
                  //             Icons.my_location,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ),

                pressedNear
                    ? Positioned(
                    bottom: 20.0,
                    child: Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child:nearbyPlacesList(_products),
                    ))
                    : Container(),
                cardTapped
                    ? Positioned(
                    top: 100.0,
                    left: 15.0,
                    child: FlipCard(
                      front: Container(
                        height: 250.0,
                        width: 175.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0))),
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              height: 150.0,
                              width: 175.0,

                            ),
                            Container(
                              padding: EdgeInsets.all(7.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Address: ',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              padding:
                              EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                              width: 175.0,
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Contact: ',
                                    style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                      width: 105.0,
                                      child: Text(
                                            'none given',
                                        style: TextStyle(
                                            fontFamily: 'WorkSans',
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w400),
                                      ))
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
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // isReviews = true;
                                        // isPhotos = false;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 700),
                                      curve: Curves.easeIn,
                                      padding: EdgeInsets.fromLTRB(
                                          7.0, 4.0, 7.0, 4.0),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // isReviews = false;
                                        // isPhotos = true;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 700),
                                      curve: Curves.easeIn,
                                      padding: EdgeInsets.fromLTRB(
                                          7.0, 4.0, 7.0, 4.0),
                                      child: Text(
                                        'Photos',
                                        style: TextStyle(
                                            color:  Colors.black87,
                                            fontFamily: 'WorkSans',
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                    : Container(),

                GetBuilder<SplashController>(builder: (splashController) {
                    for (int i = 0; i < _products.length; i++) {
                    Estate currentCoordinate = _products[i];
                    print('Coordinate ${i+1}: (${currentCoordinate.id}, ${currentCoordinate.title})');
                    selectedIndex = i;

                    }
                  return cardTapped? nearbyPlacesList(_products): const SizedBox();
                }),

              ]);

                  },
              ):Center(child: Text("looding"),):Container();



          });
    })
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
    _customMarkers=[];
    _customMarkers.clear();

    print("----------------${estate.length}");
    _customMarkers.add(MarkerData(
      marker: const Marker(markerId: MarkerId('id-0'), position: LatLng(
        // double.parse(Get.find<LocationController>().getUserAddress().latitude),
        // double.parse(Get.find<LocationController>().getUserAddress().longitude),
          26.451363,
          50.109046
      )),
      child: Image.asset(Images.estate_default, height: 32, width: 20),
    ));
    for (int i = 0; i < estate.length; i++) {
      Estate currentCoordinate = estate[i];
      print('Coordinate ${i+1}: (${currentCoordinate.id}, ${currentCoordinate.title})');
      LatLng _latLng = LatLng(double.parse(currentCoordinate.latitude), double.parse(currentCoordinate.longitude));
      _latLngs.add(_latLng);

      _customMarkers.add(MarkerData(

          marker: Marker(

              markerId: MarkerId('id-$i'), position: _latLng, onTap: () {
            selectedIndex = i;
            // pressedNear=true;
           //  Get.find<SplashController>().setNearestEstateIndex(i);

            // cardTapped = fal
            // _pageController.animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut,);
                print("---------------------------------------------$i");

            _pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut,);

            // setState(() {});
          }),
          child: Column(
            children: [
              Container(

                padding:   const EdgeInsets.only(right: 1,left: 1),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).secondaryHeaderColor
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        '${currentCoordinate.price}',
                        style:robotoBlack.copyWith(fontSize: 7)
                    ),
                    Image.asset(currentCoordinate.serviceOffers.isEmpty?Images.vt:Images.vt_offer, height: 8, width: 8),
                  ],

                ),
              ),

              Stack(
                children: [
                  Image.asset(Images.location_marker, height: 35, width: 35,color:currentCoordinate.serviceOffers.length==0?Theme.of(context).primaryColor:Colors.orange),
                  Positioned(top: 3, left: 0, right: 0, child: Center(
                    child: ClipOval(child: CustomImage(image: "https://www.rocketmortgage.com/resources-cmsassets/RocketMortgage.com/Article_Images/Large_Images/Stock-Front-Of-Smaller-House-AdobeStock-118866140%20copy.jpeg", placeholder: Images.placeholder, height: 18, width: 18, fit: BoxFit.cover)),
                  )),
                ],
              ),
            ],
          )


      ));

       // Marker marker = Marker(
       //    markerId: MarkerId('marker_$i'),
       //    position: _latLng,
       //     icon: markerIcon ?? BitmapDescriptor.defaultMarker,
       //    onTap: () {
       //
       //      pressedNear=true;
       //       // Get.find<SplashController>().setNearestEstateIndex(i);
       //       //    setState(() {
       //           // cardTapped = fal
       //            showCustomSnackBar(estate[i].title);
       //            selectedIndex = i;
       //           // _pageController.animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut,);
       //
       //            _pageController.animateToPage(i, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut,);
       //
       //          // });
       //    },
       //   );


      // setState(() {
      //   _markers.add(marker);
      // });
    }



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


  nearbyPlacesList(List<Estate> _products) {

    return  PageView.builder(

        controller: _pageController,
        itemCount: _products.length,
        onPageChanged:(int value) {
          selectedIndex = value;
          _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                  double.parse( _products[selectedIndex].latitude),
                  double.parse( _products[selectedIndex].longitude)),
              zoom: 14.0,
              bearing: 45.0,
              tilt: 45.0)));

        },
        itemBuilder: (BuildContext context, int index) {
          return AnimatedBuilder(
            animation: _pageController,

            builder: (BuildContext context, Widget widget) {
              double value = 1;
              if (_pageController.position.haveDimensions) {
                value = (_pageController.page - index);
                value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);

              }

              return Center(
                child: SizedBox(
                  // height: Curves.easeInOut.transform(value) * 125.0,
                  // width: Curves.easeInOut.transform(value) * 100.0,
                  child: widget,
                ),
              );
            },
            child: InkWell(
              onTap: () async {
                cardTapped = !cardTapped;
                if (cardTapped) {
                  // tappedPlaceDetail = await MapServices()
                  //     .getPlace(allFavoritePlaces[index]['place_id']);
                  showCustomSnackBar("message");
                  setState(() {
                  });
                }



              },
              child: Stack(
                children: [
                  Center(
                    child:   EstateItem(estate: _products[index],onPressed: (){
                      Get.toNamed(RouteHelper.getDetailsRoute( _products[index].id,_products[index].userId));
                    },fav: false,),
                  )
                ],
              ),
            ),
          );
        });
  }


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