import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/theme_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/estate_item.dart';
import 'package:abaad/view/base/rating_bar.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/profile/widget/profile_button.dart';
import 'package:abaad/view/screen/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../util/images.dart';
import '../profile/widget/profile_bg_widget.dart';


class AgentProfileScreen extends StatefulWidget {
  final Userinfo userInfo;
   AgentProfileScreen({ @required Key key,  this.userInfo}) : super(key: key);

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
     _isLoggedIn = Get.find<AuthController>().isLoggedIn();

     print("userInfo${widget.userInfo.id}");
    if(_isLoggedIn && Get.find<UserController>().agentInfoModel == null) {
      Get.find<UserController>().getUserInfoByID(widget.userInfo.id);
    }

    Get.find<AuthController>().getZoneList();
    if(Get.find<UserController>().estateModel == null) {
      Get.find<UserController>().getEstateByUser(1, false,widget.userInfo.id);
    }
    Get.find<UserController>().getEstateByUser(1, false,widget.userInfo.id);

  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar:  CustomAppBar(title: 'profile'.tr),
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<UserController>(builder: (userController) {
    return   GetBuilder<UserController>(builder: (restController) {
        return (_isLoggedIn && userController.agentInfoModel == null) ? Center(child: CircularProgressIndicator()) :( restController.estateModel != null &&restController.estateModel.estates != null) ?  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProfileBgWidget(
            backButton: true,
            circularImage: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                    children: [
                       Stack(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            child:  Container   (
                              decoration: BoxDecoration(
                                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.topRight,
                              child: ClipOval(child: CustomImage(
                                image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                    '/${(userController.agentInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                height: 90, width: 90, fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.online_prediction_sharp,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:  [
                            Column(
                              children: [
                                Text(
                                  "نوع المعلن",
                                  style:  robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeDefault),
                                ),
                        Text(
                          _isLoggedIn ? '${userController.agentInfoModel.userinfo.membershipType}' : 'guest'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),)


                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "الإعلانات",
                                    style:  robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault),
                                ),
                                Text("${restController.estateModel.totalSize}"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "رقم المعلن في هية العقار",
                                    style:  robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeDefault),
                                ),
                                Text(
                                  _isLoggedIn ? '${userController.agentInfoModel.userinfo.advertiserNo}' : 'guest'.tr,
                                  style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                ),

                 Padding(
                   padding: const EdgeInsets.only(right: 5,left: 5,top: 5,bottom: 5),
                   child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   Text(
                   _isLoggedIn ? '${userController.agentInfoModel.name}' : 'guest'.tr,
                     style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                   ),
                      SizedBox(height: 4),
                      Text(  _isLoggedIn ? '${userController.agentInfoModel.phone}' : 'guest'.tr,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 4),
RatingBar(rating: 4, ratingCount: 4)     ,
                      Text(
                       _isLoggedIn ? '${userController.agentInfoModel.userinfo.membershipType}' : 'guest'.tr,
                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                     ),



                      SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                              child:ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                  ),
                                  onPressed: (){
                                    __launchWhatsapp(userController.agentInfoModel.phone);
                                  }, icon: Icon(Icons.whatsapp), label: Text("واتساب")),
                          ),
                          const SizedBox(width:5),
                          Expanded(
                            child:ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                                ),
                                onPressed: ()async{
                                  await Get.toNamed(RouteHelper.getChatRoute(
                                      notificationBody: NotificationBody(orderId: 1 ,restaurantId:userController.agentInfoModel.id),
                                      user: Userinfo(id: userController.agentInfoModel.id, name: userController.agentInfoModel.name,  image: userController.agentInfoModel.image,),estate_id: 0

                                  ));
                                }, icon: Icon(Icons.chat), label: Text("محادثة")),
                          ),
                           SizedBox(width:5),
                          Expanded(
                            child:ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                                ),
                                onPressed: (){

                            }, icon: Icon(Icons.call), label: Text("اتصال")),
                          ),
                        ],
                      ),





                    ],
                ),
                 )
              ],
            ),
            mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: Center(child: Container(

              width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,

              child: Column(children: [


                SizedBox(height: 4),

                _isLoggedIn ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(4.0),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).backgroundColor,
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(1, 0.5), // changes position of shadow
                            ),

                          ],

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SocialIcon(
                              color: Color(0xFF102397),
                              iconData:Images.facebook,
                              onPressed: () {},
                            ),

                            SocialIcon(
                              color: Color(0xFF102397),
                              iconData:Images.tiktok,
                              onPressed: () {},
                            ),
                            SocialIcon(
                              color: Color(0xff58b3f5),
                              iconData:Images.snap,
                              onPressed: () {},
                            ),
                            SocialIcon(
                              color: Color(0xFF38A1F3),
                              iconData:Images.website,
                              onPressed: () {
                                _launchURL();
                              },
                            ),
                            SocialIcon(
                              color: Color(0xFF2867B2),
                              iconData:Images.twiter,
                              onPressed: () {},
                            ),
                            SocialIcon(
                              color: Color(0xFF38A1F3),
                              iconData:Images.instgram,
                              onPressed: () {},
                            ),
                            SocialIcon(
                              color: Color(0xFF146522),
                              iconData:Images.youtube,
                              onPressed: () {},
                            ),

                          ],
                        ),
                      ),



                ]) : SizedBox(),
                SizedBox(height: _isLoggedIn ? 6 : 0),
                Container(
                  height: 600,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount:  restController.estateModel.estates.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return  GetBuilder<EstateController>(builder: (wishController) {
                        return  EstateItem(estate: restController.estateModel.estates[index],onPressed: (){
                          Get.toNamed(RouteHelper.getDetailsRoute( restController.estateModel.estates[index].id,restController.estateModel.estates[index].userId));
                        },fav: false,);
                      });
                    },
                  ),
                ),
                SizedBox(height: _isLoggedIn ? Dimensions.PADDING_SIZE_LARGE : 0),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                  SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall)),
                ]),

              ]),
            ))),
          ),
        ): const Center(child: CircularProgressIndicator());
      });
      }),
    );
  }

  __launchWhatsapp(String  number) async {
    var whatsapp = "+9${number}";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=hello");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }

}



class SocialIcon extends StatelessWidget {
  final Color color;
  final String  iconData;
  final Function onPressed;

  SocialIcon({this.color, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0),
      child: Container(
        width: 40.0,
        height: 40.0,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: Colors.blue)
        ),
        child: RawMaterialButton(
          shape: CircleBorder(),
          onPressed: onPressed,
          child:Image.asset(iconData,height: 30,width: 30),
        ),
      ),
    );
  }
}


_launchURL() async {
  const url = 'https://www.tpp.com.sa/';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
