import 'dart:convert';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/language_model.dart';
import 'package:abaad/data/model/response/splash_repo.dart';
import 'package:abaad/data/repository/auth_repo.dart';
import 'package:abaad/data/repository/language_repo.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> _languages = Map();
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> _mappedJson = json.decode(jsonStringValues);
    Map<String, String> _json = Map();
    _mappedJson.forEach((key, value) {
      _json[key] = value.toString();
    });
    _languages['${languageModel.languageCode}_${languageModel.countryCode}'] = _json;
  }
  return _languages;
}