import 'dart:convert';

import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/address_model.dart';
import 'package:abaad/data/model/response/language_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/view/screen/dashboard/dashboard_screen.dart';
import 'package:abaad/view/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;

  LocalizationController({required this.sharedPreferences, required this.apiClient}) {
    loadCurrentLanguage();
  }

  Locale _locale = Locale(AppConstants.languages[0].languageCode, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  List<LanguageModel> _languages = [];

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  List<LanguageModel> get languages => _languages;

  void setLanguage(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    if(_locale.languageCode == 'ar') {
      _isLtr = false;
    }else {
      _isLtr = true;
    }
    AddressModel addressModel;
    try {
      addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.userAddress)));
    }catch(_) {}
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.TOKEN), addressModel?.zoneIds,
      locale.languageCode,   "24.263867",
      "45.033284",
    );
    saveLanguage(_locale);



    update();

    Get.offNamed(RouteHelper.getInitialRoute());
  }

  void loadCurrentLanguage() async {
    _locale = Locale(sharedPreferences.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode,
        sharedPreferences.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode);
    _isLtr = _locale.languageCode != 'ar';
    for(int index = 0; index<AppConstants.languages.length; index++) {
      if(AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(AppConstants.languageCode, locale.languageCode);
    sharedPreferences.setString(AppConstants.countryCode, locale.countryCode);
  }

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      _languages  = [];
      _languages = AppConstants.languages;
    } else {
      _selectedIndex = -1;
      _languages = [];
      for (var language in AppConstants.languages) {
        if (language.languageName.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(language);
        }
      }
    }
    update();
  }
}