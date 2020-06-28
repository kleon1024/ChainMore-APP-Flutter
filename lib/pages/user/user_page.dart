import 'package:chainmore/models/author.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/user_info.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/flexible_detail_bar.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:chainmore/widgets/widget_round_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'dart:math' as math;

import 'dart:ui';

import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final Author author;

//  final BuildContext buildContext;

  UserPage(this.author) : assert(author != null);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool _forceUpdate = true;
  EasyRefreshController _controller = EasyRefreshController();

  Map<String, int> userHistories = {
    "发出的分享": 0,
    "发出的评论": 0,
    "创建的领域": 0,
    "认证的领域": 0,
    "关注的领域": 0,
    "关注的同学": 0,
    "追随的同好": 0,
  };

  List<String> userHistoryKeys;
  List<Function> userHistoryFunctions = [];

  @override
  void initState() {
    userHistoryKeys = userHistories.keys.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);
    bool login = userModel.isLoggedIn();

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Container(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(350),
              right: ScreenUtil().setWidth(10)),
          child: Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(80),
            child: FloatingActionButton(
              heroTag: "close",
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
                child: CupertinoScrollbar(
                  child: EasyRefresh.custom(
                    header: LoadHeader(),
                    footer: LoadFooter(),
                    controller: _controller,
                    onRefresh: () async {
                      setState(() {
                        _forceUpdate = true;
                      });
                    },
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        expandedHeight: ScreenUtil().setHeight(600),
                        pinned: true,
                        elevation: 0,
                        floating: false,
                        backgroundColor: Colors.grey,
                        brightness: Brightness.dark,
                        iconTheme: IconThemeData(color: Colors.white),
                        title: Text(
                          widget.author.nickname,
                          style: TextUtil.style(18, 600, color: Colors.white),
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
                                      "详情",
                                      style: TextUtil.style(16, 600),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleDetailBar(
                          content: CustomFutureBuilder(
                            futureFunc:
                                login ? API.getUserInfo : API.getUserInfoUnSign,
                            params: {'username': widget.author.username},
                            forceUpdate: _forceUpdate,
                            builder: (context, author) {
                              if (author == null) {
                                return Center(child: Text("加载失败"));
                              }

                              _forceUpdate = false;

                              userHistories = {
                                "发出的分享": author.posts,
                                "发出的评论": author.comments,
                                "创建的领域": author.domains,
                                "认证的领域": author.certifieds,
                                "关注的领域": author.watcheds,
                                "关注的同学": author.followings,
                                "追随的同好": author.followers,
                              };

                              String watchString = "关注同学";
                              if (author.following != null && author.following) {
                                 watchString = "已关注";
                              }

                              return Padding(
                                padding: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(40),
                                  ScreenUtil().setWidth(135),
                                  ScreenUtil().setWidth(40),
                                  ScreenUtil().setWidth(20),
                                ),
                                child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    VEmptyView(30),
                                    Text(
                                      author.bio,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextUtil.style(14, 300,
                                          color: Colors.white),
                                    ),
                                    VEmptyView(30),
                                    author.username == userModel.user.username
                                        ? VEmptyView(0)
                                        : ThinBorderButton(
                                            text: watchString,
                                            onTap: () {
                                              if (login) {
                                                if (!author.following) {
                                                  API.followUser(context,
                                                      params: {
                                                        "username":
                                                            author.username,
                                                      }).then((res) {
                                                    if (res != null) {
                                                      setState(() {
                                                        _forceUpdate = true;
                                                      });
                                                      Utils.showToast(context, "关注成功");
                                                    } else {
                                                      Utils.showToast(context, "关注失败");
                                                    }
                                                  });
                                                } else {
                                                  Utils.showToast(context, "已关注该同学");
                                                }
                                              } else {
                                                NavigatorUtil.goLoginPage(
                                                    context,
                                                    data: LoginConfig(
                                                        initial: false));
                                              }
                                            },
                                          ),
                                    VEmptyView(30),
                                  ],
                                ),
                              );
                            },
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
                                  color: Colors.black12,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(40)),
                            height: ScreenUtil().setWidth(150),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(userHistoryKeys[index],
                                    style: TextUtil.style(16, 500)),
                                Text(userHistories[userHistoryKeys[index]]
                                        .toString() +
                                    "    "),
                              ],
                            ),
                          );
                        }, childCount: userHistoryKeys.length),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
