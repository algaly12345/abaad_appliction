import 'package:abaad/util/images.dart';
import 'package:abaad/view/screen/estate/add_estate_screen.dart';
import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 2 ,left: 2),

      decoration:  BoxDecoration(
        color: _item.isSelected
            ?  Color(0xff81b5fc)
            : Colors.transparent,
        border:  Border.all(

            color: _item.isSelected
                ?  Color(0xff81b5fc)
                : Colors.grey),
        borderRadius: const BorderRadius.all(const Radius.circular(2.0)),
      ),
      child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 30.0,
            width: 30.0,
            child: Image.asset(_item.imge),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Text(_item.text),
          )
        ],
      ),
    );
  }
}