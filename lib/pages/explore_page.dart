import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/cards/explore_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
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
          "探索",
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
      body: ListView.builder(
        itemCount: 2,
          itemBuilder: (context, index) {
        return ExploreCard();
      })
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
                            selected: settingModel.disabledCategories
                                .contains(category.id),
                            onTap: () {
                              if (settingModel.disabledCategories
                                  .contains(category.id)) {
                                settingModel
                                    .removeDisabledCategory(category.id);
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
                  child: Column(children: widgets)));
        }).then((res) {});
  }

  @override
  bool get wantKeepAlive => true;
}
