import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/auto_complete_result.dart';
import 'package:abaad/data/model/response/category_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/estate_repo.dart';
import 'package:abaad/helper/route_helper.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class EstateController extends GetxController implements GetxService {
  final EstateRepo estateRepo;
  EstateController({@required this.estateRepo});
  var currentStep =0.obs;
  EstateModel _estateModel;
  List<Estate> _estateList;
  Estate _estate;
  int _categoryIndex = 0;
  int _categoryPostion = 0;
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
  XFile _pickedLogo;
  XFile _pickedCover;
  List<Property> _categoryRestList;


  List<String> _tagList = [];

  List<String> options = ["ممرات مكيفة", "التحكم بالستائر", "التحكم باإنارة", "اطلالة بحرية", "الدخول الزكي","التحكم بالتكيف"];
  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;

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
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  List<Property> get categoryRestList => _categoryRestList;
  List<String> get tagList => _tagList;
  int get categoryPostion => _categoryPostion;



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

  Future<void> getCategoriesEstateList(int estateId, int offset, String type, bool notify) async {

    _foodOffset = offset;
    if(offset == 1 || _estateList == null) {
      _type = type;

      _estateList = null;
      if(notify) {
        update();
      }
    }


    Response response = await estateRepo.getCategorisEstateList(
        1, offset, type);
      if (response.statusCode == 200) {
        if (offset == 1) {
          _estateList = [];
        }
        print("awad-------------------------------${response.body}");
        _estateList.addAll(EstateModel.fromJson(response.body).estates);
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

  void setCategoryPostion(int index) {
    _categoryPostion = index;
    update();
  }


  int getCategoryIndex() {
  return  _categoryIndex;

  }

  int getCategoryPostion() {
    return  _categoryPostion;

  }

  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }


  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  Future<Estate> getEstateDetails(Estate estate) async {

    if(estate.shortDescription != null) {
      _estate = estate;
    }else {
      _isLoading = true;
      _estate = null;
      Response response = await estateRepo.getEstateDetails(estate.id.toString());
      if (response.statusCode == 200) {
        _estate = Estate.fromJson(response.body);
        print("-------------------------------------detailsapp${_estate.shortDescription}");

      } else {
        ApiChecker.checkApi(response);
      }

      _isLoading = false;
      update();
    }
    return _estate;
  }


  void pickImage(bool isLogo, bool isRemove) async {
    if(isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    }else {
      if (isLogo) {
        _pickedLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover = await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> registerRestaurant(Estate restaurantBody) async {
    _isLoading = true;
    update();
    Response response = await estateRepo.createEstate(restaurantBody, _pickedLogo, _pickedCover);
    if(response.statusCode == 200) {
      int _restaurantId = response.body['restaurant_id'];
      Get.offAllNamed(RouteHelper.getBusinessPlanRoute(_restaurantId));
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }






  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}


}






