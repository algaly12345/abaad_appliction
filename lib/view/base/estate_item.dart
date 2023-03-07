import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/screen/estate/widgets/estate_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_stack/image_stack.dart';

class EstateItem extends StatelessWidget {
 final  Estate estate;
 final  bool fav;
 final void Function() onPressed;


  const EstateItem({@required this.estate,this.onPressed,this.fav});

  @override
  Widget build(BuildContext context) {
    List<String> images = <String>[
      "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
      "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
      "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
    ];

    List<Widget> widgets = [
      ...images.map<Widget>((img) => Image.network(
        img,
        fit: BoxFit.cover,
      ))
    ];

    List<ImageProvider> providers = [
      ...images.map<ImageProvider>((img) => NetworkImage(
        img,
      ))
    ];
    return  InkWell(
      onTap:onPressed,
      child: Container(
        width: context.width,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,

        ),
        child: Container(
          alignment: Alignment.center,
          child:Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4), //border corner radius
              boxShadow:[
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), //color of shadow
                  spreadRadius: 5, //spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(0, 2), // changes position of shadow
                  //first paramerter of offset is left-right
                  //second parameter is top to down
                ),
                //you can set more BoxShadow() here
              ],
            ),
            child: Row(
              children: <Widget>[

                Expanded(
                  child: Column(
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Container(
                            padding: const EdgeInsets.all(3.0),
                            child:   Center(child: EstateImageView(estate_id: estate.estate_id,fromView: false)),
                            width: 130,
                            height: 140,
                          ),
                          SizedBox(width: 11.0),
                          Flexible(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                    SizedBox(width: 11.0),
                                    Text(" ${estate.price}"  ,style: robotoBlack.copyWith(fontSize: 11)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Text("${estate.shortDescription}",
                                    style: robotoBlack.copyWith(fontSize: 12)),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: [
                                    Text(" العنوان الوطني : ",
                                        style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                    Text("45",
                                        style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                  ],

                                ),
                                const SizedBox(
                                  height: 7.0,
                                ),

                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(Images.bed, width: 14.0, height: 14.0),

                                          Text(
                                              '2 غرفة نوم',
                                              style: robotoBlack.copyWith(fontSize: 11)
                                          ),
                                        ],
                                      ),
                                    ),
                                    //
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(Images.bathroom, width: 14.0, height: 14.0),

                                          Text(
                                              '2 حمام',
                                              style: robotoBlack.copyWith(fontSize: 11)
                                          ),
                                        ],
                                      ),
                                    ),
                                    //
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(Images.setroom, width: 14.0, height: 14.0),

                                          Text(
                                            '2 غرفة نوم',
                                            style: robotoBlack.copyWith(fontSize: 11),
                                          ),
                                        ],
                                      ),
                                    ),//
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                    fav?  Container(
                        width: 30, height: 30,
                        margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                        child:     GetBuilder<WishListController>(builder: (wishController) {
                          bool _isWished = wishController.wishRestIdList.contains(estate.estate_id);
                          return InkWell(
                            onTap: () {
                              if(Get.find<AuthController>().isLoggedIn()) {
                                _isWished ? wishController.removeFromWishList(estate.estate_id) : wishController.addToWishList(estate, true);
                              }else {
                                showCustomSnackBar('you_are_not_logged_in'.tr);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical:  Dimensions.PADDING_SIZE_SMALL ),
                              child: Icon(
                                _isWished ? Icons.favorite : Icons.favorite_border,  size:25,
                                color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                              ),
                            ),
                          );
                        }),
                      ):Container(),
                      Container(
                        width: 40,
                        margin: const EdgeInsets.only(top: 10),
                        decoration:  BoxDecoration(
                            color: estate.forRent==1?Colors.blue:Colors.orange),
                        child:  Text(estate.forRent==1?"للبيع":"للإجار",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,)
                        ),
                      ),

                    ],
                  ),
                ),
                // Container(
                //   width: 30, height: 30,
                //   margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                //   child:     GetBuilder<WishListController>(builder: (wishController) {
                //     bool _isWished = wishController.wishRestIdList.contains(estate.estate_id);
                //     return InkWell(
                //       onTap: () {
                //         if(Get.find<AuthController>().isLoggedIn()) {
                //           _isWished ? wishController.removeFromWishList(estate.estate_id) : wishController.addToWishList(estate, true);
                //         }else {
                //           showCustomSnackBar('you_are_not_logged_in'.tr);
                //         }
                //       },
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(vertical:  Dimensions.PADDING_SIZE_SMALL ),
                //         child: Icon(
                //           _isWished ? Icons.favorite : Icons.favorite_border,  size:25,
                //           color: _isWished ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
                //         ),
                //       ),
                //     );
                //   }),
                // ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}
