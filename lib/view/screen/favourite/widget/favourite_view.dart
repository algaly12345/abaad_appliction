import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductView extends StatelessWidget {
  final List<Estate> restaurants;


  final String noDataText;
  ProductView({required this.restaurants,  this.noDataText});

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;


    return   Center(
      child: Column(
        children: [
          const Text("omeromeromeromeroemreomreomrer"),
          GridView.builder(
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : 0.01,
              crossAxisCount:  1 ,
            ),
            physics: BouncingScrollPhysics() ,
            itemBuilder: (context, index) {
              return  GetBuilder<WishListController>(builder: (wishController) {
                bool _isWished = wishController.wishRestIdList.contains(wishController.wishRestList[index].id);
                return InkWell(
                  // onTap: () {
                  //   if(Get.find<AuthController>().isLoggedIn()) {
                  //     _isWished ? wishController.removeFromWishList(restaurant.id, true)
                  //         : wishController.addToWishList(null, restaurant, true);
                  //   }else {
                  //     showCustomSnackBar('you_are_not_logged_in'.tr);
                  //   }
                  // },
                  child: Column(
                    children: [
                      Text("omeromer"),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL ),
                        child: Icon(
                          _isWished ? Icons.favorite : Icons.favorite_border,  size:  25,
                          color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                        ),
                      ),
                    ],
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}