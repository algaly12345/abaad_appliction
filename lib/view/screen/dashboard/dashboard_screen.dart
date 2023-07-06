import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/banner_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/controller/zone_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/confirmation_dialog.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/details_dilog.dart';
import 'package:abaad/view/base/drawer_menu.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/chat/chat_screen.dart';
import 'package:abaad/view/screen/chat/conversation_screen.dart';
import 'package:abaad/view/screen/dashboard/widget/bottom_nav_item.dart';
import 'package:abaad/view/screen/favourite/favourite_screen.dart';
import 'package:abaad/view/screen/draw.dart';
import 'package:abaad/view/screen/home/home_screen.dart';
import 'package:abaad/view/screen/map/map_view_screen.dart';
import 'package:abaad/view/screen/old.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DashboardScreen extends StatefulWidget {
  final bool fromSignUp;
  final bool fromHome;
  final String route;
  final int pageIndex;
  DashboardScreen({@required this.fromSignUp, @required this.fromHome, @required this.route,@required this.pageIndex});

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

    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);

    }

     Get.find<UserController>().getUserInfo();
    Get.find<CategoryController>().getSubCategoryList("0");
    Get.find<ZoneController>().getCategoryList();
    int offset = 1;
    Get.find<AuthController>().getZoneList();
    Get.find<BannerController>().getBannerList(true,1);
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
     await _initDynamicLinks(context);

      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }
  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }
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

                if(userController.userInfoModel.accountVerification != "0") {
                  Get.toNamed(RouteHelper.getAddEstateRoute());
                }else{
                  Get.toNamed(RouteHelper.getAgentRegister());
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
                BottomNavItem(iconData: Images.home,name: "الرئسية",isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                BottomNavItem(iconData: Images.menu, name:"القائمة",isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                Expanded(child: SizedBox()),
                BottomNavItem(iconData: Images.messageText,name: "المحادثة", isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
                BottomNavItem(iconData: Images.heart, name: "المفضلة",isSelected: _pageIndex == 3, onTap: () => _setPage(3),),
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
