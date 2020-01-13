import 'package:chainmore/pages/home/discover/discover_page.dart';
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
                            text: '分享',
                          ),
                          Tab(
                            text: '灵感',
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
                    Positioned(
                      left: ScreenUtil().setWidth(0),
                      child: IconButton(
                        icon: Icon(
                          Icons.flip,
                          size: ScreenUtil().setWidth(70),
                          color: Colors.black87,
                        ),
                        onPressed: () {
                          _onSelectClassifier();
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
                      SparklePage(),
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

  List<Widget> _buildCategoryGroups() {
    SettingModel settingModel = Provider.of<SettingModel>(context);

    return settingModel.categoryGroups
        .map(
          (categoryGroup) => Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
        child: Row(
          children: <Widget>[
            Text(categoryGroup.title, style: TextUtil.style(15, 700)),
            HEmptyView(30),
            Row(
              children: categoryGroup.categories
                  .map(
                    (category) => Container(
                  padding:
                  EdgeInsets.only(right: ScreenUtil().setWidth(50)),
                  child: CategoryTagSelectable(
                    text: category.category,
                    selected: settingModel.disabledCategories.contains(category.id),
                    onTap: () {
                      if (settingModel.disabledCategories.contains(category.id)) {
                        settingModel.removeDisabledCategory(category.id);
                      } else {
                        settingModel.addDisabledCategory(category.id);
                      }
                      setState(() {});
                    },
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    )
        .toList();
  }

  void _onSelectClassifier() {
    var widgets = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
        child: Text("过滤选项", style: TextUtil.style(16, 700)),
      ),
    ];
    widgets.addAll(_buildCategoryGroups());

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: ScreenUtil().setHeight(780),
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    topRight: Radius.circular(ScreenUtil().setWidth(50))),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(30),
                  horizontal: ScreenUtil().setHeight(80)),
              child: Column(children: widgets))
          );
        }).then((res) {

    });
  }


  @override
  bool get wantKeepAlive => true;
}
