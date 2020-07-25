import 'package:chainmore/network/apis.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_item.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SparklePage extends StatefulWidget {
  @override
  _SparklePageState createState() => _SparklePageState();
}

class _SparklePageState extends State<SparklePage>
    with AutomaticKeepAliveClientMixin {
  List items = [];
  EasyRefreshController _controller = EasyRefreshController();

  int offset = 1;
  int limit = 5;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    offset = 1;
    List sparkles = await API
        .getTrendingSparkles(params: {"offset": offset, "limit": limit});
    if (sparkles.isNotEmpty) {
      items = sparkles;
      if (sparkles.length < limit) {
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
    List sparkles = await API
        .getTrendingSparkles(params: {"offset": offset, "limit": limit});
    if (sparkles.isNotEmpty) {
      items.addAll(sparkles);
      if (sparkles.length < limit) {
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
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (items.length == 0) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(50)),
                          child: Center(
                            child: Text("还没有什么内容"),
                          ),
                        );
                      }
                      if (index == items.length) {
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
                      return SparkleItem(item: items[index]);
                    },
                    childCount: items.length + 1,
                  ),
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
