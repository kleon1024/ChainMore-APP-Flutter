import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WorkbenchPage extends StatefulWidget {
  @override
  _WorkbenchPageState createState() => _WorkbenchPageState();
}

class _WorkbenchPageState extends State<WorkbenchPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
          child: Row(
            children: <Widget>[
              GestureDetector(
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setHeight(120),
                    imageUrl:
                        "http://i.serengeseba.com/uploads/i_2_2608823560x2626403468_26.jpg",
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                onTap: () {
                  _scaffoldKey.currentState.openDrawer();
                },
              )
            ],
          ),
        ),
        title: Text(
          "工作台",
          style: commonTitleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.apps,
              size: ScreenUtil().setWidth(70),
              color: Colors.black87,
            ),
            onPressed: () {
//              _onSelectClassifier();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: ScreenUtil().setWidth(70),
              color: Colors.black87,
            ),
            onPressed: () {
              NavigatorUtil.goSearchPage(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: PersonalDrawer(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(30)),
        child: Card(
//        borderOnForeground: false,
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(30)),
          ),
          child: CachedNetworkImage(
            imageUrl:
                "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1588792994611&di=cd5bb29b62e0e44aefb4f08961ff2ad1&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20160923%2Fadaf5902a26e4362ad8e36f53ae2e30a_th.jpg",
          ),
        ),
      ),
    );
  }


  @override
  bool get wantKeepAlive => true;
}
