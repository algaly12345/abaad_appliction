import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    Key key,
     this.label,
    this.roundness = 8.0,
    this.btnColor,
    this.fontWeight = FontWeight.bold,
    this.padding = const EdgeInsets.symmetric(vertical: 24),
    this.trailingWidget,
    this.titleColor,
     this.onPressed,
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
      width: 180.0,
      height: 60.0,
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
                  const SizedBox(width: 10.0),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: robotoMedium.copyWith(fontSize: 16.0),
                  ),
                ],
              ),
      ),
    );
  }
}