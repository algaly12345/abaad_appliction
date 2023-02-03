import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/view/base/web_menu_bar.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
class EstateDetails extends StatefulWidget {
final Estate estate;
EstateDetails({@required this.estate});

  @override
  State<EstateDetails> createState() => _EstateDetailsState();
}

class _EstateDetailsState extends State<EstateDetails> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  @override
  @override
  void initState() {
    super.initState();
    Get.find<EstateController>().getEstateDetails(Estate(id: 6));
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    Get.find<EstateController>().getCategoriesEstateList(1, 1, 'all', false);

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: GetBuilder<EstateController>(builder: (estateController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Estate _estate;
          if(estateController.estate != null && estateController.estate.shortDescription != null && categoryController.categoryList != null) {
            _estate = estateController.estate;
          }
          estateController.setCategoryList();

          return (estateController.estate != null && estateController.estate.shortDescription != null) ?
          Center(child: Text(estateController.estate.shortDescription),) : const Center(child: CircularProgressIndicator());
        });
      }),
    );
  }
}
