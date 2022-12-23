import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/config_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {

  static Future<void> loadData(bool reload) async {
    // Get.find<BannerController>().getBannerList(reload);
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final ScrollController _scrollController = ScrollController();
  ConfigModel _configModel = Get.find<SplashController>().configModel;

  @override
  void initState() {
    super.initState();

    HomeScreen.loadData(false);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Theme.of(context).cardColor : null,
      body: SafeArea(
        child: Text("home screen "),
      ),
    );
  }
}

