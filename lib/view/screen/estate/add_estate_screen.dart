import 'dart:convert';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/package_model.dart';
import 'package:abaad/helper/color_coverter.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';

import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_dialog.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/data_view.dart';
import 'package:abaad/view/base/header_widget.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/stepper.dart';
import 'package:abaad/view/screen/auth/widget/registration_stepper_widget.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';
import 'package:abaad/view/screen/estate/business_plan/business_plan.dart';
import 'package:abaad/view/screen/estate/business_plan/widgets/subscription_card.dart';
import 'package:abaad/view/screen/estate/business_plan/widgets/success_widget.dart';
import 'package:abaad/view/screen/estate/widgets/confiram_location_view.dart';
import 'package:abaad/view/screen/estate/widgets/estate_bg_widget.dart';
import 'package:abaad/view/screen/estate/widgets/menu_option.dart';
import 'package:abaad/view/screen/profile/widget/profile_bg_widget_update.dart';
import 'package:abaad/view/screen/profile/widget/profile_card.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multiselect/multiselect.dart';



class AddEstateScreen extends StatefulWidget {
  @override
  State<AddEstateScreen> createState() => _AddEstateScreenState();
}

class _AddEstateScreenState extends State<AddEstateScreen> {
  int currentStep = 1;
  int stepLength = 5;
  bool complete;
  bool _isLoggedIn;
  String type_properties;
  String network_type;


  next() {
    if (currentStep <= stepLength) {
      goTo(currentStep + 1);
    }
  }

  back() {
    if (currentStep > 1) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
    if (currentStep > stepLength) {
      setState(() => complete = true);
    }
  }
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _longDescController = TextEditingController();

  final TextEditingController _spaceController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _longDescFocus = FocusNode();
  final FocusNode _spaceFocus = FocusNode();
  final FocusNode _buildSpaceFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  final TextEditingController _authorizedController = TextEditingController();
  final TextEditingController _widthStreetController = TextEditingController();
  final TextEditingController _buildSpaceController = TextEditingController();


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

  final FocusNode _minTimeFocus = FocusNode();


  var isSelected2 = [false, true];
  bool negotiation;


  int _typeProperties = 0;
  int _djectivePresenter=0;
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
  final List<String> _interfaceist = [   "الواجهة الشمالية",
    "الواجهة الشرقية",
    "الواجهة الغربية",
    "الواجهة الجنوبية",];
  int east, west,north,south=0;
  final List<String> _selectedInterfaceistItems = [];


  String valueChoose;
  String _ageValue;
  int _selectedRoomIndex = 0;
  int _selectedBathroomsIndex = 0;
  int _selectedLounge=0;
  List<String> _interests = [];
  String interests;
  bool add=true;
  _onSelected(int index) {
    setState(() => _selectedRoomIndex = index);
  }
  String item;

  _onSelectedBathrooms(int index) {
    setState(() => _selectedBathroomsIndex = index);
  }

  _onSelectedlounge(int index) {
    setState(() => _selectedLounge = index);
  }

  int fieldCount = 0;
  int nextIndex = 0;

  String district;
  String city;

  Future<void> getAddressFromLatLang(double lat, double log) async {
    print("omeromer");
    List<Placemark> placemark =
    await placemarkFromCoordinates(lat, log);
    Placemark place = placemark[0];
    String  _address= 'Address : ${place.locality},${place.country}';
    district=place.subLocality;
    city=place.locality;
    showCustomSnackBar("message${place.subLocality}");
    print("adress-------------------------------------${place.locality},${place.country}");
  }

  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getZoneList();
    Get.find<CategoryController>().getFacilitiesList(true);
    Get.find<CategoryController>().getAdvantages(true);
    if (Get
        .find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);

      Get.find<CategoryController>().getPropertiesList(1);

