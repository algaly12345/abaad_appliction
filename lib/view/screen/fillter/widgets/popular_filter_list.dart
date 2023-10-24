import 'package:get/get.dart';

class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.value
  });

  String titleTxt;
  int value;
  bool isSelected;


  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'all'.tr,
      isSelected: false,

    ),
    PopularFilterListData(
      titleTxt: 'it_includes_offers'.tr,
      isSelected: false,
      value: 1
    ),
    PopularFilterListData(
      titleTxt: 'virtual_ture'.tr,
      isSelected: false

    ),
    // PopularFilterListData(
    //   titleTxt: 'منظور الشارع',
    //   isSelected: false,
    // ),
    // PopularFilterListData(
    //   titleTxt: 'Hotel',
    //   isSelected: false,
    // ),
    // PopularFilterListData(
    //   titleTxt: 'Resort',
    //   isSelected: false,
    // ),
  ];
}
