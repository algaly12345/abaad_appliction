import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/auto_complete_result.dart';
import 'package:abaad/data/model/response/category_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/estate_repo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EstateController extends GetxController implements GetxService {
  final EstateRepo estateRepo;
  EstateController({@required this.estateRepo});

  EstateModel _estateModel;
  List<Estate> _estateList;
  Estate _estate;
  int _categoryIndex = 0;
  List<CategoryModel> _categoryList;
  bool _isLoading = false;
  String _estateType = 'all';
  String _type = 'all';
  String _searchType = 'all';
  String _searchText = '';
  int _foodOffset = 1;
  List<int> _foodOffsetList = [];
  int _foodPageSize;
  bool _foodPaginate = false;



  EstateModel get estateModel => _estateModel;
  List<Estate> get estateList => _estateList;
  Estate get estate => _estate;
  int get categoryIndex => _categoryIndex;
  List<CategoryModel> get categoryList => _categoryList;
  bool get isLoading => _isLoading;
  String get estateType => _estateType;
  String get type => _type;
  String get searchType => _searchType;
  String get searchText => _searchText;
  int get foodOffset => _foodOffset;
  int get foodPageSize => _foodPageSize;
  bool get foodPaginate => _foodPaginate;

  Future<void> getEstateList(int offset, bool reload) async {

    if(reload) {
      _estateModel = null;
      update();
    }
    Response response = await estateRepo.getEstateList(offset, _estateType);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _estateModel = EstateModel.fromJson(response.body);
        print("estate response ...............${_estateModel.totalSize}");
      }else {
        _estateModel.totalSize = EstateModel.fromJson(response.body).totalSize;
        _estateModel.offset = EstateModel.fromJson(response.body).offset;
        _estateModel.estates.addAll(EstateModel.fromJson(response.body).estates);

      }
      update();
    } else {
      ApiChecker.checkApi(response);


    }
  }

  Future<void> getRestaurantProductList(int restaurantID, int offset, String type, bool notify) async {

    _foodOffset = offset;
    if(offset == 1 || _estateList == null) {
      _type = type;
     // _foodOffsetList = [];
      _estateList = null;
      _foodOffset = 1;
      if(notify) {
        update();
      }
    }


    Response response = await estateRepo.getRestaurantProductList(
        1, offset, type);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _estateList = [];
        }
        print("awad-------------------------------${response.body}");
        _estateList.addAll(EstateModel.fromJson(response.body).estates);
        // _foodPageSize = ProductModel.fromJson(response.body).totalSize;
        // _foodPaginate = false;
        update();
      } else {
        print("awad-------------------------------${response.body}");
        ApiChecker.checkApi(response);
      }
  }

  void setRestaurantType(String type) {
    _estateType = type;
    update();
  }


  void setCategoryList() {

    if(Get.find<CategoryController>().categoryList != null ) {
      _categoryList = [];
      _categoryList.add(CategoryModel());

      Get.find<CategoryController>().categoryList.forEach((category) {
        // if(_restaurant.categoryIds.contains(category.id)) {
          _categoryList.add(category);
          print("list_cate${category.name}");
        // }
      });
    }
  }


  void showBottomLoader() {
    _isLoading = true;
    update();
  }


  void setCategoryIndex(int index) {
    _categoryIndex = index;
    update();
  }


  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }


  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  final String key = 'AIzaSyDYQ4n3qgjC49HNL8zD-fp62SsNz5OnRjo';
  final String types = 'geocode';

  Future<List<AutoCompleteResult>> searchPlaces(String searchInput) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchInput&types=$types&key=$key';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var results = json['predictions'] as List;

    return results.map((e) => AutoCompleteResult.fromJson(e)).toList();
  }
}