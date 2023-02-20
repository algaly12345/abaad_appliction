import 'package:flutter/material.dart';
import 'package:abaad/util/images.dart';
import 'package:get/get.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/screen/onboard/on_boarding_data.dart';
import 'package:abaad/view/screen/test.dart';

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
      title: "مغ تطبيق ابعاد تستطيع التجوال داخل العقار سواء كمبوند– فيلا– شقه باستخدام  نظارات الواقع الافتراضي (Virtual Reality)  كما يدعم التطبيق استعراض صور العقارات بخاصية الرؤيه 360 درجة ( °360 View). .",
      image: Images.onboard_1,
      color: Color(0xffDAD3C8),
    ),
    OnboardingModel(
      title:"أن التطبيق يتيح لراغبي عرض الوحدات العقارية للبيع سواء مطورين عقاريين او شركات وساطة او حتى أفراد بإنشاء مواقع إلكترونية خاصة بهم بعدة تصميمات مختلفة بصورة آلية ومن خلال التطبيق مباشرة",
      image: Images.onboard_2,
      color: Color(0xffFFE5DE),
    ),
    OnboardingModel(
      title:
      "تعامل مع جهات ذات مصداقية أفضل من تعامل مع جهات مجهولة.\nعقار زيلو عقارات للنخبة مع سعر السوق العادل.تعامل مع شركات ذات مصداقية أفضل من تعامل مع جهات مجهولة.عقار زيلو عقارات للنخبة مع سعر السوق العادل.",
      image: Images.onboard_1,
      color: Color(0xffDCF6E6),
    ),
  ];
}
