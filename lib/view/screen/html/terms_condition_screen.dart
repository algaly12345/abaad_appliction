import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class WebViewDialog extends StatelessWidget {
  final String url;

  WebViewDialog({@required this.url});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
    return Scaffold(
      appBar:  CustomAppBar(title: 'terms_conditions'.tr),
      body: Container(
        child: buildTabContent(isArabic ?"${Get.find<SplashController>().configModel.termsConditionsAr}":"${Get.find<SplashController>().configModel.termsConditions}"),
      ),
    );
  }



  Widget buildTabContent(String text) {
    return  SingleChildScrollView(
      child: HtmlWidget(text),
    );
  }
}
