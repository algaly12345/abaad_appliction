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
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
              Get.offNamed(RouteHelper.getDetailsRoute(1));
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
                      SizedBox(
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
                      ),
                  SizedBox(
                    height: 4,),
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4), //border corner radius
                          boxShadow:[
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5), //color of shadow
                              spreadRadius: 5, //spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 2), // changes position of shadow
                              //first paramerter of offset is left-right
                              //second parameter is top to down
                            ),
                            //you can set more BoxShadow() here
                          ],
                        ),
                        child: Row(
                          children: <Widget>[

                            Expanded(
                              child: Column(
                                children: <Widget>[

                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          flex: 2,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(3.0),
                                            child: Image.network(
                                                "https://cdn.pixabay.com/photo/2017/06/13/22/42/kitchen-2400367_960_720.jpg"),
                                          ),
                                        ),
                                        SizedBox(width: 11.0),
                                        Flexible(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                             Text("34343"  ,style: robotoBlack.copyWith(fontSize: 11)),
                                              const SizedBox(
                                                height: 3.0,
                                              ),
                                               Text("${estate.shortDescription}",
                                                  style: robotoBlack.copyWith(fontSize: 11)),
                                              const SizedBox(
                                                height: 3.0,
                                              ),
                                               Row(
                                                 children: [
                                                   Text(" العنوان الوطني : ",
                                                       style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                                   Text("45",
                                                       style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                                 ],

                                               ),
                                              const SizedBox(
                                                height: 7.0,
                                              ),

                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  //
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Image.asset(Images.bed, width: 14.0, height: 14.0),

                                                        Text(
                                                          '2 غرفة نوم',
                                                            style: robotoBlack.copyWith(fontSize: 11)
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Image.asset(Images.bathroom, width: 14.0, height: 14.0),

                                                        Text(
                                                          '2 حمام',
                                                            style: robotoBlack.copyWith(fontSize: 11)
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //
                                                  Expanded(
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Image.asset(Images.setroom, width: 14.0, height: 14.0),

                                                        Text(
                                                          '2 غرفة نوم',
                                                          style: robotoBlack.copyWith(fontSize: 11),
                                                        ),
                                                      ],
                                                    ),
                                                  ),//
                                                ],
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                width: 40,
                                margin: const EdgeInsets.only(top: 10),
                                decoration:  BoxDecoration(
                                    color: estate.forRent==1?Colors.blue:Colors.orange),
                                child:  Text(estate.forRent==1?"للبيع":"للإجار",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
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