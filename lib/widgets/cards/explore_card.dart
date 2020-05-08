import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: () {
          print("route to /discover_domain");
        },
        onLongPress: () {
          print("Long pressed");
        },
        child: Card(
//        borderOnForeground: false,
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
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: <Color>[Colors.white, Colors.grey[400]],
                    stops: [0.5, 0.9],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: CachedNetworkImage(
                  imageUrl:
                      "http://www.linuxeden.com/wp-content/uploads/2017/07/vm9ej5e7rl5i0h2v.jpegheading.jpg",
                ),
              ),
              Positioned(
                top: ScreenUtil().setHeight(30),
                left: ScreenUtil().setWidth(30),
                child: Text(
                  "发现领域",
                  style: TextUtil.style(16, 300, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: ScreenUtil().setHeight(30),
                right: ScreenUtil().setWidth(30),
                child: Text(
                  "VueJs快速入门",
                  style: TextUtil.style(18, 800, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
