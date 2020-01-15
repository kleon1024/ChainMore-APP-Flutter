import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/home/discover/post_item.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  List items = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int offset = 1;
  int limit = 5;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  void _onRefresh() async {
    offset = 1;
    // monitor network fetch
    List<Post> posts =
        await API.getTrendingPosts(params: {"offset": offset, "limit": limit});
    if (posts.isNotEmpty) {
      items = posts;
      if (posts.length < limit) {
        _refreshController.loadNoData();
      }
      offset += 1;
    }
    // if failed,use refreshFailed()
    if (mounted) setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    List<Post> posts =
        await API.getTrendingPosts(params: {"offset": offset, "limit": limit});
    if (posts.isNotEmpty) {
      items.addAll(posts);
      if (posts.length < limit) {
        _refreshController.loadNoData();
      }
      offset += 1;
      _refreshController.loadComplete();
    } else {
      _refreshController.loadNoData();
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SettingModel settingModel = Provider.of<SettingModel>(context);
    List<int> filteredIndices = [];
    for (int i = 0; i < items.length; ++i) {
      if (Utils.hasAnyCategory(items[i].categories, settingModel.disabledCategories)) {
        filteredIndices.add(i);
      }
    }

    return RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(),
      // Configure the default header indicator. If you have the same header indicator for each page, you need to set this
      footerBuilder: () => ClassicFooter(),
      // Configure default bottom indicator
      headerTriggerDistance: 80.0,
      // header trigger refresh trigger distance
      springDescription:
          SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
      // custom spring back animate,the props meaning see the flutter api
      maxOverScrollExtent: 100,
      //The maximum dragging range of the head. Set this property if a rush out of the view area occurs
      maxUnderScrollExtent: 0,
      // Maximum dragging range at the bottom
      enableScrollWhenRefreshCompleted: true,
      //This property is incompatible with PageView and TabBarView. If you need TabBarView to slide left and right, you need to set it to true.
      enableLoadingWhenFailed: true,
      //In the case of load failure, users can still trigger more loads by gesture pull-up.
      hideFooterWhenNotFull: false,
      // Disable pull-up to load more functionality when Viewport is less than one screen
      enableBallisticLoad: true,
      // trigger load more by BallisticScrollActivity
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Scrollbar(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body;
                    if (mode == LoadStatus.idle) {
                      body = Text("上拉加载");
                    } else if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("加载失败");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("加载更多");
                    } else {
                      body = Text("");
                    }
                    return Container(
                      height: 150.0,
                      child: Center(child: body),
                    );
                  },
                ),
                controller: _refreshController,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: ListView.separated(
                  itemBuilder: (c, i) {
                    if (filteredIndices.length == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(50)),
                        child: Center(
                          child: Text("还没有什么内容"),
                        ),
                      );
                    }
                    if (i == filteredIndices.length) {
                      return Column(
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(30)),
                              child: Text("你碰到我的底线了",
                                  textAlign: TextAlign.center)),
                          VEmptyView(300),
                        ],
                      );
                    }
                    return PostItem(items[filteredIndices[i]], callback: (post) {
                      items[filteredIndices[i]] = post;
                    });
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      color: Color(0x05000000),
                      height: ScreenUtil().setWidth(30),
                    );
                  },
                  itemCount: filteredIndices.length + 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
