import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CategoryRepo {
  final ApiClient apiClient;
  CategoryRepo({@required this.apiClient});

  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORIES);
  }


  Future<Response> getCategoryRestaurantList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}limit=10&offset=$offset&type=$type');
  }

}