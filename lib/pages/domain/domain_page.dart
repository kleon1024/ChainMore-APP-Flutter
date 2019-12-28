import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/domain/domain_post_item.dart';
import 'package:chainmore/pages/post/comment_input_widget.dart';
import 'package:chainmore/pages/post/comment_item.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/flexible_detail_bar.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_round_header.dart';
import 'package:chainmore/widgets/widget_sliver_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'dart:ui';

import 'package:provider/provider.dart';

class DomainPage extends StatefulWidget {
  final Domain item;

  DomainPage(this.item) : assert(item != null);

  @override
  _DomainPageState createState() => _DomainPageState(this.item);
}

class _DomainPageState extends State<DomainPage> {
  Domain _data;
  List<Post> _posts;

  bool launched;

  _DomainPageState(this._data);

  @override
  void initState() {
    launched = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
          padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(150),
              right: ScreenUtil().setWidth(10)),
          child: Container(
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
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        expandedHeight: ScreenUtil().setHeight(800),
                        pinned: true,
                        elevation: 0,
                        floating: false,
                        backgroundColor: Colors.grey,
                        brightness: Brightness.dark,
                        iconTheme: IconThemeData(color: Colors.white),
                        title: Text(
                          _data.title,
                          style: TextUtil.style(16, 600, color: Colors.white),
                        ),
                        bottom: RoundHeader(
                          child: Container(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox.fromSize(
                                size:
                                    Size.fromHeight(ScreenUtil().setWidth(120)),
                                child: Row(
                                  children: <Widget>[
                                    HEmptyView(20),
                                    Text(
                                      "内容",
                                      style: TextUtil.style(16, 600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleDetailBar(
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(40),
                              ScreenUtil().setWidth(135),
                              ScreenUtil().setWidth(40),
                              ScreenUtil().setWidth(20),
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  _data.description,
                                  maxLines: 3,
                                  softWrap: true,
                                  style: TextUtil.style(14, 300,
                                      color: Colors.white),
                                ),
                                VEmptyView(50),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          NavigatorUtil.goDomainCertifyPage(context, data: widget.item);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setHeight(15),
                                            top: ScreenUtil().setHeight(15),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 0.5,
                                                style: BorderStyle.solid),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                ScreenUtil().setWidth(20),
                                              ),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                            "获得认证",
                                            style: TextUtil.style(14, 300,
                                                color: Colors.white),
                                            ),
                                          ),
                                        ),
                                    ),
                                    ),
                                  ],
                                ),
                                VEmptyView(30),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(15),
                                          top: ScreenUtil().setHeight(15),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white,
                                              width: 0.5,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              ScreenUtil().setWidth(20),
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "关注领域",
                                            style: TextUtil.style(14, 300,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          background: Stack(
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logo.png",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaY: 20,
                                  sigmaX: 20,
                                ),
                                child: Container(
                                  color: Colors.black38,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomSliverFutureBuilder<Domain>(
                        futureFunc: API.getDomain,
                        params: {'id': widget.item.id},
                        builder: (context, data) {
                          setData(data);
                          return SliverList(
                            delegate: SliverChildListDelegate([]),
                          );
                        },
                      ),
                      CustomSliverFutureBuilder<List>(
                        futureFunc: API.getDomainPosts,
                        params: {'id': widget.item.id},
                        builder: (context, data) {
                          _posts = data;
                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              double lastPadding = index == _posts.length - 1
                                  ? ScreenUtil().setWidth(800)
                                  : ScreenUtil().setWidth(20);
                              return Container(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20),
                                    bottom: ScreenUtil().setHeight(lastPadding),
                                    left: ScreenUtil().setWidth(0),
                                    right: ScreenUtil().setWidth(0)),
                                child: DomainPostItem(item: _posts[index]),
                              );
                            }, childCount: _posts.length),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void setData(Domain data) {
    print("set data");
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted && !launched) {
        setState(() {
          print("set state");
          launched = true;
          _data = data;
        });
      }
    });
  }
}
