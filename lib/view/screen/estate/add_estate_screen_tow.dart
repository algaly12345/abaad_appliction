import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/category_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/route_helper.dart';

import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/screen/auth/widget/registration_stepper_widget.dart';
import 'package:abaad/view/screen/auth/widget/select_location_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class AddEstateScreenTow extends StatefulWidget {
  @override
  State<AddEstateScreenTow> createState() => _AddEstateScreenState();
}

class _AddEstateScreenState extends State<AddEstateScreenTow> {
  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _vatController = TextEditingController();

  final TextEditingController _minTimeController = TextEditingController();

  final TextEditingController _maxTimeController = TextEditingController();

  final TextEditingController _fNameController = TextEditingController();

  final TextEditingController _lNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();

  final FocusNode _priceFocus = FocusNode();

  final FocusNode _addressFocus = FocusNode();

  final FocusNode _vatFocus = FocusNode();

  final FocusNode _minTimeFocus = FocusNode();

  final FocusNode _maxTimeFocus = FocusNode();

  final FocusNode _fNameFocus = FocusNode();

  final FocusNode _lNameFocus = FocusNode();

  final FocusNode _phoneFocus = FocusNode();

  final FocusNode _emailFocus = FocusNode();

  final FocusNode _passwordFocus = FocusNode();

  final FocusNode _confirmPasswordFocus = FocusNode();
  var isSelected1 = [false, true];
  var isSelected2 = [false, true];

