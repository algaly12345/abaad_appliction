import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/data/model/response/userinfo_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';

class AgentRegistrationScreen extends StatefulWidget {
  @override
  State<AgentRegistrationScreen> createState() => _AgentRegistrationScreenState();
}

class _AgentRegistrationScreenState extends State<AgentRegistrationScreen> {
  final TextEditingController _advertiserNoController = TextEditingController();

  final TextEditingController _identityNumberController = TextEditingController();
  final FocusNode _advertiserNoNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String _documentTypeValue;
  String _membershipType;
  bool _isLoggedIn;


  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().setIdentityTypeIndex(Get
        .find<AuthController>()
        .identityTypeList[0], false);
    Get.find<AuthController>().setDMTypeIndex(Get
        .find<AuthController>()
        .dmTypeList[0], false);
    Get.find<AuthController>().getZoneList();

    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'complete_the_data'.tr),
      body: GetBuilder<AuthController>(builder: (authController) {
    return  GetBuilder<UserController>(builder: (userController) {
    return (_isLoggedIn && userController.userInfoModel == null) ? Center(child: CircularProgressIndicator()) :
    userController.userInfoModel.userType=="agent" ? Column(children: [

          Expanded(child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: BouncingScrollPhysics(),
            child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, children: [

                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'document_type'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_SMALL),
                          decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .cardColor,
                            borderRadius: BorderRadius.circular(
                                Dimensions.RADIUS_SMALL),
                            boxShadow: [
                              BoxShadow(color: Colors.grey[Get.isDarkMode
                                  ? 800
                                  : 200],
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 5))
                            ],
                          ),
                          child: DropdownButton<String>(
                            focusColor: Colors.white,
                            value: _documentTypeValue,
                            isExpanded: true,
                            underline: SizedBox(),
                            //elevation: 5,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeLarge,
                                color: Colors.black),
                            iconEnabledColor: Colors.black,
                            items: <String>[
                              'هوية وطنية',
                              'سجل تجاري',
                              'هوية وطنية '
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: const TextStyle(
                                    color: Colors.black),),
                              );
                            }).toList(),
                            hint: Text(
                              "select_document_type".tr,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge,
                                  color: Colors.black),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _documentTypeValue = value;
                              });
                            },
                          ),
                        ),
                      ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  _documentTypeValue != "سجل تجاري" ? Container() : Row(children: [
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'membership_type'.tr,
                            style: robotoRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .cardColor,
                              borderRadius: BorderRadius.circular(
                                  Dimensions.RADIUS_SMALL),
                              boxShadow: [
                                BoxShadow(color: Colors.grey[Get.isDarkMode
                                    ? 800
                                    : 200],
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 5))
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: authController.dmTypeList[authController
                                  .dmTypeIndex],
                              items: authController.dmTypeList.map((
                                  String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.tr),
                                );
                              }).toList(),
                              onChanged: (value) {
                                authController.setDMTypeIndex(value, true);
                                _membershipType=value;
                              },
                              isExpanded: true,
                              underline: SizedBox(),
                            ),
                          ),
                        ])),

                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  Row(children: [


                    Expanded(child: Material(

                      child: CustomTextField(
                        hintText: _documentTypeValue == "سجل تجاري"
                            ? 'commercial_registration_no'.tr
                            : 'id_number'.tr,
                        controller: _identityNumberController,
                        focusNode: _identityNumberNode,
                        nextFocus: _advertiserNoNode,
                        inputAction: TextInputAction.done,
                        showTitle: true,
                        boarder: true,

                      ),
                    )),


                  ]),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  CustomTextField(
                    hintText: 'advertiser_no'.tr,
                    controller: _advertiserNoController,
                    focusNode: _advertiserNoNode,
                    inputType: TextInputType.emailAddress,
                    showTitle: true,
                    boarder: true,
                  ),

                ]))),
          )),

          !authController.isLoading ? CustomButton(
            buttonText: 'save'.tr,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            height: 50,
            onPressed: () => _addAgent(authController),
          ) : Center(child: CircularProgressIndicator()),

        ]):Center(child: Text("تواصل مع الدعم الفني"),);
      });
      }),
    );
  }

  void _addAgent(AuthController authController) async {
    String _advertiser = _advertiserNoController.text.trim();
    String _identityNumber = _identityNumberController.text.trim();


     if (_advertiser.isEmpty) {
      showCustomSnackBar('ادخل رقم المعلن'.tr);
    }  else if (_identityNumber.isEmpty) {
       _documentTypeValue!="سجل تجاري"?showCustomSnackBar('ادخل رقم الهوية'.tr):showCustomSnackBar('ادخل رقم السجل التجاري'.tr);
    } else if(_advertiser.length < 6) {
       showCustomSnackBar('رقم المعلن اقل من 6 ارقام'.tr);
    } else {
       showCustomSnackBar("---------------$_membershipType");
      authController.registerAgent(Userinfo(membershipType: _membershipType==null?"فرد":_membershipType,
          commercialRegisterionNo: _identityNumber,
          identityType: _documentTypeValue,
          identity: _advertiser,advertiserNo: _advertiser));
    }
  }
}
