import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key? key,
     required this.label,
    this.roundness = 8.0,
    required this.btnColor,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(vertical: 5),
    required this.trailingWidget,
    required this.titleColor,
     required this.onPressed,
  }) : super(key: key);

  ///
  final String label;
  final double roundness;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final Widget trailingWidget;
  final void Function() onPressed;
  final Color btnColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130.0,
      height: 40.0,
      child: MaterialButton(
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundness),
        ),
        color: btnColor ?? Theme.of(context).primaryColor,
        textColor: titleColor ?? Colors.white,
        elevation: 0.0,
        padding: padding,
        onPressed: onPressed,
        //   child: Text(
        //     label,
        //     textAlign: TextAlign.center,
        //     style: robotoRegular.copyWith(fontSize: 14.0),
        //   ),
        // )
        child: trailingWidget == null
            ? Text(
                label,
                textAlign: TextAlign.center,
                style: robotoMedium.copyWith(fontSize: 16.0),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  trailingWidget ?? const SizedBox(),
                  const SizedBox(width: 20.0),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style:robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ),
                ],
              ),
      ),
    );
  }
}
