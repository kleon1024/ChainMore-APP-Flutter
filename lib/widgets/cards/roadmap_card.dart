import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoadmapCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.goRoadmapDetailPage(context);
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
                        "http://www.linuxeden.com/wp-content/uploads/2017/07/vm9ej5e7rl5i0h2v.jpegheading.jpg",
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(30),
                  top: ScreenUtil().setHeight(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "VueJS快速入门",
                        style: TextUtil.style(16, 800, color: Colors.white),
                      ),
                      VEmptyView(ScreenUtil().setHeight(80)),
                      Text(
                        "三天精通没啥可说的，想来就赶快吧！",
                        style: TextUtil.style(16, 300),
                      ),
                    ],
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
