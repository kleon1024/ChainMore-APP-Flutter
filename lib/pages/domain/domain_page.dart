import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/home/discover/post_item.dart';
import 'package:chainmore/pages/post/comment_input_widget.dart';
import 'package:chainmore/pages/post/comment_item.dart';
import 'package:chainmore/providers/domain_create_model.dart';
import 'package:chainmore/providers/edit_model.dart';
import 'package:chainmore/providers/setting_model.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/flexible_detail_bar.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
import 'package:chainmore/widgets/widget_category_tag.dart';
import 'package:chainmore/widgets/widget_future_builder.dart';
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

class DomainPage extends StatefulWidget {
  final Domain item;

//  final BuildContext buildContext;

  DomainPage(this.item) : assert(item != null);

  @override
  _DomainPageState createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  Domain _domain;
  List<Post> _posts = List<Post>();

  bool _forceUpdate = true;

  int postOffset = 1;
  int postLimit = 5;

  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      if (mounted) {
        await request();
        setState(() {});
      }
    });
  }

  Future<bool> request() async {
    var response = await API.getDomainPosts(context, params: {
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
    UserModel userModel = Provider.of<UserModel>(context);
    EditModel editModel = Provider.of<EditModel>(context);
    bool login = userModel.isLoggedIn();

    SettingModel settingModel = Provider.of<SettingModel>(context);
    List<int> filteredIndices = [];
    for (int i = 0; i < _posts.length; ++i) {
      if (Utils.hasAnyCategory(
          _posts[i].categories, settingModel.disabledCategories)) {
        filteredIndices.add(i);
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
                    if (_domain == null) {
                      return;
                    }
                    if (login) {
                      if (_domain.depended != null && !_domain.depended) {
                        Utils.showToast(context, "还有未认证的前置领域");
                      } else {
                        if (editModel.hasHistory()) {
                          Utils.showDoubleChoiceDialog(
                            context,
                            title: "开始分享",
                            body: "你还有未完成的分享，是否继续？",
                            leftText: "恢复",
                            rightText: "丢弃",
                            leftFunc: () {
                              editModel.initState();
                              Navigator.of(context).pop();
                              NavigatorUtil.goEditPage(context);
                            },
                            rightFunc: () {
                              editModel.reset();
                              editModel.setDomain(widget.item);
                              Navigator.of(context).pop();
                              NavigatorUtil.goEditPage(context);
                            },
                          );
                        } else {
                          editModel.setDomain(widget.item);
                          NavigatorUtil.goEditPage(context);
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
                  child: EasyRefresh.custom(
                    header: LoadHeader(),
                    footer: LoadFooter(),
                    controller: _controller,
                    onRefresh: () async {
                      postOffset = 1;
                      setState(() {
                        _forceUpdate = true;
                      });
                      request();
                      setState(() {});
                    },
                    onLoad: () async {
                      var response = await request();
                      _controller.finishLoad(noMore: response, success: true);
                      setState(() {});
                    },
                    slivers: <Widget>[
                      SliverAppBar(
                        automaticallyImplyLeading: false,
                        centerTitle: true,
                        expandedHeight: ScreenUtil().setHeight(900),
                        pinned: true,
                        elevation: 0,
                        floating: false,
                        backgroundColor: CMColors.blueLonely,
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
                          content: CustomFutureBuilder<Domain>(
                            futureFunc:
                                login ? API.getDomain : API.getDomainUnSign,
                            params: {'id': widget.item.id},
                            forceUpdate: _forceUpdate,
                            builder: (context, domain) {
                              if (domain.id == null) {
                                return Center(
                                    child: Text(
                                  "加载失败",
                                  style: TextUtil.style(14, 400,
                                      color: Colors.white),
                                ));
                              }

                              String certifyString = "获得认证";
                              String watchString = "关注领域";

                              _domain = domain;
                              _forceUpdate = false;

                              if (domain.certified) {
                                certifyString = "已认证";
                              }

                              if (domain.watched) {
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
                                    ThinBorderButton(
                                      text: certifyString,
                                      onTap: () {
                                        if (login) {
                                          if (!domain.certified) {
                                            if (!userModel
                                                .userInfo.rootCertified) {
                                              Utils.showDoubleChoiceDialog(
                                                context,
                                                title: "认证系统",
                                                body:
                                                    "在开始任意领域的认证前，\n需要获得顶级领域<阡陌>的认证。",
                                                leftText: "放弃认证",
                                                rightText: "开始认证",
                                                leftFunc: () {
                                                  Navigator.of(context).pop();
                                                },
                                                rightFunc: () {
                                                  Navigator.of(context).pop();
                                                  NavigatorUtil
                                                      .goDomainCertifyPage(
                                                          context,
                                                          data: Domain(id: 1));
                                                },
                                              );
                                            } else {
                                              NavigatorUtil.goDomainCertifyPage(
                                                  context,
                                                  data: widget.item);
                                            }
                                          } else {
                                            Utils.showToast(context, "已认证该领域");
                                          }
                                        } else {
                                          NavigatorUtil.goLoginPage(context,
                                              data:
                                                  LoginConfig(initial: false));
                                        }
                                      },
                                    ),
                                    VEmptyView(30),
                                    ThinBorderButton(
                                      text: watchString,
                                      onTap: () {
                                        if (userModel.isLoggedIn()) {
                                          if (!domain.watched) {
                                            API.watchDomain(context, params: {
                                              "id": domain.id
                                            }).then((res) {
                                              if (res != null) {
                                                setState(() {
                                                  _forceUpdate = true;
                                                });
                                              } else {
                                                Utils.showToast(
                                                    context, "关注失败");
                                              }
                                            });
                                          } else {
                                            Utils.showToast(context, "已关注该领域");
                                          }
                                        } else {
                                          NavigatorUtil.goLoginPage(context,
                                              data:
                                                  LoginConfig(initial: false));
                                        }
                                      },
                                    ),
                                    VEmptyView(30),
                                    ThinBorderButton(
                                      text: "领域结构",
                                      onTap: () {
                                        if (userModel.isLoggedIn()) {
                                          NavigatorUtil.goDomainMapPage(context,
                                              data: _domain);
                                        } else {
                                          NavigatorUtil.goLoginPage(context,
                                              data:
                                                  LoginConfig(initial: false));
                                        }
                                      },
                                    ),
                                    VEmptyView(30),
                                    Text(
                                      domain.description,
                                      maxLines: 3,
                                      softWrap: true,
                                      style: TextUtil.style(14, 300,
                                          color: Colors.white),
                                    ),
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
                                  color: Colors.black38,
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
                                  domain: widget.item, callback: (post) {
                                _posts[filteredIndices[index]] = post;
                              }));
                        }, childCount: filteredIndices.length + 1),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: ScreenUtil().setWidth(10),
                child: IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    size: ScreenUtil().setWidth(70),
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (_domain != null) {
                      _onSelectMore(_domain, userModel);
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  void _editPost(Domain domain, DomainCreateModel domainModel) {
    domainModel.reset();

    domainModel.setTitle(domain.title != null ? domain.title : "");
    domainModel.setId(domain.id);

    domainModel
        .setDescription(domain.description != null ? domain.description : "");
    domainModel.setBio(domain.bio != null ? domain.bio : "");
    domainModel.setDependentDomain(
        domain.dependeds != null ? domain.dependeds[0] : null);
    domainModel.setAggregateDomain(
        domain.aggregators != null ? domain.aggregators[0] : null);

    NavigatorUtil.goDomainCreatePage(context).then((res) {
      setState(() {});
    });
  }

  void _onSelectMore(Domain domain, UserModel userModel) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: ScreenUtil().setHeight(300),
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
                userModel.isLoggedIn() && domain.certified && domain.id != 1
                    ? GestureDetector(
                        onTap: () {
                          DomainCreateModel domainCreateModel =
                              Provider.of<DomainCreateModel>(context);
                          Navigator.of(context).pop();
                          if (domainCreateModel.hasHistory()) {
                            Utils.showDoubleChoiceDialog(context,
                                title: "历史编辑",
                                body: "你还有正在创建的领域",
                                rightText: "恢复领域",
                                leftText: "丢弃领域", rightFunc: () {
                              NavigatorUtil.goEditPage(context);
                            }, leftFunc: () {
                              _editPost(domain, domainCreateModel);
                            });
                          } else {
                            _editPost(domain, domainCreateModel);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setHeight(30)),
                          child: Text("修改领域", style: TextUtil.style(16, 600)),
                        ),
                      )
                    : VEmptyView(0),
                userModel.isLoggedIn() && !domain.certified
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

//  void setData(Domain data) {
//    Future.delayed(Duration(milliseconds: 50), () {
//      if (mounted && _forceUpdate) {
//        setState(() {
//          _forceUpdate = false;
//          _domain = data;
//        });
//      }
//    });
//  }
}
