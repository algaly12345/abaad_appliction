
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'favourite'.tr, isBackButtonExist: false),
      body: Container(
        width: Dimensions.WEB_MAX_WIDTH,
        color: Theme.of(context).cardColor,
        child: const Center( child: Text("favoriest"),),
      ),
    );
  }
}
