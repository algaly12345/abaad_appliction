import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

import 'estate_view.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration:  BoxDecoration(
        color: _item.isSelected
            ?  Theme.of(context).primaryColor
            : Colors.transparent,
        border:  Border.all(
            width: 1.0,
            color: _item.isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey),
        borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
      ),
      margin:  EdgeInsets.all(5.0),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
           Container(
            height: 50.0,
            width: 50.0,

            child:  Center(
              child:  Image.asset(_item.text,height: 24,width: 24),
            ),
          ),
           Container(
            margin: new EdgeInsets.only(left: 10.0),
            child:  Text(_item.buttonText,style: robotoBlack.copyWith(fontSize: 11, color: _item.isSelected
                ? Theme.of(context).backgroundColor
                : Colors.grey)),
          )
        ],
      ),
    );
  }
}