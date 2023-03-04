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


  Future<Response> createEstate(EstateBody estate,XFile cover) async {
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
      "facilities":estate.facilities


    });


    // address = json['address'];
    // property = json['property'];
    //
    // space = json['space'];
    // categoryId = json['category_id'];
    // price = json['price'];
    // ownershipType = json['ownership_type'];
    // districts = json['districts'];
    // networkType = json['network_type'];
    // serviceOffers = json['service_offers'];
    //
    //
    // arPath = json['ar_path'];
    // latitude = json['latitude'];
    // longitude = json['longitude'];
    // zoneId = json['zone_id'];
    // forRent = json['for_rent'];
    // forSell = json['for_sell'];
    // territoryId = json['territory_id'];
    // ageEstate = json['age_estate'];
    // shortDescription = json['short_description'];
    // longDescription=json['long_description'];
    // floors = json['floors'];
    // near = json['near'];
    // priceNegotiation=json['price_negotiation'];
    return apiClient.postMultipartData(


      AppConstants.CREATE_ESATE_URI, _body, [ MultipartBody('cover_photo', cover)],
    );
  }










}