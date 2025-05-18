import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/drawer_menu.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/view_image_dilog.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/chat/conversation_screen.dart';
import 'package:abaad/view/screen/dashboard/widget/bottom_nav_item.dart';
import 'package:abaad/view/screen/draw.dart';
import 'package:abaad/view/screen/favourite/favourite_screen.dart';
import 'package:abaad/view/screen/home/home_screen.dart';
import 'package:abaad/view/screen/map/map_view_screen.dart';
import 'package:abaad/view/screen/qr.dart';
// import 'package:abaad/view/screen/map/map_view_screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'widget/bottom_sheet_guide.dart';

class DashboardScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String route;
  final int pageIndex;
  DashboardScreen({@required this.fromSignUp, @required this.fromHome, @required this.route,@required this.pageIndex});
  static Future<void> loadData(bool reload) async {
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(reload);

    }

    Get.find<UserController>().getUserInfo();

    Get.find<CategoryController>().getSubCategoryList("0");
    Get.find<ZoneController>().getCategoryList();

    // Get.find<AuthController>().getZoneList();
    Get.find<BannerController>().getBannerList(true,1);
  }
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;

  int _pageIndex = 0;


  List<Widget> _screens;
  final ScrollController scrollController = ScrollController();

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    DashboardScreen.loadData(true);
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
       //   Get.find<CategoryController>().getCategoryProductList(0,"0", 0,'0',"0","0","0", offset.toString());
        }
      }
    });
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);


    _screens = [
      MapViewScreen(),
      HomeScreen(),
      ConversationScreen(),
      FavouriteScreen(),


      // CartScreen(fromNav: true),
      // OrderScreen(),

    ];

    Future.delayed(Duration(seconds: 5), () async{
     _initDynamicLinks(context);

      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }
  bool _show = true;
  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  bool checkingFlight = false;
  bool success = false;
  @override
  Widget build(BuildContext context) {
    // Get.find<UserController>().getUserInfo();
    // bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();


    return
      GetBuilder<UserController>(builder: (userController) {

        return
      WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr, style: TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          ));

          // Timer(Duration(seconds: 2), () {
          //
          // });
          return false;

        }
      },

      child: Scaffold(
        key: _key,
        appBar: WebMenuBar(ontop:()=>     _key.currentState.openDrawer(),),
        drawer: DrawerMenu(),

        floatingActionButton:

       Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {

                if(userController.userInfoModel != null) {
                  if (userController.userInfoModel.accountVerification != "0") {
                    Get.toNamed(RouteHelper.getAddLicenseRoute());
                    // Get.toNamed(RouteHelper.getAddEstateRoute());
                  } else {

                    showBottomSheet(context);
                //    Get.toNamed(RouteHelper.getAgentRegister());
                  }
                }else{
                  Get.dialog(Container(
                    color: Colors.white,
                      child: NotLoggedInScreen()));
                }
              },
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment(0.7, -0.5),
                    end: Alignment(0.6, 0.5),
                    colors: [
                      Color(0xFF194B7C),
                      Color(0xFF0864C0),
                    ],
                  ),
                ),
                child: Icon(Icons.add, size: 40,color: Colors.white),
              ),
            ),
          ),
        ),




        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


        bottomNavigationBar: ResponsiveHelper.isDesktop(context) ? SizedBox() : GetBuilder<AuthController>(builder: (orderController) {
          return BottomAppBar(
            elevation: 5,
            notchMargin: 5,
            clipBehavior: Clip.antiAlias,

            shape: CircularNotchedRectangle(),

            child: Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              child: Row(children: [
                BottomNavItem(iconData: Images.home,name: "home".tr,isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                BottomNavItem(iconData: Images.menu, name:"menu".tr,isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                Expanded(child: SizedBox()),
                BottomNavItem(iconData: Images.messageText,name: "chat".tr, isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
                BottomNavItem(iconData: Images.heart, name: "favorite".tr,isSelected: _pageIndex == 3, onTap: () => _setPage(3),),
              ]),
            ),

          );

        }
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );

      });


  }

  void _initDynamicLinks(context) async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;

          if (deepLink != null) {
            // final code = deepLink.path.split('/')[1];
            handleMyLink(deepLink);
          }







        }, onError: (OnLinkErrorException error) async {
      // show error
    });

    final PendingDynamicLinkData data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link;

    if (deepLink != null) {
      // final code = deepLink.path.split('/')[1];
      handleMyLink(deepLink);
    }
  }



  void showBottomSheet(BuildContext context) {

    final TextEditingController _phoneController = TextEditingController();
    Get.dialog(
        GetBuilder<UserController>(builder: (userController) {
          return


      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  child:Container(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[


                           Text(
                          "account_verification".tr,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5,),

                        Text(
                          "your_account_is_not_verified_verify_the_account_through_nafath".tr,
                          style:const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: Colors.black87,
                          ),
                        ),


                        SizedBox(height: 5,),

                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
                              ]),
                          child: Column(
                            children: <Widget>[
                              CustomTextField(
                                hintText: '000000000',
                                controller: _phoneController,
                                inputType: TextInputType.phone,
                                maxLength: 10,
                                textAlign: TextAlign.center,

                                divider: false,
                              ),




                            !userController.isLoading  ? CustomButton(
                                onPressed: () {
          userController.validateNafath(_phoneController.text.toString(),context);
          if(userController.codeStatus==200){
            showCustomSnackBar("oomeroomer");

          }
          },
                                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                buttonText: 'verification'.tr,
                              ) : Center(child: CircularProgressIndicator()),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );


        })
    );
  }


  void handleMyLink(Uri url){
    List<String> sepeatedLink = [];
    /// osama.link.page/Hellow --> osama.link.page and Hellow
    sepeatedLink.addAll(url.path.split('/'));

    print("The Token that i'm interesed in is ${sepeatedLink[1]}");
    // Get.to(()=>EstateDetails(estate: ,));

    // Get.dialog(DettailsDilog(estate:_products[index]));
    Get.toNamed(RouteHelper.getDetailsRoute(  int.parse(sepeatedLink[1])));

  }


  buildDynamicLinks(String title,String image,String docId) async {
    String url = "https://abaad.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$docId'),
      androidParameters: AndroidParameters(
        packageName: "sa.pdm.abaad.abaad",
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '',
          imageUrl:
          Uri.parse("$image"),
          title: title),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    String desc = '${dynamicUrl.shortUrl.toString()}';

    await Share.share(desc, subject: title,);

  }
  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
Widget listItem( int  index ,IconData icon, String label, Color color,onTop) {
  return InkWell(
    onTap: onTop,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        child: Container(



          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12,),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );


}
