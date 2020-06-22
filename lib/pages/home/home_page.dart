import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/cards/circle_cached_image_card.dart';
import 'package:chainmore/widgets/cards/default_card.dart';
import 'package:chainmore/widgets/cards/roadmap_progress_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AppBar appbar = AppBar(
      elevation: 0,
      leading: CircleCachedImageCard(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      title: Text(
        "聚焦",
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.filter_list,
            size: ScreenUtil().setWidth(70),
          ),
          onPressed: () {
            _onSelectClassifier();
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
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appbar,
      drawer: Drawer(
        child: PersonalDrawer(),
      ),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              DefaultCard(),
              RoadmapProgressCard(),
            ]),
          ),
        ],
      ),
    );
  }

  void _onSelectClassifier() {
    var widgets = <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
        child: Text("过滤选项", style: Theme.of(context).textTheme.subtitle1,),
      ),
    ];

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: ScreenUtil().setHeight(780),
              child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setWidth(30),
                      horizontal: ScreenUtil().setHeight(80)),
                  child: Column(children: widgets)));
        }).then((res) {});
  }

  @override
  bool get wantKeepAlive => true;
}
