import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/view/base/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class BtnOnBoarding extends StatelessWidget {
  const BtnOnBoarding({
     key,
     this.currentPage,
     this.pageController,
    this.trailingWidget,
  });
  //
  final int currentPage;
  final PageController pageController;
  final Widget trailingWidget;
  //
  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: _titleBtn,
      trailingWidget: trailingWidget,
      onPressed: () => _onPressed(context),
    );
  }

  String get _titleBtn {
    switch (currentPage) {
      case 3:
        return 'last';
    }
    return 'التالي';
  }

  Future<void> _onPressed(BuildContext context) async {
    if (currentPage == 2) {
     // Push.toWithoutBackPage(context, const LoginScreen());
      // hide on boarding
    //  await OnBoardingLocalStorage.showOnBoarding(false);
      Get.find<SplashController>().disableIntro();
      Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.onBoarding));
    } else {
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }
}
