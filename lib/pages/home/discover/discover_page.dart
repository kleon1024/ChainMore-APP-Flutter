import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/home/discover/post_item.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  List _posts = [];
  EasyRefreshController _controller = EasyRefreshController();

  int offset = 1;
  int limit = 5;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    offset = 1;
    // monitor network fetch
    List<Post> posts =
        await API.getTrendingPosts(params: {"offset": offset, "limit": limit});
    if (posts.isNotEmpty) {
      _posts = posts;
      if (posts.length < limit) {
        _controller.finishLoad(noMore: true, success: true);
      }
      offset += 1;
    }
    // if failed,use refreshFailed()
    if (mounted) setState(() {});

    _controller.finishLoad(noMore: false, success: true);
  }

  Future<void> _onLoading() async {
    // monitor network fetch
    List<Post> posts =
        await API.getTrendingPosts(params: {"offset": offset, "limit": limit});
    if (posts.isNotEmpty) {
      _posts.addAll(posts);
      if (posts.length < limit) {
        _controller.finishLoad(noMore: true, success: true);
      }
      offset += 1;
      _controller.finishLoad(noMore: false, success: true);
    } else {
      _controller.finishLoad(noMore: true, success: true);
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SettingModel settingModel = Provider.of<SettingModel>(context);
    List<int> filteredIndices = [];
//    for (int i = 0; i < _posts.length; ++i) {
//      if (Utils.hasAnyCategory(
//          _posts[i].categories, settingModel.disabledCategories)) {
//        filteredIndices.add(i);
//      }
//    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: CupertinoScrollbar(
            child: EasyRefresh.custom(
              header: LoadHeader(),
              footer: LoadFooter(),
              controller: _controller,
              onRefresh: _onRefresh,
              onLoad: _onLoading,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    if (filteredIndices.length == 0) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(50)),
                        child: Center(
                          child: Text("没什么好看的"),
                        ),
                      );
                    }

                    if (index == filteredIndices.length) {
                      return Column(
                        children: <Widget>[
                          Container(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(100)),
                              child: Text("你碰到我的底线了",
                                  textAlign: TextAlign.center)),
                        ],
                      );
                    }

                    return Container(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(20),
                            bottom: ScreenUtil().setHeight(20),
                            left: ScreenUtil().setWidth(0),
                            right: ScreenUtil().setWidth(0)),
                        child: PostItem(_posts[filteredIndices[index]],
                            callback: (post) {
                          _posts[filteredIndices[index]] = post;
                        }));
                  }, childCount: filteredIndices.length + 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
