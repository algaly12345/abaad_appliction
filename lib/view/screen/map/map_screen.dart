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
import 'package:abaad/view/base/details_dilog.dart';
import 'package:abaad/view/base/discount_tag.dart';
import 'package:abaad/view/base/drawer_menu.dart';
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
import 'package:image_stack/image_stack.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool card = false;
  bool searchToggle = false;
  Set<Circle> _circles = Set<Circle>();
  bool radiusSlider = false;

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
      card=false;
      // goToTappedPlace();
      // fetchImage();
    }
  }
  int selectedIndex = 0;


  void _setCircle(LatLng point) async {


    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('raj'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
    //  getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }


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
    //      Get.find<CategoryController>().getCategoryProductList("${widget.mainCategory.id}", 0,'0',"0","0","0", offset.toString());
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
    // getUserCurrentLocation().then((value) async {
    //   CameraPosition cameraPosition = new CameraPosition(
    //     target: LatLng(value.latitude, value.longitude),
    //     zoom: 14,
    //   );
    //   _initialPosition = LatLng(
    //       value.latitude,
    //       value.longitude
    //   );
    //
    //   _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    //   setState(() {});
    // });

    _initialPosition = LatLng(
        26.451363,
        50.109046
    );

    Get.find<CategoryController>().setFilterIndex(widget.mainCategory.id,0,"0","0",0,"0");
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

  final GlobalKey<ScaffoldState> _key = GlobalKey();

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
        key: _key,
        appBar: WebMenuBar(ontop:()=>     _key.currentState.openDrawer(),),
        drawer: DrawerMenu(),
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
                      return              Stack(children: [
                        !_isNull ?_products.length>0?

                        GoogleMap(
                          initialCameraPosition:  CameraPosition(zoom: 12, target: LatLng(
                            // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                            // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                              double.parse(widget.mainCategory.longitude),
                            double.parse(widget.mainCategory.latitude),
                          )),
                          // markers: markers,
                          // myLocationEnabled: false,
                          // compassEnabled: false,
                          zoomControlsEnabled: true,
                          mapType: _currentMapType,
                          onTap: (point) {
                            tappedPoint = point;
                            _setCircle(point);
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
                                  crossAxisAlignment: CrossAxisAlignment.end,

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
                                            cardTapped=true;
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

                                                 //     categoryController.setFilterIndex(0,index,"0","0",0,"0");
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

                                    }),


                                    Container(
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
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Align(
                        //           alignment: Alignment.bottomCenter,
                        //           child:
                        //           Container(height: 200,
                        //             child:   nearbyPlacesList(_products))
                        //         ),

                        // pressedNear
                        //     ? Positioned(
                        //     bottom: 20.0,
                        //     child: Container(
                        //       // height: 300.0,
                        //       width: MediaQuery.of(context).size.width,
                        //       child:nearbyPlacesList(_products),
                        //     ))
                        //     : Container(),
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
                                // height: 300.0,
                                  width: 225.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child:Column(
                                    children: [
                                      for (int i = 0; i < _products.length; i++)
                                        ServiceProviderItem(estate:_products[i],restaurants:_products[i].serviceOffers,
                                        ),
                                    ],
                                  )

                              ),
                            ))
                            : Container(),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child:
                          Container(
                            height: 200,
                            child: GetBuilder<SplashController>(builder: (splashController) {
                              for (int i = 0; i < _products.length; i++) {
                                Estate currentCoordinate = _products[i];
                                print('Coordinate ${i+1}: (${currentCoordinate.id}, ${currentCoordinate.title})');
                                selectedIndex = i;

                              }
                              return nearbyPlacesList(_products);
                            }),
                          ),
                        ),

                      ]);
                    }
                    return
                      Stack(children: [
                !_isNull ?_products.length>0?

                GoogleMap(
                  initialCameraPosition:  CameraPosition(zoom: 12, target: LatLng(
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                    double.parse(widget.mainCategory.longitude),
                    double.parse(widget.mainCategory.latitude),
                  )),
                  markers: markers,
                  // myLocationEnabled: false,
                  // compassEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: _currentMapType,
                  onTap: (point) {
                    tappedPoint = point;
                    _setCircle(point);
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
                          crossAxisAlignment: CrossAxisAlignment.end,

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
                                              //categoryController.setFilterIndex(0,index,"0","0",0,"0");
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

                            }),


                            Container(
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
                              )),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        // Align(
        //           alignment: Alignment.bottomCenter,
        //           child:
        //           Container(height: 200,
        //             child:   nearbyPlacesList(_products))
        //         ),

                // pressedNear
                //     ? Positioned(
                //     bottom: 20.0,
                //     child: Container(
                //       // height: 300.0,
                //       width: MediaQuery.of(context).size.width,
                //       child:nearbyPlacesList(_products),
                //     ))
                //     : Container(),
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
                                // height: 300.0,
                                width: 225.0,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child:Column(
                                  children: [
                                    for (int i = 0; i < _products.length; i++)
                                    ServiceProviderItem(estate:_products[i],restaurants:_products[i].serviceOffers,
                                    ),
                                  ],
                                )

                              ),
                            ))
                            : Container(),

                        Align(
                          alignment: Alignment.bottomCenter,
                  child:
                  Container(
                    height: 200,
                    child: GetBuilder<SplashController>(builder: (splashController) {
                        for (int i = 0; i < _products.length; i++) {
                        Estate currentCoordinate = _products[i];
                        print('Coordinate ${i+1}: (${currentCoordinate.id}, ${currentCoordinate.title})');
                        selectedIndex = i;

                        }
                      return nearbyPlacesList(_products);
                    }),
                  ),
                ),

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
              infoWindow: InfoWindow( //popup info
                title: '${estate[i].title}',
                snippet: ' المساحة ${estate[i].space}',
              ),


              markerId: MarkerId('id-$i'), position: _latLng, onTap: () {
            selectedIndex = i;
            // pressedNear=true;



            // _pageController.animateToPage(i, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut,);
                print("-----------------------------------------omeromer----");

            _pageController.animateToPage(selectedIndex, duration: const Duration(milliseconds: 800), curve: Curves.easeInOut,);



          }),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){

                },
                child:  Container(


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
                      Text(currentCoordinate.price.length ==5? '${currentCoordinate.price } الف':currentCoordinate.price.length ==4? '${currentCoordinate.price } الف':currentCoordinate.price.length ==7? '${currentCoordinate.price } الف':currentCoordinate.price.length ==6? '${currentCoordinate.price } الف':currentCoordinate.price.length >=9? '${currentCoordinate.price } مليون':currentCoordinate.price,
                          style:robotoBlack.copyWith(fontSize: 9)
                      ),
                      Image.asset(currentCoordinate.serviceOffers.isEmpty?Images.vt:Images.vt_offer, height: 8, width: 8),
                    ],

                  ),
                ),
              ),

     selectedIndex==i?         Stack(
                children: [
                  Image.asset(Images.location_marker, height: 40, width: 40,color:currentCoordinate.serviceOffers.length==0?Colors.red:Colors.orange),
                  Positioned(top: 3, left: 0, right: 0, child: Center(
                    child: ClipOval(child: CustomImage(image:currentCoordinate.images.length ==0?1:"${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${currentCoordinate.images[0]}", placeholder: Images.placeholder, height: 20, width: 20, fit: BoxFit.cover)),
                  )),
                ],
              ): Stack(
       children: [
         Image.asset(Images.location_marker, height: 35, width: 35,color:currentCoordinate.serviceOffers.length==0?Theme.of(context).primaryColor:Colors.orange),
         Positioned(top: 3, left: 0, right: 0, child: Center(
           child: ClipOval(child: CustomImage(  image:currentCoordinate.images.length ==0?1:"${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${currentCoordinate.images[0]}", placeholder: Images.placeholder, height: 18, width: 18, fit: BoxFit.cover)),
         )),
       ],
     ),
            ],
          )


      ));




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



  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {
      print(value);
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  nearbyPlacesList(List<Estate> _products) {

    return  PageView.builder(

        controller: _pageController,
        itemCount: _products.length,
        onPageChanged:(int value) {


          selectedIndex = value;
          _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(
                  double.parse( _products[selectedIndex].latitude)??0  ,
                  double.parse( _products[selectedIndex].longitude)??0),
              zoom: 18.0,
              bearing: 45.0,
              tilt: 45.0)));


          if(_products[selectedIndex].serviceOffers.length >0){
            cardTapped=true;
            setState(() {

            });
          }else{
            cardTapped=false ;
            setState(() {

            });
          }


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


                        cardTapped==true;




              },
              child: Column(
                children: [
                  Column(
                    children: [
                      Container(

                        width: context.width,
                        child: _products[index].serviceOffers.length>0? SizedBox(
                          height: 35,

                          child: Container(

                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.orangeAccent),
                               color: Colors.white,
                            ),
                            child: GestureDetector(
                              onTap: () async {

                              },

                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(Images.offer_icon, height: 35, width: 40),
                                      Text("يتضمن عروض خاص مقدمة لك",style: robotoBlack.copyWith(fontSize: 11)),
                                    ],
                                  ),
                                  Center(
                                    child:      SizedBox(

                                      child: Row(
                                        children: [
                                          for (var i = 0; i < _products[index].serviceOffers.length; i++)

                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.topRight,
                                              child: ClipOval(child: CustomImage(
                                                image: '${Get.find<SplashController>().configModel.baseUrls.provider}'
                                                    '/${ _products[index].serviceOffers[i].image}',
                                                height: 27, width: 27, fit: BoxFit.cover,
                                              )),
                                            ),


                                        ],
                                      ),
                                    ),
                                    ),

                                ],
                              ),
                            ),
                          ),
                        ):SizedBox(
                          height: 35,
                        ),
                      ),
                      Center(
                        child:   EstateItem(estate: _products[index],onPressed: (){
                          // showCustomSnackBar("${ _products[index].title}");
                          Get.dialog(DettailsDilog(estate:_products[index]));
                         // Get.toNamed(RouteHelper.getDetailsRoute( _products[index].id,_products[index].userId));
                        },fav: false,),
                      ),
                    ],
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