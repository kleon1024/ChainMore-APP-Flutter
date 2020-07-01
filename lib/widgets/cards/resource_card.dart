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

class ResourceCard extends StatefulWidget {
  @override
  _ResourceCardState createState() {
    return _ResourceCardState();
  }
}

class _ResourceCardState extends State<ResourceCard>
    with AutomaticKeepAliveClientMixin {
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
          // TODO: External Link Go WebViewPage
          // TODO: Go Page
        },
        onLongPress: () {
          // TODO: In Page Modal
        },
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          fastThreshold: 0,
          actionExtentRatio: 0.2,
          child: Container(
            height: ScreenUtil().setHeight(200),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "万字干货|《增长黑客》的背后逻辑是什么？是什么？是什么？是什么？是什么？是什么？",
                      style: Theme.of(context).textTheme.bodyText1,
                      softWrap: false,
                    ),
                    Text(
                      "woship.com",
                      style: Theme.of(context).textTheme.bodyText2,
                      softWrap: false,
                    )
                  ],
                ),
              ),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
//              caption: '归档',
              color: Colors.transparent,
              icon: Icons.archive,
            ),
            IconSlideAction(
//              caption: '分享',
              color: Colors.transparent,
              icon: Icons.share,
            ),
//            IconSlideAction(
//              caption: '选中',
//              color: Colors.transparent,
//              icon: Icons.check,
//            ),
//            IconSlideAction(
//              caption: '更多',
//              color: Colors.transparent,
//              icon: Icons.more_horiz,
//            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
