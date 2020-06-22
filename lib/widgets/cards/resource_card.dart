import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/percent_indicator.dart';
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
                        stops: [0.25, 0.25],
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    child: Container(
                      color: Colors.grey.withOpacity(0.2),
                    )),
                Positioned(
                  left: ScreenUtil().setWidth(30),
                  top: ScreenUtil().setHeight(0),
                  right: ScreenUtil().setWidth(30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "HTML入门",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.share,
                            size: 16,
                          ),
                          Icon(
                            Icons.list,
                            size: 16,
                          ),
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Positioned(
                  left: ScreenUtil().setHeight(30),
                  bottom: ScreenUtil().setHeight(30),
                  right: ScreenUtil().setWidth(30),
                  child: Text(
                    "2018-01-01",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Positioned(
                  top: ScreenUtil().setWidth(80),
                  right: ScreenUtil().setWidth(30),
                  child: PercentIndicator([
                    0.1,
                    0.4,
                    0.4,
                    0.1,
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
