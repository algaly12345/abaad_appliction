import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';

import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/estate_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_stack/image_stack.dart';

class EstateDetailsSheet extends StatelessWidget {
  final Function(int index) callback;
  final void Function() onPressed;
  EstateDetailsSheet({@required this.callback,   this.onPressed});

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
    return GetBuilder<EstateController>(builder: (estateController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        Estate estate = estateController.estateModel.estates[splashController.nearestEstateIndex];

        return Stack(children: [

          InkWell(
            onTap: () {
              Get.toNamed(RouteHelper.getDetailsRoute(estate.id,estate.userId));
            },
            child: Container(
              width: context.width,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,

              ),
              child: Stack(children: [


                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      // InkWell(
                      //   onTap: () =>
                      //       Get.find<SplashController>().setNearestEstateIndex(-1),
                      //   child: Icon(Icons.keyboard_arrow_down_rounded, size: 30)
                      // ),
                      estate.serviceOffers.length>0? SizedBox(
                        height: 36,

                        child: Container(
                          padding: const EdgeInsets.all(3),
                         decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.orangeAccent),
                          ),
                          child: GestureDetector(
                            onTap: onPressed,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(Images.offer_icon, height: 40, width: 40),
                                    Text("يتضمن عروض خاص مقدمة لك",style: robotoBlack.copyWith(fontSize: 11)),
                                  ],
                                ),
                                Center(
                                  child: Row(
                                     children: <Widget>[
                                      ImageStack.providers(
                                        providers: providers,
                                        imageRadius: 45,
                                        imageCount: 1,
                                        imageBorderWidth: 1,
                                        totalCount: 4,
                                        backgroundColor: Colors.white,
                                        imageBorderColor: Colors.cyan,
                                        extraCountBorderColor: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):Container(),

                      EstateItem(estate: estate,onPressed: (){
                        Get.toNamed(RouteHelper.getDetailsRoute(estate.id,estate.userId));
                      },fav: false),
                    ],
                  ),
                )

              ]),
            ),
          ),

          splashController.nearestEstateIndex != (estateController.estateModel.estates.length-1) ? Positioned(
            top: 30, bottom: 0, left: 0,
            child: InkWell(
              onTap: () {
                splashController.setNearestEstateIndex(splashController.nearestEstateIndex+1);
                callback(splashController.nearestEstateIndex);
              },
              child: Container(
                height: 27, width: 27, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ) : SizedBox(),
          //arrow_back_ios_rounded
          splashController.nearestEstateIndex != 0 ? Positioned(
            top: 30, bottom: 0, right: 0,
            child: InkWell(
              onTap: () {
                splashController.setNearestEstateIndex(splashController.nearestEstateIndex-1);
                callback(splashController.nearestEstateIndex);
              },
              child: Container(
                height: 27, width: 27, alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).cardColor.withOpacity(0.8),
                ),
                child: Icon(Icons.arrow_back_ios_rounded),
              ),
            ),
          ) : SizedBox(),

        ]);


      });
    });
  }

}