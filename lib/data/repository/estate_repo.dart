import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class EstateRepo {
  final ApiClient apiClient;
  EstateRepo({@required this.apiClient});

  Future<Response>  getRestaurantList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}/all?offset=$offset');
  }

  Future<Response> getPopularRestaurantList(String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}?type=$type');
  }

  Future<Response> getLatestRestaurantList(String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}?type=$type');
  }


  Future<Response> getRestaurantProductList( int offset, int categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?category_id=1&offset=$offset&limit=10&type=$type',
    );
  }

}