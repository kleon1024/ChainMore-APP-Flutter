import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/sparkle.dart';
import 'package:chainmore/network/apis.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/pages/domain/domain_post_item.dart';
import 'package:chainmore/pages/home/sparkle/sparkle_item.dart';
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

class SparkleDetailPage extends StatefulWidget {
  final Sparkle sparkle;

  SparkleDetailPage(this.sparkle) : assert(sparkle != null);

  @override
  _SparkleDetailPageState createState() => _SparkleDetailPageState();
}

class _SparkleDetailPageState extends State<SparkleDetailPage> {
  List<Sparkle> _sparkles = List<Sparkle>();

  int postOffset = 1;
  int postLimit = 5;

  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((d) async {
      if (mounted) {
        var response = await request();
        _controller.finishLoad(noMore: response, success: true);
      }
    });
  }

  Future<bool> request() async {
    var response = await API.getSparkleReplies(context, params: {
      "id": widget.sparkle.id,
      "offset": postOffset,
      "limit": postLimit,
    });

    if (postOffset == 1) {
      _sparkles = response;
    } else {
      _sparkles.addAll(response);
    }

    _sparkles.forEach((sparkle) {
      sparkle.replied = widget.sparkle;
    });

    setState(() {});

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
    bool login = userModel.isLoggedIn();

    double height = 500;
    if (widget.sparkle.replied != null) {
      height += 100;
    }

    return Scaffold(
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: ScreenUtil().setHeight(150),
            right: ScreenUtil().setWidth(10)),
        child: Container(
          height: ScreenUtil().setHeight(180),
          width: ScreenUtil().setWidth(80),
          child: Column(
            children: <Widget>[
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
                    setState(() {
                      postOffset = 1;
                    });
                    request();
                  },
                  onLoad: () async {
                    var response = await request();
                    _controller.finishLoad(noMore: response, success: true);
                  },
                  slivers: <Widget>[
                    SliverAppBar(
                        automaticallyImplyLeading: false,
                        expandedHeight: ScreenUtil().setHeight(height),
                        pinned: true,
                        floating: false,
                        elevation: 0,
                        iconTheme: IconThemeData(color: Colors.white),
                        backgroundColor: CMColors.blueLonely,
                        title: Text(
                          widget.sparkle.body,
                          style: TextUtil.style(18, 700, color: Colors.white),
                        ),
                        bottom: RoundHeader(
                          child: Container(
                            color: Colors.white,
                            child: InkWell(
                              onTap: () {},
                              child: SizedBox.fromSize(
                                size:
                                    Size.fromHeight(ScreenUtil().setWidth(120)),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20),
                                      left: ScreenUtil().setWidth(55)),
                                  child: Text("共鸣",
                                      style: TextUtil.style(16, 600)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleDetailBar(
                          content: Container(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(55),
                                  top: ScreenUtil().setHeight(150),
                                  right: ScreenUtil().setWidth(55)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  widget.sparkle.replied == null
                                      ? VEmptyView(0)
                                      : CategoryTag(
                                          text: widget.sparkle.replied.body,
                                          textSize: 13,
                                          color: Colors.transparent,
                                          borderWidth: 0.5,
                                          textColor: Colors.white,
                                          borderColor: Colors.white,
                                          onTap: () {
                                            NavigatorUtil.goSparkleDetailPage(
                                                context,
                                                data: widget.sparkle.replied);
                                          },
                                        ),
                                  VEmptyView(30),
                                  Text(
                                    widget.sparkle.author.nickname,
                                    style: TextUtil.style(14, 400,
                                        color: Colors.white),
                                  ),
                                  VEmptyView(10),
                                  Text(
                                    Utils.readableTimeStamp(
                                        widget.sparkle.timestamp),
                                    style: TextUtil.style(14, 400,
                                        color: Colors.white),
                                  ),
                                ],
                              )),
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
                        )),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        double lastPadding = index == _sparkles.length - 1
                            ? ScreenUtil().setWidth(800)
                            : ScreenUtil().setWidth(20);
                        return Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(20),
                              bottom: ScreenUtil().setHeight(lastPadding),
                              left: ScreenUtil().setWidth(0),
                              right: ScreenUtil().setWidth(0)),
                          child: SparkleItem(
                              item: _sparkles[index], showReplied: false),
                        );
                      }, childCount: _sparkles.length),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              child: login
                  ? CommentInputWidget(
                      (content) {
                        API.replySparkle(context, data: {
                          'body': content,
                          'reply': widget.sparkle.id,
                        }).then((r) {
                          if (r != null) {
                            Utils.showToast('共鸣成功');
                            setState(() {
                              _sparkles.insert(0, r);
                            });
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                          }
                        });
                      },
                      hintText: "产生共鸣",
                    )
                  : Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                      child: ThinBorderButton(
                        text: "登录后共鸣",
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
      ),
    );
  }
}
