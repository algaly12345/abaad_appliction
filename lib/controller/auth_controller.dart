import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/body/business_plan_body.dart';
import 'package:abaad/data/model/body/signup_body.dart';
import 'package:abaad/data/model/response/package_model.dart';
import 'package:abaad/data/model/response/response_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/data/model/response/zone_model.dart';
import 'package:abaad/data/model/response/zone_response_model.dart';
import 'package:abaad/data/repository/auth_repo.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/view/base/confirmation_dialog.dart';
import 'package:abaad/view/base/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
    _notification = authRepo.isNotificationActive();
  }

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  XFile _pickedLogo;
  XFile _pickedCover;

  // ZoneModel _zoneModel;
  List<ZoneModel> _zoneList;
  int _selectedZoneIndex = 0;
  LatLng _restaurantLocation;
  LatLng _estateLocation;
  List<int> _zoneIds;
  XFile _pickedImage;

  final List<String> _identityTypeList = ['هوية وطنية', 'سجل تجاري', 'هوية وطنية '];
  int _identityTypeIndex = 0;
  final List<String> _dmTypeList = ['مالك عقار', 'وسيط عقاري'];
  bool isFirstTime = true;
  int _dmTypeIndex = 0;

  List<String> subscriptionImages = [Images.subscription1, Images.subscription2, Images.subscription3];
  PackageModel _packageModel;
  int _activeSubscriptionIndex = 0;
  String _businessPlanStatus = 'business';
  String _secondStep= 'second_step';
  int _paymentIndex = 0;
  int _businessIndex = 0;

  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  List<ZoneModel> get zoneList => _zoneList;
  int get selectedZoneIndex => _selectedZoneIndex;
  LatLng get restaurantLocation => _restaurantLocation;
  LatLng get estateLocation => _estateLocation;
  List<int> get zoneIds => _zoneIds;
  XFile get pickedImage => _pickedImage;

  List<String> get identityTypeList => _identityTypeList;
  int get identityTypeIndex => _identityTypeIndex;
  List<String> get dmTypeList => _dmTypeList;
  int get dmTypeIndex => _dmTypeIndex;
  int get businessIndex => _businessIndex;
  String get businessPlanStatus => _businessPlanStatus;
  String get secondStep => _secondStep;
  int get activeSubscriptionIndex => _activeSubscriptionIndex;
