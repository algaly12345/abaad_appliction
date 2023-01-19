import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';


class HeaderWidget extends StatelessWidget {
  const HeaderWidget({ this.currentPage});
  final Widget currentPage;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: (){
        //    Push.to(context, const ProfileScreen()
          },
          child: Image.asset(Images.mail, width: 30.0, height: 30.0),
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'موقعك',
              style: robotoRegular.copyWith(color: Colors.grey),
            ),
            const Text(
              'السعودية, جدة',
            ),
          ],
        ),
        const Spacer(),
        Image.asset(Images.mail, width: 30.0, height: 30.0),
      ],
    );
  }
}
