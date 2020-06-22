import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/cards/circle_cached_image_card.dart';
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
            "探索",
            style: Theme.of(context).textTheme.headline6,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.apps,
              ),
              onPressed: () {
//              _onSelectClassifier();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.search,
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
        body: CustomScrollView(
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                ExploreCard(
                  title: "路线地图",
                  onTap: () {
                    NavigatorUtil.goExploreRoadmapPage(context);
                  },
                  imageUrl:
                      "http://www.linuxeden.com/wp-content/uploads/2017/07/vm9ej5e7rl5i0h2v.jpegheading.jpg",
                ),
                ExploreCard(
                  title: "发现领域",
                  onTap: () {
                    NavigatorUtil.goExploreDomainPage(context);
                  },
                  imageUrl: "http://pic1.win4000.com/wallpaper/2020-05-08/5eb5209b6028b.jpg",
                ),
              ]),
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
