import 'dart:convert';

import 'package:chainmore/models/login_config.dart';
import 'package:chainmore/utils/colors.dart';
import 'package:chainmore/widgets/common_text_style.dart';
import 'package:common_utils/common_utils.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_button.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final LoginConfig config;

  LoginPage(this.config);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.config.initial
          ? null
          : Container(
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(80),
            right: ScreenUtil().setWidth(80),
            top: ScreenUtil().setWidth(200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _LoginWidget(widget.config.initial),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  final bool initial;

  _LoginWidget(this.initial);

  @override
  __LoginWidgetState createState() => __LoginWidgetState();
}

class __LoginWidgetState extends State<_LoginWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdConfirmController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: CMColors.blueLonely),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setWidth(30)),
            child: Text(
              isLogin ? '别来无恙！' : '欢迎加入！',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 34,
              ),
            ),
          ),
          VEmptyView(50),
          TextField(
            keyboardType: TextInputType.text,
            controller: _usernameController,
            decoration: InputDecoration(
                hintText: isLogin ? '用户名/邮箱' : '用户名(6-16位数字字母)',
                prefixIcon: Icon(
                  Icons.supervised_user_circle,
                  color: CMColors.blueLonely,
                )),
          ),
          VEmptyView(isLogin ? 0 : 40),
          isLogin
              ? VEmptyView(0)
              : TextField(
            keyboardType: TextInputType.text,
            controller: _nicknameController,
            decoration: InputDecoration(
                hintText: isLogin ? '' : '昵称',
                prefixIcon: Icon(
                  Icons.account_box,
                  color: CMColors.blueLonely,
                )),
          ),
          VEmptyView(isLogin ? 0 : 40),
          isLogin
              ? VEmptyView(0)
              : TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: InputDecoration(
                      hintText: isLogin ? '' : '邮箱',
                      prefixIcon: Icon(
                        Icons.email,
                        color: CMColors.blueLonely,
                      )),
                ),
          VEmptyView(40),
          TextField(
            obscureText: true,
            keyboardType: TextInputType.text,
            controller: _pwdController,
            decoration: InputDecoration(
                hintText: '密码(6-16位数字字母)',
                prefixIcon: Icon(
                  Icons.lock,
                  color: CMColors.blueLonely,
                )),
          ),
          VEmptyView(isLogin ? 0 : 40),
          isLogin
              ? VEmptyView(0)
              : TextField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: _pwdConfirmController,
                  decoration: InputDecoration(
                      hintText: '确认密码',
                      prefixIcon:
                          Icon(Icons.lock, color: CMColors.blueLonely))),
          VEmptyView(120),
          Consumer<UserModel>(
            builder: (BuildContext context, UserModel value, Widget child) {
              return CommonButton(
                color: CMColors.blueLonely,
                textColor: Colors.white,
                callback: () {
                  if (isLogin) {
                    String username = _usernameController.text.trim();
                    String pwd = _pwdController.text.trim();

                    if (username.isEmpty || pwd.isEmpty) {
                      Utils.showToast(context, '请输入用户名或者密码');
                      return;
                    }

                    value
                        .login(
                      context,
                      username,
                      pwd,
                    )
                        .then((value) {
                      if (value != null) {
                        if (widget.initial) {
                          NavigatorUtil.goMainPage(context);
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    });
                  } else {
                    String username = _usernameController.text.trim();
                    String nickname = _nicknameController.text.trim();
                    String pwd = _pwdController.text.trim();
                    String email = _emailController.text.trim();
                    String pwdConfirm = _pwdConfirmController.text.trim();

                    if (username.isEmpty) {
                      Utils.showToast(context, '请输入用户名');
                      return;
                    }

                    if (!Utils.isUserName(username)) {
                      Utils.showToast(context, "请输入\n合法用户名");
                      return;
                    }

                    if (nickname.isEmpty) {
                      Utils.showToast(context, '请输入昵称');
                    }

                    if (email.isEmpty) {
                      Utils.showToast(context, '请输入邮箱');
                      return;
                    }

                    if (!prefix0.RegexUtil.isEmail(email)) {
                      Utils.showToast(context, '请输入有效邮箱');
                      return;
                    }

                    if (pwd.isEmpty) {
                      Utils.showToast(context, "请输入密码");
                      return;
                    }

                    if (!Utils.isLoginPassword(pwd)) {
                      Utils.showToast(context, "请输入合法密码");
                      return;
                    }

                    if (pwdConfirm.isEmpty) {
                      Utils.showToast(context, "请输入确认密码");
                      return;
                    }

                    if (pwd != pwdConfirm) {
                      Utils.showToast(context, "密码不一致");
                      return;
                    }

                    value.signup(context, username, nickname, email, pwd).then((res) {
                      if (res != null) {
                        value
                            .login(
                          context,
                          username,
                          pwd,
                        )
                            .then((value) {
                          if (value != null) {
                            if (widget.initial) {
                              NavigatorUtil.goMainPage(context);
                            } else {
                              Navigator.pop(context);
                            }
                          }
                        });
                      } else {
                        Utils.showToast(context, "注册失败");
                      }
                    });
                  }
                },
                content: isLogin ? '登录' : '注册',
                width: double.infinity,
              );
            },
          ),
          VEmptyView(50),
          isLogin
              ? CommonButton(
                  color: Colors.white,
                  textColor: CMColors.blueLonely,
                  borderColor: CMColors.blueLonely,
                  callback: () {
                    NavigatorUtil.goMainPage(context);
                  },
                  content: '立即体验',
                  width: double.infinity,
                )
              : VEmptyView(0),
          VEmptyView(isLogin ? 50 : 0),
          isLogin
              ? VEmptyView(0)
              : CommonButton(
                  color: Colors.white,
                  textColor: CMColors.blueLonely,
                  borderColor: CMColors.blueLonely,
                  callback: () {
                    setState(() {
                      isLogin = true;
                    });
                  },
                  content: '返回',
                  width: double.infinity,
                ),
          isLogin
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Text("找回密码",
                          style: TextUtil.style(15, 400,
                              color: CMColors.blueLonely)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLogin = false;
                        });
                      },
                      child: Text("注册账号",
                          style: TextUtil.style(15, 400,
                              color: CMColors.blueLonely)),
                    ),
                  ],
                )
              : VEmptyView(0),
        ],
      ),
    );
  }
}
