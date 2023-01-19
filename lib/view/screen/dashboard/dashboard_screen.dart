import 'dart:async';

import 'package:abaad/controller/auth_controller.dart';

import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
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

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
       MapViewScreen(),
      // MapPage(),
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
        key: _scaffoldKey,

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
                BottomNavItem(iconData: Icons.home_outlined,name: "الرئسية",isSelected: _pageIndex == 0, onTap: () => _setPage(0)),
                BottomNavItem(iconData: Icons.checklist, name:"قائمة",isSelected: _pageIndex == 1, onTap: () => _setPage(1)),
                Expanded(child: SizedBox()),
                BottomNavItem(iconData: Icons.chat_bubble_outline,name: "المحادثة", isSelected: _pageIndex == 2, onTap: () => _setPage(2)),
                BottomNavItem(iconData: Icons.favorite_border, name: "المحادثة",isSelected: _pageIndex == 3, onTap: () => _setPage(3),),
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
