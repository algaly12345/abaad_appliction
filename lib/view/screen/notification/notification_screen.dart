import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/notification_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/date_converter.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/no_data_screen.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/screen/notification/widget/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _loadData() async {
    Get.find<NotificationController>().clearNotification();
    if(Get.find<SplashController>().configModel == null) {
      await Get.find<SplashController>().getConfigData();
    }
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<NotificationController>().getNotificationList(true);
    }
  }
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBar(title: 'notification'.tr),
      body: Get.find<AuthController>().isLoggedIn() ? GetBuilder<NotificationController>(builder: (notificationController) {
        if(notificationController.notificationList != null) {
         // notificationController.saveSeenNotificationCount(notificationController.notificationList.length);
        }
        List<DateTime> _dateTimeList = [];
        return notificationController.notificationList != null ? notificationController.notificationList.length > 0 ? RefreshIndicator(
          onRefresh: () async {
            await notificationController.getNotificationList(true);
          },
          child: Scrollbar(child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: ListView.builder(
              itemCount: notificationController.notificationList.length,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                bool _addTitle = false;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  _addTitle ? Padding(
                    padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Text("${notificationController.notificationList[index].createdAt}"),
                  ) : SizedBox(),
                  Container(

                    margin: EdgeInsets.fromLTRB(4, 5, 4, 4),
                    padding: EdgeInsets.fromLTRB(5, 12, 5, 18),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.015, 0.015],
                        colors: [Colors.cyan, Color(0xffcedaff)],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 0.0),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: [
                               Text(
                                 "${notificationController.notificationList[index].title}",
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                              ),
                              Text(
                                "${notificationController.notificationList[index].description}",
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ],
                          ),
                          Image.asset(Images.bell_small),
                        ],
                      ),
                    ),
                  ),

                  // InkWell(
                  //   onTap: () {
                  //     showDialog(context: context, builder: (BuildContext context) {
                  //       return NotificationDialog(notificationModel: notificationController.notificationList[index]);
                  //     });
                  //   },
                  //   child:
                  //
                  //   Padding(
                  //     padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  //     child: Row(children: [
                  //
                  //       // ClipOval(child: CustomImage(
                  //       //   height: 40, width: 40, fit: BoxFit.cover,
                  //       //   image: '${Get.find<SplashController>().configModel.baseUrls.notificationImageUrl}'
                  //       //       '/${notificationController.notificationList[index].data.image}',
                  //       // )),
                  //       SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                  //
                  //       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  //         Text(
                  //           notificationController.notificationList[index].notifiableType ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  //           style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  //         ),
                  //         Text(
                  //           notificationController.notificationList[index].notifiableType ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                  //           style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  //         ),
                  //       ])),
                  //
                  //     ]),
                  //   ),
                  // ),


                ]);
              },
            ))),
          )),
        ) : NoDataScreen(text: 'no_notification_found'.tr) : Center(child: CircularProgressIndicator());
      }) : NotLoggedInScreen(),
    );
  }
}
