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

class RoadmapDetailPage extends StatefulWidget {
  @override
  _RoadmapDetailPageState createState() => _RoadmapDetailPageState();
}

class _RoadmapDetailPageState extends State<RoadmapDetailPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
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
                title: Text("VueJS快速入门", style: Theme.of(context).textTheme.subtitle1),
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
                          "http://www.linuxeden.com/wp-content/uploads/2017/07/vm9ej5e7rl5i0h2v.jpegheading.jpg",
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
                            number: 162,
                            icon: Icon(Icons.location_on),
                            text: "全部领域",
                          ),
                          StatisticIndicator(
                            number: 126,
                            icon: Icon(Icons.flight_takeoff),
                            text: "正在进行",
                          ),
                          StatisticIndicator(
                            number: 163,
                            icon: Icon(Icons.favorite),
                            text: "标记收藏",
                          ),
                          StatisticIndicator(
                            number: 16,
                            icon: Icon(Icons.access_time),
                            text: "预计时间",
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                    ),
                    ListDivider(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)),
                      child: Text("前置领域", style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: true,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return RoadmapItemCard(
                            children: <Widget>[
                              IconIndicator(
                                icon: Icon(Icons.location_on),
                                text: "HTML基础",
                              ),
                              IconIndicator(
                                icon: Icon(Icons.access_time),
                                text: "5h",
                              ),
                            ],
                          );
                        },
                        itemCount: 2,
                      ),
                    ),
                    ListDivider(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)),
                      child: Text("使用建议", style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)),
                      child: Text(
                          "扎实的 JavaScript / HTML / CSS 基本功。这是前置条件。通读官方教程 (guide) 的基础篇。不要用任何构建工具，就只用最简单的 <script>，把教程里的例子模仿一遍，理解用法。不推荐上来就直接用 vue-cli 构建项目，尤其是如果没有 Node/Webpack 基础。",
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                    ListDivider(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(30)),
                      child: Text("关键节点", style: Theme.of(context).textTheme.subtitle1),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: true,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(10),
                                horizontal: ScreenUtil().setHeight(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconIndicator(
                                    icon: Icon(Icons.location_on),
                                    text: "HTML基础",
                                  ),
                                  IconIndicator(
                                    icon: Icon(Icons.access_time),
                                    text: "5h",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: 2,
                      ),
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
