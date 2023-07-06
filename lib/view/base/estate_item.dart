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
import 'package:abaad/view/screen/estate/widgets/estate_image_view.dart';
import 'package:abaad/view/screen/profile/edit_dilog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:image_stack/image_stack.dart';

class EstateItem extends StatelessWidget {
 final  Estate estate;
 final  bool fav;
 final int  isMyProfile;
 final void Function() onPressed;


  const EstateItem({@required this.estate,this.onPressed,this.fav,this.isMyProfile});

  @override
  Widget build(BuildContext context) {

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
                                  String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                                  return         CustomImage(
                                    image:estate.images.length ==0?1:"${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${estate.images[0]}",
                                    fit:  BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,


                                  );
                                },
                                ),
                              ),
                            )),
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                   Row(
                                     children: [
                                       Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                       SizedBox(width: 11.0),
                                       Text(" ${estate.price}"  ,style: robotoBlack.copyWith(fontSize: 11)),
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
                                                    _isWished ? wishController.removeFromWishList(int.parse(estate.estate_id)) : wishController.addToWishList(estate, true);
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

                                          isMyProfile==1?Column(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                            Get.dialog(ConfirmationDialog(icon: Images.support,
                            title: 'are_you_sure_to_delete_account'.tr,
                            description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                            onYesPressed: () => Get.find<EstateController>().deleteProduct(estate.id),
                          ), useSafeArea: false);
        },
                                                child: Icon(Icons.delete_forever, color: Colors.white),
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  backgroundColor: Colors.blue, // <-- Button color
                                                  foregroundColor: Colors.red, // <-- Splash color

                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: ()async {
                                                  Get.find<EstateController>().currentIndex==0;
                                                  Get.find<EstateController>().categoryIndex==0;
                                              await    Get.dialog(EditDialog(estate:estate));
                                                },
                                                child: Icon(Icons.edit_note_rounded, color: Colors.white),
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  backgroundColor: Colors.blue, // <-- Button color
                                                  foregroundColor: Colors.red, // <-- Splash color

                                                ),
                                              ),
                                            ],

                                          ): Container(
                                            width: 40,
                                            margin: const EdgeInsets.only(top: 10),
                                            decoration:  BoxDecoration(
                                                color: estate.type_add=="for_rent"?Colors.blue:Colors.orange),
                                            child:  Text(estate.type_add=="for_sell"?"للبيع":"للإجار",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: Colors.white,)
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
                                Text("${estate.title}",
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: [
                                    Text(" العنوان الوطني : ",
                                        style: robotoBlack.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.black26)),
                                    Text("${estate.nationalAddress}",
                                        style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                  ],

                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text("رقم الإعلان :",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
                                      SizedBox(
                                        width: 4.0,
                                      ),
                                      Text("${estate.adNumber}",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)),
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
                margin: const EdgeInsets.only(left: 7.0),
                child: Text(" ${estate.property[index].number ?? ""}حمام",style: robotoBlack.copyWith(fontSize: 9,)),
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
                      Images.bathroom, height: 15,
                      color: Theme.of(context).primaryColor,
                      width: 15),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 7.0),
                child: Text(" ${estate.property[index].number ?? ""}حمام",style: robotoBlack.copyWith(fontSize: 9,)),
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
              Container(
                margin: EdgeInsets.only(left: 10.0),
                child: Text(" ${ estate.property[index].number ?? ""}مطبخ",style: robotoBlack.copyWith(fontSize: 9,)),
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
            Container(
              margin: const EdgeInsets.only(left: 7.0),
              child: Text(" ${ estate
                  .property[index]
                  .number} غرف النوم",style: robotoBlack.copyWith(fontSize: 9,)),
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
                    Images.bed, height: 20,
                    color: Theme.of(context).primaryColor,
                    width: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: estate
                  .property[index]
                  .number!=0?Text("${estate
                  .property[index]
                  .number}الصالات",style: robotoBlack.copyWith(fontSize: 9,)):Text("الصالات 0",style: robotoBlack.copyWith(fontSize: 9,)),
            )
          ],
        ),):Container();




      },
    ),
  ),
):Container():        Text("${estate.shortDescription}",
    style: robotoBlack.copyWith(fontSize: 12)),
                                const Divider(),
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
}
