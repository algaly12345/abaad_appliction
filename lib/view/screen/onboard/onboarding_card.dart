import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/screen/onboard/on_boarding_data.dart';
import 'package:abaad/view/screen/test.dart';
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

        Container(
          child: Stack(
            // alignment: AlignmentDirectional.center,
            children: [

              Container(


                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    child: Image.asset(
                      Images.rectangle1,
                      width: double.infinity,
                      height: ResponsiveHelper.getHeight(context) * 0.64,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Container(
                height: ResponsiveHelper.getHeight(context) * 0.66,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    child: Image.asset(
                      Images.rectangle2,
                      width: double.infinity,
                      height: ResponsiveHelper.getHeight(context) * 0.66,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,

                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    child: Image.asset(
                      onboardingContent.image,
                      width: double.infinity,
                      height: ResponsiveHelper.getHeight(context) * 0.62,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),


        Padding(
          padding: const EdgeInsets.only(right: 12,left: 12),
          child: Text(
            onboardingContent.title,
            textAlign: TextAlign.center,
            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault)
          ),
        ),
      ],
    );
  }
}
