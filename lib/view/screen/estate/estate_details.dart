import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'widgets/estate_view.dart';
import 'widgets/service _provider_view.dart';
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
      body: SingleChildScrollView(
        child: GetBuilder<EstateController>(builder: (estateController) {
          return GetBuilder<CategoryController>(builder: (categoryController) {

            Estate _estate;

            if(estateController.estate != null   && categoryController.categoryList != null) {
              _estate = estateController.estate;
            }
            estateController.setCategoryList();

            return (estateController.estate != null && estateController.estate.shortDescription != null) ?
            Column(
              children: [
                EstateView(
                    fromView: true,estate:estateController.estate ) ,


                Container(margin: EdgeInsets.symmetric(horizontal: 10), decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
            color: Colors.grey[Get.find<ThemeController>().darkTheme ? 700 : 300],
            ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${estateController.estate.shortDescription}",
                              style: robotoBlack.copyWith(fontSize: 12)),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 40,
                              margin: const EdgeInsets.only(top: 10),
                              decoration:  BoxDecoration(
                                  color: estateController.estate.forRent==1?Colors.blue:Colors.orange),
                              child:  Text( estateController.estate.forRent==1?"للبيع":"للإجار",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,)
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )
                : const Center(child: CircularProgressIndicator());
          });
        }),
      ),
    );
  }
}
