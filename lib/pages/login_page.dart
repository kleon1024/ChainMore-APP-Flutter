import 'dart:convert';

import 'package:chainmore/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/providers/user_model.dart';
import 'package:chainmore/utils/navigator_util.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:chainmore/widgets/common_button.dart';
import 'package:chainmore/widgets/v_empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(
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
              _LoginWidget()
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatefulWidget {
  @override
  __LoginWidgetState createState() => __LoginWidgetState();
}

class __LoginWidgetState extends State<_LoginWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

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
              '别来无恙！',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 34,
              ),
            ),
          ),
          VEmptyView(50),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
                hintText: '用户名/邮箱/手机号',
                prefixIcon: Icon(
                  Icons.supervised_user_circle,
                  color: CMColors.blueLonely,
                )),
          ),
          VEmptyView(40),
          TextField(
            obscureText: true,
            controller: _pwdController,
            decoration: InputDecoration(
                hintText: '密码',
                prefixIcon: Icon(
                  Icons.lock,
                  color: CMColors.blueLonely,
                )),
          ),
          VEmptyView(120),
          Consumer<UserModel>(
            builder: (BuildContext context, UserModel value, Widget child) {
              return CommonButton(
                color: CMColors.blueLonely ,
                callback: () {
                  String username = _usernameController.text.trim();
                  String pwd = _pwdController.text.trim();
                  if (username.isEmpty || pwd.isEmpty) {
                    Utils.showToast('请输入账号或者密码');
                    return;
                  }
                  value.login(
                    context,
                    username,
                    pwd,
                  ).then((value){
                    if(value != null) {
                      Navigator.pop(context);
                    }
                  });
                },
                content: '登录',
                width: double.infinity,
              );
            },
          )
        ],
      ),
    );
  }
}
