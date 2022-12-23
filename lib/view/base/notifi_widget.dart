
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifIconWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool fromRestaurant;
  NotifIconWidget({@required this.color, @required this.size, this.fromRestaurant = false});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.notifications_active, size: size,
        color: color,
      ),
    ]);
  }
}
