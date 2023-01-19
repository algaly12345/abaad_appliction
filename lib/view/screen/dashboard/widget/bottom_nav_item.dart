import 'package:abaad/util/styles.dart';
import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  final bool isSelected;
  final String name;
  BottomNavItem({ this.iconData,this.name, this.onTap, this.isSelected = false});

  @override
  Widget build(BuildContext context) {

    return  Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          child: Material(
            type: MaterialType.transparency,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(iconData, color: isSelected ? Theme.of(context).primaryColor : Colors.grey, size: 30),
                  SizedBox(

                    child: Text(
                        name, style: robotoBlack.copyWith(fontSize: 11)
                    ),
                  )
                ],
              ),

          ),
        ),
      ),
    );
  }
}
