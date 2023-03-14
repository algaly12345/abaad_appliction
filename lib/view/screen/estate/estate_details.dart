import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/controller/wishlist_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_dialog.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';

import 'widgets/estate_view.dart';
class EstateDetails extends StatefulWidget {
final Estate estate;
final int user_id;
EstateDetails({@required this.estate,this.user_id});

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




    if(Get.find<AuthController>().isLoggedIn()) {
      if(Get.find<CategoryController>().categoryList == null) {
        Get.find<CategoryController>().getCategoryList(true);
      }
      Get.find<EstateController>().getCategoriesEstateList(1, 1, 'all', false);
      Get.find<EstateController>().getEstateDetails(Estate(id: widget.estate.id));
      print("mohammed-------------${widget.user_id}");
       Get.find<WishListController>().getWishList();


    }


    Get.find<UserController>().getUserInfoByID(widget.user_id);
    getAddressFromLatLang(26.439280,50.094460);

  }
  @override
  Widget build(BuildContext context) {
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    return  Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<EstateController>(builder: (estateController) {
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
              children: [EstateView(fromView: true,estate:estateController.estate,EstateId: widget.estate.id ) ,


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
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      Text("${estateController.estate.title}",
                          style: robotoBlack.copyWith(fontSize: 14)),

                      Text(
                        'وصف مختصر'.tr,
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${estateController.estate.shortDescription}",
                              style: robotoBlack.copyWith(fontSize: 14)),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 40,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration:  BoxDecoration(
                                  color: estateController.estate.forRent==1?Colors.blue:Colors.orange),
                              child:  Text( estateController.estate.forRent==1?"للبيع":"للإجار",
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
                        blurRadius: 1.0,
                      ),
                    ], ),
                  child: Column(
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
              estateController.estate.property  != null ?Center(
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
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(" ${estateController.estate.property[index].number ?? ""}  حمام"),
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
                   Container(
                     margin: EdgeInsets.only(left: 8.0),
                     child: Text(" ${  estateController.estate.property[index].number ?? ""}  مطبخ"),
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
                   Container(
                     margin: const EdgeInsets.only(left: 10.0),
                     child: Text(" ${ estateController.estate
                         .property[index]
                         .number}  غرف النوم"),
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
                                        .number}عدد الصالات"),
                                  )
                                ],
                              ),):Container():Container();




                            },
                          ),
                        ),
                      ):Container(),
                      Divider(height: 1,),
                      Text(
                        'المرافق ',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall),
                      ),

                      const MapDetailsView(
                          fromView: true),
                      estateController.isLoading && estateController.estate.facilities  == null ?Container(): SizedBox(
                          height: 160,
                          child:  GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: estateController.estate.facilities.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3 ,
                              childAspectRatio: (1/0.50),
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(


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

                                    children: [
                                      estateController.estate.facilities[index].image.isEmpty?Container():CustomImage(
                                        image: '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}'
                                            '/${ estateController.estate.facilities[index].image}',
                                        height: 30, width: 30,
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Flexible(
                                        flex: 1,
                                          child: Text(
                                        estateController.estate.facilities[index].name,
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
                      estateController.isLoading && estateController.estate.otherAdvantages  == null?  Container:SizedBox(
                          height: 160,
                          child:  GridView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: estateController.estate.otherAdvantages.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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

                                    children: [

                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                      Flexible(
                                        flex: 1,
                                          child: Text(
                                        estateController.estate.otherAdvantages[index].name,
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
                              Container(
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
                                  Text('نوع العقار'),
                                  Text('سكني'),
                                ]),
                              ),
                    Container(
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
                        Text('المساحة'),
                        Text(estateController.estate.space),
                      ]),
                    ),
                      Container(
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
            Image.asset(Images.age_estate,height: 70,width: 70,),
            Text('عمر العقار'),
              estateController.estate.ageEstate!=null? Text(estateController.estate.ageEstate):Container(),
            ]),
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
                              Text(estateController.estate.adNumber.toString()),

                              IconButton(onPressed:(){
                                FlutterClipboard.copy(estateController.estate.adNumber.toString()).then(( value ) {
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

                              Text('546854166'),
                              IconButton(onPressed:(){
                                FlutterClipboard.copy(estateController.estate.nationalAddress).then(( value ) {
                                  showCustomSnackBar('تم النسخ'.tr, isError: false);
                                });
                              }, icon: Icon(Icons.copy,color: Theme.of(context).primaryColor,)),
                            ]),
                      ),

                      SizedBox(height: 6),
                      Divider(height: 1,),
                      SizedBox(height: 6),
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

                          Expanded(child:
                          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                            Text(userController.agentInfoModel.name, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Row(children: [

                              Container(
                                height: 25, width: 70, alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                ),
                                child: Center(
                                  child: Text(estateController.estate.ownershipType, style: robotoBold.copyWith(
                                    color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeLarge,
                                  )),
                                ),
                              ),
                              Expanded(child: SizedBox()),




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
                      !userController.isLoading ? CustomButton(
                        onPressed: () async{
                          await Get.toNamed(RouteHelper.getChatRoute(
                            notificationBody: NotificationBody(orderId: estateController.estate.id, restaurantId: estateController.estate.userId),
                            user: Userinfo(id:  estateController.estate.userId, name: userController.agentInfoModel.name,  image: userController.agentInfoModel.image,),estate_id: widget.estate.id

                          ));
                        },
                        buttonText: 'تواصل مع المعلن',
                      ) : Center(child: CircularProgressIndicator()),

                    ],
                  ),
                ),

              ],
            )
                : const SizedBox();
          });
        });
        }),
      ),
    );
  }


  Future<void> getAddressFromLatLang(double lat, double log) async {
    print("omeromer");
    List<Placemark> placemark =
    await placemarkFromCoordinates(lat, log);
    Placemark place = placemark[0];
   String  _address= 'Address : ${place.locality},${place.country}';
   showCustomSnackBar("message   ${place.name}");
    print("adress-------------------------------------${place.locality},${place.country}");
  }
}
