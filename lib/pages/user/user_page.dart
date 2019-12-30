import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/domain/domain_post_item.dart';
import 'package:chainmore/pages/post/comment_input_widget.dart';
import 'package:chainmore/pages/post/comment_item.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/flexible_detail_bar.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_load_footer.dart';
import 'package:chainmore/widgets/widget_load_header.dart';
import 'package:chainmore/widgets/widget_round_header.dart';
import 'package:chainmore/widgets/widget_sliver_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart';
import 'dart:math' as math;

import 'dart:ui';

import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final Domain item;

//  final BuildContext buildContext;

  UserPage(this.item) : assert(item != null);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Domain _data;
  List<Post> _posts = List<Post>();

  bool launched = false;
  bool allowCertify = true;

  int postOffset = 1;
  int postLimit = 20;

  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    launched = false;
    request();
    super.initState();
  }

  Future<bool> request() async {
    var response = await API.getDomainPosts(params: {
      "id": widget.item.id,
      "offset": postOffset,
      "limit": postLimit,
    });
    if (postOffset == 1) {
      _posts = response;
    } else {
      _posts.addAll(response);
    }
    if (response.length < postLimit) {
      return true;
    } else {
      postOffset += 1;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    String certifyString = "获得认证";
    String watchString = "关注领域";

    UserModel userModel = Provider.of<UserModel>(context);
    EditModel editModel = Provider.of<EditModel>(context);

    bool login = userModel.isLoggedIn();

    if (login) {
      if (_data != null) {
        if (_data.certified != null && _data.certified) {
          certifyString = "已认证";
          allowCertify = false;
        }
      }
    }

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
                  heroTag: "post",
                  elevation: 0,
                  backgroundColor: CMColors.blueLonely,
                  child: Icon(Icons.add),
                  onPressed: () {
                    if (userModel.isLoggedIn()) {
                      if (editModel.hasHistory()) {
                        Utils.showDoubleChoiceDialog(
                          context,
                          title: "开始分享",
                          body: "你还有未完成的分享，是否继续？",
                          leftText: "恢复",
                          rightText: "丢弃",
                          leftFunc: () {
                            editModel.initState();
                            NavigatorUtil.goEditPage(context);
                          },
                          rightFunc: () {
                            editModel.reset();
                            editModel.setDomain(widget.item);
                            NavigatorUtil.goEditPage(context);
                          },
                        );
                      } else {
                        editModel.setDomain(widget.item);
                        NavigatorUtil.goEditPage(context);
                      }
                    } else {
                      NavigatorUtil.goLoginPage(context,
                          data: LoginConfig(initial: false));
                    }
                  },
                ),
                FloatingActionButton(
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
                  child: EasyRefresh.custom(
                    header: LoadHeader(),
                    footer: LoadFooter(),
                    controller: _controller,
                    onRefresh: () async {
                      postOffset = 1;
                      request();
                    },
                    onLoad: () async {
                      var response = await request();
                      _controller.finishLoad(noMore: response, success: true);
                    },
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        expandedHeight: ScreenUtil().setHeight(900),
                        pinned: true,
                        elevation: 0,
                        floating: false,
                        backgroundColor: Colors.grey,
                        brightness: Brightness.dark,
                        iconTheme: IconThemeData(color: Colors.white),
                        title: Text(
                          widget.item.title,
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
                                      "分享",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _data != null
                                    ? Text(
                                        _data.description,
                                        maxLines: 3,
                                        softWrap: true,
                                        style: TextUtil.style(14, 300,
                                            color: Colors.white),
                                      )
                                    : VEmptyView(0),
                                VEmptyView(50),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          if (userModel.isLoggedIn()) {
                                            if (allowCertify) {
                                              NavigatorUtil.goDomainCertifyPage(
                                                  context,
                                                  data: widget.item);
                                            } else {
                                              Utils.showToast("无需重复认证");
                                            }
                                          } else {
                                            NavigatorUtil.goLoginPage(context,
                                                data: LoginConfig(
                                                    initial: false));
                                          }
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
                                              certifyString,
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
                                      child: InkWell(
                                        onTap: () {
                                          if (userModel.isLoggedIn()) {
                                          } else {
                                            NavigatorUtil.goLoginPage(context,
                                                data: LoginConfig(
                                                    initial: false));
                                          }
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
                                              watchString,
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
                                      child: InkWell(
                                        onTap: () {
                                          if (userModel.isLoggedIn()) {
//                                            NavigatorUtil.goDomainMapPage(context, data: _data);
                                          } else {
                                            NavigatorUtil.goLoginPage(context,
                                                data: LoginConfig(
                                                    initial: false));
                                          }
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
                                              "领域结构",
                                              style: TextUtil.style(14, 300,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                      CustomSliverFutureBuilder(
                        futureFunc: login ? API.getDomain : API.getDomainUnSign,
                        params: {'id': widget.item.id},
                        builder: (context, data) {
                          setData(data);
                          return SliverList(
                            delegate: SliverChildListDelegate([]),
                          );
                        },
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          double lastPadding = index == _posts.length - 1
                              ? ScreenUtil().setWidth(800)
                              : ScreenUtil().setWidth(20);
                          return Container(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(20),
                                bottom: ScreenUtil().setHeight(lastPadding),
                                left: ScreenUtil().setWidth(0),
                                right: ScreenUtil().setWidth(0)),
                            child: DomainPostItem(
                                item: _posts[index], domain: widget.item),
                          );
                        }, childCount: _posts.length),
                      ),
//                      CustomSliverFutureBuilder<List>(
//                        futureFunc: API.getDomainPosts,
//                        params: {'id': widget.item.id},
//                        builder: (context, data) {
//                          _posts = data;
//                          return SliverList(
//                            delegate:
//                                SliverChildBuilderDelegate((context, index) {
//                              double lastPadding = index == _posts.length - 1
//                                  ? ScreenUtil().setWidth(800)
//                                  : ScreenUtil().setWidth(20);
//                              return Container(
//                                padding: EdgeInsets.only(
//                                    top: ScreenUtil().setHeight(20),
//                                    bottom: ScreenUtil().setHeight(lastPadding),
//                                    left: ScreenUtil().setWidth(0),
//                                    right: ScreenUtil().setWidth(0)),
//                                child: DomainPostItem(
//                                    item: _posts[index], domain: widget.item),
//                              );
//                            }, childCount: _posts.length),
//                          );
//                        },
//                      ),
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
