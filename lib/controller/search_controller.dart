import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/search_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  SearchController({@required this.searchRepo});

  List<Estate> _searchRestList;
  List<Estate> _allRestList;
  String _searchText = '';
  String _restResultText = '';
  String _prodResultText = '';
  double _lowerValue = 0;
  double _upperValue = 0;
  List<String> _historyList = [];
  bool _isSearchMode = true;
  List<String> _sortList = ['ascending'.tr, 'descending'.tr];
  int _sortIndex = -1;
  int _rating = -1;
  bool _isRestaurant = false;
  bool _isAvailableFoods = false;
  bool _isDiscountedFoods = false;
  bool _veg = false;
  bool _nonVeg = false;
  List<Estate> get searchRestList => _searchRestList;
  String get searchText => _searchText;
  double get lowerValue => _lowerValue;
  double get upperValue => _upperValue;
  bool get isSearchMode => _isSearchMode;
  List<String> get historyList => _historyList;
  List<String> get sortList => _sortList;
  int get sortIndex => _sortIndex;
  int get rating => _rating;
  bool get isRestaurant => _isRestaurant;
  bool get isAvailableFoods => _isAvailableFoods;
  bool get isDiscountedFoods => _isDiscountedFoods;
  bool get veg => _veg;
  bool get nonVeg => _nonVeg;

  void toggleVeg() {
    _veg = !_veg;
    update();
  }

  void toggleNonVeg() {
    _nonVeg = !_nonVeg;
    update();
  }

  void toggleAvailableFoods() {
    _isAvailableFoods = !_isAvailableFoods;
    update();
  }

  void toggleDiscountedFoods() {
    _isDiscountedFoods = !_isDiscountedFoods;
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isRestaurant = isRestaurant;
    update();
  }

  void setSearchMode(bool isSearchMode) {
    _isSearchMode = isSearchMode;
    if(isSearchMode) {
      _searchText = '';
      _prodResultText = '';
      _restResultText = '';
      _allRestList = null;
      _searchRestList = null;
      _sortIndex = -1;
      _isDiscountedFoods = false;
      _isAvailableFoods = false;
      _veg = false;
      _nonVeg = false;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
    }
    update();
  }

  void setLowerAndUpperValue(double lower, double upper) {
    _lowerValue = lower;
    _upperValue = upper;
    update();
  }



  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  // void getSuggestedFoods() async {
  //   Response response = await searchRepo.getSuggestedFoods();
  //   if(response.statusCode == 200) {
  //     _suggestedFoodList = [];
  //     response.body.forEach((suggestedFood) => _suggestedFoodList.add(Product.fromJson(suggestedFood)));
  //   }else {
  //     ApiChecker.checkApi(response);
  //   }
  //   update();
  // }

  void searchData(String query) async {
    if((_isRestaurant && query.isNotEmpty && query != _restResultText) || (!_isRestaurant && query.isNotEmpty && query != _prodResultText)) {
      _searchText = query;
      _rating = -1;
      _upperValue = 0;
      _lowerValue = 0;
      if (_isRestaurant) {
        _searchRestList = null;
        _allRestList = null;
      } else {
      }
      if (!_historyList.contains(query)) {
        _historyList.insert(0, query);
      }
     // searchRepo.saveSearchHistory(_historyList);
      _isSearchMode = false;
      update();

      // Response response = await searchRepo.getSearchData(query, _isRestaurant);
      // if (response.statusCode == 200) {
      //   if (query.isEmpty) {
      //     if (_isRestaurant) {
      //       _searchRestList = [];
      //     } else {
      //     }
      //   } else {
      //     if (_isRestaurant) {
      //       _restResultText = query;
      //       _searchRestList = [];
      //       _allRestList = [];
      //       _searchRestList.addAll(EstateModel.fromJson(response.body).estates);
      //       _allRestList.addAll(EstateModel.fromJson(response.body).estates);
      //     } else {
      //       // _prodResultText = query;
      //       // _searchProductList = [];
      //       // _allProductList = [];
      //       // _searchProductList.addAll(ProductModel.fromJson(response.body).products);
      //       // _allProductList.addAll(ProductModel.fromJson(response.body).products);
      //     }
      //   }
      // } else {
      //   ApiChecker.checkApi(response);
      // }
      update();
    }
  }

  void getHistoryList() {
    _searchText = '';
    _historyList = [];
 //   _historyList.addAll(searchRepo.getSearchAddress());
  }

  void removeHistory(int index) {
    _historyList.removeAt(index);
   // searchRepo.saveSearchHistory(_historyList);
    update();
  }

  void clearSearchAddress() async {
   // searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  }

  void setRating(int rate) {
    _rating = rate;
    update();
  }

  void setSortIndex(int index) {
    _sortIndex = index;
    update();
  }

  void resetFilter() {
    _rating = -1;
    _upperValue = 0;
    _lowerValue = 0;
    _isAvailableFoods = false;
    _isDiscountedFoods = false;
    _veg = false;
    _nonVeg = false;
    _sortIndex = -1;
    update();
  }

}
