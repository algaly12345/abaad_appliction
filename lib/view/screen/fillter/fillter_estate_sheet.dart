import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/screen/fillter/widgets/slider_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/popular_filter_list.dart';


class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;
  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;
  int _typeProperties = 0;
  String type_properties;
  String ctiy_name;
  String districts;

  RangeValues _values = const RangeValues(100, 600);
  double distValue = 0;
  final ScrollController _scrollController = ScrollController();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<ZoneController>().getCategoryList();
    Get.find<CategoryController>().getSubCategoryList("0");
    int offset = 1;
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
     return GetBuilder<EstateController>(builder: (restController) {
      return GetBuilder<ZoneController>(builder: (zoneController) {

        return   zoneController.categoryList != null &&zoneController.subCategoryList!=null ? Container(
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return (categoryController.categoryList != null) ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      // priceBarFilter(),
                      const Divider(
                        height: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ad_typ".tr, style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault, color: Theme
                                .of(context)
                                .hintColor),),
                            SizedBox(height: 7),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded( // Place `Expanded` inside `Row`
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => _typeProperties = 0);
                                    },
                                    child: Container(
                                      height: 39,
                                      decoration: BoxDecoration(
                                          color: _typeProperties == 0 ? Theme
                                              .of(context)
                                              .secondaryHeaderColor : Colors
                                              .transparent,
                                          border: Border.all(
                                            width: 1, color: Colors.blue[500],),
                                          borderRadius: BorderRadius.circular(2,)
                                      ),

                                      child: Center(child: Text('for_rent'.tr,
                                        style: robotoBlack.copyWith(fontSize: 16,
                                            color: _typeProperties == 0
                                                ? Colors.white
                                                : Colors.blue),)),


                                    ),
                                  ),
                                ),
                                SizedBox(width: 3,),
                                Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                                  child: InkWell(
                                    onTap: () {
                                      setState(() => _typeProperties = 1);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: _typeProperties == 1 ? Theme
                                              .of(context)
                                              .secondaryHeaderColor : Colors
                                              .transparent,
                                          border: Border.all(
                                            width: 1, color: Colors.blue[500],),
                                          borderRadius: BorderRadius.circular(2,)
                                      ),
                                      height: 39,
                                      // color: _value == 1 ? Colors.grey : Colors.transparent,
                                      child: Center(child: Text('for_sell'.tr,
                                        style: robotoBlack.copyWith(fontSize: 16,
                                            color: _typeProperties == 1
                                                ? Colors.white
                                                : Colors.blue),)),


                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Text("type_property".tr, style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeDefault, color: Theme
                                .of(context)
                                .hintColor),),
                            SizedBox(height: 7),
                            GetBuilder<CategoryController>(
                                builder: (categoryController) {
                                  return (categoryController.categoryList != null) ?
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: categoryController.categoryList
                                            .length,
                                        padding: EdgeInsets.only(
                                            left: Dimensions.PADDING_SIZE_SMALL),
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          String _baseUrl = Get
                                              .find<SplashController>()
                                              .configModel
                                              .baseUrls
                                              .categoryImageUrl;
                                          return Column(
                                            children: [

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 5, left: 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    restController
                                                        .setCategoryIndex(categoryController.categoryList[index].id);
                                                    restController
                                                        .setCategoryPostion(int.parse(categoryController.categoryList[index].position));
                                                    setState(() {
                                                      type_properties=categoryController.categoryList[index].name;
                                                    });

                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    padding: const EdgeInsets.only(
                                                        left: 4.0, right: 4.0),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: categoryController.categoryList[index].id ==
                                                              restController
                                                                  .categoryIndex
                                                              ? Theme
                                                              .of(context)
                                                              .primaryColor : Colors
                                                              .white
                                                      ),
                                                      borderRadius: BorderRadius
                                                          .circular(2.0),
                                                      color: Colors.white,

                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 26,
                                                          color: Colors.white,
                                                          child: Text(
                                                            categoryController
                                                                .categoryList[index]
                                                                .name,
                                                            style: categoryController.categoryList[index].id ==
                                                                restController
                                                                    .categoryIndex
                                                                ? robotoBlack
                                                                .copyWith(
                                                                fontSize: 17)
                                                                : robotoRegular
                                                                .copyWith(
                                                                fontSize: Dimensions
                                                                    .fontSizeDefault,
                                                                fontStyle: FontStyle
                                                                    .normal,
                                                                color: Theme
                                                                    .of(context)
                                                                    .disabledColor),),
                                                        ),
                                                        SizedBox(width: 5),

                                                        CustomImage(
                                                            image: '$_baseUrl/${categoryController
                                                                .categoryList[index]
                                                                .image}',
                                                            height: 25,
                                                            width: 25,
                                                            colors: categoryController.categoryList[index].id ==
                                                                restController
                                                                    .categoryIndex
                                                                ? Theme
                                                                .of(context)
                                                                .primaryColor
                                                                : Colors.black12),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        }),
                                  )

                                      : Container();
                                }),
                          ],
                        ),
                      ),
                      Row(children: [

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            'المنطقة'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                            ),
                            child: DropdownButton<int>(
                              value: zoneController.categoryIndex,
                              items: zoneController.zoneIds.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: zoneController.zoneIds.indexOf(value),
                                  child: Text(value != 0 ? zoneController.categoryList[(zoneController.zoneIds.indexOf(value)-1)].nameAr : 'Select'),
                                );
                              }).toList(),
                              onChanged: (int value) {
                                zoneController.setCategoryIndex(value, true);
                                zoneController.getSubCategoryList(value != 0 ? zoneController.categoryList[value-1].regionId : 0);
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ])),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            'المدينة'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                            ),
                            child: DropdownButton<int>(
                              value: zoneController.subCategoryIndex,
                              items: zoneController.cityIds.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: zoneController.cityIds.indexOf(value),
                                  child: Text(value != 0 ? zoneController.subCategoryList[(zoneController.cityIds.indexOf(value)-1)].nameAr : 'Select'),
                                );
                              }).toList(),
                              onChanged: (int value) {
                                zoneController.setSubCategoryIndex(value, true);
                                zoneController.getSubSubCategoryList(value != 0 ? zoneController.subCategoryList[value-1].cityId : 0);
                                ctiy_name=zoneController.subCategoryList[value-1].nameAr ;
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ])),

                      ]),




                      Row(children: [


                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(
                            'الحي'.tr,
                            style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 2, blurRadius: 5, offset: Offset(0, 5))],
                            ),
                            child: DropdownButton<int>(
                              value: zoneController.subSubCategoryIndex,
                              items: zoneController.subSubCategoryIds.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: zoneController.subSubCategoryIds.indexOf(value),
                                  child: Text(value != 0 ? zoneController.subSubCategoryList[(zoneController.subSubCategoryIds.indexOf(value)-1)].nameAr : 'Select'),
                                );
                              }).toList(),
                              onChanged: (int value) {
                                zoneController.setSubSubCategoryIndex(value, true);
                                districts= zoneController.subSubCategoryList[value-1].nameAr ;
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ])),

                      ]),

                      // popularFilter(),
                      const Divider(
                        height: 1,
                      ),
                      SizedBox(height: 30,),
                      distanceViewUI(),
                      const Divider(
                        height: 1,
                      ),
                      allAccommodationUI()
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                       showCustomSnackBar("${(distValue/10).toInt()}");
                    categoryController.setFilterIndex(restController.getCategoryIndex(),ctiy_name,districts,(distValue/10).toInt());
                    Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
              : Container();
        }),
      ),
    ): Center(child: CircularProgressIndicator());
      });
    });
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'خصائض البحث',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getAccomodationListUI(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> getAccomodationListUI() {
    final List<Widget> noList = <Widget>[];
    for (int i = 0; i < accomodationListData.length; i++) {
      final PopularFilterListData date = accomodationListData[i];
      noList.add(
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            onTap: () {
              setState(() {
                checkAppPosition(i);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      date.titleTxt,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: date.isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.withOpacity(0.6),
                    onChanged: (bool value) {
                      setState(() {
                        checkAppPosition(i);
                      });
                    },
                    value: date.isSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      if (i == 0) {
        noList.add(const Divider(
          height: 1,
        ));
      }
    }
    return noList;
  }

  void checkAppPosition(int index) {
    if (index == 0) {
      if (accomodationListData[0].isSelected) {
        accomodationListData.forEach((d) {
          d.isSelected = false;
        });
      } else {
        accomodationListData.forEach((d) {
          d.isSelected = true;
        });
      }
    } else {
      accomodationListData[index].isSelected =
      !accomodationListData[index].isSelected;

      int count = 0;
      for (int i = 0; i < accomodationListData.length; i++) {
        if (i != 0) {
          final PopularFilterListData data = accomodationListData[i];
          if (data.isSelected) {
            count += 1;
          }
        }
      }

      if (count == accomodationListData.length - 1) {
        accomodationListData[0].isSelected = true;
      } else {
        accomodationListData[0].isSelected = false;
      }
    }
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16),
          child: Text(
            'المساحة',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: distValue,
          onChangedistValue: (double value) {
            distValue = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Popular filters',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData date = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                        showCustomSnackBar(date.titleTxt);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            date.isSelected
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: date.isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.withOpacity(0.6),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            date.titleTxt,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Price (for 1 night)',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        // RangeSliderView(
        //   values: _values,
        //   onChangeRangeValues: (RangeValues values) {
        //     _values = values;
        //   },
        // ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color:Theme.of(context).primaryColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(

              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.close,color: Colors.white,),
                  ),
                ),
              ),
            ),
            Container(
              child: const Text(
                'الفلترة',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 20,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}