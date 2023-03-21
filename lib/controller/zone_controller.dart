import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/banner_model.dart';
import 'package:abaad/data/model/response/city_model.dart';
import 'package:abaad/data/model/response/district_model.dart';
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
  List<int> _zoneIds = [];
  List<int> _cityIds = [];
  List<int> _subSubCategoryIds = [];
  int _subCategoryIndex = 0;
  List<RegionModel> _categoryList;
  List<CityModel> _subCategoryList;
  int _categoryIndex = 0;
  int _subSubCategoryIndex = 0;
  List<DistrictModel> _subSubCategoryList;





  LandModel get estateModel => _estateModel;
  List<Features> get estateList => _estateList;
  List<int> get zoneIds => _zoneIds;
  List<int> get cityIds => _cityIds;
  int get subCategoryIndex => _subCategoryIndex;
  List<RegionModel> get categoryList => _categoryList;
  List<CityModel> get subCategoryList => _subCategoryList;
  int get categoryIndex => _categoryIndex;
  int get subSubCategoryIndex => _subSubCategoryIndex;
  List<DistrictModel> get subSubCategoryList => _subSubCategoryList;
  List<int> get subSubCategoryIds => _subSubCategoryIds;


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
    _zoneIds = [];
    _cityIds = [];
    _zoneIds.add(0);
    _cityIds.add(0);
    getSubCategoryList(0);
    Response response = await zoneRepo.getRegionList();
    if (response.statusCode == 200) {
      _categoryList = [];
      response.body.forEach((category) => _categoryList.add(RegionModel.fromJson(category)));
      if(_categoryList != null) {
        for(int index=0; index<_categoryList.length; index++) {
          _zoneIds.add(_categoryList[index].regionId);
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
    _cityIds = [];
    _cityIds.add(0);
    if(categoryID != 0) {
      Response response = await zoneRepo.getCitiesList(categoryID);
      if (response.statusCode == 200) {
        _subCategoryList = [];
        response.body.forEach((category) => _subCategoryList.add(CityModel.fromJson(category)));
        if(_subCategoryList != null) {
          for(int index=0; index<_subCategoryList.length; index++) {
            _cityIds.add(_subCategoryList[index].cityId);
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


  Future<void> getSubSubCategoryList(int categoryID) async {
    _subSubCategoryIndex = 0;
    _subSubCategoryList = [];
    _subSubCategoryIds = [];
    _subSubCategoryIds.add(0);
    if(categoryID != 0) {
      Response response = await zoneRepo.getDistrictList(categoryID);
      if (response.statusCode == 200) {
        _subSubCategoryList = [];
        response.body.forEach((category) => _subSubCategoryList.add(DistrictModel.fromJson(category)));
        if(_subSubCategoryList != null) {
          for(int index=0; index<_subSubCategoryList.length; index++) {
            _subSubCategoryIds.add(int.parse(_subSubCategoryList[index].districtId));
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



  void setSubSubCategoryIndex(int index, bool notify) {
    _subSubCategoryIndex = index;
    if(notify) {
      update();
    }
  }
}
