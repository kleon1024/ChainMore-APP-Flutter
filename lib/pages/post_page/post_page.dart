import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_round_header.dart';
import 'package:chainmore/widgets/widget_sliver_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post item;

  PostPage(this.item);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post _data;
  List<Comment> _comments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        height: ScreenUtil().setHeight(80),
        width: ScreenUtil().setWidth(80),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Colors.black87,
          child: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(35),
                    right: ScreenUtil().setWidth(35),
                    top: ScreenUtil().setHeight(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(widget.item.domain.title,
                                  style: TextUtil.style(14, 500)),
                              HEmptyView(5),
                              Text(
                                  widget.item.domain.watchers.toString() +
                                      widget.item.domain.bio,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: ScreenUtil().setSp(38))),
                            ],
                          ),
                        ),
                      ),
                      VEmptyView(30),
                      Row(children: <Widget>[
                        CategoryTag(text: widget.item.category),
                      ]),
                      VEmptyView(20),
                      Hero(
                        tag: 'post_title_' + widget.item.id.toString(),
                        child: Text(widget.item.title, style: w600_16TextStyle),
                      ),
                      VEmptyView(5),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: <Widget>[
                            Text(widget.item.author.nickname,
                                style: w400_13TextStyle),
                            HEmptyView(5),
                            Text(
                                // TODO: Change to bio
                                widget.item.author.username,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: ScreenUtil().setSp(38))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
            CustomSliverFutureBuilder<Post>(
              futureFunc: API.getPost,
              params: {'id': widget.item.id},
              builder: (context, data) {
                setData(data);
                String description = "";
                if (_data != null) {
                  if (_data.description != null) {
                    description = _data.description;
                  }
                }
                return SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setHeight(35),
                        right: ScreenUtil().setHeight(35),
                        top: ScreenUtil().setHeight(30),
                        bottom: ScreenUtil().setHeight(80),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          VEmptyView(10),
                          description != ""
                              ? Text(
                                  description,
                                  style: w400_15TextStyle,
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                )
                              : VEmptyView(0),
                        ],
                      ),
                    )
                  ]),
                );
              },
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: ScreenUtil().setHeight(120),
                maxHeight: ScreenUtil().setHeight(120),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                        topRight: Radius.circular(ScreenUtil().setWidth(50))),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Color(0x0f000000),
                          offset: Offset(0, -4),
                          blurRadius: 4),
                    ],
                  ),
                  child: Center(
                    child: Text("ABC"),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(20),
                      bottom: ScreenUtil().setHeight(20),
                      left: ScreenUtil().setWidth(40),
                      right: ScreenUtil().setWidth(40)),
                  child: Text("A"),
                );
              }, childCount: 100),
            )
          ],
        ),
      ),
    );
  }

  void setData(Post data) {
    Future.delayed(Duration(milliseconds: 20), () {
      if (mounted) {
        setState(() {
          _data = data;
        });
      }
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
