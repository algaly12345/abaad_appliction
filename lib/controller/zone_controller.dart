import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/banner_model.dart';
import 'package:abaad/data/model/response/city_model.dart';
import 'package:abaad/data/model/response/land_service.dart';
import 'package:abaad/data/model/response/region_model.dart';
import 'package:abaad/data/repository/banner_repo.dart';
import 'package:abaad/data/repository/zone_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneController extends GetxController implements GetxService {
  final ZoneRepo zoneRepo;
  ZoneController({@required this.zoneRepo});
  LandModel _estateModel;
  List<Features> _estateList;
  List<int> _categoryIds = [];
  List<int> _subCategoryIds = [];
  int _subCategoryIndex = 0;
  List<RegionModel> _categoryList;
  List<CityModel> _subCategoryList;
  int _categoryIndex = 0;




  LandModel get estateModel => _estateModel;
  List<Features> get estateList => _estateList;
  List<int> get categoryIds => _categoryIds;
  List<int> get subCategoryIds => _subCategoryIds;
  int get subCategoryIndex => _subCategoryIndex;
  List<RegionModel> get categoryList => _categoryList;
  List<CityModel> get subCategoryList => _subCategoryList;
  int get categoryIndex => _categoryIndex;


  Future<void> getLandList() async {


    Response response = await zoneRepo.getLandService();
   // print("land response ...............${_estateModel.features}");
    if (response.statusCode == 200) {
    {
      print("land response ............${response.body}");
        _estateModel = LandModel.fromJson(response.body);


        _estateModel.fields = LandModel.fromJson(response.body).fields;
        _estateModel.features = LandModel.fromJson(response.body).features;
        _estateModel.features.addAll(LandModel.fromJson(response.body).features);

      }
      update();
    } else {
      ApiChecker.checkApi(response);


    }
  }

  Future<void> getCategoryList() async {
    _categoryIds = [];
    _subCategoryIds = [];
    _categoryIds.add(0);
    _subCategoryIds.add(0);
    Response response = await zoneRepo.getRegionList();
    if (response.statusCode == 200) {
      _categoryList = [];
      response.body.forEach((category) => _categoryList.add(RegionModel.fromJson(category)));
      if(_categoryList != null) {
        for(int index=0; index<_categoryList.length; index++) {
          _categoryIds.add(_categoryList[index].regionId);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSubCategoryList(int categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = [];
    _subCategoryIds = [];
    _subCategoryIds.add(0);
    if(categoryID != 0) {
      Response response = await zoneRepo.getCitiesList(categoryID);
      if (response.statusCode == 200) {
        _subCategoryList = [];
        response.body.forEach((category) => _subCategoryList.add(CityModel.fromJson(category)));
        if(_subCategoryList != null) {
          for(int index=0; index<_subCategoryList.length; index++) {
            _subCategoryIds.add(_subCategoryList[index].cityId);
          }
          // if(product != null && product.categoryIds.length > 1) {
          //   setSubCategoryIndex(_subCategoryIds.indexOf(int.parse(product.categoryIds[1].id)), false);
          // }
        }
      } else {
        ApiChecker.checkApi(response);
      }
    }
    update();
  }


  void setCategoryIndex(int index, bool notify) {
    _categoryIndex = index;
    if(notify) {
      update();
    }
  }

  void setSubCategoryIndex(int index, bool notify) {
    _subCategoryIndex = index;
    if(notify) {
      update();
    }
  }
}
