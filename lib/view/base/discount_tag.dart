import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

class DiscountTag extends StatelessWidget {
  final double discount;
  final String discountType;
  final double fromTop;
  final double fontSize;
  final bool inLeft;
  final bool freeDelivery;
  DiscountTag({
    required this.discount, required this.discountType, this.fromTop = 10, this.fontSize, this.freeDelivery = false,
    this.inLeft = true,
  });

  @override
  Widget build(BuildContext context) {
    return (discount > 0 || freeDelivery) ? Positioned(
      top: fromTop, left: inLeft ? 0 : null, right: inLeft ? null : 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(inLeft ? Dimensions.RADIUS_SMALL : 0),
            left: Radius.circular(inLeft ? 0 : Dimensions.RADIUS_SMALL),
          ),
        ),
        child: Text(
         'percent'  ,
          style: robotoMedium.copyWith(
            color: Colors.white,
            fontSize: fontSize != null ? fontSize : ResponsiveHelper.isMobile(context) ? 8 : 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ) : SizedBox();
  }
}
