import 'package:abaad/util/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key key,
    this.imageUrl,
    this.width,
    this.height,
    this.isCircle,
    this.borderRadius,
    this.fit,
  }) : super(key: key);

  ///
  final String imageUrl;
  final double width, height;
  final bool isCircle;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;

  ///
  @override
  Widget build(BuildContext context) {
    //
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width ?? 50.0,
      height: height ?? 50.0,
      alignment: Alignment.center,
      fit: BoxFit.cover,

      imageBuilder: (context, imageProvider) => Container(
        width: width ?? 50.0,
        height: height ?? 50.0,
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        // padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: borderRadius,
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.contain,
          ),
        ),
      ),
      // in loading image case
      placeholder: (context, index) => PlaceHolderImage(
        width: width,
        height: height,
        isCircle: isCircle,
      ),
      // in error case
      errorWidget: (context, url, error) {
        debugPrint('url $url , error $error');
        try {
          return ShowDefaultImage(
            width: width,
            height: height,
            isCircle: isCircle,
            borderRadius: borderRadius,
            fit: fit,
          );
        } catch (e) {
          return ShowDefaultImage(
            width: width,
            height: height,
            isCircle: isCircle,
            borderRadius: borderRadius,
            fit: fit,
          );
        }
        // debugPrint('error from cahched image $error url = $url');
      },
    );
  }
}

class PlaceHolderImage extends StatelessWidget {
  const PlaceHolderImage({
    this.height,
    this.width,
    this.isCircle,
    this.borderRadius,
  });
  final double width, height;
  final bool isCircle;
  final BorderRadiusGeometry borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 50.0,
      height: height ?? 50.0,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      // padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: borderRadius,
        image:  DecorationImage(
          image: AssetImage(Images.placeholder),
          // fit: fit ?? BoxFit.contain,
        ),
      ),
    );
  }
}

class ShowDefaultImage extends StatelessWidget {
  const ShowDefaultImage({
    Key key,
    this.width,
    this.height,
    this.isCircle,
    this.borderRadius,
    this.fit,
  }) : super(key: key);

  final double width, height;
  final bool isCircle;
  final BorderRadiusGeometry borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // width: width ?? 50.0,
      // height: height ?? 50.0,
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: isCircle == true ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: borderRadius,
        image: DecorationImage(
          image: const AssetImage(
            'assets/images/background_resturant.png',
          ),
          fit: fit ?? BoxFit.contain,
        ),
      ),
    );
  }
}
