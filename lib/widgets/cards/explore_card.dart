import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreCard extends StatelessWidget {
  final Function onTap;
  final Function onLongPress;
  final String imageUrl;
  final String title;
  final String subtitle;

  ExploreCard({
    Key key,
    this.onTap,
    this.onLongPress,
    this.imageUrl = "",
    this.title = "",
    this.subtitle = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          height: ScreenUtil().setHeight(500),
          child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
            ),
            child: Stack(
              children: <Widget>[
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: <Color>[Colors.grey[500], Colors.white],
                      stops: [0, 0.8],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: CachedImage(imageUrl: imageUrl),
                ),
                Positioned(
                  top: ScreenUtil().setHeight(10),
                  left: ScreenUtil().setWidth(30),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Positioned(
                  bottom: ScreenUtil().setHeight(10),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
