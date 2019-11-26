import 'dart:convert';

import 'package:chainmore/network/apis.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/utils/utils.dart';

class UserModel with ChangeNotifier {
  User _user;

  User get user => _user;

  void initUser() {
    if (Application.sp.containsKey('user')) {
      String s = Application.sp.getString('user');
      _user = User.fromJson(json.decode(s));
    }
  }

  Future<User> login(BuildContext context, String username, String pwd) async {

    var user = await API.login(context, username, pwd);
    if (user == null) {
      return null;
    }
    if (user.code > 299) {
      Utils.showToast('登录失败，请检查账号密码');
      return null;
    }
    Utils.showToast('登录成功');
    _saveUserInfo(user);
    return user;
  }

  logout(BuildContext context) async {
    _deleteUserInfo();
    await API.logout(context);
  }

  _saveUserInfo(User user) {
    _user = user;
    Application.sp.setString('user', json.encode(user.toJson()));
  }

  _deleteUserInfo() {
    Application.sp.remove('user');
  }
}
