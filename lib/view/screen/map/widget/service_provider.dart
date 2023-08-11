import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ServiceProviderItem extends StatelessWidget {
  final Estate estate;

  const ServiceProviderItem({Key key,this.estate}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = estate == null;
    if(!_isNull) {
      print("---------------------------------------4${estate.id}");
      _length = estate.serviceOffers.length;
    return
      !_isNull ? _length > 0 ?Container(
      height: 270,
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
      child:  ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: estate.serviceOffers .length,
        itemBuilder: (context, index) {
          return
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
                          border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                          shape: BoxShape.circle,
                        ),
                        child:  GetBuilder<SplashController>(builder: (splashController) {
                          String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                          //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                          return ClipOval(
                            child: CustomImage(
                              image: '$_baseUrl/${estate.serviceOffers[index].image}',
                              fit: BoxFit.cover,
                              height: 35,
                              width: 35,
                            ),
                          );
                        },
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(

                          child:  Text(
                            '${estate.serviceOffers[index].title}',
                            style: robotoBlack.copyWith(fontSize: 11),
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        Row(
                          children: [
                           estate.serviceOffers[index].servicePrice!=null?Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)):Text("discount".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                            SizedBox(width: 11.0),
                           estate.serviceOffers[index].discount!=null?  SizedBox(
                              height: 16,
                              width: 44,
                              child: CustomPaint(
                                painter: PriceTagPaint(),
                                child: Center(
                                  child: Text(
                                      "${estate.serviceOffers[index].discount}%",
                                      style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                                  ),
                                ),
                              ),
                            ):Text(" ${estate.serviceOffers[index].servicePrice} ريال "  ,style: robotoBlack.copyWith(fontSize: 11)),
                          ],
                        ),
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
          );
        },
      ),
    ):Text(""):Text("");
  }
}}
