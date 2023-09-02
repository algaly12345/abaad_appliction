import 'package:abaad/controller/auth_controller.dart';
import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/user_controller.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_button.dart';
import 'package:abaad/view/base/my_text_field.dart';
import 'package:abaad/view/base/not_logged_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReportWidget extends StatefulWidget {
  final int estate_id;
  const ReportWidget({Key key ,@required this.estate_id}) : super(key: key);

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _longDescController = TextEditingController();
  final FocusNode _longDescFocus = FocusNode();
  bool _isLoggedIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.find<EstateController>().setReportIndex(Get
        .find<EstateController>()
        .reportList[0], false);


    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if(_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  String _documentTypeValue;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EstateController>(builder: (estateController) {
      final isLoading = estateController.isLoading2.value;



      return AlertDialog(
      title: Text('report_the_ad'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'document_type'.tr,
            style: robotoRegular.copyWith(
                fontSize: Dimensions.fontSizeSmall),
          ),
          const SizedBox(
              height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          Container(
            padding:  const EdgeInsets.symmetric(
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
                'place_wrong'.tr,
                'contradicting_the_terms_o_the_real_estate_authority'.tr,
                'another_reason'.tr,
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(
                      color: Colors.black),),
                );
              }).toList(),
              hint: Text(
                "please_select_reason".tr,
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

          SizedBox(height: 8),
          MyTextField(
            hintText: 'text_of_the_communication'.tr,
            controller: _longDescController,
            focusNode: _longDescFocus,
            // nextFocus: _vatFocus,
            size: 17,

            maxLines: 4,
            inputType: TextInputType.text,
            capitalization: TextCapitalization.sentences,
            showBorder: true,
          ),
        ],
      ),
      actions: [
        !estateController.isLoading ?  CustomButton(

          onPressed:  ()
          {
            final title = _documentTypeValue;
            final description = _longDescController.text;
            final estateId =  44;
            estateController.insertEstate(title, description, estateId,context);
        //    Navigator.pop(context);
          },
          buttonText: 'send'.tr,
        ): Center(child: CircularProgressIndicator()),
      ],
    );  });
  }


  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

}
