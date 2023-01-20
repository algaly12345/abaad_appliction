import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class RestaurantDetailsSheet extends StatelessWidget {
  final Function(int index) callback;
  RestaurantDetailsSheet({@required this.callback});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EstateController>(builder: (restaurantController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        Estate restaurant = restaurantController.estateModel.estates[splashController.nearestRestaurantIndex];

        return Stack(children: [

          InkWell(
            onTap: () {
              // Get.toNamed(
              //   RouteHelper.getRestaurantRoute(restaurant.id),
              //   arguments: RestaurantScreen(restaurant: restaurant),
              // );
            },
            child: Container(
              width: context.width, height: 310,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: ResponsiveHelper.isMobile(context) ? BorderRadius.vertical(top: Radius.circular(30))
                    : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
              ),
              child: Stack(children: [

                InkWell(
                  onTap: () => Get.find<SplashController>().setNearestEstateIndex(-1),
                  child: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                Stack(children: [

                  ClipRRect(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT), child: CustomImage(
                    image: '',
                    height: 180, width: context.width, fit: BoxFit.cover,
                  )),

                  Positioned(
                    left: 10, bottom: 10,
                    child: Container(
                      height: 80, width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Theme.of(context).cardColor, width: 2),
                      ),
                      child: ClipRRect(borderRadius: BorderRadius.circular(50),
                        child: CustomImage(
                          image: '',
                          placeholder: Images.placeholder,
                          height: 80, width: 80, fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(children: [

                  Expanded(child: Text(restaurant.address, maxLines: 1, style: robotoBold.copyWith(fontSize: Dimensions.fontSizeDefault))),

                  Icon(Icons.star, color: Theme.of(context).primaryColor, size: 18),
                ]),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Row(children: [

                  Icon(Icons.location_on_rounded, color: Theme.of(context).disabledColor, size: 20),
                  Expanded(child: Text(
                    '${restaurant.address != null ? restaurant.address : 'no_address_found'.tr}', maxLines: 2,
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  )),

                  Text('${(Geolocator.distanceBetween(
                    double.parse(restaurant.latitude), double.parse(restaurant.longitude),
                      26.451363,
                      50.109046
                    // double.parse(Get.find<LocationController>().getUserAddress().latitude),
                    // double.parse(Get.find<LocationController>().getUserAddress().longitude),
                  )/1000).toStringAsFixed(1)} ${'km'.tr}', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor)),
                  SizedBox(width: Dimensions.PADDING_SIZE_LARGE),


                ]),

              ]),
            ),
          ),

          splashController.nearestRestaurantIndex != (restaurantController.estateModel.estates.length-1) ? Positioned(
            top: 0, bottom: 0, left: 0,
            child: InkWell(
              onTap: () {
                  splashController.setNearestEstateIndex(splashController.nearestRestaurantIndex+1);
                  callback(splashController.nearestRestaurantIndex);
              },
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ) : SizedBox(),

          splashController.nearestRestaurantIndex != 0 ? Positioned(
            top: 0, bottom: 0, right: 0,
            child: InkWell(
              onTap: () {
                splashController.setNearestEstateIndex(splashController.nearestRestaurantIndex-1);
                callback(splashController.nearestRestaurantIndex);
              },
              child: Container(
                height: 40, width: 40, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ) : SizedBox(),

        ]);


      });
    });
  }

  Widget myDetailsContainer1(Estate estate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(estate.near,
                style: TextStyle(
                    color: Color(0xff6200ee),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              )),
        ),
        SizedBox(height:5.0),
        Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    child: const Text(
                      "4.1",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
                Container(
                  child: Icon(
                   Icons.add,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.add,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.add,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.add,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                  child: Icon(
                    Icons.add,
                    color: Colors.amber,
                    size: 15.0,
                  ),
                ),
                Container(
                    child: const Text(
                      "(946)",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    )),
              ],
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
              ),
            )),
        SizedBox(height:5.0),
        Container(
            child: Text(
              "Closed \u00B7 Opens 17:00 Thu",
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
