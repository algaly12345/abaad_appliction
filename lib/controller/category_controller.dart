import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/category_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/category_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryRepo categoryRepo;
  CategoryController({@required this.categoryRepo});

  List<CategoryModel> _categoryList;
  List<CategoryModel> _subCategoryList;
  List<Estate> _categoryRestList;
  List<Estate> _searchEstList = [];
  List<bool> _interestSelectedList;
  bool _isLoading = false;
  int _pageSize;
  int _estPageSize;
  bool _isSearching = false;
  String _type = 'all';
  bool _isEstates = false;
  String _searchText = '';
  int _offset = 1;


  List<CategoryModel> get categoryList => _categoryList;
  List<Estate> get categoryRestList => _categoryRestList;
  List<Estate> get searchEstList => _searchEstList;
  List<bool> get interestSelectedList => _interestSelectedList;
  bool get isLoading => _isLoading;
  int get pageSize => _pageSize;
  int get esttPageSize => _estPageSize;
  bool get isSearching => _isSearching;
  String get type => _type;
  bool get isRestaurant => _isEstates;
  String get searchText => _searchText;
  int get offset => _offset;


  Future<void> getCategoryList(bool reload) async {

    if(_categoryList == null || reload) {
      Response response = await categoryRepo.getCategoryList();
      if (response.statusCode == 200) {

        _categoryList = [];
        _interestSelectedList = [];
        response.body.forEach((category) {
          _categoryList.add(CategoryModel.fromJson(category));
          _interestSelectedList.add(false);
          print("omeromeromer");
        });
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }





  void getCategoryRestaurantList(String categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if(offset == 1) {
      if(_type == type) {
        _isSearching = false;
      }
      _type = type;
      if(notify) {
        update();
      }
      _categoryRestList = null;
    }
    Response response = await categoryRepo.getCategoryRestaurantList(categoryID, offset, type);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _categoryRestList = [];
      }
      _categoryRestList.addAll(EstateModel.fromJson(response.body).estates);
      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void addInterestSelection(int index) {
    _interestSelectedList[index] = !_interestSelectedList[index];
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isEstates = isRestaurant;
    update();
  }

}