import 'dart:async';

import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/body/business_plan_body.dart';
import 'package:abaad/data/model/body/signup_body.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(AppConstants.REGISTER_URI, signUpBody.toJson());
  }

  Future<Response> login({String phone, String password}) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, {"phone": phone, "password": password});
  }



  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_ALL);
  }



  Future<Response> updateToken() async {
    String _deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
      }
    }else {
      _deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": _deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String _deviceToken = '@';
    if(!GetPlatform.isWeb) {
      try {
        _deviceToken = await FirebaseMessaging.instance.getToken();
      }catch(e) {}
    }
    if (_deviceToken != null) {
      print('--------Device Token---------- '+_deviceToken);
    }
    return _deviceToken;
  }


  Future<Response> verifyToken(String phone, String token) async {
    return await apiClient.postData(AppConstants.VERIFY_TOKEN_URI, {"phone": phone, "reset_token": token});
  }





  Future<Response> updateZone() async {
    return await apiClient.getData(AppConstants.UPDATE_ZONE_URL);
  }

  // for  user token
  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token, null, sharedPreferences.getString(AppConstants.LANGUAGE_CODE));
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedData() {
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    apiClient.token = null;
    apiClient.updateHeader(null, null, null);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.USER_NUMBER) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
        if(isLoggedIn()) {
          FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
        }
      }
    }
    sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }




  Future<Response> verifyPhone(String phone, String otp) async {
    return await apiClient.postData(AppConstants.VERIFY_PHONE_URI, {"phone": phone, "otp": otp});
  }



  Future<Response> registerAgent(Userinfo agnetBody) async {
    return apiClient.postData(AppConstants.REGISTER_AS_AGENT, agnetBody.toJson());
  }


  Future<Response> getPackageList() async {
    return await apiClient.getData(AppConstants.RESTAURANT_PACKAGES_URI);
  }

  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody) async {
    return await apiClient.postData(AppConstants.BUSINESS_PLAN_URI, businessPlanBody.toJson());
  }


}
