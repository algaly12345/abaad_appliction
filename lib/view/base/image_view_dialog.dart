import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ImageViewDiloag extends StatelessWidget {
  Estate estate;
   ImageViewDiloag({this.estate});

  @override
  Widget build(BuildContext context) {
      return GetBuilder<EstateController>(builder: (estateController) {
      return (estate != null && estate.planned!= null) ?
    Container(


      padding: EdgeInsets.only(top: 2),
      child: (estate != null && estate.planned != null)  != null ? Stack(

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:CarouselSlider.builder(

              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                height: 340 ,

                autoPlayInterval: Duration(seconds: 7),
                onPageChanged: (index, reason) {
                  estateController.setCurrentIndex(index, true);
                },
              ),
              itemCount:estate.planned.length== 0 ? 1 :  estate.planned.length,
              itemBuilder: (context, index, _) {
                String _baseUrl = Get.find<SplashController>().configModel.baseUrls.estateImageUrl;
                print("---------------anner----------${_baseUrl}");
                return GestureDetector(
                  onTap: (){


                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      child:  GetBuilder<SplashController>(builder: (splashController) {
                        return  CustomImage(
                          image: '$_baseUrl/${estate.planned[index]}',
                          fit: BoxFit.cover,
                        );
                      },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


          Positioned(
            bottom: 20,
            right: 20,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:estate.images.map((bnr) {
                int index =estate.images.indexOf(bnr);
                return TabPageSelectorIndicator(
                  backgroundColor: index == estateController.currentIndex ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withOpacity(0.5),
                  borderColor: Theme.of(context).backgroundColor,
                  size: index == estateController.currentIndex ? 10 : 7,
                );
              }).toList(),
            ),
          ),

        ],
      ) : Shimmer(
        duration: Duration(seconds: 2),
        enabled: estate.images == null,
        child: Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
        )),
      ),
    ) : const Center(child: CircularProgressIndicator());
    });
  }
}
