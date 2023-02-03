import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isButtonActive;
  final Function onTap;
  ProfileButton({@required this.icon, @required this.title, @required this.onTap, this.isButtonActive});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_SMALL,
          vertical: isButtonActive != null ? Dimensions.PADDING_SIZE_EXTRA_SMALL : Dimensions.PADDING_SIZE_DEFAULT,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
          boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
        ),
        child: Row(children: [
          Icon(icon, size: 25),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
          Expanded(child: Text(title, style: robotoRegular)),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: Icon(Icons.arrow_back_ios_new ,size: 20,),
          ),
        ]),
      ),
    );
  }
}
