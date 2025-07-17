
import 'dart:convert';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/data/model/response/package_model.dart';
import 'package:abaad/helper/color_coverter.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';

import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/data_view.dart';
import 'package:abaad/view/base/header_widget.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/stepper.dart';
import 'package:abaad/view/screen/estate/business_plan/widgets/subscription_card.dart';
import 'package:abaad/view/screen/estate/business_plan/widgets/success_widget.dart';
import 'package:abaad/view/screen/estate/widgets/confiram_location_view.dart';
import 'package:abaad/view/screen/estate/widgets/estate_bg_widget.dart';
import 'package:abaad/view/screen/map/pick_map_screen.dart';
import 'package:abaad/view/screen/map/widget/permission_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';



class AddEstateScreen extends StatefulWidget {
  @override
  State<AddEstateScreen> createState() => _AddEstateScreenState();
}

class _AddEstateScreenState extends State<AddEstateScreen> {
  late int currentStep = 1;
  int stepLength = 5;
  late  bool complete;
  late bool _isLoggedIn;
  late String type_properties;
  late String network_type;
  bool isCheckBoxChecked = false;


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
  final TextEditingController _totalPriceController = TextEditingController();
  final TextEditingController _addNumberController = TextEditingController();

  final TextEditingController _shortDescController = TextEditingController();
  final TextEditingController _longDescController = TextEditingController();
  final TextEditingController _deedNumberController  = TextEditingController();

  final TextEditingController _spaceController = TextEditingController();
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _longDescFocus = FocusNode();
  final FocusNode _spaceFocus = FocusNode();
  final FocusNode _buildSpaceFocus = FocusNode();
  final FocusNode _documentNumberFocus = FocusNode();

  final FocusNode _AdNumberFocus = FocusNode();

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


  //  الهيئية
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _regionCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _cityCodeController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _districtCodeController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _buildingNumberController = TextEditingController();
  final TextEditingController _additionalNumberController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  final TextEditingController _propertyTypeController = TextEditingController();
  final TextEditingController _propertyAgeController = TextEditingController();
  final TextEditingController _advertisementTypeController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();



  final TextEditingController _planNumberController = TextEditingController();




  TextEditingController northNameController = TextEditingController();
  TextEditingController northDescController = TextEditingController();
  TextEditingController northLengthController = TextEditingController();

  TextEditingController eastNameController = TextEditingController();
  TextEditingController eastDescController = TextEditingController();
  TextEditingController eastLengthController = TextEditingController();


  TextEditingController _arPathController = TextEditingController();

  TextEditingController _propertyFaceController = TextEditingController();



  TextEditingController _licenseNumberController = TextEditingController();
  TextEditingController _advertiserNumberController = TextEditingController();
  TextEditingController _advertiserTypeController = TextEditingController();



// نفس الشيء للـ west و south...


  // final TextEditingController _propertyUsagesController = TextEditingController();



//


  TextEditingController _textEditingController = TextEditingController();
  bool isButtonEnabled = false;



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
  final List<String> _interfaceist = [   "الواجهة الشمالية",
    "الواجهة الشرقية",
    "الواجهة الغربية",
    "الواجهة الجنوبية",];
  int east, west,north,south=0;
  final List<String> _selectedInterfaceistItems = [];
  int _value1=0;

  String valueChoose;
  String _ageValue;
  int _selectedRoomIndex = 0;
  int _selectedBathroomsIndex = 0;
  int _selectedLounge=0;
  int _selectedkitchen=0;
  List<String> _interests = [];
  late String interests;
  bool add=true;
  _onSelected(int index) {
    setState(() => _selectedRoomIndex = index);
  }
  late String item;

  _onSelectedBathrooms(int index) {
    setState(() => _selectedBathroomsIndex = index);
  }

  _onSelectedlounge(int index) {
    setState(() => _selectedLounge = index);
  }

  _onSelectedkitchen(int index) {
    setState(() => _selectedkitchen = index);
  }

  int fieldCount = 0;
  int nextIndex = 0;

  late String district;
  late String city;



  Future<void> getAddressFromLatLang(double lat, double log) async {
    print("omeromer");
    List<Placemark> placemark =
    await placemarkFromCoordinates(lat, log);
    Placemark place = placemark[0];
    String  _address= 'Address : ${place.locality},${place.country}';
    district=place.subLocality!;
    city=place.locality!;
  }




