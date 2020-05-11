import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResourceCard extends StatelessWidget {
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
          height: GlobalParams.resourceCardHeight,
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
                    child: Container(
                      color: Colors.grey[200],
                    )),
                Positioned(
                  left: ScreenUtil().setWidth(30),
                  top: ScreenUtil().setHeight(0),
                  right: ScreenUtil().setWidth(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("HTML入门"),
                      Row(
                        children: <Widget>[
                          Icon(Icons.build, size: 16,),
                          Icon(Icons.link, size: 16,),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(30),
                  top: ScreenUtil().setHeight(80),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    "三分钟精通HTML简史",
                    style: TextUtil.style(18, 800),
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    "2018-01-01",
                    style: TextUtil.style(16, 300),
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
