import 'package:cached_network_image/cached_network_image.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String imageUrl;
  final Function callback;

  CachedImage({this.imageUrl = "", this.callback});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) {
        if (callback != null) {
          print("Getting coloring");
          getImageFromProvider(imageProvider).then((image) {
            getColorFromImage(image).then((color) {
              callback(color);
            });
          });
        }

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
//                          colorFilter:
//                              ColorFilter.mode(Colors.red, BlendMode.colorBurn),
            ),
          ),
        );
      },
      placeholder: (context, url) => Container(color: Colors.grey[100]),
    );
  }
}
