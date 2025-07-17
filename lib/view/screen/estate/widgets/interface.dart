import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/util/styles.dart';

import 'package:flutter/material.dart';
class InterfaceItem extends StatelessWidget {
  final Estate estate;
  final List<Interface> restaurants;
  const InterfaceItem({required this.estate ,required this.restaurants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isNull = true;
    int _length = 0;

    _isNull = restaurants == null;
    if(!_isNull) {
      _length = restaurants.length;
    return
      !_isNull ? _length > 0 ?Container(
        height: estate.interface .length==0?0:100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.background,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 0.5), // changes position of shadow
          ),

        ],

      ),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: estate.interface .length,
        itemBuilder: (context, index) {
          return  estate.interface[index].space != null?Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.background,
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 0.5), // changes position of shadow
                ),

              ],

            ),
            child: Row(

              children: [
                Expanded(flex: 1,
                    child: Container(
                        padding: EdgeInsets.all(10),child:  Text("${estate.interface[index].name}"))),
                VerticalDivider(width: 1.0),
                Expanded(flex: 1,child: Container(
                    padding: EdgeInsets.all(10),child: Text("${estate.interface[index].space} م ",  style: robotoBlack.copyWith(fontSize: 14)))),
              ],
            ),
          ):Container();
        },
      ),
    ):Text(""):Text("");
  }
}}
