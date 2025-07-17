import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ZoneSheet extends StatelessWidget {
  final Function(int index) callback;
  ZoneSheet({required this.callback});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EstateController>(builder: (restaurantController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        Estate restaurant = restaurantController.estateModel.estates[splashController.nearestEstateIndex];

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
              child: Row(
                children: [
                  Container(
                    height: 35.0,
                    width: 35.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage("https://rimh2.domainstatic.com.au/lLttCNdxxvVfTZ_3Pq9qovjREKk=/660x440/filters:format(jpeg):quality(80)/2018271065_1_1_221226_032538-w4134-h2756"),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(width: 4.0),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: 160.0,
                      child: Text(
                      "name ather",
                        style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 3.0),
                    // RatingStars(
                    //   value: review['rating'] * 1.0,
                    //   starCount: 5,
                    //   starSize: 7,
                    //   valueLabelColor: const Color(0xff9b9b9b),
                    //   valueLabelTextStyle: const TextStyle(
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
                    //   const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                    //   valueLabelMargin: const EdgeInsets.only(right: 4),
                    //   starOffColor: const Color(0xffe7e8ea),
                    //   starColor: Colors.yellow,
                    // )
                  ])
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "name",
                  style: TextStyle(
                      fontFamily: 'WorkSans',
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade600, height: 1.0)
          ],
        );
        // return Stack(children: [
        //
        //   InkWell(
        //     onTap: () {
        //       // Get.toNamed(
        //       //   RouteHelper.getRestaurantRoute(restaurant.id),
        //       //   arguments: RestaurantScreen(restaurant: restaurant),
        //       // );
        //     },
        //     child: Container(
        //       width: context.width, height: 310,
        //       padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).cardColor,
        //         borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(30))
        //             : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
        //       ),
        //       child: Column(children: [
        //
        //         InkWell(
        //           onTap: () => Get.find<SplashController>().setNearestEstateIndex(-1),
        //           child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        //         ),
        //         SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //
        //         Stack(children: [
        //
        //           ClipRRect(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT), child: CustomImage(
        //             image: '',
        //             height: 180, width: context.width, fit: BoxFit.cover,
        //           )),
        //
        //           Positioned(
        //             left: 10, bottom: 10,
        //             child: Container(
        //               height: 80, width: 80,
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 border: Border.all(color: Theme.of(context).cardColor, width: 2),
        //               ),
        //               child: ClipRRect(borderRadius: BorderRadius.circular(50),
        //                 child: CustomImage(
        //                   image: '',
        //                   placeholder: Images.placeholder,
        //                   height: 80, width: 80, fit: BoxFit.cover,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ]),
        //         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        //
        //         Row(children: [
        //
        //           Expanded(child: Text(restaurant.address, maxLines: 1, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),
        //
        //           Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
        //         ]),
        //         SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        //
        //         Row(children: [
        //
        //           Icon(Icons.location_on_rounded, color: Theme.of(context).disabledColor, size: 20),
        //           Expanded(child: Text(
        //             '${restaurant.address != null ? restaurant.address : 'no_address_found'.tr}', maxLines: 2,
        //             style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        //           )),
        //
        //           Text('${(Geolocator.distanceBetween(
        //               double.parse(restaurant.latitude), double.parse(restaurant.longitude),
        //               26.451363,
        //               50.109046
        //             // double.parse(Get.find<LocationController>().getUserAddress().latitude),
        //             // double.parse(Get.find<LocationController>().getUserAddress().longitude),
        //           )/1000).toStringAsFixed(1)} ${'km'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
        //           SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
        //
        //
        //         ]),
        //
        //       ]),
        //     ),
        //   ),
        //
        //   splashController.nearestRestaurantIndex != (restaurantController.estateModel.estates.length-1) ? Positioned(
        //     top: 0, bottom: 0, left: 0,
        //     child: InkWell(
        //       onTap: () {
        //         splashController.setNearestEstateIndex(splashController.nearestRestaurantIndex+1);
        //         callback(splashController.nearestRestaurantIndex);
        //       },
        //       child: Container(
        //         height: 40, width: 40, alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
        //         ),
        //         child: Icon(Icons.arrow_back_ios_rounded),
        //       ),
        //     ),
        //   ) : SizedBox(),
        //
        //   splashController.nearestRestaurantIndex != 0 ? Positioned(
        //     top: 0, bottom: 0, right: 0,
        //     child: InkWell(
        //       onTap: () {
        //         splashController.setNearestEstateIndex(splashController.nearestRestaurantIndex-1);
        //         callback(splashController.nearestRestaurantIndex);
        //       },
        //       child: Container(
        //         height: 40, width: 40, alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
        //         ),
        //         child: Icon(Icons.arrow_forward_ios_rounded),
        //       ),
        //     ),
        //   ) : SizedBox(),
        //
        // ]);


      });
    });

  }
}
