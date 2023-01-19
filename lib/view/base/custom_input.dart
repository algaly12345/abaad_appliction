import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hex_color/flutter_hex_color.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    this.hint,
    this.hintInnerTxt,
    this.isRequired,
    this.validator,
    this.prefixIcon,
    this.controller,
    this.isPutHintTxtInTextFormField,
    this.keyboardType,
    this.onTap,
    this.onChanged,
    this.maxLength,
  });
  //
  final int maxLength;
  final String hint;
  final String hintInnerTxt;
  final bool isRequired;
  final void Function() onTap;
  final void Function(String) onChanged;

  /// when show input only without column
  final bool isPutHintTxtInTextFormField;
  final String Function(String) validator;
  final Widget prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  //
  @override
  Widget build(BuildContext context) {
    if (isPutHintTxtInTextFormField == true) {
      return TextFormField(
        controller: controller,
        validator: validator,
        onTap: onTap,
        onChanged: onChanged,
        maxLength: maxLength,
        decoration: InputDecoration(
          counter: const SizedBox(),

          /// hint
          hintText: hint,
          hintStyle: robotoMedium,
          hintTextDirection: TextDirection.rtl,

          ///
          suffixIcon: prefixIcon,

          /// Border
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .9, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),

          ///
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .5, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          //
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: .8, color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
      );
    }

    ///
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              hint ?? '',
              style: robotoMedium.copyWith(
                fontSize: 14.0,
                color: HexColor('#4D515B'),
              ),
            ),
            const Spacer(),
            if (isRequired == true)
              Text(
                '*',
                style: robotoBold.copyWith(fontSize: 22.0, color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 5.0),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hintInnerTxt,
            hintStyle: robotoRegular,
            counter: const SizedBox(),
            //
            suffixIcon: prefixIcon,
            //
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: .9, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            //
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: .5, color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            //
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: .8, color: Colors.red),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
        ),
      ],
    );
  }
}
