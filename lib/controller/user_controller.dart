import 'dart:async';
import 'dart:convert';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/response_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/data/repository/user_repo.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  UserInfoModel _userInfoModel;
  UserInfoModel _agentInfoModel;
  XFile _pickedFile;
  bool _isLoading = false;
  EstateModel _estateModel;
  String _estateType = 'all';

  UserInfoModel get userInfoModel => _userInfoModel;
  UserInfoModel get agentInfoModel => _agentInfoModel;
  XFile get pickedFile => _pickedFile;
  bool get isLoading => _isLoading;
  EstateModel get estateModel => _estateModel;
  String get estateType => _estateType;

  var latitude = '0'.obs;
  var longitude = '0'.obs;
  var address = 'Getting Address..'.obs;
   StreamSubscription<Position> streamSubscription;


  Future<ResponseModel> getUserInfo() async {
    _pickedFile = null;
    ResponseModel _responseModel;
    Response response = await userRepo.getUserInfo();
   print("user respone =====================>${response.body}");
    if (response.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(response.body);
      print('---------------------------body${response.body}');
      _responseModel = ResponseModel(true, 'successful');
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
    return _responseModel;
  }





  Future<ResponseModel> getUserInfoByID(int id) async {
    print("mohammed  =====================>");
    _pickedFile = null;
    ResponseModel _responseModel;
    Response response = await userRepo.getUserInfoById(id);
    print("mohammed  =====================>${response.body}");
    if (response.statusCode == 200) {
      _agentInfoModel = UserInfoModel.fromJson(response.body);
      _responseModel = ResponseModel(true, 'successful');
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      ApiChecker.checkApi(response);
    }
    update();
    return _responseModel;
  }

  /*Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String password) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, password, _pickedFile);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.body);
      String message = map["message"];
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, message);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print('${response.statusCode} ${response.statusText}');
    }
    update();
    return _responseModel;
  }*/

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String token) async {
    _isLoading = true;
    update();
    ResponseModel _responseModel;
    Response response = await userRepo.updateProfile(updateUserModel, _pickedFile, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      _userInfoModel = updateUserModel;
      _responseModel = ResponseModel(true, response.bodyString);
      _pickedFile = null;
      getUserInfo();
      print(response.bodyString);
    } else {
      _responseModel = ResponseModel(false, response.statusText);
      print(response.statusText);
    }
    update();
    return _responseModel;
  }



  void pickImage() async {
    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    update();
  }

  void initData() {
    _pickedFile = null;
  }

  Future removeUser() async {
    _isLoading = true;
    update();
    Response response ;

    if (response.statusCode == 200) {
      showCustomSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));

    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }
  }


  void updateUserWithNewData(Userinfo user) {
    _userInfoModel.userinfo = user;
  }


  @override
  void onInit() async {
    super.onInit();
    getLocation();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
  }

  getLocation() async {
    bool serviceEnabled;

    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    streamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
          latitude.value = '${position.latitude}';
          longitude.value = '${position.longitude}';
          print("addressssssssssss");
          // getAddressFromLatLang(position);
        });
    print("addressssssssssss");
  }

  // Future<void> getAddressFromLatLang(Position position) async {
  //   List<Placemark> placemark =
  //   await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark place = placemark[0];
  //   address.value = ' ${place.subLocality}, ${place.locality},${place.country}';
  //   print("adress-------------------------------------${place.locality},${place.country}");
  // }


  Future<void> getEstateByUser(int offset, bool reload,int userId) async {
    if (reload) {
      _estateModel = null;
      update();
    }
    Response response = await userRepo.getEstateList(offset, _estateType,userId);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _estateModel = EstateModel.fromJson(response.body);
        print("estate response ...............${response.body}");
      } else {
        _estateModel.totalSize = EstateModel
            .fromJson(response.body)
            .totalSize;
        _estateModel.offset = EstateModel
            .fromJson(response.body)
            .offset;
        _estateModel.estates.addAll(EstateModel
            .fromJson(response.body)
            .estates);
        Get.find<EstateController>() .getCategoryList(response.body);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }


  String  transId ;
  var random = ''.obs;
  int  codeStatus ;

  void validateNafath(String idNumber,BuildContext context) async {
    _isLoading = true;
    update();
    try {
      final response = await userRepo.validateNafath(idNumber);

      codeStatus=response.statusCode;
      if (response.statusCode != 200) {
        final errorMessage = response.body['message']['message'].toString();
        Get.snackbar('Error', errorMessage);
      } else {
        transId = response.body['transId'];
        random.value = response.body['random'];
        // Handle the successful response
        print("----------${transId}");
        print("----------${random.value}");


        AwesomeDialog(
          context: context,
          btnCancelColor:Theme.of(context).primaryColor ,
          btnOkColor: Theme.of(context).primaryColor,
          barrierColor: Theme.of(context).primaryColor,
          dialogType: DialogType.SUCCES,
          borderSide:  BorderSide(
            color:Theme.of(context).primaryColor,
            width: 2,
          ),

          buttonsBorderRadius: const BorderRadius.all(
            Radius.circular(2),
          ),
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: false,
          onDissmissCallback: (type) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Dismissed by $type'),
              ),
            );
          },
          headerAnimationLoop: false,
          animType: AnimType.BOTTOMSLIDE,
          title: '${random}',
          desc: 'click_on_confirm_the_authentication_process'.tr,
          showCloseIcon: true,
          btnOkOnPress: () {
            print("--------------------------------------------idNumber-${idNumber}random  ${random} transId${transId} ");
            checkRequestStatus(idNumber,transId,random.toString());
          },
        ).show();

      }
    } catch (e) {

      Get.snackbar('Error', e.toString());
    } finally {
      _isLoading = false;
    }
  }






  Future<ResponseModel> checkRequestStatus(String nationalId, String transId, String random) async {
    final response = await userRepo.checkRequestStatus(nationalId,transId,random);

    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute() );
      showCustomSnackBar('registration_successful'.tr, isError: false);

    } else {
      final errorMessage = response.body['message']['message'].toString();
    //  Get.snackbar('Error', errorMessage);
      showCustomSnackBar(errorMessage);
      print("=============================================${errorMessage}");
      print("=============================================${response.body}");
      //throw Exception('Failed to check status: ${response.body}');
    }
  }
}


