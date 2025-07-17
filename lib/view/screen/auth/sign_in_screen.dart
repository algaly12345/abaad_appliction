import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/localization_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:abaad/view/screen/auth/widget/guest_button.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import 'widget/code_picker_widget.dart';
import 'widget/condition_check_box.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  SignInScreen({required this.exitFromApp});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
        : CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
    _phoneController.text =  Get.find<AuthController>().getUserNumber() ?? '';
    _passwordController.text = Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(widget.exitFromApp) {
          if (_canExit) {
            if (GetPlatform.isAndroid) {
              SystemNavigator.pop();
            } else if (GetPlatform.isIOS) {
              exit(0);
            } else {
              Navigator.pushNamed(context, RouteHelper.getAccessLocationRoute('verification'));
            }
            return Future.value(false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr, style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return Future.value(false);
          }
        }else {
          return true;
        }
      },
      child: Scaffold(
        appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : !widget.exitFromApp ? AppBar(leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyText1.color),
        ), elevation: 0, backgroundColor: Colors.transparent) : null,
        body: SafeArea(child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Center(
                child: Container(
                  width: context.width > 700 ? 700 : context.width,
                  padding: context.width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                  decoration: context.width > 700 ? BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                  ) : null,
                  child: GetBuilder<AuthController>(builder: (authController) {

                    return Column(children: [
                      const SizedBox(height: Dimensions.PADDING_SIZE_OVER_LARGE),
                      Image.asset(Images.logo, width: 200),
                      // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // Image.asset(Images.logo_name, width: 100),


                      // Text('sign_in'.tr.toUpperCase(), style: robotoBlack.copyWith(fontSize: 30)),
                      SizedBox(height: 50),

                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Theme.of(context).cardColor,
                            boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                          ),
                          child: Column(children: [

                            Row(children: [
                              CodePickerWidget(
                                onChanged: (CountryCode countryCode) {
                                  _countryDialCode = countryCode.dialCode;
                                },
                                initialSelection: _countryDialCode != null ? Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
                                    : CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code : Get.find<LocalizationController>().locale.countryCode,
                                favorite: [Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
                                    : CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code],
                                showDropDownButton: true,
                                padding: EdgeInsets.zero,
                                showFlagMain: true,
                                flagWidth: 25,
                                dialogBackgroundColor: Theme.of(context).cardColor,
                                textStyle: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color,
                                ),
                              ),
                              Expanded(flex: 1, child: CustomTextField(
                                hintText: '500000000',
                                controller: _phoneController,
                                focusNode: _phoneFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.phone,
                                divider: false,
                              )),
                            ]),
                            Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE), child: Divider(height: 1)),

                            // CustomTextField(
                            //   hintText: 'password'.tr,
                            //   controller: _passwordController,
                            //   focusNode: _passwordFocus,
                            //   inputAction: TextInputAction.done,
                            //   inputType: TextInputType.visiblePassword,
                            //   prefixIcon: Images.lock,
                            //   isPassword: true,
                            //   onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms)
                            //       ? _login(authController, _countryDialCode) : null,
                            // ),

                          ]),
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      ConditionCheckBox(authController: authController),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                      !authController.isLoading ? Row(children: [
                        Expanded(child: CustomButton(
                          buttonText: 'sign_in'.tr,
                          onPressed: authController.acceptTerms ? () => _login(authController, _countryDialCode) : null,
                        )),
                      ]) : Center(child: CircularProgressIndicator()),



                   Row(children: [
                        Expanded(child: CustomButton(
                          buttonText: 'sign_up'.tr,
                          transparent: true,
                          onPressed: () => Get.toNamed(RouteHelper.getSignUpRoute()),
                        )),
                      ]),



                    const   GuestButton(),

                      // SocialLoginWidget(),


                    ]);
                  }),
                ),
              ),
            ),
          ),
        )),
      ),
    );
  }
  void _login(AuthController authController, String countryDialCode) async {
    String _phone = _phoneController.text.trim();
    // String _password = _passwordController.text.trim();
    String _numberWithCountryCode = countryDialCode+_phone;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;  
      } catch (e) {}
    }
    if (_phone.isEmpty) {
      showCustomSnackBar('enter phone number'.tr);
    }
    // else if (!_isValid) {
    //   showCustomSnackBar('invalid phone number'.tr);
    // }
    else {
      authController.login(_numberWithCountryCode, "1234567").then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(_phone, "1234567", countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          String _token = status.message.substring(1, status.message.length);
            List<int> _encoded = utf8.encode("1234567");
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode, _token, RouteHelper.signUp, _data));

        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
