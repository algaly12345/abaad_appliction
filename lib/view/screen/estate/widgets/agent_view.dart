// import 'package:abaad/controller/splash_controller.dart';
// import 'package:abaad/data/model/response/estate_model.dart';
// import 'package:abaad/data/model/response/userinfo_model.dart';
// import 'package:abaad/helper/route_helper.dart';
// import 'package:abaad/util/dimensions.dart';
// import 'package:abaad/util/styles.dart';
// import 'package:abaad/view/base/custom_image.dart';
// import 'package:clipboard/clipboard.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class AgentItemView extends StatelessWidget {
//   final Estate estate;
//   final UserInfoModel restaurants;
//  restaurants;
//   const AgentItemView({Key key,this.estate ,this.restaurants,this.userInfoModel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     bool _isNull = true;
//     int _length = 0;
//
//     _isNull = restaurants == null;
//     if(!_isNull) {
//       _length = restaurants.length;
//     return
//       !_isNull ? _length > 0 ?Column(
//         children: [
//           Divider(height: 1,),
//           SizedBox(height: 6),
//           GestureDetector(
//             onTap: () async{
//               await Get.toNamed(RouteHelper.getProfileAgentRoute(estate.userId));
//             },
//             child: Container(
//               margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
//               padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                 boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], spreadRadius: 1, blurRadius: 5)],
//               ),
//               child: Row(children: [
//
//                 ClipOval(child: CustomImage(
//                   image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
//                       '/${(userInfoModel.agent != null) ? userInfoModel.image : ''}',
//                   height: 100, width: 100, fit: BoxFit.cover,
//                 )),
//                 SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
//
//                 Expanded(child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
//
//                   Text(userInfoModel.agent.name, style: robotoMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
//                   SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
//
//                   Row(children: [
//
//                     Container(
//                       height: 25, width: 70, alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
//                       ),
//                       child: Center(
//                         child: Text(userInfoModel.agent.membershipType, style: robotoBold.copyWith(
//                           color: Theme.of(context).cardColor,
//                           fontSize: Dimensions.fontSizeLarge,
//                         )),
//                       ),
//                     ),
//                     Expanded(child: SizedBox()),
//
//
//
//
//                   ]),
//                   SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Text(
//                         "رقم المعلن",
//                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
//                       ),
//                       SizedBox(width: 20),
//                       // Text(
//                       //   userController.agentInfoModel.agent.advertiserNo==null?"":userController.agentInfoModel.agent.advertiserNo,
//                       //   style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
//                       // ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "تاريخ النشر",
//                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).disabledColor),
//                       ),
//                       SizedBox(width: 20),
//                       Text(
//                         estate.createdAt ?? "",
//                         style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor),
//                       ),
//                     ],
//                   ),
//                 ])
//                 ),
//
//               ]),
//             ),
//           ),
//         ],
//       ):Text("not data"):Text("looding");
//   }
// }}
