

import 'package:abaad/controller/onboarding_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  @override
  Widget build(BuildContext context) {
    Get.find<OnBoardingController>().getOnBoardingList();
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFF03182A),
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: GetBuilder<OnBoardingController>(
        builder: (onBoardingController) => onBoardingController.onBoardingList.length > 0 ? SafeArea(
          child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Column(children: [
            Expanded(child: PageView.builder(
              itemCount: onBoardingController.onBoardingList.length,
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      height: 160,
                    //  child: HeaderWidget(160, true, Icons.person),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 160,
                        child: Column(
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    onBoardingController.onBoardingList[index].title,
                                    style: robotoMedium.copyWith(fontSize: context.height*0.033, color: Theme.of(context).disabledColor),
                                    textAlign: TextAlign.center,


                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    onBoardingController.onBoardingList[index].description,
                                    style: robotoRegular.copyWith(fontSize: context.height*0.020, color: Theme.of(context).backgroundColor),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: _pageIndicators(onBoardingController, context),
                            // ),
                            // SizedBox(height: context.height*0.05),
                            // const SizedBox(height: 75)
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              onPageChanged: (index) {
                onBoardingController.changeSelectIndex(index);
              },
            )),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _pageIndicators(onBoardingController, context),
            ),
            SizedBox(height: context.height*0.05),

            Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Row(children: [
                onBoardingController.selectedIndex == 2 ? SizedBox() : Expanded(
                  child: CustomButton(
                    transparent: true,
                    onPressed: () {
                      Get.find<SplashController>().disableIntro();
                      Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                    },
                    buttonText: 'skip'.tr,
                  ),
                ),
                Expanded(
                  child: CustomButton(
                    buttonText: onBoardingController.selectedIndex != 2 ? 'next'.tr : 'get_started'.tr,
                    onPressed: () {
                      if(onBoardingController.selectedIndex != 2) {
                        _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.ease);
                      }else {
                        Get.find<SplashController>().disableIntro();
                        Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                      }
                    },
                  ),
                ),
              ]),
            ),

          ]))),
        ) : SizedBox(),
      ),
    );
  }

  List<Widget> _pageIndicators(OnBoardingController onBoardingController, BuildContext context) {
    List<Container> _indicators = [];

    for (int i = 0; i < onBoardingController.onBoardingList.length; i++) {
      _indicators.add(
        Container(
          width: 7,
          height: 7,
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: i == onBoardingController.selectedIndex ? Theme.of(context).primaryColor : Theme.of(context).disabledColor,
            borderRadius: i == onBoardingController.selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return _indicators;
  }
}
