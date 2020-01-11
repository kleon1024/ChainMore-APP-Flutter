import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/post/comment_input_widget.dart';
import 'package:chainmore/pages/post/comment_item.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
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
  Post _post;
  List<Comment> _comments;

  bool collected = false;
  bool collecting = false;

  bool _launched = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    bool login = userModel.isLoggedIn();

    return Scaffold(
        floatingActionButton: Container(
          padding: EdgeInsets.only(
              bottom: ScreenUtil().setHeight(150),
              right: ScreenUtil().setWidth(10)),
          child: Container(
            height: ScreenUtil().setHeight(360),
            width: ScreenUtil().setWidth(80),
            child: Column(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "collect",
                  elevation: 0,
                  backgroundColor: CMColors.blueLonely,
                  child: Icon(collected ? Icons.star : Icons.star_border),
                  onPressed: () {
                    if (_post == null) {
                      return;
                    }
                    if (login) {
                      if (!collecting) {
                        collecting = true;
                        setState(() {
                          collected = !collected;
                        });
                        if (!collected) {
                          API.unCollectPost(context,
                              params: {'id': widget.item.id}).then((res) {
                            if (res != null) {
                              setState(() {
                                collected = false;
                              });
                            }
                            collecting = false;
                          });
                        } else {
                          API.collectPost(context,
                              params: {'id': widget.item.id}).then((res) {
                            if (res != null) {
                              setState(() {
                                collected = true;
                              });
                            }
                            collecting = false;
                          });
                        }
                      }
                    } else {
                      NavigatorUtil.goLoginPage(context,
                          data: LoginConfig(initial: false));
                    }
                  },
                ),
                FloatingActionButton(
                  heroTag: "close",
                  elevation: 0,
                  backgroundColor: Colors.black87,
                  child: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
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
                                  onTap: () {
                                    NavigatorUtil.goDomainPage(context,
                                        data: widget.item.domain);
                                  },
                                  child: Container(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Text(widget.item.domain.title,
                                            style: TextUtil.style(14, 500)),
                                        HEmptyView(5),
                                        Text(
                                            widget.item.domain.watchers
                                                    .toString() +
                                                widget.item.domain.bio,
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize:
                                                    ScreenUtil().setSp(38))),
                                      ],
                                    ),
                                  ),
                                ),
                                VEmptyView(30),
//                                Row(children: <Widget>[
//                                  CategoryTag(text: widget.item.category),
//                                ]),
//                                VEmptyView(20),
                                Hero(
                                  tag:
                                      'post_title_' + widget.item.id.toString(),
                                  child: Text(widget.item.title,
                                      style: w600_16TextStyle),
                                ),
                                VEmptyView(5),
                                GestureDetector(
                                  onTap: () {
                                    NavigatorUtil.goUserPage(context,
                                        data: widget.item.author);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(widget.item.author.nickname,
                                          style: w400_13TextStyle),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      CustomSliverFutureBuilder(
                        futureFunc: login ? API.getPost : API.getPostUnSign,
                        params: {'id': widget.item.id},
                        builder: (context, post) {
                          setData(post);
                          String description = "";
                          String url = "";
                          if (post != null) {
                            description = post.description;
                            if (post.url != "") {
                              url = post.url.split("/")[2];
                            }
                            collected = post.collected;
                          } else {
                            return Center(child: Text("加载失败"));
                          }

                          return SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setHeight(40),
                                  right: ScreenUtil().setHeight(40),
                                  top: ScreenUtil().setHeight(30),
                                  bottom: ScreenUtil().setHeight(80),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    url != null && url != ""
                                        ? CategoryTag(
                                            text: url,
                                            textColor: CMColors.blueLonely,
                                            color: Colors.white,
                                            onTap: () {
                                              NavigatorUtil.goWebViewPage(
                                                  context,
                                                  web: Web(
                                                      url: post.url,
                                                      post: post));
                                            },
                                          )
                                        : VEmptyView(0),
                                    VEmptyView(15),
                                    description != ""
                                        ? Text(
                                            description,
                                            style: w400_15TextStyle,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
                                          )
                                        : VEmptyView(0),
                                    VEmptyView(15),
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
                                  topLeft: Radius.circular(
                                      ScreenUtil().setWidth(50)),
                                  topRight: Radius.circular(
                                      ScreenUtil().setWidth(50))),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Color(0x0f000000),
                                    offset: Offset(0, -4),
                                    blurRadius: 4),
                              ],
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(40)),
                                child:
                                    Text("评论区", style: TextUtil.style(16, 700)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomSliverFutureBuilder<List>(
                        futureFunc: API.getPostComments,
                        params: {'id': widget.item.id},
                        builder: (context, data) {
                          _comments = data;
                          return SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                              double lastPadding = index == _comments.length - 1
                                  ? ScreenUtil().setWidth(800)
                                  : ScreenUtil().setWidth(20);
                              return Container(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20),
                                    bottom: ScreenUtil().setHeight(lastPadding),
                                    left: ScreenUtil().setWidth(40),
                                    right: ScreenUtil().setWidth(40)),
                                child: CommentItem(item: _comments[index]),
                              );
                            }, childCount: _comments.length),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                child: login
                    ? (_post != null && _post.domain.depended
                        ? CommentInputWidget((content) {
                            API.postComment(context, content, params: {
                              'id': widget.item.id,
                            }).then((r) {
                              if (r != null) {
                                Utils.showToast('评论成功！');
                                setState(() {
                                  _comments.insert(0, r);
                                });
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              }
                            });
                          })
                        : Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                            child: ThinBorderButton(
                              text: "认证前置领域后评论",
                              onTap: () {
                                print("TAPPPPPP");
                                if (!userModel.userInfo.rootCertified) {
                                  Utils.showDoubleChoiceDialog(
                                    context,
                                    title: "📋认证系统",
                                    body: "在开始任意领域的认证前，\n需要获得顶级领域<阡陌>的认证。",
                                    leftText: "放弃认证",
                                    rightText: "开始认证",
                                    leftFunc: () {
                                      Navigator.of(context).pop();
                                    },
                                    rightFunc: () {
                                      Navigator.of(context).pop();
                                      NavigatorUtil.goDomainCertifyPage(
                                        context,
                                        data: Domain(id: 1),
                                      ).then((res) {
                                        setState(() {});
                                      });
                                    },
                                  );
                                } else {
                                  NavigatorUtil.goDomainCertifyPage(context,
                                      data: _post.domain.dependeds[0]);
                                }
                              },
                              color: CMColors.blueLonely,
                            )))
                    : Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                        child: ThinBorderButton(
                          text: "登录后评论",
                          onTap: () {
                            NavigatorUtil.goLoginPage(context,
                                data: LoginConfig(initial: false));
                          },
                          color: CMColors.blueLonely,
                        )),
                alignment: Alignment.bottomCenter,
              ),
            ],
          ),
        ));
  }

  void setData(Post data) {
    Future.delayed(Duration(milliseconds: 50), () {
      if (mounted && _launched) {
        setState(() {
          _post = data;
          _launched = false;
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
