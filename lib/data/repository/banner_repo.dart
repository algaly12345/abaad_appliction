import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
class BannerRepo {
  final ApiClient apiClient;
  BannerRepo({required this.apiClient});

  Future<Response> getBannerList(int zoneId) async {
    return await apiClient.getData("${AppConstants.BANNER_URI}?zone_id=$zoneId");
  }

}