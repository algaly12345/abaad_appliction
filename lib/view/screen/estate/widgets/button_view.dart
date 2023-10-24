import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

import 'estate_view.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(4.0),
      decoration:  BoxDecoration(
        color: _item.isSelected
            ?  Theme.of(context).primaryColor
            : Colors.transparent,
        border:  Border.all(
            width: 1.0,
            color: _item.isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey),
        borderRadius: const BorderRadius.all(const Radius.circular(5.0)),
      ),
      margin:  EdgeInsets.all(2.0),
      child:  Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[

           Container(

            child:  Text(_item.buttonText,style: robotoBlack.copyWith(fontSize: 13, color: _item.isSelected
                ? Theme.of(context).backgroundColor
                : Colors.grey)),
          ),
          Container(
            height: 50.0,
            width: 50.0,

            child:  Center(
              child:  Image.asset(_item.text,height: 24,width: 24),
            ),
          ),
        ],
      ),
    );
  }
}