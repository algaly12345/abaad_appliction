import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';


class ServiceProivderView extends StatefulWidget {
  final Estate productModel;
  final bool fromView;
  ServiceProivderView({@required this.productModel,this.fromView});

  @override
  State<ServiceProivderView> createState() => _ServiceProivderViewState();
}

class _ServiceProivderViewState extends State<ServiceProivderView> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id: widget.productModel.id));

  }
  @override
  Widget build(BuildContext context) {


    return GetBuilder<EstateController>(builder: (estateController) {
      return  (estateController.estate != null && estateController.estate.shortDescription != null) ?
      Container(


        padding: EdgeInsets.only(top: 2),
        child: (estateController.estate != null && estateController.estate.serviceOffers != null)  != null ? Stack(

          children: [
            Expanded(
              child: CarouselSlider.builder(

                options: CarouselOptions(
                  viewportFraction: 1,
                  autoPlay: true,
                  height: 100,

                  autoPlayInterval: Duration(seconds: 7),
                  onPageChanged: (index, reason) {
                    estateController.setCurrentIndex(index, true);
                  },
                ),
                itemCount:estateController.estate.serviceOffers== 0 ? 1 : estateController.estate.serviceOffers.length,
                itemBuilder: (context, index, _) {
                  //
                  return InkWell(
                    onTap: (){


                    },

                    // ),
child: Container(
                      height: 80,
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
                                        flex: 4,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(3.0),
                                          child:  GetBuilder<SplashController>(builder: (splashController) {
                                          String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                                         //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                                            return CustomImage(
                                              image: '$_baseUrl/${estateController.estate.serviceOffers[index].image}',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),),
                                      SizedBox(width: 11.0),
                                      Flexible(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                estateController.estate.serviceOffers[index].discount=="price"?Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)):Text("discount".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
                                                SizedBox(width: 11.0),
                                                estateController.estate.serviceOffers[index].discount!="price"?  SizedBox(
                                                  height: 16,
                                                  width: 44,
                                                  child: CustomPaint(
                                                    painter: PriceTagPaint(),
                                                    child: Center(
                                                      child: Text(
                                                          "${estateController.estate.serviceOffers[index].discount}%",
                                                          style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                                                      ),
                                                    ),
                                                  ),
                                                ):Text(" ${estateController.estate.serviceOffers[index].servicePrice}"  ,style: robotoBlack.copyWith(fontSize: 11)),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 3.0,
                                            ),
                                            Text("${estateController.estate.serviceOffers[index].title}",
                                                style: robotoBlack.copyWith(fontSize: 12)),
                                            const SizedBox(
                                              height: 3.0,
                                            ),
                                            Row(
                                              children: [
                                                Text("",
                                                    style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                                Text("",
                                                    style: robotoBlack.copyWith(fontSize: 11,color: Colors.black26)),
                                              ],

                                            ),
                                            const SizedBox(
                                              height: 7.0,
                                            ),


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
                              height: 30,
                              width: 30,
                              child: Image.asset(Images.offer_icon),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),


            Positioned(
              bottom: 5,
              right: 20,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:estateController.estate.serviceOffers.map((bnr) {
                  int index =estateController.estate.serviceOffers.indexOf(bnr);
                  return TabPageSelectorIndicator(
                    backgroundColor: index == estateController.currentIndex ? Colors.orange
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
          enabled: widget.productModel.serviceOffers == null,
          child: Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
          )),
        ),
      ) :  Center(child:Container());
    });
  }
}
