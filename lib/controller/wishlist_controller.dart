import 'package:abaad/data/api/api_checker.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/repository/wishlist_repo.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListController extends GetxController implements GetxService {
  final WishListRepo wishListRepo;
  WishListController({@required this.wishListRepo});


  List<Estate> _wishRestList;
  List<int> _wishProductIdList = [];
  List<int> _wishRestIdList = [];


  List<Estate> get wishRestList => _wishRestList;
  List<int> get wishProductIdList => _wishProductIdList;
  List<int> get wishRestIdList => _wishRestIdList;

  void addToWishList(Estate restaurant, bool isRestaurant) async {
    Response response = await wishListRepo.addWishList( restaurant.id, isRestaurant);
    if (response.statusCode == 200) {
        _wishRestIdList.add(restaurant.id);
        _wishRestList.add(restaurant);

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeFromWishList(int id) async {
    Response response = await wishListRepo.removeWishList(id);

    if (response.statusCode == 200) {
      int _idIndex = -1;


        _idIndex = _wishRestIdList.indexOf(id);
        _wishRestIdList.removeAt(_idIndex);
        _wishRestList.removeAt(_idIndex);

      showCustomSnackBar(response.body['message'], isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getWishList() async {
    _wishRestList = [];
    _wishRestIdList = [];
    Response response = await wishListRepo.getWishList();

    if (response.statusCode == 200) {
      update();


      response.body['estate'].forEach((restaurant) async {
        Estate _restaurant;

        try{
          _restaurant = Estate.fromJson(restaurant);
        }catch(e){}
        _wishRestList.add(_restaurant);
        _wishRestIdList.add(_restaurant.estate_id);
        print("omeromeromeromeomromer${restaurant.body}");
      });
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeWishes() {
    _wishProductIdList = [];
    _wishRestIdList = [];
  }
}