      _isLoggedIn = Get.find<AuthController>().isLoggedIn();
      if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      Get.find<UserController>().initData();

    }

    Get.find<AuthController>().resetBusiness();
    Get.find<AuthController>().getPackageList();

  }

  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(double.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;


  @override
  Widget build(BuildContext context) {


    return Scaffold(


      body: SingleChildScrollView(
        child:
      GetBuilder<AuthController>(builder: (authController) {
              return GetBuilder<EstateController>(builder: (restController) {
                return GetBuilder<CategoryController>(
               builder: (categoryController) {
       return GetBuilder<UserController>(builder: (userController) {
           if(userController.userInfoModel != null && _phoneController.text.isEmpty) {
             _firstNameController.text = userController.userInfoModel.name ?? '';
             _phoneController.text = userController.userInfoModel.phone ?? '';
         //    _userTypeController.text = userController.userInfoModel.userType ?? '';
           }
    return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            currentStep != 5? const SizedBox(height: 30):Container(),
           currentStep == 5?Container():   NumberStepper(
              totalSteps: stepLength,
              width: MediaQuery.of(context).size.width,
              curStep: currentStep,
              stepCompleteColor: Colors.blue,
              currentStepColor: Color(0xffdbecff),
              inactiveColor: Color(0xffbababa),
              lineWidth: 3.5,
            ),

            Container(


              child: currentStep <= stepLength
                  ? currentStep==1?
              Container(
                padding: const EdgeInsets.only(right: 7.0,left: 7.0),
                child:  Column(
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
                      Text("type_property".tr, style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault, color: Theme
                          .of(context)
                          .hintColor),),
                      SizedBox(height: 7),
                      GetBuilder<CategoryController>(
                          builder: (categoryController) {
                            return (categoryController.categoryList != null) ?
                            SizedBox(
                              height: 40,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryController.categoryList
                                      .length,
                                  padding: EdgeInsets.only(
                                      left: Dimensions.PADDING_SIZE_SMALL),
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    String _baseUrl = Get
                                        .find<SplashController>()
                                        .configModel
                                        .baseUrls
                                        .categoryImageUrl;
                                    return Column(
                                      children: [

                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 5, left: 5),
                                          child: InkWell(
                                            onTap: () {
                                              restController
                                                  .setCategoryIndex(categoryController.categoryList[index].id);
                                              restController
                                                  .setCategoryPostion(int.parse(categoryController.categoryList[index].position));
                                              setState(() {
                                                type_properties=categoryController.categoryList[index].name;
                                              });

                                    },
                                            child: Container(
                                              height: 40,
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 4.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: categoryController.categoryList[index].id ==
                                                        restController
                                                            .categoryIndex
                                                        ? Theme
                                                        .of(context)
                                                        .primaryColor : Colors
                                                        .black12,
                                                  width: 2
                                                ),
                                                borderRadius: BorderRadius
                                                    .circular(2.0),
                                                color: Colors.white,

                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: 26,
                                                    color: Colors.white,
                                                    child: Text(
                                                      categoryController
                                                          .categoryList[index]
                                                          .name,
                                                      style: categoryController.categoryList[index].id ==
                                                          restController
                                                              .categoryIndex
                                                          ? robotoBlack
                                                          .copyWith(
                                                          fontSize: 17)
                                                          : robotoRegular
                                                          .copyWith(
                                                          fontSize: Dimensions
                                                              .fontSizeDefault,
                                                          fontStyle: FontStyle
                                                              .normal,
                                                          color: Theme
                                                              .of(context)
                                                              .disabledColor),),
                                                  ),
                                                  SizedBox(width: 5),

                                                  CustomImage(
                                                      image: '$_baseUrl/${categoryController
                                                          .categoryList[index]
                                                          .image}',
                                                      height: 25,
                                                      width: 25,
                                                      colors: categoryController.categoryList[index].id ==
                                                          restController
                                                              .categoryIndex
                                                          ? Theme
                                                          .of(context)
                                                          .primaryColor
                                                          : Colors.black12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  }),
                            ) : Container();
                          }),
                    ],
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  authController.zoneList != null ? SelectLocationView(
                      fromView: true) : Center(
                      child: CircularProgressIndicator()),
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




                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                    Expanded(child:
                    Container(
                      height: 70,
                      padding: EdgeInsets.only(
                        right: 9, left: 9, top: 16,bottom: 4),
                      child: ToggleButtons(
                        borderColor: Theme
                            .of(context)
                            .primaryColor,
                        fillColor: Theme
                            .of(context)
                            .secondaryHeaderColor,
                        borderWidth: 2,
                        selectedBorderColor: Theme
                            .of(context)
                            .primaryColor,
                        selectedColor: Colors.white,
                        borderRadius: BorderRadius.circular(7),
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0;
                            buttonIndex < isSelected2.length;
                            buttonIndex++) {
                              if (buttonIndex == index) {
                                isSelected2[buttonIndex] = true;
                                negotiation=true;
                              } else {
                                isSelected2[buttonIndex] = false;
                                negotiation=false;
                              }
                            }
                          });
                        },
                        isSelected: isSelected2,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'negotiate'.tr,
                              style: robotoBlack.copyWith(fontSize: 11),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'non_negotiable'.tr,
                              style: robotoBlack.copyWith(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ),
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
                          hintText:restController.getCategoryPostion()==1?"ادخل مساحة الارض (بامتر مربع)": 'enter_the_area'.tr,
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
                    restController.getCategoryPostion()==1? Expanded(child:  MyTextField(
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






                ]),):currentStep==2?
              Container(
                  padding: const EdgeInsets.only(right: 10.0,left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                            Text(
                              'إرفاق صور المخطط'.tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount:restController .pickPlaned.length + 1,
                                itemBuilder: (context, index) {
                                  XFile _file = index ==
                                      restController.pickPlaned.length
                                      ? null
                                      : restController.pickPlaned[index];
                                  if (index == restController.pickPlaned.length) {
                                    return InkWell(
                                      onTap: () =>
                                          restController.pickPlanedImage(false, false),
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
                                              restController.removePlanedImage(index),
                                          child: const Padding(
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



                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            restController.getCategoryPostion()==1?    Column(
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


                                    Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

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

                                      const SizedBox(
                                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    ],
                                  ),
                                ),

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
                                      'اقل من سنة',
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
                                      "select_age_of_the_property".tr,
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
                                Container(

                                  child:     categoryController.facilitiesList.length!=null?    Column(
                                    children: [
                                      ExpansionTile(
                                        title: const Text("إضافة تغطية"), //add icon//children padding
                                        children: [
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
                                                              fontSize: Dimensions.fontSizeSmall,
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
                                                          color: categoryController.advanSelectedList[index] ? Theme.of(context).primaryColor
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
                                                                fontSize: Dimensions.fontSizeLarge,
                                                                color: categoryController.advanSelectedList[index] ? Theme.of(context).cardColor
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
                                      'اقل من سنة',
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
                                      "select_age_of_the_property".tr,
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

                              ],
                            ):Container(),









                          ]),

                    ],



                  )):currentStep==3?
              Container(
                padding: EdgeInsets.only(right: 10 ,left: 10),
                child:

                Container(
                  child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Row(children: [

                      Text(
                        'advertiser_name'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text('(${'non_changeable'.tr})', style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).errorColor,
                      )),
                    ]),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    MyTextField(
                      hintText: 'full_name'.tr,
                      controller: _firstNameController,
                      focusNode: _firstNameFocus,
                      nextFocus: _phoneFocus,
                      inputType: TextInputType.name,
                      showBorder: true,
                      isEnabled: false,
                      capitalization: TextCapitalization.words,
                    ),




                    SizedBox(height: Dimensions.PADDING_SIZE_LARGE),





                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    MyTextField(
                      hintText: 'phone'.tr,
                      controller: _phoneController,
                      focusNode: _phoneFocus,
                      inputType: TextInputType.phone,
                      showBorder: true,
                      isEnabled: true,
                    ),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
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
                                    style: robotoBlack.copyWith(fontSize: 16,
                                        color: _djectivePresenter == 1
                                            ? Colors.white
                                            : Colors.blue),)),


                                ),
                              ),
                            ),
                          ],
                        ),
                        _djectivePresenter==0?Column(
                          children: [
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

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
                          ],
                        ):Container(),


                      ],
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  ]))),
                )



              ):currentStep==4?
              Container(
                padding: EdgeInsets.only(right: 10 ,left: 10),
                child:   Container(
                    child: authController.businessPlanStatus == 'complete' ? SuccessWidget() : Center(
                      child: Column(children: [
                        Column(children: [


                          Column(children: [

                            Center(child: Text('choose_your_business_plan'.tr, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Row(children: [
                                Get.find<SplashController>().configModel.businessPlan.commission != 0 ? Expanded(
                                  child: baseCardWidget(authController, context, title: 'commission'.tr,
                                      index: 0, onTap: ()=> authController.setBusiness(0)),
                                ) : SizedBox(),
                                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                                Get.find<SplashController>().configModel.businessPlan.subscription != 0 ? Expanded(
                                  child: baseCardWidget(authController, context, title: 'subscription_base'.tr,
                                      index: 1, onTap: ()=> authController.setBusiness(1)),
                                ) : SizedBox(),
                              ]),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                            authController.businessIndex == 0 ? Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                              child: Text(
                                "${'يتم اخذ عمولة من تطبيق'.tr}  ${Get.find<SplashController>().configModel.businessName} ${'من سعر العقار  من خلال تسويق عقارك وهي'.tr} ${Get.find<SplashController>().configModel.adminCommission}% ",
                                style: robotoRegular, textAlign: TextAlign.start, textScaleFactor: 1.1,
                              ),
                            ) : Container(
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  child: Text(
                                    'subscription_package'.tr,
                                    style: robotoRegular, textAlign: TextAlign.start,
                                  ),
                                ),

                                authController.packageModel != null ? SizedBox(
                                  height: ResponsiveHelper.isDesktop(context) ? 700 : 600,
                                  child: (authController.packageModel.packages.isNotEmpty && authController.packageModel.packages.length != 0) ? Swiper(

                                    itemCount: authController.packageModel.packages.length,
                                    itemWidth: ResponsiveHelper.isDesktop(context) ? 400 : context.width * 0.8,
                                    itemHeight: 600.0,
                                    layout: SwiperLayout.STACK,
                                    onIndexChanged: (index){
                                      authController.selectSubscriptionCard(index);
                                    },
                                    itemBuilder: (BuildContext context, int index){
                                      Packages _package = authController.packageModel.packages[index];

                                      Color _color = ColorConverter.stringToColor(_package.color);

                                      return GetBuilder<AuthController>(
                                          builder: (authController) {

                                            return Stack(clipBehavior: Clip.none, children: [

                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE),
                                                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 10)],
                                                ),
                                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE, bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                                child: SubscriptionCard(index: index, authController: authController, package: _package, color: _color),
                                              ),

                                              authController.activeSubscriptionIndex == index ? Positioned(
                                                top: 5, right: -10,
                                                child: Container(
                                                  height: 40, width: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: _color, border: Border.all(color: Theme.of(context).cardColor, width: 2),
                                                  ),
                                                  child: Icon(Icons.check, color: Theme.of(context).cardColor),
                                                ),
                                              ) : SizedBox(),

                                            ]);
                                          }
                                      );
                                    },
                                  ) : Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(Images.empty_box, height: 150),
                                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                        Text('no_package_available'.tr),
                                      ]),
                                  ),
                                ) : CircularProgressIndicator(),

                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                              ]),
                            ),
                          ])
                        ]),




                        // SizedBox(
                        //   width: Dimensions.WEB_MAX_WIDTH,
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL),
                        //     child: Row(children: [
                        //       (authController.businessPlanStatus == 'payment') ? Expanded(
                        //         child: InkWell(
                        //           onTap: () {
                        //             if(authController.businessPlanStatus != 'payment'){
                        //               authController.showBackPressedDialogue('your_business_plan_not_setup_yet'.tr);
                        //             }else{
                        //               authController.setBusinessStatus('business');
                        //               if(authController.isFirstTime == false){
                        //                 authController.isFirstTime = true;
                        //               }
                        //             }
                        //           },
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
                        //             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        //               Icon(Icons.keyboard_double_arrow_left),
                        //               SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        //
                        //               Text("back".tr, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                        //             ]),
                        //           ),
                        //         ),
                        //       ) : SizedBox(),
                        //       SizedBox(width: (authController.businessPlanStatus == 'payment') ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                        //
                        //       authController.businessIndex == 0 || (authController.businessIndex == 1 && authController.packageModel.packages.length != 0) ? Expanded(child: CustomButton(
                        //         buttonText: 'next'.tr,
                        //         onPressed: () => authController.submitBusinessPlan(restaurantId: 1),
                        //       )) : SizedBox(),
                        //     ]),
                        //   ),
                        // )
                      ]),
                    ))

              ):currentStep==5?
              Container(

                  child: authController.businessPlanStatus == 'complete' ? SuccessWidget() : Center(
                    child: Column(children: [
                      Container(
                        height: 200,
                        child: HeaderWidget(200, true), //let's create a common header widget
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: DataView(title: 'ad_typ'.tr,value: _typeProperties==0?"for_rent".tr:"for_sell".tr,
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      type_properties!=null?  Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: DataView(title: 'type_property'.tr,value: type_properties,
                        ),
                      ):Container(),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                       Padding(
                        padding: EdgeInsets.only(right: 10,left: 10),
                        child: ConfirmMapView(
                            fromView: true,lat: authController.estateLocation.latitude, lot: authController.estateLocation.longitude,add: add),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: DataView(title: 'price'.tr,value: _priceController.text.toString(),
                        ),
                      ),

                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: DataView(title: 'space'.tr,value: _spaceController.text.toString(),
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      Padding(
                        padding: const EdgeInsets.only(right: 10,left: 10),
                        child: DataView(title: 'shot_description'.tr,value: _shortDescController.text.toString(),
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      restController.getCategoryPostion()==1?Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: DataView(title: 'number_rooms'.tr,value: _selectedRoomIndex.toString(),
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Padding(
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: DataView(title: 'number_toilets'.tr,value:_selectedBathroomsIndex.toString(),
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          network_type!=null?  Padding(
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: DataView(title: 'network_type'.tr,value:network_type,
                            ),
                          ):Container(),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),



                        ],
                      ):Container()

                    ]),
                  )
              ):Container()
                  : Column(
                children: [
                  ProfileBgWidget(),
                ],
              ),


            ),
               Container(
                 alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(right: 7.0,left: 7.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(

                      onPressed: currentStep == 1
                          ? null
                          : () {
                        back();
                      },
                      buttonText:'back'.tr,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {

                        String _price;
                        String _shortDesc;
                        String _space;
                        String _authorized;
                        _authorized=_authorizedController.text.trim();
                        _price = _priceController.text.trim();
                        _shortDesc = _shortDescController.text.trim();
                        _space = _spaceController.text.trim();
                     //   print("----------------------lat${authController.estateLocation}");
                   //    showCustomSnackBar("----------------------lat${authController.estateLocation.longitude}");

                   //     String property = '{"room": "44", "bathroom": 30}';
                        String  property ='[{"name":"حمام", "number":"${_selectedBathroomsIndex}"},{"name":"غرف نوم", "number":"${_selectedRoomIndex}"},{"name":"صلات", "number":"${_selectedLounge}"}]';

                        if(currentStep==1) {

                          if (restController.categoryIndex == 0) {

                            showCustomSnackBar('select_category'.tr);
                          } else if (_price.isEmpty) {
                            showCustomSnackBar('enter_price'.tr);
                          }
                          else if (_space.isEmpty) {
                            showCustomSnackBar('enter_space'.tr);
                          } else if (_shortDesc.isEmpty) {
                            showCustomSnackBar('enter_short_desc'.tr);
                          }else if(restController.pickedIdentities.length ==null) {
                            showCustomSnackBar('pleace select image estate'.tr);
                          }

                          else {
                            next();
                          }
                        }
                        else if(currentStep==2){
                         if (authController.pickedCover == null&& restController.getCategoryPostion()==5) {
                             // next();
                          showCustomSnackBar('select_plan_photo'.tr);

                        }else if(restController.getCategoryPostion()==1&&_ageValue==null){

                           showCustomSnackBar('اختر عمر العقار'.tr);
         // List<String> _interests = [];
         // for(int index=0; index<categoryController.categoryList.length; index++) {
         //   if (categoryController.interestSelectedList[index]) {
         //     _interests.add(categoryController.facilitiesList[index].name);
         //   }
         //
         // }
                         }
                         else{
                           getAddressFromLatLang(authController.estateLocation.latitude,authController.estateLocation.longitude);
                           next();
                         }


                        }
                        else if(currentStep==3){

                          if(_djectivePresenter==0&&_authorized.isEmpty){
                            showCustomSnackBar('ادخل رقم التفويض');
                          }else{
                            List<Map<String, dynamic >> _interests = [];
                            for(int index=0; index<categoryController.facilitiesList.length; index++) {
                              if(categoryController.interestSelectedList[index]) {

                                _interests.add ({'"' + "name" + '"':'"' + categoryController.facilitiesList[index].name + '"','"' + "image" + '"':'"' + categoryController.facilitiesList[index].image + '"'});
                              }
                            }



                            next();
                          }


                        }
                        else if(currentStep==4){

                     //  authController.submitBusinessPlan(estateId: 1);

                          next();
                         // next();
                        }
                        else if(currentStep==5){
                          List<Map<String, dynamic >> _interests = [];
                          for(int index=0; index<categoryController.facilitiesList.length; index++) {
                            if(categoryController.interestSelectedList[index]) {

                              _interests.add ({'"' + "name" + '"':'"' + categoryController.facilitiesList[index].name + '"','"' + "image" + '"':'"' + categoryController.facilitiesList[index].image + '"'});
                            }
                          }


                          List<Map<String, dynamic >> _advan= [];
                          for(int index=0; index<categoryController.advanList.length; index++) {
                            if(categoryController.advanSelectedList[index]) {

                              _advan.add ({'"' + "name" + '"':'"' + categoryController.advanList[index].name + '"'});
                            }
                          }

                          List<Map<String, dynamic >> _interface= [];
                          setState(() {
                            for (final item in _selectedInterfaceistItems) {
                              _interface.add({'"' + "name" + '"':'"' + item + '"'});

                            }
                          });




                          !restController.isLoading ?     restController.registerRestaurant(
                              EstateBody(
                                  type_add:_typeProperties==0?"for_sell":"for_rent" ,
                                  address: "${district} -${city}",
                                  space: _space,
                                  longDescription: _longDescController.text,
                                  shortDescription: _shortDesc,
                                  categoryId:restController.getCategoryIndex().toString(),
                                  ageEstate: _ageValue,
                                  arPath: "3434",
                                  districts: district,
                                  floors: "4545",
                                  latitude: authController.estateLocation.latitude.toString(),
                                  longitude: authController.estateLocation.longitude.toString(),
                                  near: "near",
                                  networkType:"${_interests}",
                                  ownershipType: _djectivePresenter==1?"مالك":'مفوض',
                                  property: property,
                                  serviceOffers: "serviceOffers",
                                  facilities: "${_interests}",
                                  territoryId: "1",
                                  zoneId: "1",
                                  nationalAddress: "234234",
                                  user_id: userController.userInfoModel.id.toString(),
                                  city: city,
                                  otherAdvantages: "${_advan}",
                                  interface: "${_interface}",
                                  streetSpace: "${_widthStreetController.text.toString()}",

                                  price: _priceController.text.toString(),
                                buildSpace: _buildSpaceController.text.toString(),
                                priceNegotiation: negotiation==true?"غير قابل للتفاوض":"قابل للتفاوض" )): Center(child: CircularProgressIndicator());
                         // authController.submitBusinessPlan(restaurantId: 1);
                         //  next();
                        }


                      },
                      buttonText:
                      currentStep == stepLength ? 'confirm'.tr : 'next'.tr,

                    ),
                  )
                ],
              ),
            )
          ],




       );
       });
    });
    });
    }),

      ),



    );



  }

  Widget paymentCart({@required String title, @required int index, @required Function onTap}){
    return GetBuilder<AuthController>(
        builder: (authController) {
          return Stack( clipBehavior: Clip.none, children: [
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                  border: authController.paymentIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 1) : null,
                  boxShadow: authController.paymentIndex != index ? [BoxShadow(color: Colors.grey[300], blurRadius: 10)] : null,
                  color: authController.paymentIndex == index ? Theme.of(context).primaryColor.withOpacity(0.05) : Theme.of(context).cardColor,
                ),
                alignment: Alignment.center,
                width: context.width,
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
                child: Text(title, style: robotoBold.copyWith(color: authController.paymentIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color)),
              ),
            ),

            authController.paymentIndex == index ? Positioned(
              top: -8, right: -8,
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
                child: Icon(Icons.check, size: 18, color: Theme.of(context).cardColor),
              ),
            ) : SizedBox(),
          ],
          );
        }
    );
  }

  Widget baseCardWidget(AuthController authController, BuildContext context,{ @required String title, @required int index, @required Function onTap}){
    return InkWell(
      onTap: onTap,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: authController.businessIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
              border: authController.businessIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 0.5) : null,
              boxShadow: authController.businessIndex == index ? null : [BoxShadow(color: Colors.grey[200], offset: Offset(5, 5), blurRadius: 10)]
          ),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_LARGE),
          child: Center(child: Text(title, style: robotoMedium.copyWith(color: authController.businessIndex == index ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.fontSizeDefault))),
        ),

        authController.businessIndex == index ? Positioned(
          top: -10, right: -10,
          child: Container(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Theme.of(context).primaryColor,
            ),
            child: Icon(Icons.check, size: 14, color: Theme.of(context).cardColor),
          ),
        ) : SizedBox()
      ]),
    );
  }

}