  int _value = 0;
  @override
  void initState() {
    super.initState();

    Get.find<AuthController>().getZoneList();
    if(Get.find<CategoryController>().categoryList == null) {
      Get.find<CategoryController>().getCategoryList(true);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'add_ads'.tr),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: GetBuilder<AuthController>(builder: (authController) {
          return
          GetBuilder<EstateController>(builder: (restController) {
           return  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             const Center(
               child: SizedBox(
                 width: Dimensions.WEB_MAX_WIDTH,
                 child: RegistrationStepperWidget(status: '1'),
               ),
             ),
            Column(
           crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ad_typ".tr,style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).hintColor),),
                SizedBox(height: 7),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(// Place `Expanded` inside `Row`
                      child: InkWell(
                        onTap: (){
                          setState(() => _value = 0);
                        },
                        child: Container(
                          height: 39,
                          decoration: BoxDecoration(
                              color: _value == 0 ? Theme.of(context).secondaryHeaderColor : Colors.transparent,
                              border: Border.all(width: 1,color: Colors.blue[500],),
                              borderRadius: BorderRadius.circular(2,)
                          ),

                            child: Center(child: Text('for_rent'.tr,style: robotoBlack.copyWith(fontSize: 16,color:  _value == 0 ? Colors.white : Colors.blue),)),


                        ),
                      ),
                    ),
                    SizedBox(width: 3,),
                    Expanded( // Place 2 `Expanded` mean: they try to get maximum size and they will have same size
                      child: InkWell(
                        onTap: (){
                        setState(() => _value = 1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color:_value == 1 ? Theme.of(context).secondaryHeaderColor : Colors.transparent,
                              border: Border.all(width: 1,color: Colors.blue[500],),
                              borderRadius: BorderRadius.circular(2,)
                          ),
                          height: 39,
                         // color: _value == 1 ? Colors.grey : Colors.transparent,
                            child: Center(child: Text('for_sell'.tr,style:  robotoBlack.copyWith(fontSize: 16,color:  _value == 1 ? Colors.white : Colors.blue),)),


                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),




            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

             Text(
               'add_photo_estate'.tr,
               style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
             ),
             SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
             SizedBox(
               height: 120,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                 physics: BouncingScrollPhysics(),
                 itemCount: authController.pickedIdentities.length+1,
                 itemBuilder: (context, index) {
                   XFile _file = index == authController.pickedIdentities.length ? null : authController.pickedIdentities[index];
                   if(index == authController.pickedIdentities.length) {
                     return InkWell(
                       onTap: () => authController.pickDmImage(false, false),
                       child: Container(
                         height: 299, width: 200, alignment: Alignment.center, decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                         border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                       ),
                         child: Container(
                           padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                           decoration: BoxDecoration(
                             border: Border.all(width: 2, color: Theme.of(context).primaryColor),
                             shape: BoxShape.circle,
                           ),
                           child: Icon(Icons.camera_alt, color: Theme.of(context).primaryColor),
                         ),
                       ),
                     );
                   }
                   return Container(
                     margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                     decoration: BoxDecoration(
                       border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                       borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                     ),
                     child: Stack(children: [
                       ClipRRect(
                         borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                         child: GetPlatform.isWeb ? Image.network(
                           _file.path, width: 150, height: 120, fit: BoxFit.cover,
                         ) : Image.file(
                           File(_file.path), width: 150, height: 120, fit: BoxFit.cover,
                         ),
                       ),
                       Positioned(
                         right: 0, top: 0,
                         child: InkWell(
                           onTap: () => authController.removeIdentityImage(index),
                           child: Padding(
                             padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                             child: Icon(Icons.delete_forever, color: Colors.red),
                           ),
                         ),
                       ),
                     ]),
                   );
                 },
               ),
             ),

            CustomTextField(
              hintText: 'وصف مختصر',
              controller: _addressController,
              focusNode: _addressFocus,
              nextFocus: _vatFocus,
              inputType: TextInputType.text,
              capitalization: TextCapitalization.sentences,
              maxLines: 3,
              showTitle: true,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            Text(
              'إرفاق المخطط',
              style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                child: authController.pickedCover != null ? GetPlatform.isWeb ? Image.network(
                  authController.pickedCover.path, width: context.width, height: 170, fit: BoxFit.cover,
                ) : Image.file(
                  File(authController.pickedCover.path), width: context.width, height: 170, fit: BoxFit.cover,
                ) : Image.asset(
                  Images.placeholder, width: context.width, height: 170, fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0, right: 0, top: 0, left: 0,
                child: InkWell(
                  onTap: () => authController.pickImage(false, false),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.white),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt, color: Colors.white, size: 50),
                    ),
                  ),
                ),
              ),
            ]),

             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

             SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            // Center(child: Text(
            //   'owner_information'.tr,
            //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            // )),
            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            //
            // Row(children: [
            //   Expanded(child: CustomTextField(
            //     hintText: 'first_name'.tr,
            //     controller: _fNameController,
            //     focusNode: _fNameFocus,
            //     nextFocus: _lNameFocus,
            //     inputType: TextInputType.name,
            //     capitalization: TextCapitalization.words,
            //     showTitle: true,
            //   )),
            //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            //   Expanded(child: CustomTextField(
            //     hintText: 'last_name'.tr,
            //     controller: _lNameController,
            //     focusNode: _lNameFocus,
            //     nextFocus: _phoneFocus,
            //     inputType: TextInputType.name,
            //     capitalization: TextCapitalization.words,
            //     showTitle: true,
            //   )),
            // ]),
            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            //
            // CustomTextField(
            //   hintText: 'phone'.tr,
            //   controller: _phoneController,
            //   focusNode: _phoneFocus,
            //   nextFocus: _emailFocus,
            //   inputType: TextInputType.phone,
            //   showTitle: true,
            // ),
            // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            //
            // Center(child: Text(
            //   'login_information'.tr,
            //   style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
            // )),
            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            //
            // CustomTextField(
            //   hintText: 'email'.tr,
            //   controller: _emailController,
            //   focusNode: _emailFocus,
            //   nextFocus: _passwordFocus,
            //   inputType: TextInputType.emailAddress,
            //   showTitle: true,
            // ),
            // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            //
            // Row(children: [
            //   Expanded(child: CustomTextField(
            //     hintText: 'password'.tr,
            //     controller: _passwordController,
            //     focusNode: _passwordFocus,
            //     nextFocus: _confirmPasswordFocus,
            //     inputType: TextInputType.visiblePassword,
            //     isPassword: true,
            //     showTitle: true,
            //   )),
            //   SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            //   Expanded(child: CustomTextField(
            //     hintText: 'confirm_password'.tr,
            //     controller: _confirmPasswordController,
            //     focusNode: _confirmPasswordFocus,
            //     inputType: TextInputType.visiblePassword,
            //     isPassword: true,
            //     showTitle: true,
            //   )),
            // ]),
            // SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            //
            //  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

             !restController.isLoading ? CustomButton(
               buttonText: 'التالي',
               onPressed: () {
                 Get.offAllNamed(RouteHelper.getBusinessPlanRoute(1));

                //  String _address = _addressController.text.trim();
                //  String _vat = _vatController.text.trim();
                //  String _minTime = _minTimeController.text.trim();
                //  String _maxTime = _maxTimeController.text.trim();
                //  String _fName = _fNameController.text.trim();
                //  String _lName = _lNameController.text.trim();
                //  String _phone = _phoneController.text.trim();
                //  String _email = _emailController.text.trim();
                //  String _password = _passwordController.text.trim();
                //  String _confirmPassword = _confirmPasswordController.text.trim();
                // if(_address.isEmpty) {
                //    showCustomSnackBar('enter_restaurant_address'.tr);
                //  }else if(_vat.isEmpty) {
                //    showCustomSnackBar('enter_vat_amount'.tr);
                //  }else if(_minTime.isEmpty) {
                //    showCustomSnackBar('enter_minimum_delivery_time'.tr);
                //  }else if(_maxTime.isEmpty) {
                //    showCustomSnackBar('enter_maximum_delivery_time'.tr);
                //  }else if(double.parse(_minTime) > double.parse(_maxTime)) {
                //    showCustomSnackBar('maximum_delivery_time_can_not_be_smaller_then_minimum_delivery_time'.tr);
                //  }else if(authController.pickedLogo == null) {
                //    showCustomSnackBar('select_restaurant_logo'.tr);
                //  }else if(authController.pickedCover == null) {
                //    showCustomSnackBar('select_restaurant_cover_photo'.tr);
                //  }else if(authController.restaurantLocation == null) {
                //    showCustomSnackBar('set_restaurant_location'.tr);
                //  }else if(_fName.isEmpty) {
                //    showCustomSnackBar('enter_your_first_name'.tr);
                //  }else if(_lName.isEmpty) {
                //    showCustomSnackBar('enter_your_last_name'.tr);
                //  }else if(_phone.isEmpty) {
                //    showCustomSnackBar('enter_phone_number'.tr);
                //  }else if(_email.isEmpty) {
                //    showCustomSnackBar('enter_email_address'.tr);
                //  }else if(!GetUtils.isEmail(_email)) {
                //    showCustomSnackBar('enter_a_valid_email_address'.tr);
                //  }else if(_password.isEmpty) {
                //    showCustomSnackBar('enter_password'.tr);
                //  }else if(_password.length < 6) {
                //    showCustomSnackBar('password_should_be'.tr);
                //  }else if(_password != _confirmPassword) {
                //    showCustomSnackBar('confirm_password_does_not_matched'.tr);
                //  }else {
                //  restController.registerRestaurant(Estate(address:"address",space:"space",categoryId:1,price:22,plannedNumber:"343434"));
                //
                //  }
               },
             ) : Center(child: CircularProgressIndicator()),

          ]);
          });
        }))),
      ),
    );
  }
}