  late GoogleMapController mapController;
  late LatLng location; // الإحداثيات
  late double latitude;
  late double longitude;


  Future<void> loadCachedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('license_data');
    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      final lat = double.tryParse(data['location']['latitude'].toString());
      final lng = double.tryParse(data['location']['longitude'].toString());

      if (lat != null && lng != null) {
        setState(() {
          location = LatLng(lat, lng);
        });
      }
    }
  }


  Future<void> loadCoordinates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString('license_data');
    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      setState(() {
        latitude = double.tryParse(data['location']['latitude'].toString());
        longitude = double.tryParse(data['location']['longitude'].toString());
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _selectionTypeEstate=2;
    Get.find<AuthController>().getZoneList();
    Get.find<CategoryController>().getFacilitiesList(true);
    Get.find<CategoryController>().getAdvantages(true);
    if (Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);

      Get.find<CategoryController>().getPropertiesList(1);

      _isLoggedIn = Get.find<AuthController>().isLoggedIn();
      if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
        Get.find<UserController>().getUserInfo();
      }
      Get.find<UserController>().initData();

    }
    Get.find<AuthController>().getZoneList();
    Get.find<AuthController>().resetBusiness();
    Get.find<AuthController>().getPackageList();


    Get.find<LocationController>().getCategoryList();


    loadCachedDataToControllers();
    loadCachedLocation();
    loadCoordinates();

    loadLocationDataFromCache();


    loadSavedLicenseData();

  }

  Future<Map<String, dynamic>> getCachedLicenseData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('license_data');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }


  Future<void> loadLocationDataFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('license_data');

    if (jsonString != null) {
      final data = jsonDecode(jsonString);
      final location = data['location'];

      _regionController.text = location['region'] ?? '';
      _regionCodeController.text = location['regionCode']?.toString() ?? '';
      _cityController.text = location['city'] ?? '';
      _cityCodeController.text = location['cityCode']?.toString() ?? '';
      _districtController.text = location['district'] ?? '';
      _districtCodeController.text = location['districtCode']?.toString() ?? '';
      _streetController.text = location['street'] ?? '';
      _postalCodeController.text = location['postalCode']?.toString() ?? '';
      _buildingNumberController.text = location['buildingNumber']?.toString() ?? '';
      _additionalNumberController.text = location['additionalNumber']?.toString() ?? '';
      _longitudeController.text = location['longitude']?.toString() ?? '';
      _latitudeController.text = location['latitude']?.toString() ?? '';


      _addressController.text = ' ${location['region'] ?? ''}   مدينة  ${location['city'] ?? ''}  حي  ${location['district'] ?? ''} ${location['street'] ?? ''}';
    }
  }


  void loadCachedDataToControllers() async {
    Map<String, dynamic> data = await getCachedLicenseData();
    SharedPreferences prefs = await SharedPreferences.getInstance();

// تحميل بيانات data2 من الكاش
    String data2String = prefs.getString('license_data2');
    if (data != null) {
      _firstNameController.text = data['advertiserName'] ?? '';
      _phoneController.text = data['phoneNumber'] ?? '';
      _deedNumberController.text = data['deedNumber'] ?? '';
      _AdNumberFocus.requestFocus(); // اختياري إذا أردت تركيز المؤشر

      _addNumberController.text = data['adLicenseNumber'] ?? '';
      _userTypeController.text = data['advertisementType'] ?? '';
      _authorizedController.text = data['brokerageAndMarketingLicenseNumber'] ?? '';

      _spaceController.text = data['propertyArea']?.toString() ?? '';
      _widthStreetController.text = data['streetWidth']?.toString() ?? '';


      _priceController.text = data['propertyPrice']?.toString() ?? '';
      _totalPriceController.text = data['landTotalPrice']?.toString() ?? '';


      _propertyTypeController.text = data['propertyType'] ?? '';
      _propertyAgeController.text = data['propertyAge'] ?? '';
      _advertisementTypeController.text = data['advertisementType'] ?? '';


      _propertyFaceController.text = data['propertyFace'] ?? '';
      _planNumberController.text= data['planNumber'] ?? '';
      //_propertyUsagesController.text = data['propertyUsages'] ?? '';
      // واجهات العقار
      _northController.text = '';
      _southController.text = '';
      _eastController.text = '';
      _westController.text = '';

      // الموقع
      if (data['location'] != null) {
        Map<String, dynamic> location = data['location'];
        _textEditingController.text = location['district'] ?? '';
      }



      // وصف مختصر وطويل
      _shortDescController.text = 'عقار ${data['propertyType'] ?? ''} للبيع في ${data['location']['district'] ?? ''}';
      _longDescController.text = 'تفاصيل العقار:\n'
          'المساحة: ${data['propertyArea']} م²\n'
          'السعر: ${data['propertyPrice']} ريال\n'
          'واجهة: ${data['propertyFace'] ?? ''}';

      SharedPreferences prefs = await SharedPreferences.getInstance();

// تحميل بيانات data2 من الكاش
      String? data2String = prefs.getString('license_data2');
      if (data2String != null) {
        Map<String, dynamic> data2 = jsonDecode(data2String);

        _northController.text =
        '${data2['northLimitName'] ?? ''} ${data2['northLimitDescription'] ?? ''} ${data2['northLimitLengthChar'] ?? ''}';

        _southController.text =
        '${data2['southLimitName'] ?? ''} ${data2['southLimitDescription'] ?? ''} ${data2['southLimitLengthChar'] ?? ''}';

        _eastController.text =
        '${data2['eastLimitName'] ?? ''} ${data2['eastLimitDescription'] ?? ''} ${data2['eastLimitLengthChar'] ?? ''}';

        _westController.text =
        '${data2['westLimitName'] ?? ''} ${data2['westLimitDescription'] ?? ''} ${data2['westLimitLengthChar'] ?? ''}';
      }

print("-------------------------------${data2String}");

    } else {
      print('لا توجد بيانات محفوظة في الكاش');
    }
  }


  void loadSavedLicenseData() async {
    final prefs = await SharedPreferences.getInstance();
    _licenseNumberController.text = prefs.getString('numberLicense') ?? '';
    _advertiserNumberController.text = prefs.getString('advertiserNumber') ?? '';
    _advertiserTypeController.text = (prefs.getInt('advertiserTypeInput')?.toString() ?? '');
  }

  static const _locale = 'en';
  String _formatNumber(String s) => NumberFormat.decimalPattern(_locale).format(double.parse(s));
  String get _currency => NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  int _selectionTypeEstate = 1;


  selectTypeEstate(int timeSelected) {
    setState(() {
      _selectionTypeEstate = timeSelected;
    });
  }
  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    return Scaffold(


      body: Get.find<AuthController>().isLoggedIn() ? SingleChildScrollView(
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





                     return  Column(
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
                                SizedBox(
                                    height: 35),



                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    // نوع العقار + نوع الإعلان
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'نوع العقار',
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اكتب نوع العقار',
                                                controller: _propertyTypeController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'نوع الإعلان',
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اكتب نوع الإعلان',
                                                controller: _advertisementTypeController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // المنطقة + المدينة
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('المنطقة', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اسم المنطقة',
                                                controller: _regionController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('المدينة', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اسم المدينة',
                                                controller: _cityController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // الحي + الشارع
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('الحي', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اسم الحي',
                                                controller: _districtController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('الشارع', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'اسم الشارع',
                                                controller: _streetController,
                                                inputType: TextInputType.text,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 12),

                                    // رقم المبنى + كود المنطقة + خط الطول
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('المخطط', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(

                                                controller: _planNumberController,
                                                inputType: TextInputType.number,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('كود المنطقة', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'كود المنطقة',
                                                controller: _regionCodeController,
                                                inputType: TextInputType.number,
                                                showBorder: true,
                                                isEnabled: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(' الرمز البريدي', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(

                                                controller:_postalCodeController,
                                                inputType: TextInputType.number,
                                                showBorder: true,
                                                isEnabled: false,


                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                    Text(
                                      'العنوان',
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    MyTextField(

                                      controller: _addressController,

                                       isEnabled: false,

                                      inputType: TextInputType.text,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,

                                    ),
                                    SizedBox(height: 16),


                                  ],
                                )

                                ,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text('الحد الشمالي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    MyTextField(
                                      controller: _northController,
                                      isEnabled: false,
                                      inputType: TextInputType.text,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,

                                    ),
                                    SizedBox(height: 16),

                                    Text('الحد الجنوبي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    MyTextField(
                                      controller: _southController,
                                      isEnabled: false,
                                      inputType: TextInputType.text,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,

                                    ),
                                    SizedBox(height: 16),

                                    Text('الحد الشرقي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    MyTextField(
                                      controller: _eastController,
                                      isEnabled: false,
                                      inputType: TextInputType.text,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,

                                    ),
                                    SizedBox(height: 16),

                                    Text('الحد الغربي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    MyTextField(
                                      controller: _westController,
                                      isEnabled: false,
                                      inputType: TextInputType.text,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,
                                    ),
                                    SizedBox(height: 16),
                                  Text('واجهة العقار ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    MyTextField(
                                      controller: _propertyFaceController,
                                      isEnabled: false,
                                      inputType: TextInputType.text,
                                      size: 17,

                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,
                                    ),
                                    SizedBox(height: 16),
                                  ],
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
                                          initialCameraPosition: CameraPosition(
                                            target: location,
                                            zoom: 16.0,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId: const MarkerId("propertyLocation"),
                                              position: location,
                                              infoWindow: const InfoWindow(title: "موقع العقار"),
                                            ),
                                          },
                                          onMapCreated: (GoogleMapController controller) {
                                            mapController = controller;
                                          },
                                        ),

                                      ]),
                                    )),


                                // authController.zoneList != null ? SelectLocationView(
                                //     fromView: true) : Center(
                                //     child: CircularProgressIndicator()),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                _propertyTypeController.text.toString()=="ارض"?

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [



                                    // الوصف المختصر (حقل مفرد)
                                    Text(
                                      'العنوان'.tr,
                                      style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    MyTextField(
                                      hintText: 'adree',
                                      controller: _shortDescController,
                                      focusNode: _shorDesFocus,
                                      nextFocus: _longDescFocus,
                                      inputType: TextInputType.text,
                                      isEnabled: false,
                                      size: 17,
                                      capitalization: TextCapitalization.sentences,
                                      showBorder: true,
                                    ),


                                  ],
                                )    :Container(),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                                Text(
                                  'space'.tr,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                ),


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
                                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


                                          Text(

                                            _propertyTypeController.text.toString()!="ارض"?     'price'.tr:"سعر المتر ",
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
                                                    isEnabled: false,
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
                                                  right: 4, left: 4, top: 16,bottom: 4),
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







                                          _propertyTypeController.text.toString()=="ارض"?



                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                                          Text(            'إجمالي االسعر الارض ',
                                            style: robotoRegular.copyWith(
                                              fontSize: Dimensions.fontSizeLarge,
                                              color: Theme.of(context).disabledColor,

                                            ),
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          MyTextField(

                                            controller: _totalPriceController,
                                            isEnabled: false,

                                            inputType: TextInputType.text,
                                            size: 17,
                                            capitalization: TextCapitalization.sentences,
                                            showBorder: true,
                                          )

                    ],
                    ):Container(),


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
                                          //    MyTextField(
                                          //      hintText: 'enter_long_desc'.tr,
                                          //      controller: _longDescController,
                                          // //     focusNode: _longDescFocus,
                                          //
                                          //      // nextFocus: _vatFocus,
                                          //      size: 17,
                                          //      maxLines: 4,
                                          //
                                          //      inputType: TextInputType.multiline,
                                          //      capitalization: TextCapitalization.sentences,
                                          //     // showBorder: true,
                                          //    ),



                                          TextField(
                                              controller: _longDescController,
                                              keyboardType: TextInputType.multiline,
                                              maxLines: 4,
                                              focusNode: _longDescFocus,


                                              cursorColor: Theme.of(context).primaryColor,
                                              decoration: InputDecoration(
                                                  hintText: 'enter_long_desc'.tr,
                                                  isDense: true,
                                                  filled: true,
                                                  fillColor: Theme.of(context).cardColor,
                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
                                                  hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(width: 1, color: Colors.grey)
                                                  )

                                              )

                                          ),











                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                          _propertyTypeController.text.toString()!="ارض"?    Column(
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
                                                'عمر العقار',  // لابل (label)
                                                style: robotoRegular.copyWith(
                                                  fontSize: Dimensions.fontSizeSmall,
                                                  color: Theme.of(context).disabledColor,
                                                ),
                                              ),
                                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                              MyTextField(
                                                hintText: 'ادخل عمر العقار',
                                                controller: _propertyAgeController,
                                                inputType: TextInputType.number,
                                                showBorder: true,
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
                                                                            fontSize: Dimensions.fontSizeExtraSmall,
                                                                            color: categoryController.interestSelectedList[index] ? Theme.of(context).cardColor
                                                                                : Theme.of(context).textTheme.bodyLarge?.color,
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
                                                                              fontSize: Dimensions.fontSizeSmall,
                                                                              color: categoryController.advanSelectedList[index] ? Theme.of(context).cardColor
                                                                                  : Theme.of(context).textTheme.bodyLarge!.color,
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
                                    isEnabled: false,
                                  ),


                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                      Text("نوع المعلن", style: robotoRegular.copyWith(
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
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

                                            isEnabled: false,
                                            showBorder: true,
                                          ),
                                        ],
                                      ):Container(),


                                    ],
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(
                                    '  رقم وثيقة الملكية',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  MyTextField(
                                    hintText: 'enter_the_document_number'.tr,
                                    controller: _deedNumberController,
                                    focusNode: _documentNumberFocus,

                                    inputType: TextInputType.number,
                                    size: 17,
                                    capitalization: TextCapitalization.sentences,
                                    showBorder: true,
                                    isEnabled: false,
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                  Text(
                                    'رقم رخصة الاعلان',
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                  ),
                                  MyTextField(
                                    hintText: 'enter_the_advertisement_number'.tr,
                                    controller: _addNumberController,

                                    inputType: TextInputType.number,
                                    size: 17,
                                    capitalization: TextCapitalization.sentences,
                                    showBorder: true,
                                    isEnabled: false,
                                  ),
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),


                                  SizedBox(height: 16),
                                  Text('هوية الملعن'),
                                  SizedBox(height: 8),
                                  MyTextField(
                                    hintText: 'هوية الملعن',
                                    controller: _advertiserNumberController,
                                    inputType: TextInputType.text,
                                    showBorder: true,
                                    isEnabled: false,
                                  ),

                                  SizedBox(height: 16),
                                  // Text('نوع المعلن'),
                                  // SizedBox(height: 8),
                                  // MyTextField(
                                  //   // hintText: 'نوع المعلن',
                                  //   controller: _advertiserTypeController,
                                  //   inputType: TextInputType.number,
                                  //   showBorder: true,
                                  //   isEnabled: false,
                                  //   // هنا مثلا نخلي نص الحقل يظهر حسب قيمة الكونترولر
                                  //   // مثلاً لو MyTextField يسمح بتغيير النص المعروض
                                  //   // لو هو مجرد TextField عادي ممكن تستخدم decoration.hintText
                                  //   // لكن في حالتك، ممكن تعمل الآتي:
                                  //   // مثلاً لو MyTextField يعتمد على hintText فقط،
                                  //   // فممكن تغير hintText حسب القيمة
                                  //   hintText: (_advertiserTypeController.text == '1') ? 'فرد' :
                                  //   (_advertiserTypeController.text == '2') ? 'شركة' : 'نوع المعلن',
                                  // ),



                                  Row(children: [
                                    Expanded(

                                        child:Column(children: [

                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                          MyTextField(
                                            hintText: 'enter_virtual_tour_link'.tr,
                                            size: 20,
                                            controller: _arPathController,
                                            onChanged: (value) {
                                              setState(() {
                                                isButtonEnabled = value.isNotEmpty;
                                              });
                                            },
                                            inputType: TextInputType.text,
                                            showBorder: true,
                                            isEnabled: false,

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
                                          String url = _arPathController.text;
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
                                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                ]))),

                              )

                              ,

                            ):currentStep==4?
                            Container(

                                child:   Container(
                                    child: authController.businessPlanStatus == 'complete' ? SuccessWidget() : Center(
                                      child: Column(children: [

                                        SizedBox(height: 20,),
                                        Container(
                                          padding: EdgeInsets.only(right: 10 ,left: 10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20),
                                                  ),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    colors: [Colors.blue.shade700, Colors.blue.shade400],
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.question_mark    ,
                                                        size: 64,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(height: 10),
                                                      Text(
                                                        'dimension_services_request'.tr,
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                                child: Column(
                                                  children: [

                                                    buildTabContent(
                                                      isArabic ?"${Get.find<SplashController>().configModel.featureAr}":"${Get.find<SplashController>().configModel.feature}",
                                                    ),
                                                    SizedBox(height: 15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Checkbox(
                                                          value: isCheckBoxChecked,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isCheckBoxChecked = value;
                                                            });
                                                          },
                                                        ),
                                                        Text('i_agree_with'.tr),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        ElevatedButton(
                                                          onPressed: isCheckBoxChecked
                                                              ? () {
                                                            next(); // Close the dialog
                                                          }
                                                              : null,
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.green,
                                                            padding: EdgeInsets.symmetric(horizontal: 30),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'yes_want'.tr,
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                        SizedBox(width: 20),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            next();
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red,
                                                            padding: EdgeInsets.symmetric(horizontal: 30),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'i_dont_want'.tr,
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 20), // Added spacing
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )



                                      ]),
                                    ))

                            ):currentStep==5?
                            Container(

                                child: authController.businessPlanStatus == 'complete' ? SuccessWidget() : Center(
                                  child: Column(children: [
                                    // Container(
                                    //   height: 200,
                                    //   child: HeaderWidget(200, true), //let's create a common header widget
                                    // ),

                                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10),
                                      child: DataView(title: 'ad_typ'.tr,value: _typeProperties==0?"for_rent".tr:"for_sell".tr, onTap: (){}
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    type_properties!=null?  Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10),
                                      child: DataView(title: 'type_property'.tr,value: type_properties, onTap: (){}
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
                                      child: DataView(title:  _propertyTypeController.text.toString()!="ارض"?'price'.tr:"سعر المتر",value: _priceController.text.toString(), onTap: (){}
                                      ),
                                    ),

                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    _propertyTypeController.text.toString()=="ارض"?
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10),
                                      child: DataView(title: 'اجمالي سعر الارض'.tr,value: _totalPriceController.text.toString(), onTap: (){}
                                      ),
                                    ):Container(),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10),
                                      child: DataView(title: 'space'.tr,value: _spaceController.text.toString(), onTap: (){}
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10,left: 10),
                                      child: DataView(title: 'shot_description'.tr,value: _shortDescController.text.toString(), onTap: (){},
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    _propertyTypeController.text.toString()!="ارض"?Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10,left: 10),
                                          child: DataView(title: 'number_rooms'.tr,value: _selectedRoomIndex.toString(),onTap: (){}
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10,left: 10),
                                          child: DataView(title: 'number_toilets'.tr,value:_selectedBathroomsIndex.toString(),onTap: (){}
                                          ),
                                        ),
                                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                        network_type!=null?  Padding(
                                          padding: const EdgeInsets.only(right: 10,left: 10),
                                          child: DataView(title: 'network_type'.tr,value:network_type, onTap: (){},
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
                                ProfileBgWidget(circularImage: null,),
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
                                  child:  !restController.isLoading ?  CustomButton(
                                    onPressed: () {
                                      String _price;
                                      String _shortDesc;
                                      String _space;
                                      String _authorized;
                                      String _adNumber;
                                      _authorized=_authorizedController.text.trim();
                                      _price = _priceController.text.trim();
                                      _shortDesc = _shortDescController.text.trim();
                                      _space = _spaceController.text.trim();
                                      _adNumber= _addNumberController.text.trim();
                                      //   print("----------------------lat${authController.estateLocation}");
                                      //    showCustomSnackBar("----------------------lat${authController.estateLocation.longitude}");

                                      //     String property = '{"room": "44", "bathroom": 30}';
                                      String  property ='[{"name":"حمام", "number":"$_selectedBathroomsIndex"},{"name":"غرف نوم", "number":"$_selectedRoomIndex"},{"name":"صالات", "number":"$_selectedLounge"},{"name":"مطبخ", "number":"$_selectedkitchen"}]';

                                      if(currentStep==1) {

                                        if (_price.isEmpty) {
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

                                        next();


                                      }
                                      else if(currentStep==3){

                                        if(_djectivePresenter==0&&_authorized.isEmpty){
                                          showCustomSnackBar('ادخل رقم التفويض');
                                        }else if(_adNumber.isEmpty){
                                          showCustomSnackBar('ادخل رقم الإعلان'.tr);
                                        }
                                        else{
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
                                            _interface.add({'"' + "name" + '"':'"' + item + '"','"' + "space" + '"':   item=="الواجهة الشمالية"? '"${_northController.text.toString()}"':  item=="الواجهة الشرقية"? '"${_eastController.text.toString()}"': item=="الواجهة الغربية"?'"${_westController.text.toString()}"':item=="الواجهة الجنوبية"?'"${_southController.text.toString()}"':""  });

                                          }
                                        });







                                        restController.addEstate(

                                            EstateBody(
                                                address: _addressController.text.toString(),
                                                space: _space,
                                                longDescription: _longDescController.text.toString(),
                                                shortDescription: _shortDesc,
                                                // categoryId:"1",
                                                ageEstate: _propertyAgeController.text.toString(),
                                                arPath: _arPathController.text,
                                                districts: _districtController.text.toString(),
                                                floors: "4545",
                                                latitude: latitude.toString(),
                                                longitude: longitude.toString(),
                                                near: "near",
                                                networkType:"$_interests",
                                                ownershipType: _djectivePresenter==1?"مالك":'مفوض',
                                                property: property,
                                                serviceOffers: "serviceOffers",
                                                facilities: "$_interests",
                                                territoryId: "1",
                                                zoneId: _regionCodeController.text.toString(),
                                                nationalAddress: "234234",
                                                user_id: userController.userInfoModel.id.toString(),
                                                city: _cityController.text.toString(),
                                                otherAdvantages: "$_advan",
                                                interface: "$_interface",
                                                streetSpace: "${_widthStreetController.text.toString()}",

                                                price: _priceController.text.toString(),
                                                buildSpace: _buildSpaceController.text.toString(),
                                                documentNumber: _deedNumberController.text.toString(),
                                                estate_type: _selectionTypeEstate.toString(),
                                                adNumber: _addNumberController.text.toString(),
                                                priceNegotiation: negotiation==true?"غير قابل للتفاوض":"قابل للتفاوض" ,
                                                authorization_number: _authorizedController.text.toString(),


                                                feature:"$isCheckBoxChecked",



                                              propertyFace: _propertyFaceController.text.toString(),
                                              deedNumber: _deedNumberController.text.toString(),
                                              categoryName: _propertyTypeController.text.toString(),
                                              totalPrice: _totalPriceController.text.toString(),
                                              advertisementType: _advertisementTypeController.text.toString(),
                                              postalCode: _postalCodeController.text.toString(),
                                              planNumber: _planNumberController.text.toString(),
                                              northLimit: _northController.text.toString(),
                                              eastLimit: _eastController.text.toString(),
                                              westLimit: _westController.text.toString(),
                                              southLimit: _southController.text.toString(),
                                              licenseNumber:_licenseNumberController.text.toString(),


                                                advertiserNumber :_advertiserNumberController.text.toString(),

                                                idType:_advertiserTypeController.text.toString(),




                                            )

                                        );

                                        // authController.submitBusinessPlan(restaurantId: 1);
                                        //  next();
                                      }


                                    },
                                    buttonText:
                                    currentStep == stepLength ? 'confirm'.tr : 'next'.tr,

                                  ): Center(child: CircularProgressIndicator()),
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

      ): NotLoggedInScreen(),



    );



  }

  Widget paymentCart({required String title, required int index, required Function onTap}){
    return GetBuilder<AuthController>(
        builder: (authController) {
          return Stack( clipBehavior: Clip.none, children: [
            InkWell(
              onTap: null,
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
  Widget baseCardWidget(AuthController authController, BuildContext context,{ required String title, required int index, required Function onTap}){
    return InkWell(
      onTap: null,
      child: Stack(clipBehavior: Clip.none, children: [

        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              color: authController.businessIndex == index ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).cardColor,
              border: authController.businessIndex == index ? Border.all(color: Theme.of(context).primaryColor, width: 0.5) : null,
              boxShadow: authController.businessIndex == index ? null : [BoxShadow(color: Colors.indigo, offset: Offset(5, 5), blurRadius: 10)]
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
  Widget buildTabContent(String text) {
    return  SingleChildScrollView(
      child: HtmlWidget(text),
    );
  }

}

