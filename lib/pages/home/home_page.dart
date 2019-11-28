import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 设置没有高度的 appbar，目的是为了设置状态栏的颜色
      appBar: PreferredSize(
        child: AppBar(
          elevation: 0,
        ),
        preferredSize: Size.zero,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child:
        Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(300)),
                      child: TabBar(
                        labelStyle: TextStyle(
                            fontSize: ScreenUtil().setSp(52),
                            fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontSize: ScreenUtil().setSp(48)),
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0, color: CMColors.blueLonely)
                        ),
                        controller: _tabController,
                        tabs: [
                          Tab(
                            text: '关注',
                          ),
                          Tab(
                            text: '热门',
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: ScreenUtil().setWidth(0),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: ScreenUtil().setWidth(70),
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          NavigatorUtil.goSearchPage(context);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DiscoverPage(),
                      DiscoverPage(),
                    ],
                  ),
                ),
              ],
            ),
//            PlayWidget(),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
