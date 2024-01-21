
import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/data_view.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:abaad/view/screen/map/pick_map_screen.dart';
import 'package:abaad/view/screen/map/widget/permission_dialog.dart';
import 'package:abaad/view/screen/qr.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class EditDialog extends StatefulWidget {
  Estate estate;
  // Generate some dummy data


  EditDialog({Key key,this.estate}) : super(key: key);

  @override
  State<EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  bool _isLoggedIn;
  String like;
  int zone_id=0;

  List<String> selectedAdvantages = [];
 // List<String> alreadySelectedAdvantages = [];
  bool isLoading = false;

  int zone_value=0;
  var isSelected2 = [true, false];
  LatLng _initialPosition;
  CameraPosition _cameraPosition;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _authorizedController = TextEditingController();
  final TextEditingController _widthStreetController = TextEditingController();
  final TextEditingController _buildSpaceController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _spaceController = TextEditingController();
  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _longDescController = TextEditingController();
  final TextEditingController _documentNumberController  = TextEditingController();
  final TextEditingController _addNumberController = TextEditingController();



  final TextEditingController _northController = TextEditingController();
  final TextEditingController _westController = TextEditingController();
  final TextEditingController _eastController = TextEditingController();
  final TextEditingController _southController = TextEditingController();



  final FocusNode _northFocus = FocusNode();

  final FocusNode _westDesFocus = FocusNode();

  final FocusNode _eastFocus = FocusNode();

  final FocusNode _southFocus = FocusNode();


  final FocusNode _priceFocus = FocusNode();

  final FocusNode _shorDesFocus = FocusNode();

  final FocusNode _vatFocus = FocusNode();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _longDescFocus = FocusNode();
  final FocusNode _spaceFocus = FocusNode();
  final FocusNode _buildSpaceFocus = FocusNode();
  final FocusNode _documentNumberFocus = FocusNode();
  final FocusNode _minTimeFocus = FocusNode();
  int _typeProperties ;
  int category_id;


  String district;
  String city;



  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(double.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  final List<String> _loungeList=[
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];
  final List<String> _roomList = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];
  final List<String> _bathroomsList = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];
  final List<String> _kitchenList = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];
  int _selectedRoomIndex = 0;
  int _selectedBathroomsIndex = 0;
  int _selectedLounge=0;
  int _selectedkitchen=0;
  int _djectivePresenter=0;



  String _ageValue;

  bool isButtonEnabled = false;

  TextEditingController _textEditingController = TextEditingController();
  _onSelected(int index) {
    setState(() => _selectedRoomIndex = index);
  }
  String item;
  List<String> images;
   String initialValue;
  _onSelectedBathrooms(int index) {
    setState(() => _selectedBathroomsIndex = index);
  }


  int _selectionTypeEstate = 1;


  selectTypeEstate(int timeSelected) {
    setState(() {
      _selectionTypeEstate = timeSelected;
    });
  }

  _onSelectedlounge(int index) {
    setState(() => _selectedLounge = index);
  }

  _onSelectedkitchen(int index) {
    setState(() => _selectedkitchen = index);
  }

  int _selection = 0;



  final List<String> _interfaceist = [   "الواجهة الشمالية",
    "الواجهة الشرقية",
    "الواجهة الغربية",
    "الواجهة الجنوبية",];
  int east, west,north,south=0;
  String east_st, west_st,north_st,south_st;
  final List<String> _selectedInterfaceistItems = [];

  selectTime(int timeSelected) {
    setState(() {
      _selection = timeSelected;
    });
  }
  String network_type;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<CategoryController>().getFacilitiesList(true);
    Get.find<UserController>().getEstateByUser(1, false,widget.estate.userId );
    Get.find<CategoryController>().getAdvantages(true);
    _typeProperties= widget.estate.type_add=="for_rent"?1:0;
    category_id=widget.estate.categoryId;


   // widget.estate.priceNegotiation=="غير قابل للتفاوض"?   isSelected2.first=false: isSelected2.first=false;
    Get.find<EstateController>() .getCategoryList(widget.estate);
    if( widget.estate.priceNegotiation=="غير قابل للتفاوض"){
      _selection=2;
    }else if( widget.estate.priceNegotiation=="قابل للتفاوض"){
      _selection=1;
    }



    if( widget.estate.estate_type=="2"){
      _selectionTypeEstate=2;
    }else if( widget.estate.estate_type=="1"){
      _selectionTypeEstate=1;
    }
    if(widget.estate.ownershipType=="مفوض"){
      _djectivePresenter==0;
    }else if(widget.estate.ownershipType=="مالك"){
      _djectivePresenter==1;
    }

    Get.find<AuthController>().getZoneList();

    Get.find<LocationController>().getCategoryList();

    _initialPosition = LatLng(
      double.parse(widget.estate.latitude ?? '0'),
      double.parse(widget.estate.longitude ?? '0'),
    );
    _selectedBathroomsIndex=int.parse(widget.estate.property[0].number);
    _selectedRoomIndex=int.parse(widget.estate.property[1].number);
    _selectedLounge=int.parse(widget.estate.property[2].number);
    _selectedkitchen=int.parse(widget.estate.property[3].number);



    // if(widget.estate.interface.length > 0){
    //   north_st=widget.estate.interface[0].name;
    //   // west_st=widget.estate.interface[1].name??'';
    // }


 
    // north_st=widget.estate.interface[0].name;
    // west_st=widget.estate.interface[1].name;

    // input.split('').forEach((ch) => print(ch));

    print("----------------------------categore${widget.estate.authorization_number}");
    // zone_id=widget.estate.zoneId;
   // widget.estate.priceNegotiation=="غير قابل للتفاوض"?   isSelected2.first=false: widget.estate.priceNegotiation=="قابل للتفاوض"? isSelected2.first=true:true;

    Get.find<UserController>().getUserInfoByID(widget.estate.userId);


    if(widget.estate.users.phone != null) {
      _firstNameController.text = widget.estate.users.name ?? '';
      _phoneController.text = widget.estate.users.phone ?? '';
      _priceController.text = widget.estate.price ?? '';
      _buildSpaceController.text = widget.estate.buildSpace ?? '';


      _shortDescController.text = widget.estate.shortDescription ?? '';
      _longDescController.text = widget.estate.longDescription ?? '';
      _spaceController.text =  widget.estate.space ?? '';
      _documentNumberController.text =  widget.estate.documentNumber?? '';
      _addNumberController.text =  widget.estate.adNumber.toString()?? '';
       _authorizedController.text=widget.estate.authorization_number?? '';
      _textEditingController.text =  widget.estate.arPath?? '';
      images=widget.estate.images;
      city=widget.estate.city;

      district=widget.estate.districts;



      // _websiteController.text = userController.userInfoModel.website ?? '';
      // _instagramController.text = userController.userInfoModel.instagram?? '';

      //_typeProperties==0?"for_rent".tr:"for_sell".tr;


    }

  }







  bool _isAlreadySelected(String advantageName) {
    return widget.estate.otherAdvantages.contains(advantageName);
  }

  bool _isAnyAlreadySelected(List<String> advantageNames) {
    return advantageNames.any((name) => widget.estate.otherAdvantages.contains(name));
  }


  @override
  Widget build(BuildContext context) {


    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    return Scaffold(

      body: SingleChildScrollView(
        child: (widget.estate != null) ?
    GetBuilder<AuthController>(builder: (authController) {
      return
        GetBuilder<CategoryController>(
            builder: (categoryController) {

      return   Column(

                children: [
                  // EstateView(fromView: true,estate:widget.estate ) ,



                  SizedBox(
                      height: 35),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 7),


    GetBuilder<EstateController>(builder: (restController) {
      void updateColorBack(int index) {
        setState(() {
          categoryController.advanSelectedList[index] = !    Get.find<CategoryController>().advanSelectedList[index];
        });
      }
             return (restController.categoryList != null &&   restController.isLoading==false)? Container(
               padding: const EdgeInsets.only(right: 7.0,left: 7.0),
               child:    GetBuilder<LocationController>(builder: (locationController) {
              return   Column(
                   crossAxisAlignment: CrossAxisAlignment.start, children: [

                 SizedBox(
                     height: 35),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [




                     Text(
                       "type_property".tr,
                       style: const TextStyle(
                         fontSize: 13,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Row(
                       children: <Widget>[
                         InkWell(
                           onTap: () {
                             setState(() {
                               _selectionTypeEstate = 1;
                             });
                           },
                           child: Stack(
                             children: <Widget>[
                               Container(
                                 height: 40,
                                 color: _selectionTypeEstate == 1 ? Colors.green : Colors.white,
                               ),
                               Row(
                                 children: <Widget>[
                                   Radio(
                                     focusColor: Colors.white,
                                     groupValue: _selectionTypeEstate,
                                     onChanged: selectTypeEstate,
                                     value: 1,
                                   ),
                                   Text(
                                     "residential".tr,
                                     style: const TextStyle(
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                         InkWell(
                           onTap: () {
                             setState(() {
                               _selectionTypeEstate = 2;
                             });
                           },
                           child: Stack(
                             children: <Widget>[
                               Container(
                                 height: 40,
                                 color: _selectionTypeEstate == 2 ? Colors.green : Colors.white,
                               ),
                               Row(
                                 children: <Widget>[
                                   Radio(
                                     focusColor: Colors.white,
                                     groupValue: _selectionTypeEstate,
                                     onChanged: selectTypeEstate,
                                     value: 2,
                                   ),
                                   Text(
                                     "commercial".tr,
                                     style:const TextStyle(
                                       fontSize: 13,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         )
                       ],
                     ),
                     SizedBox(height: 7),
                     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                       Text(
                         'category'.tr,
                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                       ),
                       SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                         decoration: BoxDecoration(
                           color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                           boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                         ),
                         child: DropdownButton<int>(
                           value: restController.categoryIndex,
                           items: restController.categoryIds.map((int value) {
                             return DropdownMenuItem<int>(
                               value: restController.categoryIds.indexOf(value),
                               child: isArabic?Text(value != 0 ? restController.categoryList[(restController.categoryIds.indexOf(value)-1)].nameAr : 'Select'):Text(value != 0 ? restController.categoryList[(restController.categoryIds.indexOf(value)-1)].name   : 'Select'),
                             );
                           }).toList(),
                           onChanged: (int value) {
                             restController.setCategoryIndex(value);
                             category_id=restController.categoryList[value-1].id;
                             //  restController.getSubCategoryList(value != 0 ? restController.categoryList[value-1].id : 0, null);
                           },
                           isExpanded: true,
                           underline: SizedBox(),
                         ),
                       ),
                     ]),




                   ],
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),



                 SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                 Text(
                   'price'.tr,
                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                 ),
                 Row(children: [
                   Expanded(

                       child:Column(children: [

                         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                         MyTextField(
                           hintText: 'price'.tr,
                           size: 20,
                           controller: _priceController,
                           focusNode: _priceFocus,
                           nextFocus: _shorDesFocus,
                           inputType: TextInputType.number,
                           showBorder: true,
                           onChanged: (string) {
                             string = _formatNumber(string.replaceAll(',', ''));
                             _priceController.value = TextEditingValue(
                               text: string,
                               selection: TextSelection.collapsed(offset: string.length),
                             );
                           },
                           capitalization: TextCapitalization.words,
                         ),
                       ],)
                   ),


                   Row(
                     children: <Widget>[
                       InkWell(
                         onTap: () {
                           setState(() {
                             _selection = 1;
                           });
                         },
                         child: Stack(
                           children: <Widget>[
                             Container(
                               height: 40,
                               color: _selection == 1 ? Colors.green : Colors.white,
                             ),
                             Row(
                               children: <Widget>[
                                 Radio(
                                   focusColor: Colors.white,
                                   groupValue: _selection,
                                   onChanged: selectTime,
                                   value: 1,
                                 ),
                                 Text(
                                   "negotiate".tr,
                                   style: robotoRegular.copyWith(
                                       fontSize: Dimensions.fontSizeSmall),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       ),
                       InkWell(
                         onTap: () {
                           setState(() {
                             _selection = 2;
                           });
                         },
                         child: Stack(
                           children: <Widget>[
                             Container(
                               height: 40,
                               color: _selection == 2 ? Colors.green : Colors.white,
                             ),
                             Row(
                               children: <Widget>[
                                 Radio(
                                   focusColor: Colors.white,
                                   groupValue: _selection,
                                   onChanged: selectTime,
                                   value: 2,
                                 ),
                                 Text(
                                   "non_negotiable".tr,
                                   style: robotoRegular.copyWith(
                                       fontSize: Dimensions.fontSizeSmall),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       )
                     ],
                   ),


                   // SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                   // Expanded(child:
                   // Container(
                   //   height: 70,
                   //   padding: EdgeInsets.only(
                   //       right: 4, left: 4, top: 16,bottom: 4),
                   //   child: ToggleButtons(
                   //     borderColor: Theme
                   //         .of(context)
                   //         .primaryColor,
                   //     fillColor: Theme
                   //         .of(context)
                   //         .secondaryHeaderColor,
                   //     borderWidth: 2,
                   //     selectedBorderColor: Theme
                   //         .of(context)
                   //         .primaryColor,
                   //     selectedColor: Colors.white,
                   //     borderRadius: BorderRadius.circular(7),
                   //     onPressed: (int index) {
                   //       setState(() {
                   //         for (int buttonIndex = 0;
                   //         buttonIndex < isSelected2.length;
                   //         buttonIndex++) {
                   //           if (buttonIndex == index) {
                   //             isSelected2[buttonIndex] = true;
                   //             negotiation=true;
                   //           } else {
                   //             isSelected2[buttonIndex] = false;
                   //             negotiation=false;
                   //           }
                   //         }
                   //       });
                   //     },
                   //     isSelected: isSelected2,
                   //     children: [
                   //       Padding(
                   //         padding: EdgeInsets.all(8.0),
                   //         child: Text(
                   //           'negotiate'.tr,
                   //           style: robotoBlack.copyWith(fontSize: 11),
                   //         ),
                   //       ),
                   //       Padding(
                   //         padding: EdgeInsets.all(8.0),
                   //         child: Text(
                   //           'non_negotiable'.tr,
                   //           style: robotoBlack.copyWith(fontSize: 11),
                   //         ),
                   //       ),
                   //     ],
                   //   ),
                   // ),
                   // ),
                 ]),



                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                 Text(
                   'space'.tr,
                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                 ),
                 Row(
                   children: [
                     Expanded(
                       child: MyTextField(
                         hintText: widget.estate.category=="1"?"ادخل مساحة الارض (بامتر مربع)": 'enter_the_area'.tr,
                         size: 17,
                         controller: _spaceController,
                         focusNode: _firstNameFocus,
                         nextFocus: _phoneFocus,
                         inputType: TextInputType.number,
                         showBorder: true,
                         capitalization: TextCapitalization.words,
                       ),
                     ),
                     SizedBox(width: 3,),
                     widget.estate.category=="1"? Expanded(child:  MyTextField(
                       hintText: 'ادخل مساحة البناء(بامتر مربع)'.tr,
                       size: 17,
                       controller: _buildSpaceController,
                       focusNode: _buildSpaceFocus,
                       nextFocus: _phoneFocus,
                       inputType: TextInputType.number,
                       showBorder: true,
                       capitalization: TextCapitalization.words,
                     ),):Container()
                   ],
                 ),


                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),





                 Text(
                   'shot_description'.tr,
                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                 MyTextField(
                   hintText: 'enter_shot_description'.tr,
                   controller: _shortDescController,
                   focusNode: _shorDesFocus,
                   nextFocus: _longDescFocus ,
                   inputType: TextInputType.text,
                   size: 17,
                   capitalization: TextCapitalization.sentences,
                   showBorder: true,
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                 Text(
                   'long_description'.tr,
                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                 MyTextField(
                   hintText: 'enter_long_desc'.tr,
                   controller: _longDescController,
                   focusNode: _longDescFocus,
                   // nextFocus: _vatFocus,
                   size: 17,

                   maxLines: 4,
                   inputType: TextInputType.text,
                   capitalization: TextCapitalization.sentences,
                   showBorder: true,
                 ),
                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                 SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                  ),
                  child: DropdownButton<int>(
                    value: zone_id,
                    items: locationController.zoneIds==null?Container():locationController.zoneIds.map((int value) {
                      return DropdownMenuItem<int>(
                        value: locationController.zoneIds.indexOf(value),
                        child: isArabic?Text(value != 0 ? locationController.categoryList[(locationController.zoneIds.indexOf(value)-1)].nameAr : 'حدد المنطقة'):Text(value != 0 ? locationController.categoryList[(locationController.zoneIds.indexOf(value)-1)].name   : 'select zone'),
                      );
                    }).toList(),
                    onChanged: (int value) {
                      // setState(() {
                         zone_id = value;
                      //   showCustomSnackBar(   locationController.categoryList[value-1].id.toString());
                      //
                      // });

                     zone_value=locationController.categoryList[value-1].id;
                      locationController.setCategoryIndex(value, true);
                      //      restController.getSubCategoryList(value != 0 ? restController.categoryList[value-1].id : 0, null);
                    },
                    isExpanded: true,
                    underline: SizedBox(),
                  ),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                Container(
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child: Stack(clipBehavior: Clip.none, children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 17),
                          minMaxZoomPreference: MinMaxZoomPreference(0, 30),
                          onTap: (latLng) {


                            if( zone_id==0){
                          //    showCustomSnackBar('حدد المنطقة'.tr);
                            }else{
                              Get.toNamed(
                                RouteHelper.getPickMapRoute('add-address', false),
                                arguments: PickMapScreen(
                                  fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                  route: null, canRoute: false,
                                ),
                              );}


                          },
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          onCameraIdle: () {
                            locationController.updatePosition(_cameraPosition, true);
                          },
                          onCameraMove: ((position) => _cameraPosition = position),
                          onMapCreated: (GoogleMapController controller) {
                            locationController.setMapController(controller);

                            if( zone_id==0){
                              showCustomSnackBar('حدد المنطقة'.tr);
                            }else{
                              Get.toNamed(
                                RouteHelper.getPickMapRoute('add-address', false),
                                arguments: PickMapScreen(
                                  fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                  route: null, canRoute: false,
                                ),
                              );}

                            // if(widget.address == null) {
                            //     locationController.getCurrentLocation(true, mapController: controller);
                            // }
                          },
                        ),
                        locationController.loading ? Center(child: CircularProgressIndicator()) : SizedBox(),
                        Center(child: !locationController.loading ? Image.asset(Images.pick_marker, height: 50, width: 50)
                            : CircularProgressIndicator()),
                        Positioned(
                          bottom: 10, right: 0,
                          child: InkWell(
                            onTap: () => _checkPermission(() {

                              // locationController.getCurrentLocation(true, mapController: locationController.mapController);
                            }),
                            child: Container(
                              width: 30, height: 30,
                              margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                              child: Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10, right: 0,
                          child: InkWell(
                            onTap: () {
                              if( zone_id==0){
                                showCustomSnackBar('حدد المنطقة'.tr);
                              }else{
                                Get.toNamed(
                                  RouteHelper.getPickMapRoute('add-address', false),
                                  arguments: PickMapScreen(
                                    fromAddAddress: true, fromSignUp: false, googleMapController: locationController.mapController,
                                    route: null, canRoute: false,
                                  ),
                                );
                            }
                            },
                            child: Container(
                              width: 30, height: 30,
                              margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                              child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                            ),
                          ),
                        ),
                      ]),
                    )),



              Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [




                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      widget.estate.category=="1"?    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [



                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            "number_rooms".tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(

                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemCount:  _roomList.length, itemBuilder: (context, index) {

                              return   InkWell(
                                onTap: (){
                                  _onSelected(index);

                                },
                                child: Container(
                                  width: 50,
                                  child: Card(
                                    color: _selectedRoomIndex != null && _selectedRoomIndex == index
                                        ? Theme
                                        .of(context)
                                        .primaryColor
                                        : Colors.grey,
                                    child: Container(
                                      child: Center(child: Text("${_roomList[index]==10?"9+":_roomList[index].toString()}", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                                    ),
                                  ),
                                ),
                              );

                            }),
                          ),


                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            "number_toilets".tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(

                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemCount:  _bathroomsList.length, itemBuilder: (context, index) {


                              return   InkWell(
                                onTap: (){
                                  _onSelectedBathrooms(index);

                                },
                                child: Container(
                                  width: 50,
                                  child: Card(
                                    color: _selectedBathroomsIndex != null && _selectedBathroomsIndex == index
                                        ? Theme
                                        .of(context)
                                        .primaryColor
                                        : Colors.grey,
                                    child: Container(
                                      child: Center(child: Text("${_bathroomsList[index]==10?"9+":_bathroomsList[index].toString()}", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                                    ),
                                  ),
                                ),
                              );

                            }),
                          ),



                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Text(
                            "عدد الصالات",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.02),
                                  blurRadius: 10.0,
                                  spreadRadius: 10.0,
                                )
                              ],
                            ),
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemCount:  _loungeList.length, itemBuilder: (context, index) {


                              return   InkWell(
                                onTap: (){
                                  _onSelectedlounge(index);

                                },
                                child: Container(
                                  width: 50,
                                  child: Card(
                                    color: _selectedLounge != null && _selectedLounge == index
                                        ? Theme
                                        .of(context)
                                        .primaryColor
                                        : Colors.grey,
                                    child: Container(
                                      child: Center(child: Text("${_loungeList[index]==10?"9+":_loungeList[index].toString()}", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                                    ),
                                  ),
                                ),
                              );

                            }),
                          ),


                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            "عدد المطابخ",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.02),
                                  blurRadius: 10.0,
                                  spreadRadius: 10.0,
                                )
                              ],
                            ),
                            height: 50,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemCount:  _kitchenList.length, itemBuilder: (context, index) {


                              return   InkWell(
                                onTap: (){
                                  _onSelectedkitchen(index);

                                },
                                child: Container(
                                  width: 50,
                                  child: Card(
                                    color: _selectedkitchen != null && _selectedkitchen == index
                                        ? Theme
                                        .of(context)
                                        .primaryColor
                                        : Colors.grey,
                                    child: Container(
                                      child: Center(child: Text("${_kitchenList[index]==10?"9+":_kitchenList[index].toString()}", style: TextStyle(color: Colors.white, fontSize: 20.0),)),
                                    ),
                                  ),
                                ),
                              );

                            }),
                          ),

                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                          // Container(
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //
                          //       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //
                          //       Text(
                          //         " الواجهة".tr,
                          //         style: const TextStyle(
                          //           fontSize: 13,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //       ),
                          //       Container(
                          //         height: 50,
                          //         child: ListView.builder(
                          //           scrollDirection: Axis.horizontal,
                          //           itemCount: _interfaceist.length,
                          //           itemBuilder: (context, index) {
                          //             final item = _interfaceist[index];
                          //
                          //             return  Padding(
                          //               padding: const EdgeInsets.all(5.0),
                          //               child: TextButton(
                          //                   style:  ButtonStyle(
                          //                     backgroundColor: MaterialStateProperty.all<Color>(  _selectedInterfaceistItems.contains(item) ? Theme.of(context).primaryColor : null),
                          //                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          //
                          //                       RoundedRectangleBorder(
                          //                           borderRadius: BorderRadius.circular(4),
                          //
                          //                           side: BorderSide(color:Theme.of(context).primaryColor)
                          //                       ),),),
                          //                   onPressed: (){
                          //                     setState(() {
                          //                       if (_selectedInterfaceistItems.contains(item)) {
                          //                         _selectedInterfaceistItems.remove(item);
                          //                         if(item=="الواجهة الشمالية") {
                          //                           north = 0;
                          //                           _northController.clear();
                          //                         }else if(item=="الواجهة الشرقية"){
                          //                           east=0;
                          //                           _eastController.clear();
                          //
                          //                         }
                          //                         else if(item=="الواجهة الغربية"){
                          //                           west=0;
                          //                           _westController.clear();
                          //
                          //                         }
                          //                         else if(item=="الواجهة الجنوبية"){
                          //                           south=0;
                          //                           _southController.clear();
                          //
                          //                         }
                          //                       } else {
                          //                         _selectedInterfaceistItems.add(item);
                          //                         if(item=="الواجهة الشمالية") {
                          //                           north = 1;
                          //                         }else if(item=="الواجهة الشرقية"){
                          //                           east=1;
                          //
                          //                         }
                          //                         else if(item=="الواجهة الغربية"){
                          //                           west=1;
                          //
                          //                         }
                          //                         else if(item=="الواجهة الجنوبية"){
                          //                           south=1;
                          //
                          //                         }
                          //                       }
                          //                     });
                          //                   },
                          //                   child: Text(item,style: TextStyle(color: _selectedInterfaceistItems.contains(item) ? Theme.of(context).cardColor :Theme.of(context).primaryColor,fontSize: 15.0),)
                          //               ),
                          //             );
                          //
                          //           },
                          //         ),
                          //       ),
                          //       SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          //
                          //       Row(
                          //         mainAxisSize: MainAxisSize.max,
                          //         children: [
                          //           north==1?   Expanded( // Place `Expanded` inside `Row`
                          //             child: MyTextField(
                          //               hintText: 'ادخل عرض الشارع بالمتر'.tr,
                          //               controller: _northController,
                          //               focusNode: _northFocus,
                          //               maxLines: 1,
                          //               inputType: TextInputType.number,
                          //               capitalization: TextCapitalization.sentences,
                          //               showBorder: true,
                          //             ),
                          //           ):SizedBox(),
                          //           SizedBox(width: 3,),
                          //           east==1?  Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                          //             child: MyTextField(
                          //               hintText: 'ادخل عرض الشارع بالمتر'.tr,
                          //               controller: _eastController,
                          //               focusNode: _eastFocus,
                          //               nextFocus: _westDesFocus,
                          //               maxLines: 1,
                          //               inputType: TextInputType.number,
                          //               capitalization: TextCapitalization.sentences,
                          //               showBorder: true,
                          //             ),
                          //           ):SizedBox(),
                          //           SizedBox(width: 3,),
                          //           west==1? Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                          //             child: MyTextField(
                          //               hintText: 'ادخل عرض الشارع بالمتر'.tr,
                          //               controller: _westController,
                          //               focusNode: _westDesFocus,
                          //               nextFocus: _southFocus,
                          //               maxLines: 1,
                          //               inputType: TextInputType.number,
                          //               capitalization: TextCapitalization.sentences,
                          //               showBorder: true,
                          //             ),
                          //           ):SizedBox(),
                          //           SizedBox(width: 3,),
                          //           south==1?   Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                          //             child: MyTextField(
                          //               hintText: 'ادخل عرض الشارع بالمتر'.tr,
                          //               controller: _southController ,
                          //               focusNode: _southFocus,
                          //               nextFocus: _vatFocus,
                          //               maxLines: 1,
                          //               inputType: TextInputType.number,
                          //               capitalization: TextCapitalization.sentences,
                          //               showBorder: true,
                          //             ),
                          //           ):SizedBox(),
                          //         ],
                          //       ),
                          //
                          //       const SizedBox(
                          //           height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          //
                          //     ],
                          //   ),
                          // ),

                          // Text(
                          //   'age_of_the_property'.tr,
                          //   style: robotoRegular.copyWith(
                          //       fontSize: Dimensions.fontSizeSmall),
                          // ),
                          // const SizedBox(
                          //     height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: Dimensions.PADDING_SIZE_SMALL),
                          //   decoration: BoxDecoration(
                          //     color: Theme
                          //         .of(context)
                          //         .cardColor,
                          //     borderRadius: BorderRadius.circular(
                          //         Dimensions.RADIUS_SMALL),
                          //     boxShadow: [
                          //       BoxShadow(color: Colors.grey[Get.isDarkMode
                          //           ? 800
                          //           : 200],
                          //           spreadRadius: 2,
                          //           blurRadius: 5,
                          //           offset: Offset(0, 5))
                          //     ],
                          //   ),
                          //   child: DropdownButton<String>(
                          //     focusColor: Colors.white,
                          //     value: _ageValue,
                          //     isExpanded: true,
                          //     underline: SizedBox(),
                          //     //elevation: 5,
                          //     style: robotoRegular.copyWith(
                          //         fontSize: Dimensions.fontSizeLarge,
                          //         color: Colors.black),
                          //     iconEnabledColor: Colors.black,
                          //     items: <String>[
                          //       'اقل من سنة',
                          //       'سنة',
                          //       'سنتين',
                          //       '3 سنوات',
                          //       '4 سنوات',
                          //       '5 سنوات',
                          //       '6 سنوات',
                          //       '7 سنوات',
                          //       '8 سنوات',
                          //       '9 سنوات',
                          //       '10 سنوات',
                          //       'اكثر من 10',
                          //       'اكثر من 20'
                          //     ].map<DropdownMenuItem<String>>((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(value, style: const TextStyle(
                          //             color: Colors.black),),
                          //       );
                          //     }).toList(),
                          //     hint: Text(
                          //       "select_age_of_the_property".tr,
                          //       style: robotoRegular.copyWith(
                          //           fontSize: Dimensions.fontSizeLarge,
                          //           color: Colors.black),
                          //     ),
                          //     onChanged: (String value) {
                          //       setState(() {
                          //         _ageValue = value;
                          //       });
                          //     },
                          //   ),
                          // ),
                          //



                          Text(
                            'age_of_the_property'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              boxShadow: [
                                BoxShadow(color: Colors.grey[Get.isDarkMode
                                    ? 800
                                    : 200],
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 5))
                              ],
                            ),
                            child: DropdownButton<String>(
                              focusColor: Colors.white,
                              value: _ageValue,
                              isExpanded: true,
                              underline: SizedBox(),
                              //elevation: 5,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Colors.black),
                              iconEnabledColor: Colors.black,
                              items: <String>[
                                'جديد',
                                'سنة',
                                'سنتين',
                                '3 سنوات',
                                '4 سنوات',
                                '5 سنوات',
                                '6 سنوات',
                                '7 سنوات',
                                '8 سنوات',
                                '9 سنوات',
                                '10 سنوات',
                                'اكثر من 10',
                                'اكثر من 20'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: const TextStyle(
                                      color: Colors.black),),
                                );
                              }).toList(),
                              hint: Text(
                                widget.estate.ageEstate??  "select_age_of_the_property".tr,
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeLarge,
                                    color: Colors.black),
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  _ageValue = value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_LARGE),

                        ]
                      ):Container(),





                      /// interface
                      ///
                      /// //////
                      Text(
                        " الواجهة".tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _interfaceist.length,
                          itemBuilder: (context, index) {
                            final item = _interfaceist[index];

                            return  Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TextButton(
                                  style:  ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(  _selectedInterfaceistItems.contains(item) ? Theme.of(context).primaryColor : null),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),

                                          side: BorderSide(color:Theme.of(context).primaryColor)
                                      ),),),
                                  onPressed: (){
                                    setState(() {
                                      if (_selectedInterfaceistItems.contains(item)) {
                                        _selectedInterfaceistItems.remove(item);
                                        if(item=="الواجهة الشمالية") {
                                          north = 0;
                                          _northController.clear();
                                        }else if(item=="الواجهة الشرقية"){
                                          east=0;
                                          _eastController.clear();

                                        }
                                        else if(item=="الواجهة الغربية"){
                                          west=0;
                                          _westController.clear();

                                        }
                                        else if(item=="الواجهة الجنوبية"){
                                          south=0;
                                          _southController.clear();

                                        }
                                      } else {
                                        _selectedInterfaceistItems.add(item);
                                        if(item=="الواجهة الشمالية") {
                                          north = 1;
                                        }else if(item=="الواجهة الشرقية"){
                                          east=1;

                                        }
                                        else if(item=="الواجهة الغربية"){
                                          west=1;

                                        }
                                        else if(item=="الواجهة الجنوبية"){
                                          south=1;

                                        }
                                      }
                                    });
                                  },
                                  child: Text(item,style: TextStyle(color: _selectedInterfaceistItems.contains(item) ? Theme.of(context).cardColor :Theme.of(context).primaryColor,fontSize: 15.0),)
                              ),
                            );

                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          north==1?   Expanded( // Place `Expanded` inside `Row`
                            child: MyTextField(
                              hintText: 'ادخل عرض الشارع بالمتر'.tr,
                              controller: _northController,
                              focusNode: _northFocus,
                              maxLines: 1,
                              inputType: TextInputType.number,
                              capitalization: TextCapitalization.sentences,
                              showBorder: true,
                            ),
                          ):SizedBox(),
                          SizedBox(width: 3,),
                          east==1?  Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                            child: MyTextField(
                              hintText: 'ادخل عرض الشارع بالمتر'.tr,
                              controller: _eastController,
                              focusNode: _eastFocus,
                              nextFocus: _westDesFocus,
                              maxLines: 1,
                              inputType: TextInputType.number,
                              capitalization: TextCapitalization.sentences,
                              showBorder: true,
                            ),
                          ):SizedBox(),
                          SizedBox(width: 3,),
                          west==1? Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                            child: MyTextField(
                              hintText: 'ادخل عرض الشارع بالمتر'.tr,
                              controller: _westController,
                              focusNode: _westDesFocus,
                              nextFocus: _southFocus,
                              maxLines: 1,
                              inputType: TextInputType.number,
                              capitalization: TextCapitalization.sentences,
                              showBorder: true,
                            ),
                          ):SizedBox(),
                          SizedBox(width: 3,),
                          south==1?   Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                            child: MyTextField(
                              hintText: 'ادخل عرض الشارع بالمتر'.tr,
                              controller: _southController ,
                              focusNode: _southFocus,
                              nextFocus: _vatFocus,
                              maxLines: 1,
                              inputType: TextInputType.number,
                              capitalization: TextCapitalization.sentences,
                              showBorder: true,
                            ),
                          ):SizedBox(),
                        ],
                      ),

                      Container(

                        child:     categoryController.facilitiesList.length!=null?    Column(
                          children: [
                            ExpansionTile(
                              title: const Text("إضافة تغطية"), //add icon//children padding
                              children: [

                                Container(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.estate.networkType.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: TextButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).primaryColor),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4),
                                                side: BorderSide(color: Theme.of(context).primaryColor),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            // Handle button press
                                          },
                                          child: Row(
                                            children: [
                                              // Add an Image widget for your icon
                                              CustomImage(
                                                image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}'
                                                    '/${widget.estate.networkType[index].image}',
                                                height: 20, width: 20,
                                              ),
                                              SizedBox(width: 8), // Add spacing between icon and text
                                              Text(
                                                "${widget.estate.networkType[index].name}",
                                                style: TextStyle(color: Theme.of(context).cardColor, fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
,
                                Center(
                                  child: Container(
                                    height: 240,
                                    child:GridView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: categoryController.facilitiesList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3 ,
                                        childAspectRatio: (1/0.50),
                                      ),
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () => categoryController.addInterestSelection(index),
                                          child: Container(
                                            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                            padding: EdgeInsets.symmetric(
                                              vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL,
                                            ),
                                            decoration: BoxDecoration(
                                              color: categoryController.interestSelectedList[index] ? Theme.of(context).primaryColor
                                                  : Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
                                            ),
                                            alignment: Alignment.center,
                                            child:   Row(

                                              children: [
                                                CustomImage(
                                                  image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}'
                                                      '/${categoryController.facilitiesList[index].image}',
                                                  height: 30, width: 30,
                                                ),
                                                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                Flexible(child: Text(
                                                  categoryController.facilitiesList[index].name,
                                                  style: robotoMedium.copyWith(
                                                    fontSize: Dimensions.fontSizeExtraSmall,
                                                    color: categoryController.interestSelectedList[index] ? Theme.of(context).cardColor
                                                        : Theme.of(context).textTheme.bodyText1.color,
                                                  ),
                                                  maxLines: 2, overflow: TextOverflow.ellipsis,
                                                )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),


                              ],
                            ),

                          ],
                        ):Container(),
                      ),



                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          categoryController.advanList.length!=null?    Column(
                            children: [

                              ExpansionTile(
                                title:Text("other_advantages".tr), //add icon//children padding
                                children: [

                                  Column(
                                    children: [
                                      Container(
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount:  widget.estate.otherAdvantages.length,
                                          itemBuilder: (context, index) {


                                            return  Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: TextButton(
                                                  style:  ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>( Theme.of(context).primaryColor ),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(

                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(4),

                                                          side: BorderSide(color:Theme.of(context).primaryColor)
                                                      ),),),
                                                  onPressed: (){

                                                  },
                                                  child: Text("${widget.estate.otherAdvantages[index].name}",style: TextStyle(color:Theme.of(context).cardColor,fontSize: 15.0),)
                                              ),
                                            );

                                          },
                                        ),
                                      ),


                                      Center(
                                        child: Container(
                                          height: 240,
                                          child: GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: categoryController.advanList.length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              childAspectRatio: (1 / 0.50),
                                            ),
                                            itemBuilder: (context, index) {

                                              return InkWell(
                                                onTap: () async{
                                                  categoryController.addAdvantSelection(index);
                                                  setState(() {

                                                  });
                                            //      updateColorBack(index);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                                                    horizontal: Dimensions.PADDING_SIZE_SMALL,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: categoryController.advanSelectedList[index]
                                                        ? Theme.of(context).primaryColor
                                                        : Theme.of(context).cardColor,



                                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey[Get.isDarkMode ? 800 : 200],
                                                        blurRadius: 5,
                                                        spreadRadius: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          categoryController.advanList[index].name,
                                                          style: robotoMedium.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            color: categoryController.advanSelectedList[index]
                                                                ? Theme.of(context).cardColor
                                                                : Theme.of(context).textTheme.bodyText1.color,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),


                                ],
                              ),

                            ],
                          ):Container(),

                        ],
                      ),









                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded( // Place `Expanded` inside `Row`
                            child: InkWell(
                              onTap: () {
                                setState(() => _djectivePresenter = 0);
                              },
                              child: Container(
                                height: 41,
                                decoration: BoxDecoration(
                                    color: _djectivePresenter == 0 ? Theme
                                        .of(context)
                                        .secondaryHeaderColor : Colors
                                        .transparent,
                                    border: Border.all(
                                      width: 1, color: Colors.blue[500],),
                                    borderRadius: BorderRadius.circular(2,)
                                ),

                                child: Center(child: Text('authorized'.tr,
                                  style: robotoBlack.copyWith(fontSize: 16,
                                      color: _djectivePresenter == 0
                                          ? Colors.white
                                          : Colors.blue),)),


                              ),
                            ),
                          ),
                          SizedBox(width: 3,),
                          Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                            child: InkWell(
                              onTap: () {
                                setState(() => _djectivePresenter = 1);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: _djectivePresenter == 1 ? Theme
                                        .of(context)
                                        .secondaryHeaderColor : Colors
                                        .transparent,
                                    border: Border.all(
                                      width: 1, color: Colors.blue[500],),
                                    borderRadius: BorderRadius.circular(2,)
                                ),
                                height: 39,
                                // color: _value == 1 ? Colors.grey : Colors.transparent,
                                child: Center(child: Text('owner'.tr,
                                  style: robotoBlack.copyWith(
                                      fontSize: 16,
                                      color: _djectivePresenter == 1
                                          ? Colors.white
                                          : Colors.blue),)),


                              ),
                            ),
                          ),



                        ],
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Row(children: [
                        Expanded(

                            child:Column(children: [

                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              MyTextField(
                                hintText: 'enter_virtual_tour_link'.tr,
                                size: 20,
                                controller: _textEditingController,
                                onChanged: (value) {
                                  setState(() {
                                    isButtonEnabled = value.isNotEmpty;
                                  });
                                },
                                inputType: TextInputType.text,
                                showBorder: true,

                                capitalization: TextCapitalization.words,
                              ),



                            ],)
                        ),




                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Container(
                          height: 70,
                          padding: EdgeInsets.only(
                              right: 4, left: 4, top: 16,bottom: 4),
                          child:    ElevatedButton(
                            onPressed: isButtonEnabled
                                ? () {
                              String url = _textEditingController.text;
                              if (url.isNotEmpty) {
                                _showWebViewDialog(context, url);
                              } else {
                                // Handle empty URL input
                                print('URL is empty');
                              }
                            }
                                : null,
                            child: Text('View'),
                          ),
                        ),

                      ]),



                      Text(
                        'authorization_number'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                      ),


                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      MyTextField(
                        hintText: 'authorization_number'.tr,
                        controller: _authorizedController,
                        inputType: TextInputType.phone,

                        isEnabled: true,
                        showBorder: true,
                      ),



                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(
                        'document_number'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      MyTextField(
                        hintText: 'enter_the_document_number'.tr,
                        controller: _documentNumberController,
                        focusNode: _documentNumberFocus,

                        inputType: TextInputType.number,
                        size: 17,
                        capitalization: TextCapitalization.sentences,
                        showBorder: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      Text(
                        'ad_number'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      MyTextField(
                        hintText: 'enter_the_advertisement_number'.tr,
                        controller: _addNumberController,

                        inputType: TextInputType.number,
                        size: 17,
                        capitalization: TextCapitalization.sentences,
                        showBorder: true,
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      CustomButton(
                        onPressed: () async {

                          String _price;
                          String _shortDesc;
                          String _space;
                          String _authorized;
                          String _adNumber;
                          _authorized=_authorizedController.text.trim();
                          _price = _priceController.text.trim();
                          _shortDesc = _shortDescController.text.trim();
                          _space = _spaceController.text.trim();
                          String  property ='[{"name":"حمام", "number":"$_selectedBathroomsIndex"},{"name":"غرف نوم", "number":"$_selectedRoomIndex"},{"name":"صلات", "number":"$_selectedLounge"},{"name":"مطبخ", "number":"$_selectedkitchen"}]';
                          List<Map<String, dynamic >> _interface= [];

                            setState(() {
                              for (final item in _selectedInterfaceistItems) {
                                _interface.add({'"' + "name" + '"':'"' + item + '"','"' + "space" + '"':   item=="الواجهة الشمالية"? '"${_northController.text.toString()}"':  item=="الواجهة الشرقية"? '"${_eastController.text.toString()}"': item=="الواجهة الغربية"?'"${_westController.text.toString()}"':item=="الواجهة الجنوبية"?'"${_southController.text.toString()}"':""  });

                              }
                            });



                          List<Map<String, dynamic >> _interests = [];
                          for(int index=0; index<categoryController.facilitiesList.length; index++) {
                            if(categoryController.interestSelectedList[index]) {

                              _interests.add ({'"' + "name" + '"':'"' + categoryController.facilitiesList[index].name + '"','"' + "image" + '"':'"' + categoryController.facilitiesList[index].image + '"'});
                            }
                          }





                          List<Map<String, dynamic>> serializedAdvantages = widget.estate.otherAdvantages.map((advantage) => advantage.toJson()).toList();
                          String new_adv = jsonEncode(serializedAdvantages);



                  // showCustomSnackBar(     jsonEncode({widget.estate.otherAdvantages}));



                          List<Map<String, dynamic >> _advan= [];
                          for(int index=0; index<categoryController.advanList.length; index++) {
                            if(categoryController.advanSelectedList[index]) {

                              //   showCustomSnackBar("${categoryController.advanList[index].name }");
                              _advan.add ({'"' + "name" + '"':'"' + categoryController.advanList[index].name + '"'});
                            }
                          }






                          String otherAdvantages = (_advan != null && _advan.isNotEmpty) ? jsonEncode(_advan) :new_adv;




                          restController.updatEstate(
                              EstateBody (

                                 id: widget.estate.id.toString(),
                                  address: "${locationController.address}",
                                  space: _space,
                                  longDescription: _longDescController.text,
                                  shortDescription: _shortDesc,
                                  categoryId:category_id.toString(),
                                  ageEstate: _ageValue,
                                  arPath: _textEditingController.text,
                                   districts:  locationController.pickPosition.longitude==0.0?widget.estate.districts:locationController.district.toString(),
                                  floors: "4545",
                                  latitude: locationController.pickPosition.latitude==0.0?widget.estate.latitude:locationController.pickPosition.latitude.toString(),
                                  longitude: locationController.pickPosition.longitude==0.0?widget.estate.longitude:locationController.pickPosition.longitude.toString(),
                                  near: "near",
                                  networkType:"$_interests",
                                  ownershipType: _djectivePresenter==1?"مالك":'مفوض',
                                  property: property,
                                  serviceOffers: "serviceOffers",
                                  // facilities: "$_interests",
                                  territoryId: "1",
                                  zoneId:zone_value==0?widget.estate.zoneId.toString():zone_value.toString(),
                                  nationalAddress: "234234",
                                  user_id: widget.estate.userId.toString(),
                                  city: locationController.pickPosition.longitude==0.0?widget.estate.city.toString():locationController.city.toString(),
                                  otherAdvantages:"$_advan",
                                  // interface:widget.estate.interface.map((v) => v.toJson()).toList().toString(),
                                  streetSpace: "${_widthStreetController.text.toString()}",

                                  price: _priceController.text.toString(),
                                  buildSpace: _buildSpaceController.text.toString(),
                                  documentNumber: _documentNumberController.text.toString(),
                                authorization_number: _authorizedController.text.toString(),
                                  adNumber: _addNumberController.text.toString(),

                              //    priceNegotiation: negotiation==true?"غير قابل للتفاوض":"قابل للتفاوض" )
                             priceNegotiation: _selection==0?widget.estate.priceNegotiation: _selection!=1?"غير قابل للتفاوض":"قابل للتفاوض",
                                estate_type: _selectionTypeEstate==0?widget.estate.estate_type: _selectionTypeEstate!=1?"2":"1",
                              )
                              );


                        },
                        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        buttonText: 'update'.tr,
                      ),


                    ]),


               ])  ;   }),): Center(child: CircularProgressIndicator());

    })
            ],
          ),



                ],

              );



            })
      ;   })
                  : const SizedBox()


      ),
    );

  }






  void _showWebViewDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Web View'),
          content: Container(
            width: double.maxFinite,
            height: 300, // Adjust the height as needed
            child: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
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

}



