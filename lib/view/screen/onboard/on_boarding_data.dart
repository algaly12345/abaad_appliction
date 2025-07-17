import 'package:flutter/material.dart';
import 'package:abaad/util/images.dart';
import 'package:get/get.dart';

class OnboardingModel {
  const OnboardingModel({
  required this.title,
     required this.image,
     required this.color,
  });

  ///
  final String title;
  final String image;
  final Color color;
}

class OnBoardingData {
  static List<OnboardingModel> contents =  [
    OnboardingModel(
      title: "application_provides_optimal".tr,
      image: Images.onboard_1,
      color: Color(0xffDAD3C8),
    ),
    OnboardingModel(
      title:"application_allows_companies".tr,
      image: Images.onboard_2,
      color: Color(0xffFFE5DE),
    ),
    OnboardingModel(
      title:
      "you_can_tour_the_property_with".tr,
      image: Images.onboard_1,
      color: Color(0xffDCF6E6),
    ),
  ];
}
