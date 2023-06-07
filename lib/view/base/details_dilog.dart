
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/offer_list.dart';
import 'package:abaad/view/screen/estate/widgets/estate_view.dart';
import 'package:abaad/view/screen/estate/widgets/interface.dart';
import 'package:abaad/view/screen/estate/widgets/near_by_view.dart';
import 'package:abaad/view/screen/estate/widgets/network_type.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DettailsDilog extends StatefulWidget {
  Estate estate;
  // Generate some dummy data


  DettailsDilog({Key key,this.estate}) : super(key: key);

  @override
  State<DettailsDilog> createState() => _DettailsDilogState();
}

class _DettailsDilogState extends State<DettailsDilog> {
  bool _isLoggedIn;
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

                        Text(
                          'العنوان'.tr,
                          style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                        ),
                        Text("${widget.estate.title}",
                            style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),

                        Text(
                          'وصف مختصر'.tr,
                          style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("${widget.estate.shortDescription}",
                                style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 40,
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration:  BoxDecoration(
                                    color:widget.estate.type_add==1?Colors.blue:Colors.orange),
                                child:    Text( widget.estate.type_add=="for_sell"?"للبيع":"للإجار",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,)
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'وصف كامل '.tr,
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
                                'تحتوي علي ',
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeSmall),
                              ),

                            ],
                          ),
                          SizedBox(height: 10)
                          ,                      Divider(height: 1,),
                          widget.estate.property  != null ?Center(
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
                                        Container(
                                          margin: const EdgeInsets.only(left: 10.0),
                                          child: Text(" ${widget.estate.property[index].number ?? ""}  حمام"),
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
                                        Container(
                                          margin: EdgeInsets.only(left: 8.0),
                                          child: Text(" ${  widget.estate.property[index].number ?? ""}  مطبخ"),
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
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(" ${widget.estate
                                            .property[index]
                                            .number}  غرف النوم"),
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
                                              Images.bed, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(" ${ widget.estate
                                            .property[index]
                                            .number} مطبخ "),
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
                                              Images.bed, height: 24,
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
                                              Images.bed, height: 24,
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
                            'التفاصيل',
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
                                        padding: EdgeInsets.all(10),child:  Text("نوع العقار"))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text("سكني",  style: robotoBlack.copyWith(fontSize: 14)))),
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
                                        padding: EdgeInsets.all(10),child:  Text("المساحة"))),
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
                                        padding: EdgeInsets.all(10),child:  Text("عرض الشارع"))),
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
                                        padding: EdgeInsets.all(10),child:  Text("رقم الوثيقة"))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${ widget.estate.documentNumber}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),

                          widget.estate.interface!=null? InterfaceItem(estate: widget.estate,restaurants:   widget.estate.interface)   :Container(),
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
                                    padding: EdgeInsets.all(10),child:  Text("السعر"))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,
                                    child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${ widget.estate.priceNegotiation}",  style: robotoBlack.copyWith(fontSize: 14)))),
                              ],
                            ),
                          ):Container(),


                          widget.estate.buildSpace!=""?    Container(
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
                                        padding: EdgeInsets.all(10),child:  Text("مساحة البناء"))),
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
                                        padding: EdgeInsets.all(10),child:  Text("عمر العقار"))),
                                    VerticalDivider(width: 1.0),
                                    Expanded(flex: 1,child: Container(
                                        padding: EdgeInsets.all(10),child: Text("${widget.estate.ageEstate} سنة",  style: robotoBlack.copyWith(fontSize: 14)))),
                                  ],
                                ),
                              ):Container(),
                            ],
                          ):Container(),
                          widget.estate.ownershipType!=null?    Container(
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
                                    padding: EdgeInsets.all(10),child:  Text("المعلن"))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,child: Container(
                                    padding: EdgeInsets.all(10),child: Text("${ widget.estate.ownershipType}",  style: robotoBlack.copyWith(fontSize: 14)))),
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
                                    padding: EdgeInsets.all(10),child:  Text("الرمز الوطني المختصر"))),
                                VerticalDivider(width: 1.0),
                                Expanded(flex: 1,child: Container(
                                    padding: EdgeInsets.all(10),child: Row(
                                  children: [
                                    Text("${ widget.estate.nationalAddress}",  style: robotoBlack.copyWith(fontSize: 14)),
                                    IconButton(onPressed:(){
                                      FlutterClipboard.copy(widget.estate.nationalAddress.toString()).then(( value ) {
                                        showCustomSnackBar('تم النسخ'.tr, isError: false);
                                      });
                                    }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,size: 15,)),
                                  ],
                                ))),
                              ],
                            ),
                          ):Container(),


                          widget.estate.networkType. length >0&& widget.estate.networkType  == null?    NetworkTypeItem(estate: widget.estate,restaurants: widget.estate.networkType):Container(),

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
                          Text("معلومات اخرى",
                              style: robotoBlack.copyWith(fontSize: 14)),
                          Container   (
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
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
                                        Text('المرافق',style: robotoBlack.copyWith(fontSize: 13)),

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
                                        Text('عروض مع العقار',style: robotoBlack.copyWith(fontSize: 12)),
                                      ]),
                                    ),
                                  ),
                                  widget.estate.ageEstate!=null?Container(
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

                                    child:Column(children: <Widget>[
                                      Image.asset(Images.age_estate,height: 70,width: 70,),
                                      Text('عمر العقار'),
                                       Text(widget.estate.ageEstate),
                                    ]),
                                  ):Container(
                                      height: 70,width: 70
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
                                  Text('رقم الإعلان'),
                                  SizedBox(width: 20),
                                  Text(widget.estate.adNumber.toString()),

                                  IconButton(onPressed:(){
                                    FlutterClipboard.copy(widget.estate.adNumber.toString()).then(( value ) {
                                      showCustomSnackBar('تم النسخ'.tr, isError: false);
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
                                  Text('الرمز الوطني المختصر'),

                                  Text('${widget.estate.nationalAddress}'),
                                  IconButton(onPressed:(){
                                    FlutterClipboard.copy(widget.estate.nationalAddress).then(( value ) {
                                      showCustomSnackBar('تم النسخ'.tr, isError: false);
                                    });
                                  }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,)),
                                ]),
                          ),

                          SizedBox(height: 6),
                          Divider(height: 1,),
                          SizedBox(height: 6),

      GetBuilder<UserController>(builder: (userController) {

        return Column(
          children: [
            GestureDetector(
              onTap: () async{
                await Get.toNamed(RouteHelper.getProfileAgentRoute(widget.estate.userId));
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
                        '/${(userController.agentInfoModel != null && _isLoggedIn) ? userController.agentInfoModel.image : ''}',
                    height: 100, width: 100, fit: BoxFit.cover,
                  )),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Expanded(flex: 1,
                      child:
                      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                        //  Text("${ _isLoggedIn ? '${userController.agentInfoModel.name}' : 'guest'.tr}", style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(
                          '${userController.agentInfoModel.name}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                        Row(children: [

                          Container(
                            height: 25, width: 70, alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            ),
                            child: Center(
                              child: Text(widget.estate.ownershipType, style: robotoBold.copyWith(
                                color: Theme.of(context).cardColor,
                                fontSize: Dimensions.fontSizeLarge,
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
                              "رقم المعلن",
                              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                            ),
                            SizedBox(width: 20),
                            // Text(
                            //   userController.agentInfoModel.agent.advertiserNo==null?"":userController.agentInfoModel.agent.advertiserNo,
                            //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "تاريخ النشر",
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
            !userController.isLoading ? CustomButton(
              onPressed: () async{
                await Get.toNamed(RouteHelper.getChatRoute(
                    notificationBody: NotificationBody(orderId: widget.estate.id, restaurantId: widget.estate.userId),
                    user: Userinfo(id:  widget.estate.userId, name: userController.agentInfoModel.name,  image: userController.agentInfoModel.image,),estate_id: widget.estate.id

                ));
              },
              buttonText: 'تواصل مع المعلن',
            ) : Center(child: Container()),
          ],
        );
      })
                        ],
                      ))

                ],

              )
                  : const SizedBox()


      ),
    );

  }


}



