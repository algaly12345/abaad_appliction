import 'package:abaad/util/images.dart';
import 'package:abaad/view/screen/onboard/on_boarding_data.dart';
import 'package:flutter/material.dart';

import 'btn_onboarding.dart';
import 'dots.dart';

class OnBoardingFooter extends StatelessWidget {
  const OnBoardingFooter({
      key,
     required this.onboardingContent,
     required this.currentPage,
     required this.pageController,
  });
  //
  final int currentPage;
  final PageController pageController;
  final OnboardingModel onboardingContent;
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BtnOnBoarding(
          currentPage: currentPage,
          pageController: pageController,
          trailingWidget: Image.asset(Images.arrowCircle,height: 20,),
        ),
        const SizedBox(height: 20.0),
        Dots(currentPage: currentPage),
      ],
    );
  }
}
