import 'dart:convert';
import 'dart:io';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/screen/profile/widget/image_tap.dart';
import 'package:abaad/view/screen/profile/widget/planned_tap.dart';
import 'package:abaad/view/screen/profile/widget/skey_view_tap.dart';
import 'package:abaad/view/screen/profile/widget/video_tap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';


class ViewImageUploadScreen extends StatefulWidget {
  Estate estate;
  ViewImageUploadScreen(@required this.estate);
  @override
  _ViewImageUploadScreenState createState() => _ViewImageUploadScreenState();
}

class _ViewImageUploadScreenState extends State<ViewImageUploadScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child:
      Scaffold(
        appBar:  CustomAppBar(title: 'pictures_property'.tr),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.blueAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 6),
                ],
              ),
              child: SafeArea(
                child: TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4, color: Colors.white),
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  tabs: [
                    Tab(text: 'photo'.tr),
                    Tab(text: 'planned'.tr),
                    Tab(text: 'video'.tr),
                    Tab(text: 'sky_view'.tr),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ImageTab(index: 0,estate: widget.estate),
                  PlannedTab(index: 1,estate: widget.estate),
                  VideoTab(index: 2,estate: widget.estate),
                  SkyView(index: 3,estate: widget.estate),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}