//  ZoneModel get zoneModel => _zoneModel;
  PackageModel get packageModel => _packageModel;
  int get paymentIndex => _paymentIndex;


  void resetBusiness(){
    _businessIndex = Get.find<SplashController>().configModel.businessPlan.commission == 0 ? 1 : 0;
    _activeSubscriptionIndex = 0;
    _businessPlanStatus = 'business';
    _secondStep = 'second_step';
    isFirstTime = true;
    _paymentIndex = Get.find<SplashController>().configModel.freeTrialPeriodStatus == 0 ? 1 : 0;
  }

  void setPaymentIndex(int index){
    _paymentIndex = index;
    update();
  }

  void setBusiness(int business){
    _activeSubscriptionIndex = 0;
    _businessIndex = business;
    update();
  }
  void showBackPressedDialogue(String title){
    Get.dialog(ConfirmationDialog(icon: Images.support,
      title: title,
      description: 'are_you_sure_to_go_back'.tr, isLogOut: true,
      onYesPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute()),
    ), useSafeArea: false);
  }
  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if(!Get.find<SplashController>().configModel.customerVerification) {
        authRepo.saveUserToken(response.body["token"]);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone: phone, password: password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {

      }else {
        print('-----------------------token${response.body['token']}');
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true, '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }





  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }



  Future<void> updateZone() async {
    Response response = await authRepo.updateZone();
    if (response.statusCode == 200) {
      // Nothing to do
    } else {
      ApiChecker.checkApi(response);
    }
  }

  void selectSubscriptionCard(int index){
    _activeSubscriptionIndex = index;
    update();
  }
  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }


  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  bool clearSharedAddress() {
    return authRepo.clearSharedAddress();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }
  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    Response response = await authRepo.getZoneList();
    if (response.statusCode == 200) {
      _zoneList = [];
      response.body.forEach((zone) => _zoneList.add(ZoneModel.fromJson(zone)));
      setLocation(LatLng(
        double.parse(Get.find<SplashController>().configModel.defaultLocation.lat ?? '0'),
        double.parse(Get.find<SplashController>().configModel.defaultLocation.lng ?? '0'),
      ));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setZoneIndex(int index) {
    _selectedZoneIndex = index;
    update();
  }

  void setLocation(LatLng location) async {
    _estateLocation=location;
    ZoneResponseModel _response = await Get.find<LocationController>().getZone(
      location.latitude.toString(), location.longitude.toString(), false,
    );
    _restaurantLocation = location;
    if(_response != null && _response.isSuccess && _response.zoneIds.length > 0) {
      _restaurantLocation = location;
      _zoneIds = _response.zoneIds;
      for(int index=0; index<_zoneList.length; index++) {
        if(_zoneIds.contains(_zoneList[index].id)) {
          _selectedZoneIndex = index;
          break;
        }
      }
    }else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }



  void setIdentityTypeIndex(String identityType, bool notify) {
    int _index = 0;
    for(int index=0; index<_identityTypeList.length; index++) {
      if(_identityTypeList[index] == identityType) {
        _index = index;
        break;
      }
    }
    _identityTypeIndex = _index;
    if(notify) {
      update();
    }
  }

  void setDMTypeIndex(String dmType, bool notify) {
    _dmTypeIndex = _dmTypeList.indexOf(dmType);
    if(notify) {
      update();
    }
  }



  Future<ResponseModel> forgetPassword(String email) async {
    _isLoading = true;
    // update();
    // Response response = await authRepo.forgetPassword(email);
    //
    // ResponseModel responseModel;
    // if (response.statusCode == 200) {
    //   responseModel = ResponseModel(true, response.body["message"]);
    // } else {
    //   responseModel = ResponseModel(false, response.statusText);
    // }
    // _isLoading = false;
    // update();
    // return responseModel;
  }
  Future<ResponseModel> resetPassword(String resetToken, String number, String password, String confirmPassword) async {
    _isLoading = true;
    // update();
    // Response response = await authRepo.resetPassword(resetToken, number, password, confirmPassword);
    // ResponseModel responseModel;
    // if (response.statusCode == 200) {
    //   responseModel = ResponseModel(true, response.body["message"]);
    // } else {
    //   responseModel = ResponseModel(false, response.statusText);
    // }
    // _isLoading = false;
    // update();
    // return responseModel;
  }




  Future<ResponseModel> verifyPhone(String phone, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyPhone(phone, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }



  Future<void> registerAgent(Userinfo agentBody) async {
    _isLoading = true;
    update();

    Response response = await authRepo.registerAgent(agentBody);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getProfileRoute());
      showCustomSnackBar('registration_successful'.tr, isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> getPackageList() async {
    Response response = await authRepo.getPackageList();
    if (response.statusCode == 200) {
      _packageModel = null;
      _packageModel = PackageModel.fromJson(response.body);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> submitBusinessPlan({required int estateId})async {
    String _businessPlan;
    print("ahmed ahemd$businessIndex");
    if(businessIndex == 0){
      _businessPlan = 'commission';
      setUpBusinessPlan(BusinessPlanBody(businessPlan: _businessPlan, estateId: estateId.toString()));

    }else{
      _businessPlanStatus = 'payment';
      if(!isFirstTime) {
        if (_businessPlanStatus == 'payment' && _packageModel.packages.length != 0) {

          _businessPlan = 'subscription';
          int _packageId = _packageModel.packages[_activeSubscriptionIndex].id;
          String _payment = _paymentIndex == 0 ? 'free_trial' : 'paying_now';
          setUpBusinessPlan(BusinessPlanBody(businessPlan: _businessPlan,
              packageId: _packageId.toString(),
              estateId: estateId.toString(),
              payment: _payment),
          );

        } else if(_packageModel.packages.isEmpty && _packageModel.packages.length == 0){
          showCustomSnackBar('no_package_found'.tr);
        } else {
          showCustomSnackBar('please Select Any Process');
        }
      }else{
        isFirstTime = false;
      }
    }

    update();
  }

  Future<ResponseModel> setUpBusinessPlan(BusinessPlanBody businessPlanBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.setUpBusinessPlan(businessPlanBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _businessPlanStatus = 'complete';
      responseModel = ResponseModel(true, response.body.toString());
      Future.delayed(Duration(seconds: 2),()=> Get.offAllNamed(RouteHelper.getInitialRoute()));
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }


  void setBusinessStatus(String status){
    _businessPlanStatus = status;
    update();
  }

}