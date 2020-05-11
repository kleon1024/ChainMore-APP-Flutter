import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DomainCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.goDomainDetailPage(context);
        },
        onLongPress: () {
          print("Long pressed");
        },
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
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.grey[400], Colors.transparent],
                      stops: [0.2, 0.2],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: CachedImage(
                    imageUrl:
                        "http://pic1.win4000.com/wallpaper/2020-05-08/5eb5209b6028b.jpg",
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(30),
                  top: ScreenUtil().setHeight(10),
                  right: ScreenUtil().setHeight(30),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "游戏设计",
                          style: TextUtil.style(16, 800, color: Colors.white),
                        ),
                        VEmptyView(30),
                        Text(
                          "我们的理想是做最好玩的游戏，做最美的设计，做最令人感动的故事。欢迎加入我们一起行动吧。",
                          style: TextUtil.style(16, 300),
                          softWrap: true,
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setHeight(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconIndicator(
                        icon: Icon(Icons.location_on),
                        text: "361",
                      ),
                      IconIndicator(
                        icon: Icon(Icons.flight_takeoff),
                        text: "16",
                      ),
                      IconIndicator(
                        icon: Icon(Icons.favorite),
                        text: "12",
                      ),
                      IconIndicator(
                        icon: Icon(Icons.access_time),
                        text: "24h",
                      ),
                    ],
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
