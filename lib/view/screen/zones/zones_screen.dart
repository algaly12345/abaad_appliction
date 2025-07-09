import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/data/model/response/config_model.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:abaad/view/screen/fillter/fillter_estate_sheet.dart';
import 'package:abaad/view/screen/home/home_screen.dart';
import 'package:abaad/view/screen/home/widet/estate_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widet/banner_view.dart';

class ZonesScreen extends StatefulWidget {

  final ScrollController scrollController = ScrollController();
  final bool _ltr = Get.find<LocalizationController>().isLtr;

  final ScrollController _scrollController = ScrollController();
  ConfigModel _configModel = Get.find<SplashController>().configModel;



  static Future<void> loadData(bool reload) async {
    Get.find<CategoryController>().showBottomLoader();
          Get.find<CategoryController>().getCategoryProductList(0,"0", 0,'0',"0","0","0", "0",0,0,"");
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }
    // Get.find<CategoryController>().getSubCategoryList("0");
    int offset = 1;
    Get.find<BannerController>().getBannerList(reload,1);
    Get.find<AuthController>().getZoneList();
    // scrollController?.addListener(() {
    //   if (scrollController.position.pixels == scrollController.position.maxScrollExtent && Get.find<CategoryController>().categoryProductList != null && !Get.find<CategoryController>().isLoading) {
    //     int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
    //     if (offset < pageSize) {
    //       offset++;
    //       print('end of the page');
    //       Get.find<CategoryController>().showBottomLoader();
    //       Get.find<CategoryController>().getCategoryProductList(0,"0", 0,'0',"0","0","0", offset.toString());
    //     }
    //   }
    // });


    int pageSize = (Get.find<CategoryController>().pageSize / 10).ceil();
    if (offset < pageSize) {
      offset++;
      print('end of the page');
      Get.find<CategoryController>().showBottomLoader();
      Get.find<CategoryController>().getCategoryProductList(0,"0", 0,'0',"0","0","0", offset.toString(),0,0,"");
  }}

  @override
  State<ZonesScreen> createState() => _ZonesScreenState();

}

class _ZonesScreenState extends State<ZonesScreen> {


  @override
  void initState() {
    super.initState();
    _loadSavedZone();
    Get.find<AuthController>().getZoneList();


  }

  String selectedZoneName;

  void _loadSavedZone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedZoneName = prefs.getString('zone_name');
    });
  }
  static const _locale = 'en';
  String result = "Scan a QR Code"; // Initialize with a default message
  bool isFlashOn = false;

  Future<void> scanQRCode() async {
    try {
      final ScanResult scanResult = await BarcodeScanner.scan(
        options: ScanOptions(
          useCamera: -1, // Use the back camera by default
          autoEnableFlash: isFlashOn,
        ),
      );
      setState(() {
        result = scanResult.rawContent;
        Get.toNamed(RouteHelper.getDetailsRoute( 162));
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }
  }

  void toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale;
    bool isArabic = currentLocale?.languageCode == 'ar';
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
            padding: const EdgeInsets.only(right: 5, left: 5),
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


                // Text("المناطق   "),

        GetBuilder<AuthController>(builder: (locationController) {
        return SizedBox(
        height: 500,
        child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        ),
        itemCount: locationController.zoneList.length,
        itemBuilder: (context, index) {
        final zone = locationController.zoneList[index];

        return GestureDetector(
        onTap: () async{


          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('zone_name',  zone.nameAr);
          await prefs.setInt('zone_id',  zone.id);
          Get.find<CategoryController>().setFilterIndex( zone.id,0,"0","0",0,0,0,"");
        Get.to(() => HomeScreen(zoneId: zone.id)); // <-- انتقل مع المعرف
        },
        child: Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
        BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
        ),
        ],
        ),
        child: Stack(
        children: [
        ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomImage(
        image: "${AppConstants.BASE_URL}/storage/app/public/zone/${zone.image ?? ''}",
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        ),
        ),
        Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.4),
        ),
        ),
        Center(
        child: Text(
        zone.nameAr,
        style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        shadows: [
        Shadow(
        color: Colors.black,
        blurRadius: 4,
        offset: Offset(1, 1),
        )
        ],
        ),
        textAlign: TextAlign.center,
        ),
        ),
        ],
        ),
        ),
        );
        },
        ),
        );
        })



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
