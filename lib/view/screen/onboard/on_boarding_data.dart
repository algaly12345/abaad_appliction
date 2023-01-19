import 'package:flutter/material.dart';
import 'package:abaad/util/images.dart';

class OnboardingModel {
  const OnboardingModel({
  this.title,
     this.image,
     this.color,
  });

  ///
  final String title;
  final String image;
  final Color color;
}

class OnBoardingData {
  static List<OnboardingModel> contents = const [
    OnboardingModel(
      title:
          'انت على بعد خطوات وتصبح جميع العقارات بين يديك مع افضل العروض التي تناسبك',
      image: Images.onboard_1,
      color: Color(0xffDAD3C8),
    ),
    OnboardingModel(
      title: 'تمتع بجولة افتراضية تمنحك معاينة حية كاملة للعقار الذى يناسبك ',
      image: Images.onboard_2,
      color: Color(0xffFFE5DE),
    ),
    OnboardingModel(
      title:
          'تمتع بعروض لا حصر لها مع ابعاد , ابعاد هو التطبيق الوحيد الذى يوفر لك عروض على كافة العقارات',
      image: Images.onboard_2,
      color: Color(0xffDCF6E6),
    ),
  ];
}
