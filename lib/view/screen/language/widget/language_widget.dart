import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/data/model/response/language_model.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageWidget extends StatelessWidget {
  final LanguageModel languageModel;
  final LocalizationController localizationController;
  final int index;
  LanguageWidget({required this.languageModel, required this.localizationController, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        localizationController.setLanguage(Locale(
          AppConstants.languages[index].languageCode,
          AppConstants.languages[index].countryCode,
        ));
        localizationController.setSelectIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          border: Border.all(color:localizationController.selectedIndex == index ?  Theme.of(context).primaryColor:Colors.white, width: 1),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], blurRadius: 5, spreadRadius: 1)],
        ),
        child: Stack(children: [

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Container(
                height: 20, width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  languageModel.imageUrl, width: 20, height: 20,
                  color: languageModel.languageCode == 'en' || languageModel.languageCode == 'ar'
                      ? Theme.of(context).textTheme.bodyText1.color : null,
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Text(languageModel.languageName, style: robotoBlack.copyWith(fontSize: 14,color: localizationController.selectedIndex == index ? Colors.black:Colors.black54)),
            ]),
          ),

          // localizationController.selectedIndex == index ? Positioned(
          //   top: 0, right: 0,
          //   child: Icon(Icons.check_circle, color: Theme.of(context).primaryColor, size: 16),
          // ) : SizedBox(),

        ]),
      ),
    );
  }
}
