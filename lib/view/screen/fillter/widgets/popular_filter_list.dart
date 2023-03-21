class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Free Breakfast',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free Parking',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Pool',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Pet Friendly',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Free wifi',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> accomodationList = [
    PopularFilterListData(
      titleTxt: 'الكل',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'عروض مع العقار',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'جولة افتراضية',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'منظور الشارع',
      isSelected: false,
    ),
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
