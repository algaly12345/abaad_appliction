import 'package:abaad/data/model/response/estate_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SizeWidget extends StatelessWidget {
  final  productSizes;
  final Property sizeModel;
  final List<int> numbers = [1, 2, 3, 5, 8, 13, 21, 34, 55];
  SizeWidget ( this.sizeModel,this.productSizes);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: numbers.length, itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Card(
            color: Colors.blue,
            child: Container(
              child: Center(child: Text(numbers[index].toString(), style: TextStyle(color: Colors.white, fontSize: 36.0),)),
            ),
          ),
        );
      }),
    );
  }

}



