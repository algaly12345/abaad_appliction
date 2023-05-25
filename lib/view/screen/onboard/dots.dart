import 'package:flutter/material.dart';

class Dots extends StatelessWidget {
  const Dots({key, this.currentPage});
  final int currentPage;
  //
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
        (currentIndex) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              // shape: currentPage == currentIndex
              //     ? BoxShape.rectangle
              //     : BoxShape.circle,
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: Theme.of(context).primaryColor,
            ),
            margin: const EdgeInsets.only(right: 5),
            height: 5.0,
            curve: Curves.easeIn,
            width: currentPage == currentIndex ? 27 : 7,
          );
        },
      ),
    );
  }
}
