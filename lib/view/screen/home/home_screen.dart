import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
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
import 'package:abaad/view/base/web_menu_bar.dart';
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

    Get.find<BannerController>().getBannerList(true,1);
   Get.find<EstateController>().getEstateList(1, false);
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    } 
    Get.find<EstateController>().getCategoriesEstateList(1, 1, 'all', false);
  }




@override
void dispose() {
  super.dispose();
  scrollController?.dispose();
}
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body:   GetBuilder<EstateController>(builder: (restController) {
           return GetBuilder<CategoryController>(builder: (categoryController) {
             return(categoryController.categoryList != null ) ? SafeArea(
    child: ListView(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    children: [
     Row(
      children: [
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Container(
                  margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: <Widget>[
                      Row(
                        children: [
                          _textField(
                              label: 'بحث',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location,color: Colors.blue),
                                onPressed: () {
                                  showCustomSnackBar("message");
                                },
                              ),
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                });
                              }),
                          Container(
                            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.blue,
                                )),


                            child: const Icon(Icons.qr_code, size: 25 ,   color: Colors.blue,),
                          ),
                          Container(
                            padding: const EdgeInsets.all(7),
                            margin: const EdgeInsets.only(left: 4.0, right: 4.0),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                )),


                            child: const Icon(Icons.filter_list_alt, size: 25 ,   color: Colors.white,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

      ],
    ),
      Container(
        height: 150.0,
        child:   BannerView(),
      ),
    const SizedBox(height: 17),

             Container(
               height: 200,
               child: ListView.builder(
                             scrollDirection: Axis.horizontal,
                             itemCount: categoryController.categoryList.length,
                             padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                             physics: BouncingScrollPhysics(),
                             itemBuilder: (context, index) {
                               return     InkWell(
                                 onTap: (){
                                   print("estate_id --------------------${restController.estate.id}");
                                 },
                                 child: Padding(
                                   padding:  EdgeInsets.all(8.0),
                                   child: Column(
                                     children: [
                                       Container(
                                         padding:  EdgeInsets.all(10.0),
                                         decoration: BoxDecoration(
                                           color: HexColor('#B7DFFB'),
                                           shape: BoxShape.circle,
                                         ),
                                         child: const CachedImage(
                                           imageUrl: "https://upload.wikimedia.org/wikipedia/commons/e/eb/Rubio_Circle.png",
                                           width: 30.0,
                                           height: 30.0,
                                         ),
                                       ),
                                       SizedBox(height: 6),
                                       Text(categoryController.categoryList[index].name)
                                       //   Txt(data: category.name, style: robotoMedium),
                                     ],
                                   ),
                                 ),
                               );
                             }),
             )

      ,
    InkWell(
     onTap: (){
       // Push.to(context, EstateDetailsPage(estate: estate))
     },
     child: CustomCard(
       child: Column(
         children: [
           //
           Image.asset(Images.bc, height: 150.0),
           //
           const ListTile(
             contentPadding: EdgeInsets.symmetric(
               horizontal: 10.0,
               vertical: 0.0,
             ),
             trailing: Text(
               ' للبيع',
             ),
             title: Text(
               '\$ 5,245,545',
             ),
             subtitle: Text(
               "dddd",
             ),
           ),
           Row(
             children: [
               Image.asset(Images.map, width: 27.0, height: 27.0),
               const SizedBox(width: 10.0),
               const Text(
                 'المنطقة الشمالية _ جدة _ السعودية',
               ),
             ],
           ),
           // const SizedBox(height: 10.0),
           const Divider(),
           Row(
             // mainAxisAlignment: MainAxisAlignment.center,
             children: [
               //
               Expanded(
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset(Images.bed, width: 14.0, height: 14.0),
                     const SizedBox(width: 10.0),
                     Text(
                        '2 غرفة نوم',
                       style: robotoRegular.copyWith(fontSize: 10.0),
                     ),
                   ],
                 ),
               ),
               //
               Expanded(
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset(Images.bathroom, width: 20.0, height: 20.0),
                     const SizedBox(width: 10.0),
                     Text(
                       '2 حمام',
                       style: robotoRegular.copyWith(fontSize: 10.0),
                     ),
                   ],
                 ),
               ),
               //
               Expanded(
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset(Images.setroom, width: 20.0, height: 20.0),
                     const SizedBox(width: 10.0),
                     Text(
                       '3 معيشة',
                       style: robotoRegular.copyWith(fontSize: 10.0),
                     ),
                   ],
                 ),
               ), //
               Expanded(
                 child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Image.asset(Images.bed, width: 20.0, height: 20.0),
                     const SizedBox(width: 10.0),
                     Text(
                       '5*7 m',
                       style: robotoRegular.copyWith(fontSize: 10.0),
                     ),
                   ],
                 ),
               ),
             ],
           ),
           const SizedBox(height: 10.0),
         ],
       ),
     ),
   ),
    ],
    ),
    ): Center(child: CircularProgressIndicator());

      });
    }),


        // GetBuilder<EstateController>(builder: (restController) {
        //   return GetBuilder<CategoryController>(builder: (categoryController) {
        //     Estate _restaurant;
        //     if(restController.estate != null  && categoryController.categoryList != null) {
        //       _restaurant = restController.estate;
        //     }
        //     restController.setCategoryList();
        //
        //     return (restController.estate != null ) ? CustomScrollView(
        //       physics: AlwaysScrollableScrollPhysics(),
        //       controller: scrollController,
        //       slivers: [
        //
        //
        //           SliverPersistentHeader(
        //           pinned: true,
        //           delegate: SliverDelegate(child: Center(child: Container(
        //             height: 50, width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,
        //             padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        //             child: ListView.builder(
        //               scrollDirection: Axis.horizontal,
        //               itemCount: categoryController.categoryList.length,
        //               padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        //               physics: BouncingScrollPhysics(),
        //               itemBuilder: (context, index) {
        //                 return InkWell(
        //                   onTap: () => restController.setCategoryIndex(index),
        //                   child: Container(
        //                     padding: EdgeInsets.only(
        //                       left: index == 0 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
        //                       right: index == categoryController.categoryList.length-1 ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
        //                       top: Dimensions.PADDING_SIZE_SMALL,
        //                     ),
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.horizontal(
        //                         left: Radius.circular(
        //                           _ltr ? index == 0 ? Dimensions.RADIUS_EXTRA_LARGE : 0 : index == categoryController.categoryList.length-1
        //                               ? Dimensions.RADIUS_EXTRA_LARGE : 0,
        //                         ),
        //                         right: Radius.circular(
        //                           _ltr ? index == categoryController.categoryList.length-1 ? Dimensions.RADIUS_EXTRA_LARGE : 0 : index == 0
        //                               ? Dimensions.RADIUS_EXTRA_LARGE : 0,
        //                         ),
        //                       ),
        //                       color: Theme.of(context).primaryColor.withOpacity(0.1),
        //                     ),
        //                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        //                       Text(
        //                         categoryController.categoryList[index].name,
        //                         style: index == restController.categoryIndex
        //                             ? robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor)
        //                             : robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        //                       ),
        //                       index == restController.categoryIndex ? Container(
        //                         height: 5, width: 5,
        //                         decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
        //                       ) : SizedBox(height: 5, width: 5),
        //                     ]),
        //                   ),
        //                 );
        //               },
        //             ),
        //           ))),
        //         ),
        //
        //
        //       ],
        //     ) : Center(child: CircularProgressIndicator());
        //   });
        // }),


    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;

  SliverDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 50 || oldDelegate.minExtent != 50 || child != oldDelegate.child;
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
