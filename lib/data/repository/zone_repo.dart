import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class ZoneRepo {
  final ApiClient apiClient;
  ZoneRepo({@required this.apiClient});

  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_ALL);
  }

  Future<Response> getLandService() async {
    return await apiClient.getData('${AppConstants.LAND_SERVICE_URL}');
  }


  Future<Response> getRegionList() async {
    return await apiClient.getData(AppConstants.REGIONS);
  }

  Future<Response> getDistrictList(int parentID) async {
    return await apiClient.getData('${AppConstants.DISTRICT_BY_CITY}$parentID');
  }

  Future<Response> getCitiesList(int parentID) async {
    return await apiClient.getData('${AppConstants.CITIES_BY_REGIONS}$parentID');
  }


}