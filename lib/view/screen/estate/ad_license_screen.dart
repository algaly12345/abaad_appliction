import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/storage_service.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_app_bar.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/custom_snackbar.dart';
import 'package:abaad/view/base/custom_text_field.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class   AdLicenseScreen extends StatefulWidget {


  @override
  State<AdLicenseScreen> createState() => _AdLicenseScreenState();
}

class _AdLicenseScreenState extends State<AdLicenseScreen> {



  final TextEditingController _numberLicenseController = TextEditingController();



  final TextEditingController _idNumberController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'add_ads'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: GetBuilder<AuthController>(builder: (authController) {
          return  GetBuilder<UserController>(builder: (userController) {
            if(userController.userInfoModel != null && _idNumberController.text.isEmpty) {
              _idNumberController.text = userController.userInfoModel.agent.identity ?? '';

            }
          return   GetBuilder<EstateController>(builder: (estateController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  Text(
                    'رقم الترخيص',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  // حقل إدخال رقم الترخيص
                  MyTextField(
                    hintText: 'ادخل رقم الترخيص',
                    controller: _numberLicenseController,
                    inputType: TextInputType.phone,
                    showBorder: true,
                    isEnabled: true,
                  ),

                  SizedBox(height: 20),
                  Text(
                    'هوية المعلن',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  MyTextField(
                    hintText: 'ادخل رقم المعلن',
                    controller: _idNumberController, // تأكد من تعريف هذا المتغير
                    inputType: TextInputType.phone,
                    showBorder: true,
                    isEnabled: true,
                  ),

                  SizedBox(height: 20),
                  // دروب داون لست لخياري "منشأة" و"فرد"
                  Text(
                    'نوع المعلن',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                  DropdownButtonFormField<String>(
                    value: estateController.advertiserType == 1
                        ? 'فرد'
                        : estateController.advertiserType == 2
                        ? 'منشأة'
                        : null, // القيمة الافتراضية
                    items: [
                      DropdownMenuItem(
                        value: 'فرد',
                        child: Text('فرد'),
                      ),
                      DropdownMenuItem(
                        value: 'منشأة',
                        child: Text('منشأة'),
                      ),
                    ],
                    onChanged: (value) {
                      estateController.setAdvertiserType(value!); // تحديث القيمة بناءً على الاختيار
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // زر التالي
                  !estateController.isLoading
                      ? CustomButton(
              buttonText: 'التالي',
              onPressed: () async {
              String _numberLicense = _numberLicenseController.text.trim();

              String _advertiserNumber = _idNumberController.text.trim();
              final advertiserType = estateController.advertiserType;
              print(advertiserType); // يطبع 1 أو 2 بناءً على اختيار المستخدم

              if (_numberLicense.isEmpty) {
              showCustomSnackBar('ادخل رقم الترخيص');
              } else {
              bool isSuccess = await estateController.verifyLicense(_numberLicense,_advertiserNumber,advertiserType);

              if (isSuccess) {
               showCustomSnackBar('تم التحقق من رقم الترخيص بنجاح!', isError: false);

               // حفظ البيانات باستخدام SharedPreferences
               final prefs = await SharedPreferences.getInstance();
               final data = estateController.licenseData; // البيانات من API
               await prefs.setString('advertiserId', data['advertiserId'].toString());
               await prefs.setString('advertiserName', data['advertiserName']);
               await prefs.setString('phoneNumber', data['phoneNumber']);
               await prefs.setInt('advertiserType', estateController.advertiserType);


               // حفظ القيم المطلوبة أيضًا
               await prefs.setString('numberLicense', _numberLicense);
               await prefs.setString('advertiserNumber', _advertiserNumber);
               await prefs.setInt('advertiserTypeInput', advertiserType); // هذا المدخل من المستخدم



              // الانتقال إلى صفحة إضافة العقار
              Get.toNamed(RouteHelper.getAddEstateRoute());
              // يمكنك إضافة المزيد من الحقول حسب الحاجة

              // الانتقال إلى الشاشة التالية إذا لزم الأمر
              } else {
              showCustomSnackBar('فشل التحقق من رقم الترخيص');
              }
              }
              },
              )

                  : Center(child: CircularProgressIndicator()),
                ],
              );
            });
          });
        }))),
      ),
    );
  }
}
