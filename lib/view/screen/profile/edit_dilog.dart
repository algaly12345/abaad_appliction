
import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:abaad/view/base/offer_list.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';
import 'package:abaad/view/screen/estate/widgets/estate_view.dart';
import 'package:abaad/view/screen/estate/widgets/interface.dart';
import 'package:abaad/view/screen/estate/widgets/near_by_view.dart';
import 'package:abaad/view/screen/estate/widgets/network_type.dart';
import 'package:abaad/view/screen/map/pick_map_screen.dart';
import 'package:abaad/view/screen/map/widget/permission_dialog.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int _value1=0;
  var isSelected2 = [true, false];
  bool negotiation;
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

  String _ageValue;
  _onSelected(int index) {
    setState(() => _selectedRoomIndex = index);
  }
  String item;
  List<String> images;
  int zone_id;
   String initialValue;
  _onSelectedBathrooms(int index) {
    setState(() => _selectedBathroomsIndex = index);
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
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
    ;




    north_st=widget.estate.interface[0].name;
    west_st=widget.estate.interface[1].name;

    // input.split('').forEach((ch) => print(ch));

    print("----------------------------categore${widget.estate.ageEstate}");
  // _value1=widget.estate.zoneId;
   // widget.estate.priceNegotiation=="غير قابل للتفاوض"?   isSelected2.first=false: widget.estate.priceNegotiation=="قابل للتفاوض"? isSelected2.first=true:true;

    Get.find<UserController>().getUserInfoByID(widget.estate.userId);

  }
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();


    if(widget.estate.users.phone != null) {
      _firstNameController.text = widget.estate.users.name ?? '';
      _phoneController.text = widget.estate.users.phone ?? '';
      _priceController.text = widget.estate.price ?? '';
      _buildSpaceController.text = widget.estate.buildSpace ?? '';


      _shortDescController.text = widget.estate.shortDescription ?? '';
      _longDescController.text = widget.estate.longDescription ?? '';
      _spaceController.text =  widget.estate.space ?? '';
      _documentNumberController.text =  widget.estate.documentNumber?? '';
      images=widget.estate.images;


      // _websiteController.text = userController.userInfoModel.website ?? '';
      // _instagramController.text = userController.userInfoModel.instagram?? '';

      //_typeProperties==0?"for_rent".tr:"for_sell".tr;


    }
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

             return (restController.categoryList != null &&   restController.isLoading==false)? Container(
               padding: const EdgeInsets.only(right: 7.0,left: 7.0),
               child:    GetBuilder<LocationController>(builder: (locationController) {
              return   Column(
                   crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text("ad_typ".tr, style: robotoRegular.copyWith(
                         fontSize: Dimensions.fontSizeDefault, color: Theme
                         .of(context)
                         .hintColor),),
                     SizedBox(height: 7),
                     Row(
                       mainAxisSize: MainAxisSize.max,
                       children: [
                         Expanded( // Place `Expanded` inside `Row`
                           child: InkWell(
                             onTap: () {
                               setState(() => _typeProperties = 0);
                             },
                             child: Container(
                               height: 39,
                               decoration: BoxDecoration(
                                   color: _typeProperties == 0 ? Theme
                                       .of(context)
                                       .secondaryHeaderColor : Colors
                                       .transparent,
                                   border: Border.all(
                                     width: 1, color: Colors.blue[500],),
                                   borderRadius: BorderRadius.circular(2,)
                               ),

                               child: Center(child: Text('for_rent'.tr,
                                 style: robotoBlack.copyWith(fontSize: 16,
                                     color: _typeProperties == 0
                                         ? Colors.white
                                         : Colors.blue),)),


                             ),
                           ),
                         ),
                         SizedBox(width: 3,),
                         Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                           child: InkWell(
                             onTap: () {
                               setState(() => _typeProperties = 1);
                             },
                             child: Container(
                               decoration: BoxDecoration(
                                   color: _typeProperties == 1 ? Theme
                                       .of(context)
                                       .secondaryHeaderColor : Colors
                                       .transparent,
                                   border: Border.all(
                                     width: 1, color: Colors.blue[500],),
                                   borderRadius: BorderRadius.circular(2,)
                               ),
                               height: 39,
                               // color: _value == 1 ? Colors.grey : Colors.transparent,
                               child: Center(child: Text('for_sell'.tr,
                                 style: robotoBlack.copyWith(fontSize: 16,
                                     color: _typeProperties == 1
                                         ? Colors.white
                                         : Colors.blue),)),


                             ),
                           ),
                         ),
                       ],
                     )
                   ],
                 ),
                 SizedBox(
                     height: 35),
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     SizedBox(height: 7),
                     Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                       Text(
                         'type_property'.tr,
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
                               child: Text(value != 0 ? restController.categoryList[(restController.categoryIds.indexOf(value)-1)].name : 'Select'),
                             );
                           }).toList(),
                           onChanged: (int value) {
                             restController.setCategoryIndex(value);
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
                                   "قابل للتفاوض",
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
                                   "غير قابل للتفاوض",
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
                   'add_photo_estate'.tr,
                   style: robotoRegular.copyWith(
                       fontSize: Dimensions.fontSizeSmall),
                 ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount:widget.estate.images.length,
                    itemBuilder: (context, index) {
                      String _baseUrl = Get.find<SplashController>().configModel.baseUrls.estateImageUrl;

                      if (index == widget.estate.images) {
                        return InkWell(
                          onTap: () => restController.pickDmImage(false, false),
                          child: Container(
                            height: 299,
                            width: 200,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              border: Border.all(color: Theme
                                  .of(context)
                                  .primaryColor, width: 2),
                            ),
                            child: Container(

                              child: Image.network(
                                "$_baseUrl/${widget.estate.images[index]}", width: 150,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        margin: const EdgeInsets.only(
                            right: Dimensions.PADDING_SIZE_SMALL),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme
                              .of(context)
                              .primaryColor, width: 2),
                          borderRadius: BorderRadius.circular(
                              Dimensions.RADIUS_SMALL),
                        ),
                        child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                Dimensions.RADIUS_SMALL),
                            child: Image.network(
                             "${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${images[index]}", width: 150,
                              height: 120,
                              fit: BoxFit.cover,
                            )
                          ),
                          // Positioned(
                          //   right: 0, top: 0,
                          //   child: InkWell(
                          //     onTap: () =>
                          //         restController.removeIdentityImage(index),
                          //     child: Padding(
                          //       padding: EdgeInsets.all(
                          //           Dimensions.PADDING_SIZE_SMALL),
                          //       child: Icon(Icons.delete_forever,
                          //           color: Colors.red),
                          //     ),
                          //   ),
                          // ),
                        ]),
                      );
                    },
                  ),
                ),

                 SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                 SizedBox(
                   height: 120,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal,
                     physics: BouncingScrollPhysics(),
                     itemCount:restController .pickedIdentities.length + 1,
                     itemBuilder: (context, index) {
                       XFile _file = index ==
                           restController.pickedIdentities.length
                           ? null
                           : restController.pickedIdentities[index];
                       if (index == restController.pickedIdentities.length) {
                         return InkWell(
                           onTap: () =>
                               restController.pickDmImage(false, false),
                           child: Container(
                             height: 299,
                             width: 200,
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(
                                   Dimensions.RADIUS_SMALL),
                               border: Border.all(color: Theme
                                   .of(context)
                                   .primaryColor, width: 2),
                             ),
                             child: Container(
                               padding: EdgeInsets.all(
                                   Dimensions.PADDING_SIZE_DEFAULT),
                               decoration: BoxDecoration(
                                 border: Border.all(width: 2, color: Theme
                                     .of(context)
                                     .primaryColor),
                                 shape: BoxShape.circle,
                               ),
                               child: Icon(Icons.camera_alt, color: Theme
                                   .of(context)
                                   .primaryColor),
                             ),
                           ),
                         );
                       }
                       return Container(
                         margin: EdgeInsets.only(
                             right: Dimensions.PADDING_SIZE_SMALL),
                         decoration: BoxDecoration(
                           border: Border.all(color: Theme
                               .of(context)
                               .primaryColor, width: 2),
                           borderRadius: BorderRadius.circular(
                               Dimensions.RADIUS_SMALL),
                         ),
                         child: Stack(children: [
                           ClipRRect(
                             borderRadius: BorderRadius.circular(
                                 Dimensions.RADIUS_SMALL),
                             child: GetPlatform.isWeb ? Image.network(
                               _file.path, width: 150,
                               height: 120,
                               fit: BoxFit.cover,
                             ) : Image.file(
                               File(_file.path), width: 150,
                               height: 120,
                               fit: BoxFit.cover,
                             ),
                           ),
                           Positioned(
                             right: 0, top: 0,
                             child: InkWell(
                               onTap: () =>
                                   restController.removeIdentityImage(index),
                               child: Padding(
                                 padding: EdgeInsets.all(
                                     Dimensions.PADDING_SIZE_SMALL),
                                 child: Icon(Icons.delete_forever,
                                     color: Colors.red),
                               ),
                             ),
                           ),
                         ]),
                       );
                     },
                   ),
                 ),



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
                    value: _value1,
                    items: locationController.zoneIds==null?Container():locationController.zoneIds.map((int value) {
                      return DropdownMenuItem<int>(
                        value: locationController.zoneIds.indexOf(value),
                        child: Text(value != 0 ? locationController.categoryList[(locationController.zoneIds.indexOf(value)-1)].name : 'حدد المنطقة'),
                      );
                    }).toList(),
                    onChanged: (int value) {
                      setState(() {
                        _value1 = value;
                      });
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


                            if( _value1==0){
                              showCustomSnackBar('حدد المنطقة'.tr);
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

                            if( _value1==0){
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
                              if( _value1==0){
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



                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          categoryController.advanList.length!=null?    Column(
                            children: [
                              ExpansionTile(
                                title:Text("other_advantages".tr), //add icon//children padding
                                children: [
                                  Center(
                                    child: Container(
                                      height: 240,
                                      child:GridView.builder(
                                        physics: BouncingScrollPhysics(),
                                        itemCount: categoryController.advanList.length,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3 ,
                                          childAspectRatio: (1/0.50),
                                        ),
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () => categoryController.addAdvantSelection(index),
                                            child: Container(
                                              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              padding: EdgeInsets.symmetric(
                                                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL,
                                              ),
                                              decoration: BoxDecoration(
                                                color: categoryController.advanSelectedList[index] || widget.estate.otherAdvantages[index]!=index ? Theme.of(context).primaryColor
                                                    : Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
                                              ),
                                              alignment: Alignment.center,
                                              child:   Row(

                                                children: [
                                                  Flexible(child: Text(
                                                    categoryController.advanList[index].name,
                                                    style: robotoMedium.copyWith(
                                                      fontSize: Dimensions.fontSizeSmall,
                                                      color: categoryController.advanSelectedList[index] || widget.estate.otherAdvantages[index]!=index ? Theme.of(context).cardColor
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

                        ],
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



