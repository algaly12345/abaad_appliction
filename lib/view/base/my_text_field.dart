import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final int maxLines;
  final bool isPassword;
  final Function onTap;
  final Function onChanged;
  final Function onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final Color fillColor;
  final bool autoFocus;
  final GlobalKey<FormFieldState<String>> key;
  final bool showBorder;
  final double size;

  bool multiLine;

  MyTextField(
      {this.hintText = '',
        required this.controller,
        required this.focusNode,
        required this.nextFocus,
        this.isEnabled = true,
        this.inputType = TextInputType.text,
        this.inputAction = TextInputAction.next,
        this.maxLines = 1,
        required this.onSubmit,
        required this.onChanged,
        this.capitalization = TextCapitalization.none,
        required this.onTap,
        required this.fillColor,
        this.isPassword = false,
        this.autoFocus = false,
        this.showBorder = false,
        required this.size,
        this.multiLine=false,
        required this.key});

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), border: widget.showBorder ? Border.all(color: Theme.of(context).disabledColor) : null),
      child: TextField(
        key: widget.key,
        maxLines: widget.maxLines,
        controller: widget.controller,
        focusNode: widget.focusNode,
        style:TextStyle(fontSize:widget.size),


        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        cursorColor: Theme.of(context).primaryColor,
        textCapitalization: widget.capitalization,
        enabled: widget.isEnabled,
        autofocus: widget.autoFocus,
        //onChanged: widget.isSearch ? widget.languageProvider.searchLanguage : null,
        obscureText: widget.isPassword ? _obscureText : false,
        inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp('[0-9+]'))] : null,
        decoration: InputDecoration(
          hintText: widget.hintText,
          isDense: true,
          filled: true,
          fillColor: widget.fillColor != null ? widget.fillColor : Theme.of(context).cardColor,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), borderSide: BorderSide.none),
          hintStyle: robotoRegular.copyWith(color: Theme.of(context).hintColor),
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
            onPressed: _toggle,
          ) : null,
        ),
        onTap: widget.onTap,
        onSubmitted: (text) => widget.nextFocus != null ? FocusScope.of(context).requestFocus(widget.nextFocus)
            : widget.onSubmit != null ? widget.onSubmit(text) : null,
        onChanged: widget.onChanged,
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
