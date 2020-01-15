import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/emoji.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/web.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/post/comment_input_widget.dart';
import 'package:chainmore/pages/post/comment_item.dart';
import 'package:chainmore/pages/post/widget_post_header.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_circle_button.dart';
import 'package:chainmore/widgets/widget_round_header.dart';
import 'package:chainmore/widgets/widget_sliver_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post item;
  final Function callback;

  PostPage(this.item, {this.callback});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Post _post;
  List<Comment> _comments;

  bool collected = false;
  bool collecting = false;

  bool _launched = true;
  bool _update = true;

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
                                _post.collects -= 1;
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
                                _post.collects += 1;
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
                    Navigator.of(context).pop(_post);
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
                    physics: BouncingScrollPhysics(),
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
                                PostHeader(_post != null ? _post : widget.item),
                                VEmptyView(5),
                                GestureDetector(
                                  onTap: () {
                                    NavigatorUtil.goUserPage(context,
                                        data: _post != null
                                            ? _post.author
                                            : widget.item.author);
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        _post != null
                                            ? _post.author.nickname
                                            : widget.item.author.nickname,
                                        style: TextUtil.style(13, 500,
                                            color: Colors.black45),
                                      ),
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
                        forceUpdate: _update,
                        builder: (context, post) {
                          _update = false;
                          setData(post);

                          String description = "";
                          if (post != null) {
                            description = post.description;
                          } else {
                            return Center(child: Text("加载失败"));
                          }

                          return SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: EdgeInsets.only(
                                  left: ScreenUtil().setHeight(40),
                                  right: ScreenUtil().setHeight(40),
                                  top: ScreenUtil().setHeight(0),
                                  bottom: ScreenUtil().setHeight(80),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildEmojiButton(post),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          Utils.readableTimeStamp(
                                              post.timestamp),
                                          style: TextUtil.style(14, 400,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "评论 " + post.comments.toString(),
                                          style: TextUtil.style(14, 400,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          "收藏 " + post.collects.toString(),
                                          style: TextUtil.style(14, 400,
                                              color: Colors.black54),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _onSelectMore(post, userModel);
                                          },
                                          child: Icon(Icons.more_horiz,
                                              color: Colors.black54,
                                              size: ScreenUtil().setSp(60)),
                                        ),
                                      ],
                                    ),
                                    VEmptyView(20),
                                    description != ""
                                        ? Text(
                                            description,
                                            style: w400_15TextStyle,
                                            softWrap: true,
                                            textAlign: TextAlign.start,
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
                          minHeight: ScreenUtil().setHeight(90),
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
                              if (_comments.length == 0) {
                                return Container(
                                  height: ScreenUtil().setHeight(1200),
                                  child: Center(
                                    child: Text(
                                      "思想的碰撞在此处发生",
                                      textAlign: TextAlign.center,
                                      style: TextUtil.style(14, 400),
                                    ),
                                  ),
                                );
                              }

                              if (index == _comments.length) {
                                return Container(
                                  height: ScreenUtil().setHeight(1200),
                                  child: Center(
                                    child: Text(
                                      "碰撞的火花在此处延续",
                                      textAlign: TextAlign.center,
                                      style: TextUtil.style(14, 400),
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(20),
                                    bottom: ScreenUtil().setHeight(20),
                                    left: ScreenUtil().setWidth(40),
                                    right: ScreenUtil().setWidth(40)),
                                child: CommentItem(item: _comments[index]),
                              );
                            }, childCount: _comments.length + 1),
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
                                Utils.showToast(context, '评论成功！');
                                setState(() {
                                  _comments.insert(0, r);
                                  _post.comments += 1;
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

  Widget _buildEmojiButton(Post post) {
    post.emojis.sort((Emoji a, Emoji b) => b.count.compareTo(a.count));
    return Row(
      children: <Widget>[
        Row(
          children: post.emojis.map((item) {
            if (item.count > 0) {
              return EmojiCircleButton(emoji: item);
            } else {
              return HEmptyView(0);
            }
          }).toList(),
        ),
        DropdownButton<String>(
          items: [
            DropdownMenuItem<String>(
              value: "add",
              child: Icon(Icons.add_circle_outline, size: 22),
            ),
            DropdownMenuItem<String>(
              value: "emoji",
              child: Container(
                child: Column(
                  children: post.emojis
                      .map(
                        (item) => InkWell(
                          onTap: () {
                            item.count += 1;
                            if (widget.callback != null) {
                              widget.callback(post.emojis);
                            }
                            Navigator.of(context).pop();
                            API.addEmojiReply(context,
                                params: {'post': post.id, 'emoji': item.id});
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setHeight(10)),
                            child: Text(item.emoji),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
          value: "add",
          elevation: 0,
          onChanged: (value) {},
          underline: Container(),
          iconSize: 0,
        ),
      ],
    );
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

  void _editPost(Post post, EditModel editModel) {
    editModel.reset();

    editModel.setTitle(post.title != null ? post.title : "");
    editModel.setBody(post.description != null ? post.description : "");
    editModel.setUrl(post.url != null ? post.url : "");
    editModel
        .setCategories(post.categories.map((category) => category.id).toList());
    editModel.setDomain(post.domain);
    editModel.setId(post.id);

    NavigatorUtil.goEditPage(context).then((res) {
      setState(() {
        _launched = true;
        _update = true;
      });
    });
  }

  void _onSelectMore(Post post, UserModel userModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: ScreenUtil().setHeight(450),
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    topRight: Radius.circular(ScreenUtil().setWidth(50))),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(30),
                  horizontal: ScreenUtil().setHeight(80)),
              child: Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: ScreenUtil().setHeight(15)),
                  child: Text("更多选项", style: TextUtil.style(14, 400)),
                ),
                userModel.isLoggedIn() &&
                        post.author.username == userModel.user.username
                    ? GestureDetector(
                        onTap: () {
                          EditModel editModel = Provider.of<EditModel>(context);
                          if (editModel.hasHistory()) {
                            Utils.showDoubleChoiceDialog(context,
                                title: "历史编辑",
                                body: "你还有未完成的草稿",
                                rightText: "恢复草稿",
                                leftText: "丢弃草稿", rightFunc: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              NavigatorUtil.goEditPage(context);
                            }, leftFunc: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              _editPost(post, editModel);
                            });
                          } else {
                            Navigator.of(context).pop();
                            _editPost(post, editModel);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(30)),
                          child: Text("编辑内容", style: TextUtil.style(16, 600)),
                        ),
                      )
                    : VEmptyView(0),
                userModel.isLoggedIn() &&
                        post.author.username == userModel.user.username
                    ? GestureDetector(
                        onTap: () {
                          Utils.showDoubleChoiceDialog(
                            context,
                            title: "⚠️危险动作",
                            body: "删除的内容无法恢复，请谨慎操作",
                            rightText: "取消",
                            leftText: "确认删除",
                            rightFunc: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            leftFunc: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(30)),
                          child: Text("删除内容", style: TextUtil.style(16, 600)),
                        ),
                      )
                    : VEmptyView(0),
                userModel.isLoggedIn() &&
                        post.author.username != userModel.user.username
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            vertical: ScreenUtil().setHeight(30)),
                        child: Text("更多选项", style: TextUtil.style(16, 600)),
                      )
                    : VEmptyView(0),
              ]),
            ),
          );
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
