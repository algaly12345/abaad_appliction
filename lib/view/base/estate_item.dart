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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Expanded(
                  child: Column(
                    children: <Widget>[

                      Row(
                        children: <Widget>[

                          Container(
                            padding: const EdgeInsets.all(3.0),
                            child:   Center(child: EstateImageView(estate_id:fav? estate.estate_id:estate.id,fromView: false)),
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
                                Text("${estate.title}",
                                    style: robotoBlack.copyWith(fontSize: 12)),
                                const SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: [
                                    Text(" العنوان الوطني : ",
                                        style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                    Text("${estate.nationalAddress}",
                                        style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                  ],

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

                Container(


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
          ),
        ),
      ),
    );

  }
}