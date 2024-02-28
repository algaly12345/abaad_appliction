
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
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
import 'package:abaad/view/screen/estate/widgets/estate_view.dart';
import 'package:abaad/view/screen/estate/widgets/interface.dart';
import 'package:abaad/view/screen/estate/widgets/near_by_view.dart';
import 'package:abaad/view/screen/estate/widgets/network_type.dart';
import 'package:abaad/view/screen/estate/widgets/report_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'my_text_field.dart';

class DettailsDilog extends StatefulWidget {
  Estate estate;
  // Generate some dummy data


  DettailsDilog({Key key,this.estate}) : super(key: key);

  @override
  State<DettailsDilog> createState() => _DettailsDilogState();
}

class _DettailsDilogState extends State<DettailsDilog> {
  bool _isLoggedIn;
  String like;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();






    Get.find<UserController>().getUserInfoByID(widget.estate.userId);
  }
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    return Scaffold(

      body: SingleChildScrollView(
        child: (widget.estate != null) ?
              Column(

                children: [EstateView(fromView: true,estate:widget.estate ) ,


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

                        // Text(
                        //   'title'.tr,
                        //   style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                        // ),
                        Row(
                          children: [
                            Text(isArabic ? "${widget.estate.categoryNameAr} -${widget.estate.zoneNameAr} -${widget.estate.districts??''}":"${widget.estate.categoryName} -${widget.estate.zoneName??''} ",
                                style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          ],
                        ),

                        Text(
                          'shot_description'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                        Text("${widget.estate.shortDescription}",
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Align(
                              alignment: Alignment.topLeft,
                              child:  Container(
                                padding: const EdgeInsets.only(right: 4,left: 4),
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        4),
                                    color:  Colors.blue),
                                child:  Row(
                                  children: [

                                    Text(
                                        "price".tr,
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).cardColor,
                                        )),
                                    SizedBox(width: 2,),
                                    Text(
                                        "${widget.estate.price}",
                                        style: robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).cardColor,
                                        ),

                                    ),

                                    SizedBox(width: 2.0),
                                    Text("currency".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,color: Colors.white),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'long_description'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                        ),

                        Text("${widget.estate.longDescription}",
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
                          widget.estate.category!="5" ?Center(
                            child: Container(
                              height: 35,

                              child:ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount:   widget.estate.property.length,
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemBuilder: (context, index) {

                                  return widget.estate !=null? widget.estate.property[index].name=="حمام"? Container(
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
                                              child: Text(" ${widget.estate.property[index].number ?? ""}"),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ): widget.estate.property[index].name=="مطلبخ"?Container(
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
                                              child: Text(" ${  widget.estate.property[index].number ?? ""}"),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ):widget.estate.property[index].name=="غرف نوم"?Container(decoration: BoxDecoration(color: Theme
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
                                            child: Text(" ${widget.estate
                                                .property[index]
                                                .number}"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),):widget.estate.property[index].name=="مطبخ"?Container(decoration: BoxDecoration(color: Theme
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
                                              Images.kitchen, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Row(
                                        children: [

                                          Text("kitchen".tr),
                                          Container(
                                            child: Text(" ${ widget.estate
                                                .property[index]
                                                .number} "),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),):widget.estate.property[index].name=="صلات"?Container(decoration: BoxDecoration(color: Theme
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
                                              Images.setroom, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text("lounges".tr),
                                          Container(
                                            child: Text(" ${ widget.estate
                                                .property[index]
                                                .number}"),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),):widget.estate.property[index].name=="صلات"?Container(decoration: BoxDecoration(color: Theme
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
                                              Images.setroom, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(" ${ widget.estate
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
                                        padding: EdgeInsets.all(10),child:  Text( widget.estate.estate_type=="1"?"residential".tr:"commercial".tr,  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ),
                          widget.estate.space!=null?  Container(
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
                                        padding: EdgeInsets.all(10),child:  Text("space".tr))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${widget.estate.space}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),

                          widget.estate.streetSpace!=null?    Container(
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
                                        padding: EdgeInsets.all(10),child: Text("${ widget.estate.streetSpace}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),
                          widget.estate.documentNumber!=null?    Container(
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
                                        padding: EdgeInsets.all(10),child:  Text("document_number".tr))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${ widget.estate.documentNumber}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),


                          widget.estate.priceNegotiation!=null?    Container(
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
                                    padding: EdgeInsets.all(10),child:  Text("price".tr))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text(widget.estate.priceNegotiation=="قابل للتفاوض"?"negotiate".tr:"non_negotiable".tr,  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),


                          widget.estate.buildSpace!=null?    Container(
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
                                    padding: EdgeInsets.all(10),child: Text("${ widget.estate.buildSpace}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),

                          widget.estate.category!="5"? Column(
                            children: [
                              widget.estate.ageEstate!=null?    Container(
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
                                        padding: EdgeInsets.all(10),child:  Text("age_of_the_property".tr))),
                                    VerticalDivider(width: 1.0),
                                    Expanded(flex: 1,child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${widget.estate.ageEstate}",  style: robotoBlack.copyWith(fontSize: 14)))),
                                  ],
                                ),
                              ):Container(),
                            ],
                          ):Container(),
                          widget.estate.users.name!=null?    Container(
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
                                    padding: EdgeInsets.all(10),child:  Text("advertiser_phone".tr))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,child: Container(
                                    padding: EdgeInsets.all(10),child: Text("${ widget.estate.users.phone}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),

                          widget.estate.nationalAddress!=null?    Container(
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
                                    Text("${ widget.estate.nationalAddress}",  style: robotoBlack.copyWith(fontSize: 14)),
                                    IconButton(onPressed:(){
                                      FlutterClipboard.copy(widget.estate.nationalAddress.toString()).then(( value ) {
                                        showCustomSnackBar('copied'.tr, isError: false);
                                      });
                                    }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,size: 15,)),
                                  ],
                                ))),
                              ],
                            ),
                          ):Container(),


                          widget.estate.networkType. length >0?    NetworkTypeItem(estate: widget.estate,restaurants: widget.estate.networkType):Container(),
                          widget.estate.interface!=null? InterfaceItem(estate: widget.estate,restaurants:   widget.estate.interface)   :Container(),
                          const MapDetailsView(
                              fromView: true),
                         widget.estate.otherAdvantages  == null?  Container:SizedBox(
                              height: widget.estate.otherAdvantages  == null?0:120,
                              child:  GridView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: widget.estate.otherAdvantages.length,
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
                                          "${widget.estate.otherAdvantages[index].name}",
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
                                            return   ReportWidget(estate_id: widget.estate.id,);
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
                                      Get.dialog(NearByView(esate: widget.estate,));
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
                                      Get.dialog(OfferList(estate: widget.estate));
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
                                  ),
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
                                  Text(widget.estate.adNumber.toString()),

                                  IconButton(onPressed:(){
                                    FlutterClipboard.copy(widget.estate.adNumber.toString()).then(( value ) {
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

                                  Text('${widget.estate.nationalAddress}'),
                                  IconButton(onPressed:(){
                                    FlutterClipboard.copy(widget.estate.nationalAddress).then(( value ) {
                                      showCustomSnackBar('copied'.tr, isError: false);
                                    });
                                  }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,)),
                                ]),
                          ),

                          SizedBox(height: 6),
                          Divider(height: 1,),
                          SizedBox(height: 6),

      Column(
          children: [
            GestureDetector(
              onTap: () async{
                print("-------------------------------");
                Get.toNamed(RouteHelper.getProfileAgentRoute(widget.estate.users.id,0));

              },
              child:

              Container(
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
                        '/${widget.estate.users.image != null  ? widget.estate.users.image  : ''}',
                    height: 100, width: 100, fit: BoxFit.cover,
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Expanded(flex: 1,
                      child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        //  Text("${ _isLoggedIn ? '${userController.agentInfoModel.name}' : 'guest'.tr}", style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          '${widget.estate.users.name }',
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
                              child: Text(widget.estate.users.membershipType??'', style: robotoBold.copyWith(
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
                              "${widget.estate.users.advertiserNo==null?"":widget.estate.users.advertiserNo}",
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
                            // SizedBox(width: 20),
                            Text(
                              widget.estate.createdAt ?? "",
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
                            ),
                          ],
                        ),
                      ])
                  ),

                ]),
              ),
            ),
            CustomButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Get.find<AuthController>().isLoggedIn() ? Container(child:      GetBuilder<EstateController>(builder: (wishController) {
                      return   ConctactWidget(widget.estate.title, "",widget.estate.shortDescription,widget.estate.users.phone);
                    })) : NotLoggedInScreen();
                  },
                );
              },


              // async {



              buttonText: 'contact_the_advertiser'.tr,
            ),
          ],
        ),

                        ],
                      ))

                ],

              )
                  : const SizedBox()


      ),
    );

  }

  Widget ConctactWidget(String title  ,String image,String disc ,String phone)
  {

    return AlertDialog(
      title: Text('contact_the_advertiser'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Container(
            padding:  const EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .cardColor,
              borderRadius: BorderRadius.circular(
                14),
              boxShadow: [
                BoxShadow(color: Colors.grey[Get.isDarkMode
                    ? 800
                    : 200],
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 2))
              ],
            ),
          ),


          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child:  GetBuilder<SplashController>(builder: (splashController) {
                        String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                        //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                        return const ClipOval(
                          child: Icon(Icons.phone,size: 40, color: Colors.green,),
                        );
                      },
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(

                        child:  Text(
                          'call_the_advertiser'.tr,
                          style: robotoBlack.copyWith(fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      // const RatingStars(
                      //   value: 3* 1.0,
                      //   starCount: 5,
                      //   starSize: 7,
                      //   valueLabelColor: Color(0xff9b9b9b),
                      //   valueLabelTextStyle: TextStyle(
                      //       color: Colors.white,
                      //       fontFamily: 'WorkSans',
                      //       fontWeight: FontWeight.w400,
                      //       fontStyle: FontStyle.normal,
                      //       fontSize: 9.0),
                      //   valueLabelRadius: 7,
                      //   maxValue: 5,
                      //   starSpacing: 2,
                      //   maxValueVisibility: false,
                      //   valueLabelVisibility: true,
                      //   animationDuration: Duration(milliseconds: 1000),
                      //   valueLabelPadding:
                      //   EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                      //   valueLabelMargin: EdgeInsets.only(right: 4),
                      //   starOffColor: Color(0xffe7e8ea),
                      //   starColor: Colors.yellow,
                      // )
                    ])
                  ],
                ),

                // Divider(color: Colors.grey.shade600, height: 1.0)
              ],
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: (){
              buildDynamicLinks(title ,image,disc,phone);

            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [

                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(

                          shape: BoxShape.circle,
                        ),
                        child:  GetBuilder<SplashController>(builder: (splashController) {
                          String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                          //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                          return ClipOval(
                            child: Icon(Icons.whatsapp,size: 40, color: Colors.green,),
                          );
                        },
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(

                          child:  Text(
                            'contact_whatsApp'.tr,
                            style: robotoBlack.copyWith(fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        // const RatingStars(
                        //   value: 3* 1.0,
                        //   starCount: 5,
                        //   starSize: 7,
                        //   valueLabelColor: Color(0xff9b9b9b),
                        //   valueLabelTextStyle: TextStyle(
                        //       color: Colors.white,
                        //       fontFamily: 'WorkSans',
                        //       fontWeight: FontWeight.w400,
                        //       fontStyle: FontStyle.normal,
                        //       fontSize: 9.0),
                        //   valueLabelRadius: 7,
                        //   maxValue: 5,
                        //   starSpacing: 2,
                        //   maxValueVisibility: false,
                        //   valueLabelVisibility: true,
                        //   animationDuration: Duration(milliseconds: 1000),
                        //   valueLabelPadding:
                        //   EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                        //   valueLabelMargin: EdgeInsets.only(right: 4),
                        //   starOffColor: Color(0xffe7e8ea),
                        //   starColor: Colors.yellow,
                        // )
                      ])
                    ],
                  ),

                  // Divider(color: Colors.grey.shade600, height: 1.0)
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    GestureDetector(
                      onTap: () async{
  try {
  String url = "https://abaadapp.page.link";
  final DynamicLinkParameters parameters = DynamicLinkParameters(
  uriPrefix: url,
  link: Uri.parse('$url/${widget.estate.id.toString()}'),
  androidParameters: AndroidParameters(
  packageName: "sa.pdm.abaad.abaad",
  minimumVersion: 0,
  ),
  iosParameters: IosParameters(
  bundleId: "Bundle-ID",
  minimumVersion: '0',
  ),
  );

  final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
  String desc = '${dynamicUrl.shortUrl.toString()}';

  await Get.toNamed(RouteHelper.getChatRoute(
  notificationBody: NotificationBody(
  orderId: widget.estate.id,
  restaurantId: widget.estate.userId,
  ),
  user: Userinfo(
  id: widget.estate.userId,
  name: widget.estate.users.name,
  image: widget.estate.users.image,
  ),
  estate_id: widget.estate.id,
  link: desc,
  ));
  } catch (e) {
  print("Error building short dynamic link: $e");
  // Handle the error as needed, e.g., show an error message to the user.
  }

                      },

                      child:  GetBuilder<SplashController>(builder: (splashController) {
                        String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                        //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                        return const ClipOval(
                          child: Icon(Icons.chat,size: 35, color: Colors.green,),
                        );
                      },
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(

                        child:  Text(
                          'Chat_inside_the_app'.tr,
                          style: robotoBlack.copyWith(fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      // const RatingStars(
                      //   value: 3* 1.0,
                      //   starCount: 5,
                      //   starSize: 7,
                      //   valueLabelColor: Color(0xff9b9b9b),
                      //   valueLabelTextStyle: TextStyle(
                      //       color: Colors.white,
                      //       fontFamily: 'WorkSans',
                      //       fontWeight: FontWeight.w400,
                      //       fontStyle: FontStyle.normal,
                      //       fontSize: 9.0),
                      //   valueLabelRadius: 7,
                      //   maxValue: 5,
                      //   starSpacing: 2,
                      //   maxValueVisibility: false,
                      //   valueLabelVisibility: true,
                      //   animationDuration: Duration(milliseconds: 1000),
                      //   valueLabelPadding:
                      //   EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                      //   valueLabelMargin: EdgeInsets.only(right: 4),
                      //   starOffColor: Color(0xffe7e8ea),
                      //   starColor: Colors.yellow,
                      // )
                    ])
                  ],
                ),

                // Divider(color: Colors.grey.shade600, height: 1.0)
              ],
            ),
          ),
        ],
      ),

    );
  }






  buildDynamicLinks(String title,String image,String docId,String phone) async {
    String url = "https://abaadapp.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$docId'),
      androidParameters: AndroidParameters(
        packageName: "sa.pdm.abaad.abaad",
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '',
          imageUrl:
          Uri.parse("$image"),
          title: title),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    String desc = '${dynamicUrl.shortUrl.toString()}';
    var whatsapp = "$phone";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=$desc \n مرحبا لديك عرض في  تطبيق ابعاد ");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
    // await Share.share(desc, subject: title,);

  }
}

openDialPad(String phoneNumber) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Can't open dial pad.");
  }
}