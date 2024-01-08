import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/api/api_client.dart';
import 'package:abaad/data/model/body/estate_body.dart';
import 'package:abaad/data/model/response/category_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/estate_repo.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/view/base/custom_snackbar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class EstateController extends GetxController implements GetxService {
  final EstateRepo estateRepo;

  EstateController({@required this.estateRepo});

  var currentStep = 0.obs;
  EstateModel _estateModel;
  EstateModel _estateModel1;
  List<Estate> _estateList;
  Estate _restaurant;
  Estate _estate;
  int _categoryIndex = 0;
  int _categoryPostion = 0;

  int _categoryName = 0;

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
  XFile _pickedImage;
  XFile _pickedPlanedImage;
  List<XFile> _pickedIdentities = [];

  List<XFile> _pickPlaned = [];
  int _currentIndex = 0;
  String _address;

  List<int> _categoryIds = [];

  List<String> _tagList = [];
  List<String> options = [
    "ممرات مكيفة",
    "التحكم بالستائر",
    "التحكم باإنارة",
    "اطلالة بحرية",
    "الدخول الزكي",
    "التحكم بالتكيف"
  ];
  final List<String> _reportList = ['مالك عقار', 'وسيط عقاري'];

  Rx<List<String>> selectedOptionList = Rx<List<String>>([]);
  var selectedOption = ''.obs;
  List<bool> _advantagesSelectedList;

  int _reportIndex = 0;

  EstateModel get estateModel => _estateModel;
  EstateModel get estateModel1 => _estateModel1;

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

  int get categoryName => _categoryName;

  XFile get pickedImage => _pickedImage;
  XFile get pickedPlanedImage => _pickedPlanedImage;

  List<XFile> get pickedIdentities => _pickedIdentities;
  List<XFile> get pickPlaned => _pickPlaned;

  int get currentIndex => _currentIndex;

  String get address => _address;
  List<bool> get advantagesSelectedList => _advantagesSelectedList;
  List<int> get categoryIds => _categoryIds;
  Estate get restaurant => _restaurant;
  List<String> get reportList => _reportList;
  RxBool isLoading2 = false.obs;
  Future<void> getEstateList(int offset, bool reload ,int categoryId) async {
    if (reload) {
      _estateModel = null;
      update();
    }
    Response response = await estateRepo.getEstateList(offset, _estateType,0,0);
    if (response.statusCode == 200) {
      if (offset == 1) {
        _estateModel = EstateModel.fromJson(response.body);
        // print("estate response ...............${response.body}");
      } else {
        _estateModel.totalSize = EstateModel.fromJson(response.body).totalSize;
        _estateModel.offset = EstateModel.fromJson(response.body).offset;
        _estateModel.estates.addAll(EstateModel.fromJson(response.body).estates);
      }
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }


  void setReportIndex(String dmType, bool notify) {
    _reportIndex = _reportList.indexOf(dmType);
    if(notify) {
      update();
    }
  }

  void setRestaurantType(String type) {
    _estateType = type;
    update();
  }



  void setCategoryList() {
    if(Get.find<CategoryController>().categoryList != null) {
      _categoryList = [];
      _categoryList.add(CategoryModel(id: 0, name: 'all'.tr));
      Get.find<CategoryController>().categoryList.forEach((category) {
          _categoryList.add(category);

      });
    }
  }


  void showBottomLoader() {
    _isLoading = true;
    update();
  }


  void setCategoryIndex(int index) {

    _categoryIndex = index;
    getEstateList(1, false, 1);
    update();
 //    estateList.clear();
  }

  void setCategoryPostion(int index) {
    _categoryPostion = index;
    update();
  }


  void setCategoryName(int index) {
    _categoryName = index;
    update();
  }


  int getCategoryIndex() {
    return _categoryIndex;
  }

  int getCategoryPostion() {
    return _categoryPostion;
  }


  int getCategoryName() {
    return _categoryPostion;
  }

  void setFoodOffset(int offset) {
    _foodOffset = offset;
  }


  void showFoodBottomLoader() {
    _foodPaginate = true;
    update();
  }

  Future<EstateModel> getEstateDetails(Estate estate) async {
    if (estate.shortDescription != null) {
      _estate = estate;
    } else {
      _isLoading = true;
      _estate = null;
      Response response = await estateRepo.getEstateDetails(estate.id.toString());
      if (response.statusCode == 200) {
        _estate = Estate.fromJson(response.body);
      } else {
        ApiChecker.checkApi(response);
      }
      _isLoading = false;
      update();
    }
    return _estateModel;
  }


  void pickImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    } else {
      if (isLogo) {
        _pickedLogo =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }



  void pickDmImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    } else {
      if (isLogo) {
        _pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile _xFile = await ImagePicker().pickImage(
            source: ImageSource.gallery);
        if (_xFile != null) {
          _pickedIdentities.add(_xFile);
        }
      }
      update();
    }
  }


  void pickPlanedImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedPlanedImage = null;
      _pickPlaned = [];
    } else {
      if (isLogo) {
        _pickedPlanedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile _xFile = await ImagePicker().pickImage(
            source: ImageSource.gallery);
        if (_xFile != null) {
          _pickPlaned.add(_xFile);
        }
      }
      update();
    }
  }

  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }



  void removePlanedImage(int index) {
    _pickPlaned.removeAt(index);
    update();
  }


  Future<void> addEstate(EstateBody estateBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoading = true;
    update();
    List<MultipartBody> _multiParts = [];
    _multiParts.add(MultipartBody('image', _pickedImage));
    for (XFile file in _pickedIdentities) {
      _multiParts.add(MultipartBody('identity_image[]', file));
    }

    _multiParts.add(MultipartBody('image', _pickedPlanedImage));
    for (XFile file in _pickPlaned) {
      _multiParts.add(MultipartBody('planed_image[]', file));
    }
    Response response = await estateRepo.createEstate(
        estateBody, _multiParts);
   prefs.setString('estate_id', response.body["message"].toString());

    if (response.statusCode == 200) {
      _isLoading=false;

      Get.offNamed(RouteHelper.getPaymentRoute(161));
   //   Get.offAllNamed(RouteHelper.getSuccess());
    } else {
      ApiChecker.checkApi(response);
      print("error estate---------------------------------------------------${response.body}");
    }
    _isLoading = false;
    update();
  }
  Future<void> updatEstate(EstateBody estatetBody) async {
    _isLoading = true;
    update();
    // List<MultipartBody> _multiParts = [];
    // _multiParts.add(MultipartBody('image', _pickedImage));
    // for (XFile file in _pickedIdentities) {
    //   _multiParts.add(MultipartBody('identity_image[]', file));
    // }
    //
    // _multiParts.add(MultipartBody('image', _pickedPlanedImage));
    // for (XFile file in _pickPlaned) {
    //   _multiParts.add(MultipartBody('planed_image[]', file));
    // }
    Response response = await estateRepo.updateEstate(estatetBody);

    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getProfileRoute());
      showCustomSnackBar('update_successful'.tr, isError: false);
      update();

    } else {
      ApiChecker.checkApi(response);
      print("error estate---------------------------------------------------${response.body}");
    }
    _isLoading = false;
    update();
  }




  Future<void> deleteEstate(int estateId) async {
    _isLoading = true;
    update();
    Response response = await estateRepo.deleteEstate(estateId);
    if(response.statusCode == 200) {
      Get.back();
      showCustomSnackBar('estate deleted successfully'.tr, isError: false);
      Get.toNamed(RouteHelper.getProfileRoute());

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

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if (notify) {
      update();
    }
  }


  void addInterestSelection(int index) {
    _advantagesSelectedList[index] = !_advantagesSelectedList[index];
    update();
  }


  Future<void> getCategoryList(Estate product) async {
    _categoryIds = [];
  //  _subCategoryIds = [];
    _categoryIds.add(0);
 //   _subCategoryIds.add(0);
    _isLoading = true;
    Response response = await estateRepo.getCategoryList();
    if (response.statusCode == 200) {
      _categoryList = [];
      _isLoading = false;
      response.body.forEach((category) => _categoryList.add(CategoryModel.fromJson(category)));
      if(_categoryList != null) {
        for(int index=0; index<_categoryList.length; index++) {
          _categoryIds.add(_categoryList[index].id);
        }
        if(product != null) {
          setCategoryIndex(_categoryIds.indexOf(product.categoryId));
        //  await getSubCategoryList(int.parse(product.categoryIds[0].id), product);
        }
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> insertEstate(String title, String description, int estateId ,BuildContext ctx) async {
    _isLoading = true;

    try {
      final response = await http.post(
        Uri.parse('${AppConstants.BASE_URL}/api/v1/estate/create-report'), // Replace with your Laravel API endpoint
        body: {
          'title': title,
          'description': description,
          'estate_id': estateId.toString(),
        },
      );



      if (response.statusCode == 200) {
        _isLoading = false;
        Get.snackbar(
          'Thanks'.tr,
          'operation_accomplished_successfully'.tr,
          backgroundColor: Colors.green, // Customize snackbar color
          colorText: Colors.white, // Customize text color
          duration: Duration(seconds: 3), // Set duration in seconds
          snackPosition: SnackPosition.BOTTOM, // Set snackbar position
          margin: EdgeInsets.all(10), // Set margin around the snackbar
          isDismissible: true, // Allow dismissing the snackbar with a tap// Dismiss direction
        );
        Navigator.pop(ctx);// Show success snackbar
      } else {
        Get.snackbar('Error', 'Error inserting estate'); // Show error snackbar
      }
      // Handle response here

    } catch (error) {
      print("--------------------------------${error}");
    } finally {
      _isLoading = false;
    }
  }

}
