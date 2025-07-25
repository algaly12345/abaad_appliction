import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/config_model.dart';
import 'package:abaad/data/model/response/splash_repo.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController{
   SplashRepo splashRepo;
    const SplashController({required this.splashRepo});



   ConfigModel _configModel;
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  int _nearestRestaurantIndex = -1;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;
  int get nearestEstateIndex => _nearestRestaurantIndex;

  Future<bool> getConfigData() async {
    _hasConnection = true;
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if(response.statusCode == 200) {
    //  Get.offAllNamed(RouteHelper.getAccessLocationRoute('verification'));
      _configModel = ConfigModel.fromJson(response.body);

      _isSuccess = true;
    }else {
     ApiChecker.checkApi(response);
      if(response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  Future<bool> initSharedData() {
    return splashRepo.initSharedData();
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void disableIntro() {
    splashRepo.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setNearestEstateIndex(int index, {bool notify = true}) {
    _nearestRestaurantIndex = index;
    if(notify) {
      update();
    }
  }

}
