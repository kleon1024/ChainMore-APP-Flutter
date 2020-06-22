import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/indicators/progress_bar.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoadmapProgressCard extends StatefulWidget {
  @override
  _RoadmapProgressCardState createState() {
    return _RoadmapProgressCardState();
  }
}

class _RoadmapProgressCardState extends State<RoadmapProgressCard>
    with AutomaticKeepAliveClientMixin {
  Color progressBarColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);


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
          height: ScreenUtil().setHeight(400),
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
                      stops: [0.25, 0.25],
                      tileMode: TileMode.clamp,
                    ).createShader(bounds);
                  },
                  child: CachedImage(
                    imageUrl:
                        "http://pic1.win4000.com/wallpaper/2020-05-08/5eb5209b6028b.jpg",
                    callback: (color) {
                      if (progressBarColor == null && color != null) {
                        setState(() {
                          progressBarColor =
                              Color.fromARGB(255, color[0], color[1], color[2]);
                        });
                      }
                    },
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setWidth(30),
                  top: 0,
                  child: Container(
                    height: ScreenUtil().setHeight(100),
                    child: Center(
                      child: Text(
                        "VueJS快速入门",
                        style: TextUtil.style(18, 800, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(0),
                  top: ScreenUtil().setHeight(100),
                  right: ScreenUtil().setHeight(0),
                  child: Container(
                    child: ProgressBar(color: progressBarColor != null ? progressBarColor : Colors.grey, percent: 0.8),
                  ),
                ),

                Positioned(
                  left: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setHeight(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("进行中：", style: commonTitleTextStyle,),
                      VEmptyView(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconIndicator(
                            icon: Icon(Icons.location_on),
                            text: "HTML基础",
                          ),
                          IconIndicator(
                            icon: Icon(Icons.access_time),
                            text: "1h/3h",
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
