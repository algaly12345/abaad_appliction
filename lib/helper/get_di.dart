import 'dart:convert';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/chat_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/notification_controller.dart';
import 'package:abaad/controller/onboarding_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/language_model.dart';
import 'package:abaad/data/model/response/location_repo.dart';
import 'package:abaad/data/model/response/splash_repo.dart';
import 'package:abaad/data/repository/auth_repo.dart';
import 'package:abaad/data/repository/banner_repo.dart';
import 'package:abaad/data/repository/category_repo.dart';
import 'package:abaad/data/repository/chat_repo.dart';
import 'package:abaad/data/repository/estate_repo.dart';
import 'package:abaad/data/repository/language_repo.dart';
import 'package:abaad/data/repository/notification_repo.dart';
import 'package:abaad/data/repository/onboarding_repo.dart';
import 'package:abaad/data/repository/user_repo.dart';
import 'package:abaad/data/repository/zone_repo.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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
  Get.lazyPut(() => EstateRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => BannerRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => ZoneRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()));
  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OnBoardingController(onboardingRepo: Get.find()));
  Get.lazyPut(() => OnBoardingRepo());
  Get.lazyPut(() => EstateController(estateRepo: Get.find()));
  Get.lazyPut(() =>CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => BannerController(bannerRepo: Get.find()));
  Get.lazyPut(() => ZoneController(zoneRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));

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
