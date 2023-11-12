import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/offer_list.dart';
import 'package:abaad/view/screen/estate/widgets/interface.dart';
import 'package:abaad/view/screen/estate/widgets/near_by_view.dart';
import 'package:abaad/view/screen/estate/widgets/network_type.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter/material.dart';


import 'package:get/get.dart';

import 'widgets/estate_view.dart';
import 'widgets/report_widget.dart';
class EstateDetails extends StatefulWidget {
final Estate estate;

EstateDetails({@required this.estate});

  @override
  State<EstateDetails> createState() => _EstateDetailsState();
}

class _EstateDetailsState extends State<EstateDetails> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;


  bool _isLoggedIn;
  @override
  void initState() {
    super.initState();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    Get.find<EstateController>().getEstateDetails(Estate(id:  widget.estate.id));



  }
  @override
  Widget build(BuildContext context) {
     List<Estate> restaurants;
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

     bool _isNull = true;
     int _length = 0;

     final currentLocale = Get.locale;
     bool isArabic = currentLocale?.languageCode == 'ar';
    return  Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<EstateController>(builder: (estateController) {
          _isNull = restaurants == null;
          if(!_isNull) {
            _length = restaurants.length;
          }
          return  GetBuilder<UserController>(builder: (userController) {

            return (Get.find<AuthController>().isLoggedIn()  && userController.agentInfoModel == null &&estateController.isLoading) ? Center(child: CircularProgressIndicator()) :
            GetBuilder<CategoryController>(builder: (categoryController) {


              Estate _estate;

            if(estateController.estate != null   && categoryController.categoryList != null) {
              _estate = estateController.estate;
            }
            estateController.setCategoryList();

            return (estateController.estate != null) ?
               Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [EstateView(fromView: true,estate:estateController.estate ) ,


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding:  EdgeInsets.only(right: 5,left: 5),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            boxShadow: const [
            BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 0.2), //(x,y)
            blurRadius: 6.0,
            ),
            ], ),
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(

                        child:  Row(
                          children: [
                            Text(
                                "price".tr,
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                )),
                            SizedBox(width: 2,),
                            Text(
                                "${estateController.estate.price}",
                                style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                ),

                            ),
                            SizedBox(width: 2.0),
                            Text("currency".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.white),)
                          ],
                        ),

                      ),
                      SizedBox(height: 6,),
                      Row(
                        children: [
                          Text(isArabic ? "${estateController.estate.categoryNameAr} -${estateController.estate.zoneNameAr} -${estateController.estate.districts}":"${estateController.estate.categoryName} -${estateController.estate.zoneName} -${estateController.estate.districts}",
                              style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        ],
                      ),


                      Text(
                        'shot_description'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${estateController.estate.shortDescription}",
                              style: robotoBlack.copyWith(fontSize: 14)),

                        ],
                      ),
                      Text(
                        'long_description'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),

                      Text("${estateController.estate.longDescription}",
                          style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ],
                  ),
                ),
                SizedBox(height: 8),


                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding:  EdgeInsets.only(right: 5,left: 5,bottom: 5,top: 5),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.2), //(x,y)
                        blurRadius: 1.0,)
                    ], ),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   estateController.address,
                          //   style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 25,
                          //   ),
                          // )

                          Text(
                            'it_contains'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),

                        ],
                      ),
                      SizedBox(height: 10)
