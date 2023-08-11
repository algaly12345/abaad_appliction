import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ServiceProivderView extends StatefulWidget {
  final Estate estate;
  final bool fromView;
  ServiceProivderView({@required this.estate,this.fromView});

  @override
  State<ServiceProivderView> createState() => _ServiceProivderViewState();
}

class _ServiceProivderViewState extends State<ServiceProivderView> {
  final PageController _controller = PageController();
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();

    Get.find<EstateController>().getEstateDetails(Estate(id: widget.estate.id));

  }
  @override
  Widget build(BuildContext context) {



    return  widget.estate.serviceOffers != null?
    Container(
      height: 130,
      child: Stack(children: [


        Positioned(
          top: 4,
          right: 0,
          left: 0,
          bottom: 4,
          child: GetBuilder<SplashController>(builder: (splashController) {
            String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
            return  CarouselSlider(
              items: widget.estate.serviceOffers
                  .map(
                    (item) => CustomImage(
                  image: '$_baseUrl/${item.image}', fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
                  .toList(),
              carouselController: carouselController,
              options: CarouselOptions(
                scrollPhysics: const BouncingScrollPhysics(),
                autoPlay: true,
                aspectRatio: 2,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            );
          },),),
        Positioned(
          bottom: 10,
          left: 6,
          right: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(

              child:  Text(
                '${   widget.estate.serviceOffers[currentIndex].title}',
                style: robotoBlack.copyWith(fontSize: 11,color: Colors.white),
              ),
            ),
            const SizedBox(height: 3.0),
            Row(
              children: [
                widget.estate.serviceOffers[currentIndex].servicePrice!=null?Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Colors.white)):Text("discount".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color:  Colors.white)),
                SizedBox(width: 11.0),
                widget.estate.serviceOffers[currentIndex].discount!=null?  SizedBox(
                  height: 16,
                  width: 44,
                  child: CustomPaint(
                    painter: PriceTagPaint(),
                    child: Center(
                      child: Text(
                          "${   widget.estate.serviceOffers[currentIndex].discount}%",
                          style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                      ),
                    ),
                  ),
                ):Text(" ${   widget.estate.serviceOffers[currentIndex].servicePrice} ريال "  ,style: robotoBlack.copyWith(fontSize: 11,color: Colors.white)),
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
          ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.estate.serviceOffers.asMap().entries.map((entry) {

                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: currentIndex == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: currentIndex == entry.key
                              ? Colors.red
                              : Colors.teal),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                borderRadius:
                BorderRadius.all(
                    Radius.circular(8)),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(Images.background_gray))),
          ),
        ),
      ]),
    ) :  Center(child:Container());

  }
}
