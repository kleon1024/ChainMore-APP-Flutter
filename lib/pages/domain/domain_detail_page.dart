import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chainmore/pages/home/discover/discover_page.dart';
import 'package:chainmore/pages/home/personal_drawer.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_page.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/params.dart';
import 'package:chainmore/widgets/cached_image.dart';
import 'package:chainmore/widgets/cards/explore_card.dart';
import 'package:chainmore/widgets/cards/collection_card.dart';
import 'package:chainmore/widgets/cards/roadmap_card.dart';
import 'package:chainmore/widgets/cards/roadmap_item_card.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/flexible_detail_bar.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/indicators/action_indicator.dart';
import 'package:chainmore/widgets/indicators/icon_indicator.dart';
import 'package:chainmore/widgets/indicators/statistic_indicator.dart';
import 'package:chainmore/widgets/list/list_divider.dart';
import 'package:chainmore/widgets/widget_category_tag_selectable.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OldDomainDetailPage extends StatefulWidget {
  @override
  _OldDomainDetailPageState createState() => _OldDomainDetailPageState();
}

class _OldDomainDetailPageState extends State<OldDomainDetailPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                elevation: 0,
                title: Text("游戏设计"),
                floating: false,
                expandedHeight: GlobalParams.topImageHeight,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  background: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.white54, Colors.white],
                        stops: [0.2, 0.6],
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    child: CachedImage(
                      imageUrl:
                          "http://pic1.win4000.com/wallpaper/2020-05-08/5eb5209b6028b.jpg",
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StatisticIndicator(
                            number: 162162,
                            icon: Icon(Icons.location_on),
                            text: "全部资源",
                          ),
                          StatisticIndicator(
                            number: 126,
                            icon: Icon(Icons.flight_takeoff),
                            text: "正在关注",
                          ),
                          StatisticIndicator(
                            number: 163,
                            icon: Icon(Icons.favorite),
                            text: "标记收藏",
                          ),
                          StatisticIndicator(
                            number: 1623,
                            icon: Icon(Icons.access_time),
                            text: "获得认证",
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    ),
//                    ListDivider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setHeight(30),
                        ),
                        child: Text("按时间排序", style: Theme.of(context).textTheme.bodyText1),
                      ),
                    ),
                    VEmptyView(15),
                    ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: true,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CollectionCard();
                      },
                      itemCount: 3,
                    ),
                    Container(
                      height: ScreenUtil().setHeight(300),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: ScreenUtil().setHeight(0),
            left: ScreenUtil().setHeight(0),
            right: ScreenUtil().setHeight(0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ActionIndicator(
                    icon: Icon(Icons.thumb_up),
                  ),
                  ActionIndicator(
                    icon: Icon(Icons.favorite),
                  ),
                  ActionIndicator(
                    icon: Icon(Icons.add),
                  ),
                  ActionIndicator(
                    icon: Icon(Icons.flight_takeoff),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
