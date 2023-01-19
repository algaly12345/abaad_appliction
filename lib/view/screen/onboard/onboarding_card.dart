import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/screen/onboard/on_boarding_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class OnBoardingCard extends StatelessWidget {
  const OnBoardingCard({
     key,
     this.onboardingContent,
     this.currentPage,
     this.pageController,
  });
  //
  final int currentPage;
  final PageController pageController;
  final OnboardingModel onboardingContent;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          onboardingContent.image,
          width: double.infinity,
          height: ResponsiveHelper.getHeight(context) * 0.65,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            onboardingContent.title,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(
              // height: 24.0,
              fontSize: 14.0,
              color: HexColor('#1A202C'),
            ),
          ),
        ),
      ],
    );
  }
}
