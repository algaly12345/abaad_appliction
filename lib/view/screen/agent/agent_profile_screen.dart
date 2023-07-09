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
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/estate_item.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
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
  final int  isMyProfile;
   AgentProfileScreen({ @required Key key,  this.userInfo ,this.isMyProfile}) : super(key: key);

  @override
  State<AgentProfileScreen> createState() => _AgentProfileScreenState();
}

class _AgentProfileScreenState extends State<AgentProfileScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
     _isLoggedIn = Get.find<AuthController>().isLoggedIn();

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
        return (_isLoggedIn && userController.agentInfoModel == null &&userController.agentInfoModel.name == null) ? Center(child: CircularProgressIndicator()) :( restController.estateModel != null &&restController.estateModel.estates != null) ?  Padding(
          padding: const EdgeInsets.only(right: 0.0,left: 0.0),
          child: ProfileBgWidget(

            backButton: true,

            circularImage: Container(
              decoration:  BoxDecoration(
                  image:  DecorationImage(
                    image:  AssetImage(Images.background),
                    fit: BoxFit.cover,
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                      children: [
                         Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.all(7),
                              child:  Container   (
                                decoration: BoxDecoration(
                                  border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.topRight,
                                child: ClipOval(child: CustomImage(
                                  image: '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                      '/${(userController.agentInfoModel != null && _isLoggedIn) ? userController.agentInfoModel.image : ''}',
                                  height: 80, width: 80, fit: BoxFit.cover,
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
                                    style:   robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),
                                  ),
                          Text(
                             '${userController.agentInfoModel.membershipType!=null?userController.agentInfoModel.membershipType:''}',
                            style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),)


                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "عدد الإعلانات",
                                      style:  robotoRegular.copyWith(
                                          fontSize: Dimensions.fontSizeSmall),
                                  ),
                                  Text("${restController.estateModel.totalSize}", style:  robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeSmall)),
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
                     '${userController.agentInfoModel.name}',
                       style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                     ),
                        SizedBox(height: 4),
                        widget.isMyProfile==1? Text(   '${userController.agentInfoModel.phone}',
                          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ):Container(),
                        SizedBox(height: 4),
// RatingBar(rating: 4, ratingCount: 4)     ,
//                       Text(
//                        '${userController.agentInfoModel.userinfo.membershipType!=null?userController.agentInfoModel.userinfo.membershipType:''}',
//                        style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
//                      ),
//

                        Row(
                          children: [
                            Text(
                              "رقم المعلن في هية العقار",
                              style:  robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeSmall),
                            ),
                            SizedBox(width: 7,),
                            Text(
                                '${userController.userInfoModel.advertiserNo}' ,
                                style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ],
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
                                      __launchWhatsapp(userController.agentInfoModel.phone,userController.agentInfoModel.name);
                                    }, icon: Icon(Icons.whatsapp), label: Text("واتساب",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall))),
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
                                  }, icon: Icon(Icons.chat), label: Text("محادثة",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall))),
                            ),
                             SizedBox(width:5),
                            Expanded(
                              child:ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                                  ),
                                  onPressed: () async{
                                    final urlScheme = 'tel:${userController.agentInfoModel.phone}';

                                    if (await canLaunch(urlScheme)) {
                                    await launch(urlScheme);
                                    } else {
                                    throw 'Could not make a phone call.';
                                    }

                              }, icon: Icon(Icons.call), label: Text("اتصال",style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall))),
                            ),
                          ],
                        ),

                        SizedBox(height: 4,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // SocialIcon(
                            //   color: Color(0xFF102397),
                            //   iconData:Images.facebook,
                            //   onPressed: () {
                            //     _launchURL(userController.agentInfoModel.);
                            //   },
                            // ),

                            SocialIcon(
                              color: Color(0xFF102397),
                              iconData:Images.tiktok,
                              onPressed: () async{

                                String tiktokProfileUrl = 'https://www.tiktok.com/@${userController.agentInfoModel.tiktok}'; // Replace 'username' with the desired username
                                if (await canLaunch(tiktokProfileUrl)) {
                                await launch(tiktokProfileUrl);
                                } else {
                                throw 'Could not launch $tiktokProfileUrl';
                                }

                              },
                            ),
                            SocialIcon(
                              color: Color(0xff58b3f5),
                              iconData:Images.snap,
                              onPressed: () async{


                                String tiktokProfileUrl = '${userController.userInfoModel.snapchat}'; // Replace 'username' with the desired username

                                if (await canLaunch(tiktokProfileUrl)) {
                                  await launch(tiktokProfileUrl);
                                } else {
                                  throw 'Could not launch Snapchat.';
                                }
                              },
                            ),
                            SocialIcon(
                              color: Color(0xFF38A1F3),
                              iconData:Images.website,
                              onPressed: () {
                                _launchURL(userController.agentInfoModel.website);
                              },
                            ),
                            SocialIcon(
                              color: Color(0xFF2867B2),
                              iconData:Images.twiter,
                              onPressed: () {
                                _launchURL(userController.agentInfoModel.twitter);
                              },
                            ),
                            SocialIcon(
                              color: Color(0xFF38A1F3),
                              iconData:Images.instgram,
                              onPressed: () {
                                _launchURL(userController.agentInfoModel.instagram);
                              },
                            ),
                            SocialIcon(
                              color: Color(0xFF146522),
                              iconData:Images.youtube,
                              onPressed: () {
                                _launchURL(userController.agentInfoModel.youtube);
                              },
                            ),

                          ],
                        )


                      ],
                  ),
                   )
                ],
              ),
            ),
            mainWidget: SingleChildScrollView(physics: BouncingScrollPhysics(), child: Center(child: Container(

              width: Dimensions.WEB_MAX_WIDTH, color: Theme.of(context).cardColor,

              child: Column(children: [



                Container(
                  height: 600,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount:  restController.estateModel.estates.length,
                    scrollDirection: Axis.vertical,

                    itemBuilder: (context, index) {
                      return  GetBuilder<EstateController>(builder: (wishController) {
                        return  EstateItem(estate: restController.estateModel.estates[index],onPressed: (){
                          Get.toNamed(RouteHelper.getDetailsRoute( restController.estateModel.estates[index].id));
                        },fav: false,isMyProfile: widget.isMyProfile);
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

  __launchWhatsapp(String  number,String name) async {
    var whatsapp = "${number}";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=مرحبا  ${name}");
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


_launchURL( String link) async {
  //showCustomSnackBar(link);
  final url = Uri.parse(
    '$link',
  );
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {
    // ignore: avoid_print
    showCustomSnackBar("لايوجد رابط");
  }


}
