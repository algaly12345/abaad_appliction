import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestButton extends StatelessWidget {
  const GuestButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(1, 40),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, RouteHelper.getInitialRoute());
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'الدخول '.tr} ', style: robotoRegular.copyWith(color: Theme.of(context).disabledColor)),
        TextSpan(text: 'كزائر'.tr, style: robotoMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge.color)),
      ])),
    );
  }
}
