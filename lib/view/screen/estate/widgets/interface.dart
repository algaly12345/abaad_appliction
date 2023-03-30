import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/styles.dart';
import 'package:clipboard/clipboard.dart';

import 'package:flutter/material.dart';
class InterfaceItem extends StatelessWidget {
  final Estate estate;
  final List<Interface> restaurants;
  const InterfaceItem({Key key,this.estate ,this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = restaurants == null;
    if(!_isNull) {
      _length = restaurants.length;
    return
      !_isNull ? _length > 0 ?Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).backgroundColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0.5), // changes position of shadow
          ),

        ],

      ),
      child: Row(

        children: [
          Expanded(child: Container(
              padding: EdgeInsets.all(10),child:  Text(" الواجهة"))),
          VerticalDivider(width: 1.0),
          Expanded(child: Container(
              padding: EdgeInsets.all(10),child:  Container(
            height: 30,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: estate.interface .length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    children: [
                      Text(
                        "${estate.interface[index].name}",
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ), )// replace with your text
                    ],
                  ),
                );
              },
            ),
          ))),
        ],
      ),
    ):Text("not data"):Text("looding");
  }
}}
