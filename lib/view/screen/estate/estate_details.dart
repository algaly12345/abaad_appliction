import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/map_details_view.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'widgets/estate_view.dart';
import 'widgets/service _provider_view.dart';
class EstateDetails extends StatefulWidget {
final Estate estate;
EstateDetails({@required this.estate});

  @override
  State<EstateDetails> createState() => _EstateDetailsState();
}

class _EstateDetailsState extends State<EstateDetails> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  @override
  void initState() {
    super.initState();
    Get.find<EstateController>().getEstateDetails(Estate(id: 6));
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<EstateController>().getCategoriesEstateList(1, 1, 'all', false);

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<EstateController>(builder: (estateController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {

            Estate _estate;

            if(estateController.estate != null   && categoryController.categoryList != null) {
              _estate = estateController.estate;
            }
            estateController.setCategoryList();

            return (estateController.estate != null && estateController.estate.shortDescription != null) ?
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                EstateView(
                    fromView: true,estate:estateController.estate ) ,


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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${estateController.estate.shortDescription}",
                              style: robotoBlack.copyWith(fontSize: 14)),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 40,
                              margin: const EdgeInsets.only(top: 10),
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
                      Text("${estateController.estate.longDescription}",
                          style:  robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                    ],
                  ),
                ),

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("تحتوي علي ",
                              style: robotoBlack.copyWith(fontSize: 14)),

                        ],
                      ),
                      SizedBox(height: 10)
,                      Divider(height: 1,),
                      estateController.estate.property!=null?       Center(
                        child: Container(
                          height: 35,

                          child:ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:   estateController.estate.property.length,
                              scrollDirection: Axis.horizontal,
                            // ignore: missing_return
                            itemBuilder: (context, index) {
                              if(estateController.estate.property[index].name=="حمام" ) {
                                return Container(
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
                                        height: 40.0,
                                        width: 40.0,

                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          child: Image.asset(
                                              Images.bathroom, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10.0),
                                        child: Text(" ${ estateController.estate
                                            .property[index]
                                            .number} عدد الحمامات"),
                                      )
                                    ],
                                  ),
                                );
                              }else if(estateController.estate.property[index].name=="مطلبخ"){
                                return Container(
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
                                        height: 50.0,
                                        width: 50.0,

                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          child: Image.asset(
                                              Images.kitchen, height: 24,
                                              color: Theme.of(context).primaryColor,
                                              width: 24),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10.0),
                                        child: Text(" ${ estateController.estate
                                            .property[index]
                                            .number} عدد المطابخ"),
                                      )
                                    ],
                                  ),
                                );
                              }else if(estateController.estate.property[index].name=="غرف نوم"){
                                return Container(
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
                                  margin: const EdgeInsets.all(5.0),
                                  child: Row(
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
                                            .number} عدد غرف النوم"),
                                      )
                                    ],
                                  ),
                                );
                              }



                           //   Container(
                           //
                           //   padding: const EdgeInsets.only(right: 4,left: 4),
                           //   child: ElevatedButton(
                           //     onPressed: () {},
                           //     child: Text( estateController.estate.property[index].name),
                           //     style: ButtonStyle(
                           //       overlayColor: MaterialStateProperty.resolveWith<Color>(
                           //             (Set<MaterialState> states) {
                           //           if (states.contains(MaterialState.pressed)) {
                           //             return Colors.red.withOpacity(0.8);
                           //           }
                           //           return Colors.transparent;
                           //         },
                           //       ),
                           //     ),
                           //   ),
                           // );

                            },
                          ),
                        ),
                      ):Container(),
                      Divider(height: 1,),

                      MapDetailsView(
                          fromView: true),
                      Text("معلومات اخرى",
                          style: robotoBlack.copyWith(fontSize: 14)),

                      Container   (
                        padding: EdgeInsets.all(20),
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
                                  Text('Front Camera'),
                                ]),
                              ),
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
                      Image.asset(Images.space,height: 70,width: 70,),
                        Text('المساحة'),
                        Text('Front Camera'),
                      ]),
                    ),
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
            Image.asset(Images.age_estate,height: 70,width: 70,),
            Text('عمر العقار'),
              Text(estateController.estate.ageEstate),
            ]),
            ),
                            ]
                        ),
                      )
                    ],
                  ),
                ),

              ],
            )
                : const Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }
}
