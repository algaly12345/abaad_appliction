import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
class ServiceProviderItem extends StatelessWidget {
  final Estate estate;
  final List<ServiceOffers> restaurants;
  const ServiceProviderItem({Key key,this.estate ,this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = restaurants == null;
    if(!_isNull) {
      _length = restaurants.length;
    return
      !_isNull ? _length > 0 ?Container(
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
      child:  ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: estate.serviceOffers .length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2.0, top: 8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                        shape: BoxShape.circle,
                      ),
                      child:  GetBuilder<SplashController>(builder: (splashController) {
                        String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                        //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                        return CustomImage(
                          image: '$_baseUrl/${estate.serviceOffers[index].image}',
                          fit: BoxFit.cover,
                          height: 35,
                          width: 35,
                        );
                      },
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 160.0,
                        child:  Text(
                          '${estate.serviceOffers[index].title}',
                          style: robotoBlack.copyWith(fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      SizedBox(
                        height: 16,
                        width: 44,
                        child: CustomPaint(
                          painter: PriceTagPaint(),
                          child: Center(
                            child: Text(
                                "20%",
                                style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                            ),
                          ),
                        ),
                      )
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
              ),
              Divider(color: Colors.grey.shade600, height: 1.0)
            ],
          );
        },
      ),
    ):Text("not data"):Text("looding");
  }
}}
