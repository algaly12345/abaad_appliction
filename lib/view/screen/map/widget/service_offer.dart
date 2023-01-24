import 'package:abaad/controller/estate_controller.dart';
import 'package:abaad/controller/location_controller.dart';
import 'package:abaad/controller/splash_controller.dart';
import 'package:abaad/data/model/response/estate_model.dart';
import 'package:abaad/helper/responsive_helper.dart';
import 'package:abaad/helper/route_helper.dart';
import 'package:abaad/util/dimensions.dart';
import 'package:abaad/util/images.dart';
import 'package:abaad/util/styles.dart';
import 'package:abaad/view/base/custom_image.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ServiecOffers extends StatelessWidget {
  final Function(int index) callback;
  ServiecOffers({@required this.callback});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<EstateController>(builder: (restaurantController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        Estate restaurant = restaurantController.estateModel.estates[splashController.nearestEstateIndex];

        return Positioned(
            top: 100.0,
            left: 15.0,
            child: FlipCard(
              front: Container(
                height: 250.0,
                width: 175.0,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.all(Radius.circular(8.0))),
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                      height: 150.0,
                      width: 175.0,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          image: DecorationImage(
                              image: NetworkImage('https://pic.onlinewebfonts.com/svg/img_546302.png'),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      padding: EdgeInsets.all(7.0),
                      width: 175.0,
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address: ',
                            style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                              width: 105.0,
                              child: Text(
                                    'none given',
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
                      width: 175.0,
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact: ',
                            style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                              width: 105.0,
                              child: Text(
                               'none given',
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
              back: Container(
                height: 300.0,
                width: 225.0,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   isReviews = true;
                              //   isPhotos = false;
                              // });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.easeIn,
                              padding: EdgeInsets.fromLTRB(
                                  7.0, 4.0, 7.0, 4.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(11.0),
                                  color:  Colors.white),
                              child: Text(
                                'Reviews',
                                style: TextStyle(
                                    color:  Colors.black87,
                                    fontFamily: 'WorkSans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // setState(() {
                              //   isReviews = false;
                              //   isPhotos = true;
                              // });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.easeIn,
                              padding: EdgeInsets.fromLTRB(
                                  7.0, 4.0, 7.0, 4.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(11.0),
                                  color: Colors.white),
                              child: Text(
                                'Photos',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'WorkSans',
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   height: 250.0,
                    //   child: isReviews
                    //       ? ListView(
                    //     children: [
                    //       if (isReviews &&
                    //           tappedPlaceDetail['reviews'] !=
                    //               null)
                    //         ...tappedPlaceDetail['reviews']!
                    //             .map((e) {
                    //           return _buildReviewItem(e);
                    //         })
                    //     ],
                    //   )
                    //       : _buildPhotoGallery(
                    //       tappedPlaceDetail['photos'] ?? []),
                    // )
                  ],
                ),
              ),
            ));


      });
    });
  }

}
