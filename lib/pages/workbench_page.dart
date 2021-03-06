import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/widgets/cards/circle_cached_image_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/indicators/action_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class WorkbenchPage extends StatefulWidget {
  @override
  _WorkbenchPageState createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: CircleCachedImageCard(
          onTap: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
          "工作台",
          style: Theme.of(context).textTheme.headline6
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.apps,
              size: ScreenUtil().setWidth(70),
            ),
            onPressed: () {
//              _onSelectClassifier();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: ScreenUtil().setWidth(70),
            ),
            onPressed: () {
              NavigatorUtil.goSearchPage(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: PersonalDrawer(),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
//            SliverGrid.extent(
//              mainAxisSpacing: ScreenUtil().setWidth(90),
//              maxCrossAxisExtent: ScreenUtil().setHeight(300),
//              children: <Widget>[
//                ActionIndicator(
//                    icon: Icon(Icons.add_circle_outline), text: "常用应用"),
//              ],
//            ),
//            SliverPersistentHeader(
//              delegate: _SliverHeaderDelegate(
//                minHeight: ScreenUtil().setHeight(150),
//                maxHeight: ScreenUtil().setHeight(150),
//                child: Container(
//                  padding: EdgeInsets.symmetric(
//                    horizontal: ScreenUtil().setWidth(30),
//                    vertical: ScreenUtil().setHeight(10),
//                  ),
//                  child: Text(
//                    "工具箱",
//                    style: Theme.of(context).textTheme.subtitle1,
//                  ),
//                ),
//              ),
//            ),
            SliverGrid.extent(
              mainAxisSpacing: ScreenUtil().setWidth(0),
              maxCrossAxisExtent: ScreenUtil().setHeight(275),
              children: <Widget>[
                ActionIndicator(
                  icon: Icon(Icons.link),
                  text: "我的资源",
                  onTap: () {
                    NavigatorUtil.goPage(context, "/resource");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
