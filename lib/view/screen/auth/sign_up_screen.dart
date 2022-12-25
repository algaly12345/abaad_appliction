import 'dart:convert';
import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/body/signup_body.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/web_menu_bar.dart';
import 'package:country_code_picker/country_code.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

import 'widget/code_picker_widget.dart';
import 'widget/condition_check_box.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  // final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();

    _countryDialCode = CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : null,
      body: SafeArea(child: Scrollbar(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          physics: BouncingScrollPhysics(),
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

                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Image.asset(Images.logo, width: 100),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                  Image.asset(Images.logo_name, width: 100),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                  Text('sign_up'.tr.toUpperCase(), style: robotoBlack.copyWith(fontSize: 20)),
                  SizedBox(height: 30),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                    ),
                    child: Column(children: [

                      CustomTextField(
                        hintText: 'full_name'.tr,
                        controller: _fullNameController,
                        focusNode: _firstNameFocus,
                        nextFocus: _emailFocus,
                        inputType: TextInputType.name,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.full_name,
                        divider: true,
                      ),

                      // CustomTextField(
                      //   hintText: 'last_name'.tr,
                      //   controller: _lastNameController,
                      //   focusNode: _lastNameFocus,
                      //   nextFocus: _emailFocus,
                      //   inputType: TextInputType.name,
                      //   capitalization: TextCapitalization.words,
                      //   prefixIcon: Images.mail,
                      //   divider: true,
                      // ),

                      CustomTextField(
                        hintText: 'email'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _phoneFocus,
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Images.mail,
                        divider: true,
                      ),

                      Row(children: [
                        CodePickerWidget(
                          onChanged: (CountryCode countryCode) {
                            _countryDialCode = countryCode.dialCode;
                          },
                          initialSelection: CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code,
                          favorite: [CountryCode.fromCountryCode(Get.find<SplashController>().configModel.country).code],
                          showDropDownButton: true,
                          padding: EdgeInsets.zero,
                          showFlagMain: true,
                          dialogBackgroundColor: Theme.of(context).cardColor,
                          textStyle: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color,
                          ),
                        ),
                        Expanded(child: CustomTextField(
                          hintText: 'phone'.tr,
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
                      //   nextFocus: _confirmPasswordFocus,
                      //   inputType: TextInputType.visiblePassword,
                      //   prefixIcon: Images.lock,
                      //   isPassword: true,
                      //   divider: true,
                      // ),
                      //
                      // CustomTextField(
                      //   hintText: 'confirm_password'.tr,
                      //   controller: _confirmPasswordController,
                      //   focusNode: _confirmPasswordFocus,
                      //   nextFocus: Get.find<SplashController>().configModel.refEarningStatus == 1 ? _referCodeFocus : null,
                      //   inputAction: Get.find<SplashController>().configModel.refEarningStatus == 1 ? TextInputAction.next : TextInputAction.done,
                      //   inputType: TextInputType.visiblePassword,
                      //   prefixIcon: Images.lock,
                      //   isPassword: true,
                      //   divider: Get.find<SplashController>().configModel.refEarningStatus == 1 ? true : false,
                      //   onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms) ? _register(authController, _countryDialCode) : null,
                      // ),

                       CustomTextField(
                        hintText: 'refer_code'.tr,
                        controller: _referCodeController,
                        focusNode: _referCodeFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.text,
                        capitalization: TextCapitalization.words,
                        prefixIcon: Images.arabic,
                        divider: false,
                        prefixSize: 14,
                      ),

                    ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  ConditionCheckBox(authController: authController),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  !authController.isLoading ? Row(children: [
                    Expanded(child: CustomButton(
                      buttonText: 'sign_in'.tr,
                      transparent: true,
                      onPressed: () =>Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.signUp)),
                    )),
                    Expanded(child: CustomButton(
                      buttonText: 'sign_up'.tr,
                      onPressed: authController.acceptTerms ? () => _register(authController, _countryDialCode) : null,
                    )),
                  ]) : Center(child: CircularProgressIndicator()),
                  SizedBox(height: 30),

                  // SocialLoginWidget(),


                ]);
              }),
            ),
          ),
        ),
      )),
    );
  }

  void _register(AuthController authController, String countryCode) async {
    String _fullName = _fullNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    // String _password = _passwordController.text.trim();
    // String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();

    String _numberWithCountryCode = countryCode+_number;
    bool _isValid = GetPlatform.isWeb ? true : false;
    if(!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber = await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode = '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_fullName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    }else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    }else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    }else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    }
    // else if (_password.isEmpty) {
    //   showCustomSnackBar('enter_password'.tr);
    // }else if (_password.length < 6) {
    //   showCustomSnackBar('password_should_be'.tr);
    // }else if (_password != _confirmPassword) {
    //   showCustomSnackBar('confirm_password_does_not_matched'.tr);
    // }
    else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    }else {
      SignUpBody signUpBody = SignUpBody(
        fName: _fullName, email: _email, phone: _numberWithCountryCode, password: "123456789",
        refCode: _referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if(Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode("1234567");
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode, status.message, RouteHelper.signUp, _data));
          }else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
