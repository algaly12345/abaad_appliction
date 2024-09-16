import 'dart:async';
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/chat_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/body/notification_body.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/user_type.dart';
import 'package:abaad/util/app_constants.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:abaad/view/base/paginated_list_view.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/chat/widget/message_bubble.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final NotificationBody notificationBody;
  final Userinfo  user;
  final int    conversationID;
  final int index;
  final String  estate_id;
  final String link;
  final Estate estate;
  const ChatScreen({@required this.notificationBody, @required this.user, this.conversationID, this.index,this.estate_id,this.link,this.estate});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  bool _isLoggedIn;
  StreamSubscription _stream;
  String url;
  var data;
  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";
  Timer _timer;
  @override
  void initState() {
    super.initState();

    print('-------------------------------estate_id${widget.estate_id}');

    initCall();

    if(widget.link=="null"){

      _inputMessageController.text="";

      // _inputMessageController.text=widget.link;
    }else{
      setState(() {
      });
      Get.find<ChatController>().toggleSendButtonActivity();
      _inputMessageController.text=widget.link;
    }
    //
    startFetchingMessages();



  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }



  void startFetchingMessages() {
    // Define the interval for refreshing data
    const duration = Duration(seconds: 30); // Adjust the duration as needed

    // Fetch messages immediately
    Get.find<ChatController>().getMessages(1, widget.notificationBody, widget.user, widget.conversationID, firstLoad: true);

    // Start the timer
    _timer = Timer.periodic(duration, (Timer t) {
      Get.find<ChatController>().getMessages(1, widget.notificationBody, widget.user, widget.conversationID);
    });
  }

  void initCall(){
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(Get.find<AuthController>().isLoggedIn()) {
      Get.find<ChatController>().getMessages(1, widget.notificationBody, widget.user, widget.conversationID, firstLoad: true);

      if(Get.find<UserController>().userInfoModel == null || Get.find<UserController>().userInfoModel.userinfo == null) {
        Get.find<UserController>().getUserInfo();
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return GetBuilder<ChatController>(builder: (chatController) {
      String _baseUrl = '';
      if(widget.notificationBody.adminId != null) {
        _baseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;
      }else
        if(widget.notificationBody.deliverymanId != null) {
        _baseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;
      }else {
        _baseUrl = Get.find<SplashController>().configModel.baseUrls.customerImageUrl;
      }

      return Scaffold(


      //   appBar: (ResponsiveHelper.isDesktop(context) ?  WebMenuBar() : AppBar(
      //   leading: IconButton(
      //     // onPressed: () {
      //     //   if(widget.fromNotification) {
      //     //     Get.offAllNamed(RouteHelper.getInitialRoute());
      //     //   }else {
      //     //     Get.back();
      //     //   }
      //     // },
      //     icon: const Icon(Icons.arrow_back_ios),
      //   ),
      //   title: Text(chatController.messageModel != null ? '${chatController.messageModel.conversation.receiver.name}'
      //       ' ${chatController.messageModel.conversation.receiver.name}' : 'receiver_name'.tr),
      //   backgroundColor: Theme.of(context).primaryColor,
      //   actions: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Container(
      //         width: 40, height: 40, alignment: Alignment.center,
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(50),
      //           border: Border.all(width: 2,color: Theme.of(context).cardColor),
      //           color: Theme.of(context).cardColor,
      //         ),
      //         child: ClipOval(child: CustomImage(
      //           image:'${AppConstants.BASE_URL}'
      //               '/${chatController.messageModel != null ? chatController.messageModel.conversation.receiver.image : ''}',
      //           fit: BoxFit.cover, height: 40, width: 40,
      //         )),
      //       ),
      //     )
      //   ],
      // )),

        body: _isLoggedIn ?
        GetBuilder<UserController>(builder: (userController) {
      return  SafeArea(
          child: Center(
            child: Container(
              width: ResponsiveHelper.isDesktop(context) ? Dimensions.WEB_MAX_WIDTH : MediaQuery.of(context).size.width,
              child: Column(children: [
                widget.link!="null"?   Container(
                  height: 60.0,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        color: Colors.red,
                        height: 60.0,
                        child: Container(

                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.0),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5), width: 1.0),
                              color: Theme.of(context).primaryColor,),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  // onPressed: () {
                                  //   if(widget.fromNotification) {
                                  //     Get.offAllNamed(RouteHelper.getInitialRoute());
                                  //   }else {
                                  //     Get.back();
                                  //   }
                                  // },
                                  icon: const Icon(Icons.arrow_back_ios),
                                ),

                                Text(chatController.messageModel != null ? '${chatController.messageModel.conversation.receiver.name}'
                                    ' ${chatController.messageModel.conversation.receiver.name}' : 'receiver_name'.tr,style: TextStyle(color: Theme.of(context).disabledColor,),),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 40, height: 40, alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(width: 2,color: Theme.of(context).cardColor),
                                      color: Theme.of(context).cardColor,
                                    ),
                                    child: ClipOval(child: CustomImage(
                                      image:'${AppConstants.BASE_URL}'
                                          '/${chatController.messageModel != null ? chatController.messageModel.conversation.receiver.image : ''}',
                                      fit: BoxFit.cover, height: 40, width: 40,
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ):Container(
                  // child:   Text(widget.estate.shortDescription),
                ),
                GetBuilder<ChatController>(builder: (chatController) {
                  return Expanded(child: chatController.messageModel != null ? chatController.messageModel.messages.length > 0 ? SingleChildScrollView(
                    controller: _scrollController,
                    reverse: true,
                    child: PaginatedListView(
                      scrollController: _scrollController,
                      reverse: true,
                      totalSize: chatController.messageModel != null ? chatController.messageModel.totalSize : null,
                      offset: chatController.messageModel != null ? chatController.messageModel.offset : null,
                      onPaginate: (int offset) async => await chatController.getMessages(
                        offset, widget.notificationBody, widget.user, widget.conversationID,
                      ),
                      productView: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: chatController.messageModel.messages.length,
                        itemBuilder: (context, index) {
                          return MessageBubble(
                            message: chatController.messageModel.messages[index],
                            user: chatController.messageModel.conversation.receiver,
                            userType: widget.notificationBody.adminId != null ? UserType.admin
                                : widget.notificationBody.deliverymanId != null ? UserType.delivery_man : UserType.vendor,
                          );
                        },
                      ),
                    ),
                  ) : Center(child: Container()) : Center(child: CircularProgressIndicator()));
                }),

                (chatController.messageModel != null) ? Container(
                  color: Theme.of(context).cardColor,
                  child: Column(children: [

                    GetBuilder<ChatController>(builder: (chatController) {

                      return chatController.chatImage.length > 0 ? Container(height: 100,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: chatController.chatImage.length,
                            itemBuilder: (BuildContext context, index){
                              return  chatController.chatImage.length > 0 ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(children: [

                                  Container(width: 100, height: 100,
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20))),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT)),
                                      child: Image.memory(
                                        chatController.chatRawImage[index], width: 100, height: 100, fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  Positioned(top:0, right:0,
                                    child: InkWell(
                                      onTap : () => chatController.removeImage(index, _inputMessageController.text.trim()),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.clear, color: Colors.red, size: 15),
                                        ),
                                      ),
                                    ),
                                  )],
                                ),
                              ) : SizedBox();
                            }),
                      ) : SizedBox();
                    }),
                    AnyLinkPreview(

                      link: widget.link,
                      displayDirection: UIDirection.uiDirectionHorizontal,
                      cache: Duration(hours: 1),
                      backgroundColor: Colors.grey[300],
                      errorWidget: SizedBox(),
                      errorImage: _errorImage,
                    ),
                    Row(children: [

                      InkWell(
                        onTap: () async {
                          Get.find<ChatController>().pickImage(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Image.asset(Images.image, width: 25, height: 25, color: Theme.of(context).hintColor),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                        child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                      Expanded(
                        child: TextField(
                          inputFormatters: [LengthLimitingTextInputFormatter(Dimensions.MESSAGE_INPUT_LENGTH)],
                          controller: _inputMessageController,
                          textCapitalization: TextCapitalization.sentences,
                          style: robotoRegular,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,

                          decoration: InputDecoration(
                            border: InputBorder.none,

                            hintText: 'type_here'.tr,
                            hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge),
                          ),
                          onSubmitted: (String newText) {
                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                          onChanged: (String newText) {

                            if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                              Get.find<ChatController>().toggleSendButtonActivity();
                            }
                          },
                        ),
                      ),

                      GetBuilder<ChatController>(builder: (chatController) {
                        return chatController.isLoading ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: SizedBox(height: 25, width: 25, child: CircularProgressIndicator()),
                        ) : InkWell(
                          onTap: () async {

                            // if(chatController.isSendButtonActive ||  widget.estate_id==null) {
                              await chatController.sendMessage(
                                message: _inputMessageController.text, notificationBody: widget.notificationBody,
                                conversationID: widget.conversationID, index: widget.index,estate_id: widget.estate_id
                              );
                              _inputMessageController.clear();
                            // }else {
                            //   showCustomSnackBar('write_something'.tr);
                            // }
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                            child: Image.asset(
                              Images.send, width: 25, height: 25,
                              color: chatController.isSendButtonActive ? Theme.of(context).primaryColor : Theme.of(context).hintColor,
                            ),
                          ),
                        );
                      }
                      ),

                    ]),
                  ]),
                ) : SizedBox(),
              ],
              ),
            ),
          ),
        );
        })

            : NotLoggedInScreen(),
      );
    });
  }

  // void _getMetadata(String url) async {
  //   bool _isValid = _getUrlValid(url);
  //   if (_isValid) {
  //     Metadata _metadata = await AnyLinkPreview.getMetadata(
  //       link: url,
  //       cache: Duration(days: 7),
  //       proxyUrl: "https://cors-anywhere.herokuapp.com/", // Needed for web app
  //     );
  //     debugPrint("URL6 => ${_metadata?.title}");
  //     debugPrint(_metadata?.desc);
  //   } else {
  //     debugPrint("URL is not valid");
  //   }
  // }


  bool _getUrlValid(String url) {
    bool _isUrlValid = AnyLinkPreview.isValidLink(
      url,
      protocols: ['http', 'https'],
      hostWhitelist: ['https://youtube.com/'],
      hostBlacklist: ['https://facebook.com/'],
    );
    return _isUrlValid;
  }

}
