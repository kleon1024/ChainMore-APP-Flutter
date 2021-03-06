import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/indicators/progress_bar.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

typedef OnTapFinished = void Function(int index);

class RoadmapProgressCard extends StatelessWidget {
  final OnTapFinished onFinished;
  final index;

  RoadmapProgressCard({Key key, this.index, this.onFinished}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
      child: GestureDetector(
        onTap: () {
          // TODO: Go Detail
//          NavigatorUtil.goRoadmapDetailPage(context);
        },
        onLongPress: () {
          // TODO: In Page Modal
        },
        child: Slidable(
          key: Key(index.toString()),
          actionPane: SlidableBehindActionPane(),
          actionExtentRatio: 0.3,
          showAllActionsThreshold: 0.3,
          dismissal: SlidableDismissal(
            dismissThresholds: <SlideActionType, double>{
              SlideActionType.secondary: 1,
              SlideActionType.primary: 0.3
            },
            child: SlidableDrawerDismissal(),
          ),
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
                  Positioned(
                    left: ScreenUtil().setWidth(30),
                    top: 0,
                    child: Container(
                      height: ScreenUtil().setHeight(100),
                      child: Center(
                        child: Text(
                          "VueJS快速入门",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: ScreenUtil().setHeight(0),
                    top: ScreenUtil().setHeight(100),
                    right: ScreenUtil().setHeight(0),
                    child: Container(
                      child: ProgressBar(
                          color: Theme.of(context).accentColor, percent: 0.8),
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
                        Text("接下来:",
                            style: Theme.of(context).textTheme.bodyText1),
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
                              text: "估计3h",
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
          actions: [
            IconSlideAction(
              caption: '归档',
              color: Colors.transparent,
              icon: Icons.check,
              onTap: () {},
            ),
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: '分享',
              color: Colors.transparent,
              icon: Icons.share,
            ),
            IconSlideAction(
              caption: '更多',
              color: Colors.transparent,
              icon: Icons.more_horiz,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
