import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
          const EdgeInsets.only(
              right: 5, left: 5),
          child: InkWell(
            onTap: () {
              restController
                  .setCategoryIndex(
                  categoryController
                      .categoryList[
                  index]
                      .id);
              restController.setCategoryPostion(
                  int.parse(
                      categoryController
                          .categoryList[
                      index]
                          .position));
              setState(() {
                //  type_properties=categoryController.categoryList[index].name;
              });
            },
            child: Container(
              height: 40,
              padding:
              const EdgeInsets
                  .only(
                  left: 4.0,
                  right: 4.0),
              decoration:
              BoxDecoration(
                border: Border.all(
                    color: categoryController
                        .categoryList[
                    index].id ==
                        restController
                            .categoryIndex
                        ? Theme.of(
                        context)
                        .primaryColor
                        : Colors
                        .black12,
                    width: 2),
                borderRadius:
                BorderRadius
                    .circular(
                    2.0),
                color: Colors.white30,
              ),
              child: Row(
                children: [
                  Container(
                    height: 26,
                    color:
                    Colors.white,
                    child: Text(
                      categoryController
                          .categoryList[
                      index]
                          .name,
                      style: categoryController
                          .categoryList[
                      index]
                          .id ==
                          restController
                              .categoryIndex
                          ? robotoBlack
                          .copyWith(
                          fontSize:
                          17)
                          : robotoRegular.copyWith(
                          fontSize:
                          Dimensions
                              .fontSizeDefault,
                          fontStyle:
                          FontStyle
                              .normal,
                          color: Theme.of(context)
                              .disabledColor),
                    ),
                  ),
                  SizedBox(width: 5),
                  CustomImage(
                      image:
                      '$_baseUrl/${categoryController.categoryList[index].image}',
                      height: 25,
                      width: 25,
                      colors: categoryController
                          .categoryList[
                      index]
                          .id ==
                          restController
                              .categoryIndex
                          ? Theme.of(
                          context)
                          .primaryColor
                          : Colors
                          .black12),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
