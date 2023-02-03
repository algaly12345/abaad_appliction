import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';

import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/chat/chat_screen.dart';

import 'package:abaad/view/screen/dashboard/widget/bottom_nav_item.dart';
import 'package:abaad/view/screen/favourite/favourite_screen.dart';
import 'package:abaad/view/screen/draw.dart';
import 'package:abaad/view/screen/home/home_screen.dart';
import 'package:abaad/view/screen/map/map_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
       MapViewScreen(),
      // Test(),
      HomeScreen(),
      ChatScreen(),
      FavouriteScreen(),


      // CartScreen(fromNav: true),
      // OrderScreen(),

    ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }
  @override
  Widget build(BuildContext context) {
    Get.find<UserController>().getUserInfo();
    bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    return WillPopScope(
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

          Timer(Duration(seconds: 2), () {

          });
          return false;

        }
      },
      child: Scaffold(
        key: _key,
        appBar: WebMenuBar(ontop:()=>     _key.currentState.openDrawer(),),
        drawer:  GetBuilder<UserController>(builder: (userController) {
          return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) :Drawer(
                  child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  ListView(
                children: <Widget>[

                  UserAccountsDrawerHeader(
                    accountName:  Text(
                      _isLoggedIn ? '${userController.userInfoModel.name}' : 'guest'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color:  Colors.grey), ),

                    accountEmail:   Text(
                      _isLoggedIn ? '${userController.userInfoModel.phone}' : 'guest'.tr,
                      style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Colors.grey),
                    ),
                    onDetailsPressed: (){
                      Get.toNamed(RouteHelper.getProfileRoute());
                    },
                    decoration:  const BoxDecoration(
                      image:  DecorationImage(
                        image: ExactAssetImage('assets/images/lake.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    currentAccountPicture:  ClipOval(child: CustomImage(
                      image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                          '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                      height: 100, width: 100, fit: BoxFit.cover,
                    )),
                  ),
                  listItem(1,Icons.manage_accounts_outlined, 'my_account'.tr, Colors.blueAccent,(){
                    Get.toNamed(RouteHelper.getProfileRoute());
                  }),
                  listItem(1,Icons.language, 'language'.tr, Colors.green,(){
                   Get.toNamed(RouteHelper.getLanguageRoute("menu"));
                  }),
                  Divider(height: 1),

                  listItem(2,Icons.support_agent_outlined, 'help_support'.tr, Colors.orange,(){
                   //Get.toNamed(RouteHelper.getSupportRoute(0));
                  }),
                  Divider(height: 1),

                  listItem(3,Icons.policy, 'privacy_policy'.tr, Colors.pink,(){
                  //  Get.toNamed(RouteHelper.getHtmlRoute("privacy-policy"));
                  }),
                  Divider(height: 1),

                  listItem(4,Icons.info, 'about_us'.tr, Colors.deepPurple,(){
                 //   Get.toNamed(RouteHelper.getHtmlRoute("about-us"));
                  }),
                  Divider(height: 1),

                  listItem(5,Icons.list_alt, 'terms_conditions'.tr, Colors.grey,(){
                  //      Get.toNamed(RouteHelper.getHtmlRoute("terms_conditions"));
                  }),
                  Divider(height: 1),

                  listItem(6,Icons.account_balance_wallet_outlined, 'wallet'.tr, Colors.green,(){
                  //  Get.toNamed(RouteHelper.getWalletRoute(true));
                  }),

                  Divider(height: 1),

                  listItem(8,Icons.logout,  _isLoggedIn ? 'logout'.tr : 'sign_in'.tr, Colors.orange,(){


                    // if(Get.find<AuthController>().isLoggedIn()) {
                    //   Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                    //     Get.find<AuthController>().clearSharedData();
                    //     Get.find<CartController>().clearCartList();
                    //     Get.find<WishListController>().removeWishes();
                    //     Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                    //   }), useSafeArea: false);
                    // }else {
                    //   Get.find<WishListController>().removeWishes();
                    //   Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
                    // }
                  }),
                ],
              ),
            ),
          );

        }),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 70,
            width: 70,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {},
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
