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

  Future<Response> getCategoryProductList(int zone_id,String categoryID,int user_id,String city,String districts,String space,type_add, String offset) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?zone_id=$zone_id&category_id=$categoryID&user_id=$user_id&city=$city&districts=$districts&space=$space&type_add=$type_add&offset=$offset',
    );
  }

  Future<Response> getCategoryRestaurantList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}limit=10&offset=$offset&type=$type');
  }


  Future<Response> getProperties(int categoryID) async {
    return await apiClient.getData('${AppConstants.PROPERTIES_URI}?category_id=$categoryID');
  }

  Future<Response> getFacilities() async {
    return await apiClient.getData(AppConstants.FACILITIES);
  }



  Future<Response> getAdvantages() async {
    return await apiClient.getData(AppConstants.ADVANTAGES);
  }

}