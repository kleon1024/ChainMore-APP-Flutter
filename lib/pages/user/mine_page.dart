import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/models/update.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:chainmore/widgets/h_empty_view.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:chainmore/widgets/widget_button_thin_border.dart';
import 'package:chainmore/widgets/widget_update_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  Map<String, int> userHistories = {
    "发出分享": 0,
    "发出评论": 0,
    "创建领域": 0,
    "认证领域": 0,
    "关注领域": 0,
    "关注同学": 0,
    "追随同好": 0,
  };

  List<String> userHistoryKeys;
  List<Function> userHistoryFunctions = [];

  @override
  void initState() {
    super.initState();
    userHistoryKeys = userHistories.keys.toList();
    WidgetsBinding.instance.addPostFrameCallback((d) {
      if (mounted) {
        UserModel userModel = Provider.of<UserModel>(context);
        if (userModel.isLoggedIn()) {
          var userInfo = userModel.userInfo;
          var histories = {
            "发出分享": userInfo.posts,
            "发出评论": userInfo.comments,
            "创建领域": userInfo.domains,
            "认证领域": userInfo.certifieds,
            "关注领域": userInfo.watcheds,
            "关注同学": userInfo.followings,
            "追随同好": userInfo.followers,
          };
          setState(() {
            userHistories = histories;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
//              height: 100,
            padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setHeight(40),
                vertical: ScreenUtil().setHeight(200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                userModel.isLoggedIn()
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(userModel.userInfo.nickname,
                                style: TextUtil.style(18, 500)),
                            HEmptyView(30),
                            Text(userModel.userInfo.bio,
                                style: TextUtil.style(16, 300)),
                          ],
                        ),
                      )
                    : ThinBorderButton(
                        text: "立即登录",
                        onTap: () {
                          NavigatorUtil.goLoginPage(context,
                              data: LoginConfig(initial: false),
                              clearStack: false);
                        },
                        color: CMColors.blueLonely,
                      ),
                VEmptyView(200),
                Container(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
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
                    },
                    separatorBuilder: (context, index) {
                      return Container(
                        color: Colors.grey,
//                        margin:
//                            EdgeInsets.only(left: ScreenUtil().setWidth(140)),
                        height: ScreenUtil().setWidth(0.5),
                      );
                    },
                    itemCount: userHistoryKeys.length,
                  ),
                ),
                VEmptyView(300),
                userModel.isLoggedIn()
                    ? ThinBorderButton(
                        text: "退出登录",
                        onTap: () {
                          Utils.showDoubleChoiceDialog(
                            context,
                            title: "退出登录",
                            leftText: "确认",
                            rightText: "取消",
                            leftFunc: () {
                              userModel.logout(context).then((res) {
                                setState(() {});
                                Navigator.of(context).pop();
                              });
                            },
                            rightFunc: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                        color: Colors.black,
                      )
                    : VEmptyView(0),
                VEmptyView(60),
                ThinBorderButton(
                  text: "立即升级",
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          var data = Update(
                            appStoreUrl: "",
                            apkUrl: "192.168.3.5:5000/v1/download/apk/chainmore_version_1_0_0_201912292211.apk",
                            version: "1.0.0",
                            content: "船新版本",
                          );
                          return UpdateDialog(data: data);
                        });
                  },
                  color: Colors.black,
                ),
                VEmptyView(300),
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
