import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/confirmation_dialog.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/view_image_dilog.dart';
import 'package:abaad/view/screen/profile/edit_dilog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstateItem extends StatelessWidget {
 final  Estate estate;
 final  bool fav;
 final int  isMyProfile;
 final void Function() onPressed;


  const EstateItem({required this.estate,required this.onPressed,required this.fav,required this.isMyProfile});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    print("-------------------------------------------$isMyProfile");
    return  InkWell(
      onTap:onPressed,
      child: Container(
        width: context.width,
        padding: EdgeInsets.only(right: 5,left: 5,top: 3),
        // decoration: BoxDecoration(
        //   color: Theme.of(context).cardColor,
        //
        // ),
        child: Container(
          alignment: Alignment.bottomCenter,
          padding:  isMyProfile==1? const EdgeInsets.all(8 ):const EdgeInsets.all(0),
          child:Container(
            // height:fav?150: 155,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(
                  child: Column(
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Container(
                            width: 155,
                            height: 155,

                            child:   Container(child:   Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                child:  GetBuilder<SplashController>(builder: (splashController) {
                                  String _baseUrl = Get.find<SplashController>().configModel.baseUrls.estateImageUrl;
                                  return         CustomImage(
                                    image:estate.images.length > 0?"${_baseUrl}/${estate.images[0]}":Images.estate_type,
                                    fit:  BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,


                                  );
                                },
                                ),
                              ),
                            )),
                          ),
                          SizedBox(width: 11.0),

                          isMyProfile==1?Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.dialog(ConfirmationDialog(icon: Images.support,
                                    title: 'do_you_really_want_to_delete_this_offer'.tr,
                                    description: 'you_will_remove_all_your_information_from_the_offer'.tr, isLogOut: true,
                                    onYesPressed: () => Get.find<EstateController>().deleteEstate(estate.id),
                                  ), useSafeArea: false);
                                },
                                icon: Icon(Icons.delete_forever, color: Colors.red ,size: 20,),
                              ),
                              IconButton(
                                onPressed: ()async {
                                  // Get.find<EstateController>().currentIndex==0;
                                  // Get.find<EstateController>().categoryIndex==0;
                                  // await       Get.toNamed(RouteHelper.getEditEstatRoute(estate));

                                  // Get.dialog(EditDialog(estate:estate));
                                },
                                icon: Icon(Icons.edit_note_rounded, color: Colors.orange),
                              ),
                              IconButton(
                                onPressed: ()async {
                                  Get.find<EstateController>().currentIndex==0;
                                  Get.find<EstateController>().categoryIndex==0;
                                  await    Get.dialog(ViewImageUploadScreen(estate));
                                },
                                icon: Icon(Icons.image_sharp, color: Colors.blue),
                              ),
                            ],

                          ):       Container( ),
                          Flexible(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                   Row(
                                     children: [

                                       Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                       SizedBox(width: 11.0),
                                       Text(
                                         formatPrice(
                                             estate.categoryName == "ارض"
                                                 ? estate.totalPrice
                                                 : estate.price
                                         ),
                                         style: robotoBlack.copyWith(fontSize: 11),
                                       ),

                                       SizedBox(width: 2.0),
                                     // Text("currency".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall))
                                     ],
                                   )
,
                                    Container(
                                      // height: 60,



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

                                                    print("removed id ------------------omer-------${estate.id}");
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
                                            padding: const EdgeInsets.only(right: 4,left: 4),
                                            decoration:  BoxDecoration(
                                                borderRadius: BorderRadius.circular(
                                                    4),
                                                color:  Colors.blue),
                                            child:  Row(
                                              children: [
                                                Text(
                                                    "${estate.view}",
                                                    style: robotoRegular.copyWith(
                                                      fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                                    )
                                                ),
                                                SizedBox(width: 2,),
                                                Icon(Icons.remove_red_eye_outlined,color:Colors.white,size: 20,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: [
                                    Text(   isArabic ? "${estate.categoryNameAr} -${estate.city} -${estate.districts??''}":"${estate.categoryName} -${estate.zoneName} -${estate.districts}",
                                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                    Container(
                                      padding: const EdgeInsets.only(right: 4,left: 4),
                                      decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              4),
                                          color:  Colors.blue),
                                      child:  Row(
                                        children: [
                                          Text(
                                              "${estate.advertisementType}",
                                              style: robotoRegular.copyWith(
                                                fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor,
                                              )
                                          ),
                                          SizedBox(width: 2,),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 3.0,
                                ),


                                Row(
                                  children: [
                                    Text("رقم ترخيض الإعلان".tr,
                                        style: robotoBlack.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black26)),

                                  ],

                                ),
                                Container(
                                  child: Row(
                                    children: [
                     // /
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text(" ${estate.adLicenseNumber}",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                                      // IconButton(onPressed:(){
                                      //   FlutterClipboard.copy(estate.adNumber.toString()).then(( value ) {
                                      //     showCustomSnackBar('تم النسخ'.tr, isError: false);
                                      //   });
                                      // }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,size: 11,)),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 7.0,
                                ),
estate.category!="5"?     estate.property  != null ?Center(
  child: Container(
    height: 35,

    child:ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount:  estate.property.length,
      scrollDirection: Axis.horizontal,
      // ignore: missing_return
      itemBuilder: (context, index) {

        return  estate.property[index].name=="حمام"? Container(
          decoration: BoxDecoration(color: Theme
              .of(context)
              .cardColor,
            borderRadius: BorderRadius.circular(
                Dimensions.RADIUS_SMALL),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.2), //(x,y)
                blurRadius: 6.0,
              ),
            ],),
          margin: EdgeInsets.only(top: 5,bottom: 5,right: 2,left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 22.0,
                width: 22.0,

                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                      Images.bathroom, height: 15,
                      color: Theme.of(context).primaryColor,
                      width: 15),
                ),
              ),

              Container(

                child: Row(
                  children: [
                    Text("bathroom".tr,style: robotoBlack.copyWith(fontSize: 9,)),

                    Container(
                      child: Text(" ${estate.property[index].number ?? ""}",style: robotoBlack.copyWith(fontSize: 9,)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ):estate.property[index].name=="مطبخ"? Container(
          decoration: BoxDecoration(color: Theme
              .of(context)
              .cardColor,
            borderRadius: BorderRadius.circular(
                Dimensions.RADIUS_SMALL),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.2), //(x,y)
                blurRadius: 6.0,
              ),
            ],),
          margin: EdgeInsets.only(top: 5,bottom: 5,right: 2,left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 22.0,
                width: 22.0,

                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Image.asset(
                      Images.kitchen, height: 15,
                      color: Theme.of(context).primaryColor,
                      width: 15),
                ),
              ),
              Row(
                children: [
                  Text("kitchen".tr,style: robotoBlack.copyWith(fontSize: 9,)),
                  Container(

                    child: Text(" ${estate.property[index].number ?? ""}",style: robotoBlack.copyWith(fontSize: 9,)),
                  ),
                ],
              )
            ],
          ),
        ): estate.property[index].name=="مطلبخ"?Container(
          decoration: BoxDecoration(color: Theme
              .of(context)
              .cardColor,
            borderRadius: BorderRadius.circular(
                Dimensions.RADIUS_SMALL),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 0.2), //(x,y)
                blurRadius: 6.0,
              ),
            ],),
          margin: EdgeInsets.only(top: 5,bottom: 5,right: 2,left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: <Widget>[
              Container(
                height: 22.0,
                width: 22.0,

                child: Container(
                  padding: EdgeInsets.all(3),
                  child: Image.asset(
                      Images.kitchen, height: 20,
                      color: Theme.of(context).primaryColor,
                      width: 20),
                ),
              ),
              Row(
                children: [
              Text("kitchen".tr,style: robotoBlack.copyWith(fontSize: 9,)),
                  Container(
                    child: Text(" ${ estate.property[index].number ?? ""}",style: robotoBlack.copyWith(fontSize: 9,)),
                  ),
                ],
              )
            ],
          ),
        ):estate.property[index].name=="غرف نوم"?Container(decoration: BoxDecoration(color: Theme
            .of(context)
            .cardColor,
          borderRadius: BorderRadius.circular(
              Dimensions.RADIUS_SMALL),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 0.2), //(x,y)
              blurRadius: 6.0,
            ),
          ],), margin: const EdgeInsets.all(5.0), child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: <Widget>[
            Container(
              height: 25.0,
              width: 25.0,

              child: Container(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                    Images.bed, height: 22,
                    color: Theme.of(context).primaryColor,
                    width: 22),
              ),
            ),
            Row(
              children: [
                Text("bedrooms".tr,style: robotoBlack.copyWith(fontSize: 9,)),
                Container(
                  child: Text(" ${ estate.property[index].number}",style: robotoBlack.copyWith(fontSize: 9,)),
                ),
              ],
            )
          ],
        ),):estate.property[index].name=="صلات"?Container(decoration: BoxDecoration(color: Theme
            .of(context)
            .cardColor,
          borderRadius: BorderRadius.circular(
              Dimensions.RADIUS_SMALL),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 0.2), //(x,y)
              blurRadius: 6.0,
            ),
          ],),   margin: EdgeInsets.only(top: 5,bottom: 5,right: 2,left: 2), child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween,
          children: <Widget>[
            Container(
              height: 25.0,
              width: 25.0,

              child: Container(
                padding: const EdgeInsets.all(6),
                child: Image.asset(
                    Images.setroom, height: 20,
                    color: Theme.of(context).primaryColor,
                    width: 20),
              ),
            ),
            Row(
              children: [
                Text("lounges".tr,style: robotoBlack.copyWith(fontSize: 9,)),
                Container(

                  child: estate
                      .property[index]
                      .number!=0?Text("${estate
                      .property[index]
                      .number}",style: robotoBlack.copyWith(fontSize: 9,)):Text("0",style: robotoBlack.copyWith(fontSize: 9,)),
                ),
              ],
            )
          ],
        ),):Container();




      },
    ),
  ),
):Container():        Text("${estate.shortDescription}",
    style: robotoBlack.copyWith(fontSize: 12)),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );

  }


 String formatPrice(String priceStr) {
   final num price = num.tryParse(priceStr);
   if (price == null) return priceStr;

   if (price >= 1000000) {
     return "${(price / 1000000).toStringAsFixed(2)} مليون";
   } else if (price >= 1000) {
     return "${(price / 1000).toStringAsFixed(2)} ألف";
   } else {
     return price.toString();
   }
 }

}