,                      Divider(height: 1,),
              estateController.estate.category!="5" ?Center(
                        child: Container(
                          height: 35,

                          child:ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:   estateController.estate.property.length,
                              scrollDirection: Axis.horizontal,
                            // ignore: missing_return
                            itemBuilder: (context, index) {

                              return !estateController.isLoading ? estateController.estate.property[index].name=="حمام"? Container(
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
                                  margin: EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 23.0,
                                        width: 23.0,

                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          child: Image.asset(
                                              Images.bathroom, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("bathroom".tr),
                                          Container(
                                            margin: const EdgeInsets.only(left: 10.0),
                                            child: Text(" ${estateController.estate.property[index].number ?? ""}"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ): estateController.estate.property[index].name=="مطلبخ"?Container(
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
               margin: EdgeInsets.all(5.0),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: <Widget>[
                   Container(
                     height: 24.0,
                     width: 24.0,

                     child: Container(
                       padding: EdgeInsets.all(3),
                       child: Image.asset(
                           Images.kitchen, height: 24,
                           color: Theme.of(context).primaryColor,
                           width: 24),
                     ),
                   ),
                   Row(
                     children: [
                       Text("kitchen".tr),
                       Container(
                         child: Text(" ${  estateController.estate.property[index].number ?? ""}"),
                       ),
                     ],
                   )
                 ],
               ),
             ):estateController.estate.property[index].name=="غرف نوم"?Container(decoration: BoxDecoration(color: Theme
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
                     height: 40.0,
                     width: 40.0,

                     child: Container(
                       padding: const EdgeInsets.all(6),
                       child: Image.asset(
                           Images.bed, height: 24,
                           color: Theme.of(context).primaryColor,
                           width: 24),
                     ),
                   ),
                   Row(
                     children: [
                       Text("bedrooms".tr),
                       Container(
                         margin: const EdgeInsets.only(left: 10.0),
                         child: Text(" ${estateController.estate
                             .property[index]
                             .number}"),
                       ),
                     ],
                   )
                 ],
               ),):estateController.estate.property[index].name=="مطبخ"?Container(decoration: BoxDecoration(color: Theme
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
                                    height: 40.0,
                                    width: 40.0,

                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                          Images.bed, height: 24,
                                          color: Theme.of(context).primaryColor,
                                          width: 24),
                                    ),
                                  ),
                                  Row(
                                    children: [

                                      Text("kitchen".tr),
                                      Container(
                                        child: Text(" ${ estateController.estate
                                            .property[index]
                                            .number} "),
                                      ),
                                    ],
                                  )
                                ],
                              ),):estateController.estate.property[index].name=="صلات"?Container(decoration: BoxDecoration(color: Theme
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
                                    height: 40.0,
                                    width: 40.0,

                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                          Images.bed, height: 24,
                                          color: Theme.of(context).primaryColor,
                                          width: 24),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("lounges".tr),
                                      Container(
                                        child: Text(" ${ estateController.estate
                                            .property[index]
                                            .number}"),
                                      ),
                                    ],
                                  )
                                ],
                              ),):estateController.estate.property[index].name=="صلات"?Container(decoration: BoxDecoration(color: Theme
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
                                    height: 40.0,
                                    width: 40.0,

                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      child: Image.asset(
                                          Images.bed, height: 24,
                                          color: Theme.of(context).primaryColor,
                                          width: 24),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10.0),
                                    child: Text(" ${ estateController.estate
                                        .property[index]
                                        .number} صالات"),
                                  )
                                ],
                              ),):Container():Container();




                            },
                          ),
                        ),
                      ):Container(),
                      Divider(height: 1,),

                      SizedBox(height: 5,),
                      Text(
                        'details'.tr,
                        style: robotoBlack.copyWith(fontSize: 14),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded( flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child:  Text("type_property".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child: Text( estateController.estate.property_type=="سكني"?"residential".tr:"commercial".tr,  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ),
                      estateController.estate.space!=null?  Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child:    Text("space".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child: Text("${estateController.estate.space}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),



                      estateController.estate.space!=null?  Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(10),child:    Text("space".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(10),child: Text("${estateController.estate.space}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),


                      estateController.estate.streetSpace!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child:  Text("width_street".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child: Text("${ estateController.estate.streetSpace}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),
                      estateController.estate.documentNumber!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(10),child:  Row(
                                      children: [
                                        Text("document_number".tr),

                                      ],
                                    ))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                    padding: EdgeInsets.all(10),child: Text("${ estateController.estate.documentNumber}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),


                      estateController.estate.priceNegotiation!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(
                                flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child:  Row(
                                  children: [
                                    Text("price".tr),
                                  ],
                                ))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child: Text(widget.estate.priceNegotiation=="قابل للتفاوض"?"negotiate".tr:"non_negotiable".tr,  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),


                      estateController.estate.buildSpace!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,
                                child: Container(
                                padding: EdgeInsets.all(10),child:  Text("build_space".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child: Text("${ estateController.estate.buildSpace}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),


                      estateController.estate.ownershipType!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child:  Text("advertiser".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child: Text("${ estateController.estate.ownershipType}",  style: robotoBlack.copyWith(fontSize: 14)))),
                          ],
                        ),
                      ):Container(),

                      estateController.estate.nationalAddress!=null?    Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(

                          children: [
                            Expanded(flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child:  Text("short_national_code".tr))),
                            VerticalDivider(width: 1.0),
                            Expanded(flex: 1,child: Container(
                                padding: EdgeInsets.all(10),child: Row(
                              children: [
                                Text("${ estateController.estate.nationalAddress}",  style: robotoBlack.copyWith(fontSize: 14)),
                                IconButton(onPressed:(){
                                  FlutterClipboard.copy(estateController.estate.nationalAddress.toString()).then(( value ) {
                                    showCustomSnackBar('copied'.tr, isError: false);
                                  });
                                }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,size: 15,)),
                              ],
                            ))),
                          ],
                        ),
                      ):Container(),


                    estateController.estate.networkType. length >0&& estateController.estate.networkType  == null?    NetworkTypeItem(estate: estateController.estate,restaurants: estateController.estate.networkType):Container(),
                      estateController.estate.interface!=null? InterfaceItem(estate: estateController.estate,restaurants:   estateController.estate.interface)   :Container(),
                      const MapDetailsView(
                          fromView: true),
                      estateController.isLoading && estateController.estate.otherAdvantages  == null?  Container:SizedBox(
                          height: estateController.estate.otherAdvantages  == null?0:120,
                          child:  GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: estateController.estate.otherAdvantages.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3 ,
                              childAspectRatio: (1/0.50),
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(

                                child: Container(
                                  margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_SMALL,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
                                  ),
                                  alignment: Alignment.center,
                                  child:   Row(

                                    children:  [

                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Flexible(
                                        flex: 1,
                                          child: Text(
                                      "${estateController.estate.otherAdvantages[index].name}",
                                        style: robotoMedium.copyWith(
                                          fontSize: Dimensions.fontSizeLarge,
                                          color: Theme.of(context).textTheme.bodyText1.color,
                                        ),
                                        maxLines: 2, overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                      ),


                      Divider(height: 1,),
                      Text("other_information".tr,
                          style: robotoBlack.copyWith(fontSize: 14)),
                 Container   (
                          padding: EdgeInsets.all(10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[

                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Get.find<AuthController>().isLoggedIn() ? Container(child:      GetBuilder<EstateController>(builder: (wishController) {
                                          return   ReportWidget();
                                        })) : NotLoggedInScreen();
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor,
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 0.5), // changes position of shadow
                                        ),

                                      ],

                                    ),

                                    child: Column(children: <Widget>[
                                      Image.asset(Images.space,height: 70,width: 70,),
                                      Text('report_the_ad'.tr,style: robotoBlack.copyWith(fontSize: 12)),
                                    ]),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    Get.dialog(NearByView(esate: _estate,));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor,
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(0, 0.5), // changes position of shadow
                                        ),

                                      ],

                                    ),

                                    child: Column(children: <Widget>[
                                    Image.asset(Images.estate_type,height: 70,width: 70,),
                                      Text('near_by'.tr,style: robotoBlack.copyWith(fontSize: 13)),

                                    ]),
                                  ),
                                ),
                           GestureDetector(
                             onTap: (){
                               Get.dialog(OfferList(estate: estateController.estate));
                             },
                             child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).primaryColor,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 0.5), // changes position of shadow
                              ),

                          ],

                        ),

                        child: Column(children: <Widget>[
                        Image.asset(Images.space,height: 70,width: 70,),
                          Text('deals_with_the_property'.tr,style: robotoBlack.copyWith(fontSize: 12)),
                        ]),
                    ),
                           )
                              ]
                          ),
                        ),

                      SizedBox(height: 10),
                      Divider(height: 1,),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.only(right: 20,left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),

                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  <Widget>[
                              Text('ad_number'.tr),
                              SizedBox(width: 20),
                              Text(estateController.estate.adNumber.toString()),

                              IconButton(onPressed:(){
                                FlutterClipboard.copy(estateController.estate.adNumber.toString()).then(( value ) {
                                  showCustomSnackBar('copied'.tr, isError: false);
                                });
                              }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,)),
                            ]),
                      ),

                      SizedBox(height: 6),
                      Divider(height: 1,),

                      Container(
                        padding: EdgeInsets.only(right: 20,left: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(0, 0.5), // changes position of shadow
                            ),

                          ],

                        ),

                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:  <Widget>[
                              Text('short_national_code'.tr),

                              Text('${estateController.estate.nationalAddress}'),
                              IconButton(onPressed:(){
                                FlutterClipboard.copy(estateController.estate.nationalAddress).then(( value ) {
                                  showCustomSnackBar('copied'.tr, isError: false);
                                });
                              }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,)),
                            ]),
                      ),

                      SizedBox(height: 6),
                      Divider(height: 1,),
                      SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async{
                          await Get.toNamed(RouteHelper.getProfileAgentRoute(estateController.estate.userId,0));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: Row(children: [

                            ClipOval(child: CustomImage(
                              image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                  '/${(userController.agentInfoModel != null && _isLoggedIn) ? userController.agentInfoModel.image : ''}',
                              height: 100, width: 100, fit: BoxFit.cover,
                            )),
                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                            Expanded(flex: 1,
                                child:
                            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            //  Text("${ _isLoggedIn ? '${userController.agentInfoModel.name}' : 'guest'.tr}", style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text(
                           '${estateController.estate.users.name}',
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                              Row(children: [

                                Container(
                                  height: 25, alignment: Alignment.center,
                                  padding:  EdgeInsets.only(right: 4,left: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Center(
                                    child: Text(estateController.estate.users.membershipType, style: robotoBold.copyWith(
                                      color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeDefault,
                                    )),
                                  ),
                                ),
                                Expanded(flex: 1,
                                    child: SizedBox()),




                              ]),
                              SizedBox(height: 4),
                             Row(
                               children: [
                                 Text(
                                   "advertiser_no".tr,
                                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                 ),
                                 SizedBox(width: 20),
                                 Text(
                                  "${ estateController.estate.users.advertiserNo}",
                                   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                 ),
                               ],
                             ),
                              Row(
                                children: [
                                  Text(
                                    "date_of_publication".tr,
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                                  ),
                                  SizedBox(width: 20),
                                  Text(
                                  estateController.estate.createdAt ?? "",
                                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                                  ),
                                ],
                              ),
                            ])
                            ),

                          ]),
                        ),
                      ),
                      !userController.isLoading ? CustomButton(
                        onPressed: () async{
                          await Get.toNamed(RouteHelper.getChatRoute(
                            notificationBody: NotificationBody(orderId: estateController.estate.id, restaurantId: estateController.estate.userId),
                            user: Userinfo(id:  estateController.estate.userId, name: userController.agentInfoModel.name,  image: userController.agentInfoModel.image,),estate_id: widget.estate.id

                          ));
                        },
                        buttonText: 'contact_the_advertiser'.tr,
                      ) : Center(child: Container()),

                    ],
                  ))

              ],

            )
                : const SizedBox();
          });
        });
        }),
      ),
    );
  }


}
