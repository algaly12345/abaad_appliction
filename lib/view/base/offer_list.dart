
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/screen/map/widget/service_offer.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferList extends StatefulWidget {
  Estate estate;
  // Generate some dummy data


  OfferList({Key key,this.estate}) : super(key: key);

  @override
  State<OfferList> createState() => _OfferListState();
}

class _OfferListState extends State<OfferList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  CustomAppBar(title: 'العروض'),
        body: ListView.builder(
        physics: BouncingScrollPhysics(),
    itemCount:  widget.estate.serviceOffers.length,
    scrollDirection: Axis.vertical,
    itemBuilder: (context, index) {
      return    Padding(
        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
        child: Card(
          color: Colors.white,
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                shape: BoxShape.circle,
              ),
              child:  GetBuilder<SplashController>(builder: (splashController) {
                String _baseUrl = Get.find<SplashController>().configModel.baseUrls.provider;
                //   print("------------${'$_baseUrl/${estateController.estate.serviceOffers[index].imageCover}'}");
                return ClipOval(
                  child: CustomImage(
                    image: '$_baseUrl/${widget.estate.serviceOffers[index].image}',
                    fit: BoxFit.cover,
                    height: 35,
                    width: 35,
                  ),
                );
              },
              ),
            ),
            title: Text("${widget.estate.serviceOffers[index].title}"),
            subtitle:      Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Row(
            children: [
              widget. estate.serviceOffers[index].servicePrice!=null?Text("price".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)):Text("discount".tr  , style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
          SizedBox(width: 11.0),
              widget.estate.serviceOffers[index].discount!=null?  SizedBox(
            height: 16,
            width: 44,
            child: CustomPaint(
              painter: PriceTagPaint(),
              child: Center(
                child: Text(
                    "${widget.estate.serviceOffers[index].discount}%",
                    style: robotoBlack.copyWith(fontSize: 10,color: Colors.white)
                ),
              ),
            ),
          ):Text(" ${widget.estate.serviceOffers[index].servicePrice} ريال "  ,style: robotoBlack.copyWith(fontSize: 11)),
          ],
        ),
              ],
            ),
            trailing:  IconButton(
              icon: Icon(Icons.contact_mail_rounded),
              color: Colors.lightBlueAccent,
              onPressed:()=>Get.dialog(
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
                            child: Column(
                              children: [
                                const SizedBox(height: 10),

                                const SizedBox(height: 15),
                                const Text(
                                  "تواصل مع مقدم الخدمة",
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 25),
                                //Buttons
                                Row(
                                  children: [
                                    Expanded(
flex: 1,
                                      child:GestureDetector(

                                        onTap:(){
                                          buildDynamicLinks(widget.estate.title, "${Get.find<SplashController>().configModel.baseUrls.estateImageUrl}/${widget.estate.images[0]}", widget.estate.id.toString(),widget.estate.serviceOffers[index].phoneProvider);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: const BoxDecoration(
                                              color: Color(0xfff5f8fd),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                  //Created this shadow for looking elevated.
                                                  //For creating like a card.
                                                    color: Colors.black12,
                                                    offset: Offset(0.0,
                                                        18.0), // This offset is for making the the lenght of the shadow and also the brightness of the black color try seeing it by changing its values.
                                                    blurRadius: 15.0),
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, -04.0),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // I had added main axis allignment to be center to make to be at the center.
                                            children: [
                                              Icon(Icons.whatsapp),
                                              const SizedBox(width: 3),
                                              Text(
                                                "واتساب",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.deepPurpleAccent,
                                                    fontWeight: FontWeight.w700),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 1,
                                      child:GestureDetector(
                                        onTap:() async{
                                          openDialPad(widget.estate.serviceOffers[index].phoneProvider);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          decoration: const BoxDecoration(
                                              color: Color(0xfff5f8fd),
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                  //Created this shadow for looking elevated.
                                                  //For creating like a card.
                                                    color: Colors.black12,
                                                    offset: Offset(0.0,
                                                        18.0), // This offset is for making the the lenght of the shadow and also the brightness of the black color try seeing it by changing its values.
                                                    blurRadius: 15.0),
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    offset: Offset(0.0, -04.0),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // I had added main axis allignment to be center to make to be at the center.
                                            children: [
                                            Icon(Icons.call),
                                              const SizedBox(width: 3),
                                              Text(
                                                "إتصال",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.deepPurpleAccent,
                                                    fontWeight: FontWeight.w700),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      );

    }
    ));

  }


  buildDynamicLinks(String title,String image,String docId,String phone) async {
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

    var whatsapp = "$phone";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=$desc \n مرحبا لديك عرض في  تطبيق ابعاد ");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
   // await Share.share(desc, subject: title,);

  }
  __launchWhatsapp(String  number) async {
    var whatsapp = "$number";
    var whatsappAndroid =Uri.parse("whatsapp://send?phone=$whatsapp&text=مرحبا  لديك عرض  في تطبيق ابعاد");
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

openDialPad(String phoneNumber) async {
  Uri url = Uri(scheme: "tel", path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print("Can't open dial pad.");
  }
}

