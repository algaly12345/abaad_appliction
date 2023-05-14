import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';

class EstateRepo {
  final ApiClient apiClient;
  EstateRepo({@required this.apiClient});

  Future<Response>  getEstateList(int offset, String filterBy,int user_id,categoryId) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}/all?category_id=$categoryId&offset=$offset&user_id=$user_id');
  }


  Future<Response> getLatestEstateList(String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_ESTATEURI}?type=$type');
  }


  Future<Response> getCategorisEstateList( int offset, int categoryID, String type) async {
    return await apiClient.getData(
      '${AppConstants.CATEGORY_ESTATEURI}/all?category_id=$categoryID&offset=$offset&limit=10&type=$type',
    );
  }


  Future<Response> getEstateDetails(String estateID) async {
    return await apiClient.getData('${AppConstants.ESTATE_DETAILS_URI}$estateID');
  }


  Future<Response> createEstate(EstateBody estate,List<MultipartBody> multiParts) async {
    Map<String, String> _body = Map();
    _body.addAll(<String, String>{
      'address': estate.address,
      'property': estate.property,
      'space': estate.space,
      'category_id': estate.categoryId,
      'price': estate.price,
      'long_description':estate.longDescription,
      'national_address':estate.nationalAddress,
      "zone_id":estate.zoneId,
      "districts":estate.districts,
      "network_type":estate.networkType,
      "latitude":estate.latitude,
      "longitude":estate.longitude,
      "short_description":estate.shortDescription,
      "ownership_type":estate.ownershipType,
      "user_id":estate.user_id,
      'price_negotiation':estate.priceNegotiation,
      "facilities":estate.facilities,
      "city":estate.city,
      "other_advantages":estate.otherAdvantages,
      "interface":estate.interface,
      "street_space":estate.streetSpace,
      "type_add":estate.type_add,
      "build_space":estate.buildSpace,
      "document_number":estate.documentNumber



    });

    return apiClient.postMultipartData(AppConstants.CREATE_ESATE_URI, _body,multiParts);
  }



  Future<Response> getZoneList() async {
    return await apiClient.getData(AppConstants.ZONE_ALL);
  }






}