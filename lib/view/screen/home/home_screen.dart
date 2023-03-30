import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/data/model/response/config_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/cached_img.dart';
import 'package:abaad/view/base/custom_card.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_input.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/fillter/fillter_estate_sheet.dart';
import 'package:abaad/view/screen/home/widet/estate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';
import 'package:get/get.dart';

import 'widet/banner_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;

  final ScrollController _scrollController = ScrollController();
  ConfigModel _configModel = Get.find<SplashController>().configModel;

  @override
  void initState() {
    super.initState();
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    // Get.find<CategoryController>().getSubCategoryList("0");
    int offset = 1;
    Get.find<BannerController>().getBannerList(true,1);
   // Get.find<ZoneController>().geZonesList();
    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<CategoryController>().categoryProductList != null
          && !Get.find<CategoryController>().isLoading) {
        int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList("0", 0,'0',"0","0","0", offset.toString());
        }
      }
    });

  }



  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<CategoryController>(builder: (categoryController) {
        List<Estate> _products;
        if(categoryController.categoryProductList != null) {
          _products = [];
          if (categoryController.isSearching) {

          } else {
            _products.addAll(categoryController.categoryProductList);
          }
        }


          _isNull = _products == null;
          if(!_isNull) {
            _length = _products.length;
          }



        return (categoryController.subCategoryList != null) ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child:  Column(
              children: [
                Row(
                  children: [
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child:Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 2.0, right: 2.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  children: [
                                    _textField(
                                        label: 'بحث',
                                        prefixIcon:
                                        const Icon(Icons.search),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              Icons.my_location,
                                              color: Colors.blue),
                                          onPressed: () {
                                            showCustomSnackBar(
                                                "message");
                                          },
                                        ),
                                        width: width,
                                        locationCallback:
                                            (String value) {
                                          setState(() {});
                                        }),
                                    GestureDetector(
                                      onTap: (){
                                        Get.dialog(FiltersScreen());
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 4.0, right: 4.0),
                                        padding:
                                        const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                4),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.blue,
                                            )),
                                        child: const Icon(
                                          Icons.qr_code,
                                          size: 25,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),

                                      GetBuilder<ZoneController>(builder: (zoneController) {
                           return  GestureDetector(
                              onTap: (){
                            //    zoneController.categoryList.clear();
                                zoneController.categoryIndex==0;

                                Get.dialog(FiltersScreen());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                margin: const EdgeInsets.only(
                                    left: 4.0, right: 4.0),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    )),


                                child: const Icon(
                                  Icons.filter_list_alt, size: 25,
                                  color: Colors.white,),
                              ),
                            );
                                      })
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 150.0,
                  child: BannerView(),
                ),

                (categoryController.subCategoryList != null ) ? Center(child: Container(
                    height: 40,

                    child:
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryController.subCategoryList.length,
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {

                        return Padding(
                          padding: const EdgeInsets.only(right: 6,left: 6),
                          child: InkWell(
                            onTap: () => categoryController.setSubCategoryIndex(index),
                            child: Container(

                              padding: EdgeInsets.only(
                                left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                                right: index == categoryController.subCategoryList.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
                             //   top: Dimensions.PADDING_SIZE_SMALL,
                              ),


                              decoration:
                              BoxDecoration(
                                border: Border.all(
                                    color:index == categoryController.subCategoryIndex ? Theme.of(
                                        context)
                                        .primaryColor
                                        : Colors
                                        .black12,
                                    width: 2),
                                borderRadius:
                                BorderRadius
                                    .circular(
                                    2.0),
                                color: Colors.white30,
                              ),


                              child: Row(children: [
                                Text(
                                  categoryController.subCategoryList[index].name,
                                  style: index == categoryController.subCategoryIndex
                                      ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
                                      : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                ),

                                SizedBox(width: 5),
                               index==0?Container():  CustomImage(
                                    image:
                                    '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.subCategoryList[index].image}',
                                    height: 25,
                                    width: 25,
                                    colors:index ==
                                        categoryController.subCategoryIndex  ? Theme.of(
                                        context)
                                        .primaryColor
                                        : Colors
                                        .black12),

                              ]),
                            ),
                          ),
                        );
                      },
                    )  )) : SizedBox(),


                !_isNull ?_products.length>0?         Container(
                  child: ListView.builder(
                    key: UniqueKey(),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:_products.length,

                    itemBuilder: (context, index) {
                      return PropertyCard(_products[index]);
                    },
                  ),
                ):Center(
                  child: NoDataScreen(
                    text: 'no_data_available',
                  ),
                ):const SizedBox(),

                categoryController.isLoading ? Center(child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
                )) : SizedBox(),

              ],
            ),
          ) ,
        )
            : Center(child: CircularProgressIndicator());
      })
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 ||
        oldDelegate.minExtent != 50 ||
        child != oldDelegate.child;
  }
}

Widget _textField({
  TextEditingController controller,
  FocusNode focusNode,
  String label,
  String hint,
  double width,
  Icon prefixIcon,
  suffixIcon,
  Function(String) locationCallback,
}) {
  return Container(
    width: width * 0.7,
    height: 45,
    child: TextField(
      onChanged: (value) {
        locationCallback(value);
      },
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(15),
        hintText: hint,
      ),
    ),
  );
}
