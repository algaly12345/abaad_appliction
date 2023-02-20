import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class EstateRepo {
  final ApiClient apiClient;
  EstateRepo({@required this.apiClient});

  Future<Response>  getEstateList(int offset, String filterBy) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}/all?offset=$offset');
  }


  Future<Response> getLatestEstateList(String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}?type=$type');
  }


  Future<Response> getCategorisEstateList( int offset, int categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?category_id=1&offset=$offset&limit=10&type=$type',
    );
  }


  Future<Response> getEstateDetails(String estateID) async {
    return await apiClient.getData('${AppConstants.ESTATE_DETAILS_URI}$estateID');
  }


  Future<Response> createEstate(Estate restaurant, XFile logo, XFile cover) async {
    return apiClient.postMultipartData(
      AppConstants.CREATE_ESATE_URI, restaurant.toJson(), [MultipartBody('logo', logo), MultipartBody('cover_photo', cover)],
    );
  }










}