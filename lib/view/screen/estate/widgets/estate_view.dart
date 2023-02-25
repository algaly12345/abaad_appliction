import 'dart:collection';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/screen/estate/widgets/button_view.dart';
import 'package:abaad/view/screen/estate/widgets/estate_image_view.dart';
import 'package:abaad/view/screen/estate/widgets/service%20_provider_view.dart';
import 'package:abaad/view/screen/map/widget/location_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class EstateView extends StatefulWidget {
  final bool fromView;
 final  Estate estate;


  const EstateView({@required this.fromView,this.estate});

  @override
  State<EstateView> createState() => _EstateViewState();
}

class _EstateViewState extends State<EstateView> {

  Estate estate;

  List<RadioModel> sampleData = new List<RadioModel>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sampleData.add( RadioModel(false, 'صور', Images.vt));
    sampleData.add( RadioModel(false, 'تجوال 3D', Images.vt));
    sampleData.add( RadioModel(false, 'منظور الشارع',Images.vt));
    sampleData.add( RadioModel(false, 'المخطط', Images.vt));
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AuthController>(builder: (authController) {
      List<int> _zoneIndexList = [];
      if(authController.zoneList != null && authController.zoneIds != null) {
        for(int index=0; index<authController.zoneList.length; index++) {
          if(authController.zoneIds.contains(authController.zoneList[index].id)) {
            _zoneIndexList.add(index);
          }
        }
      }

      return SingleChildScrollView(
        child: Card(
          elevation: 2,
          child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
            padding: EdgeInsets.all(widget.fromView ? 0 : 4),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
           //   const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),



              Padding(
                padding: const EdgeInsets.all(0.1),
                child: Container(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ], ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Container(
                            height: 27,
                            width: 27,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4,left: 4),
                              child: Icon(Icons.arrow_back_ios,size: 23),
                            )),
                              SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Row(
                                children: [

                                  Icon(Icons.remove_red_eye_outlined),
                                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text("454 ",style: robotoBlack.copyWith(fontSize: 11),),

                                  Text(" مشاهدة",style: robotoBlack.copyWith(fontSize: 11),),
                                ],
                              ),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              Icon(Icons.share, size: 23, color: Theme.of(context).textTheme.bodyText1.color),
                            ]),
                      ),
                    Container(
                      height: widget.fromView ? 340 : (context.height * 0.70),

                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ]

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                          child: Stack(clipBehavior: Clip.none, children: [
                               EstateImageView(productModel: widget.estate,fromView: widget.fromView,),
                            widget.fromView ? Positioned(
                              top: 10, right: 0,
                              child: InkWell(
                                onTap: () {
                                  Get.to(EstateView(fromView: false,estate: estate,));
                                },
                                child: Container(
                                  width: 30, height: 30,
                                  margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color: Colors.white),
                                  child: Icon(Icons.fullscreen, color: Theme.of(context).primaryColor, size: 20),
                                ),
                              ),
                            ) : SizedBox(),


                          ]),
                        ),
                      ) ,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              SizedBox(
                height: 43   ,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sampleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return  InkWell(
                      //highlightColor: Colors.red,
                      splashColor: Colors.blueAccent,
                      onTap: () {
                        setState(() {
                          sampleData.forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                        });
                      },
                      child:RadioItem(sampleData[index]),
                    );
                  },
                ),
              ),

              ServiceProivderView(productModel: widget.estate,fromView: widget.fromView),



              !widget.fromView ? CustomButton(
                buttonText: 'back'.tr,
                onPressed: () {
               //   widget.mapController.moveCamera(CameraUpdate.newCameraPosition(_cameraPosition));
                  Get.back();
                },
              ) : SizedBox()

            ]),
          )),
        ),
      );
    });
  }
}
class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;

  RadioModel(this.isSelected, this.buttonText, this.text);
}