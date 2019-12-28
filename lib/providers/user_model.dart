import 'dart:convert';

import 'package:chainmore/network/apis.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/utils/utils.dart';

class UserModel with ChangeNotifier {
  User _user;

  bool _loggedIn;

  User get user => _user;

  void initUser() {
    _loggedIn = false;
    if (Application.sp.containsKey('user')) {
      String s = Application.sp.getString('user');
      _user = User.fromJson(json.decode(s));
      _loggedIn = true;
    }
  }

  Future<User> login(BuildContext context, String username, String pwd) async {
    _loggedIn = false;
    var user = await API.login(context, username: username, password: pwd);
    if (user == null) {
      return null;
    }
    if (user.code != 20000) {
      Utils.showToast('登录失败，请检查账号密码');
      return null;
    }
    Utils.showToast('登录成功');
    _saveUserInfo(user);
    return user;
  }

  signup(BuildContext context, String username, String email, String pwd) async {
    _loggedIn = false;
    var response = await API.signup(context, username: username, password: pwd, email: email);

    if (response != null) {
      if (response.data["code"] == 20000) {
        return true;
      }
    }
    return null;
  }

  refreshLogin(BuildContext context) async {
    _loggedIn = false;
    var response = await API.refreshLogin(context);
    if (response != null) {
      _user.accessToken = response.data["accessToken"];
      _user.refreshToken = response.data["refreshToken"];
      _loggedIn = true;
      _saveUserInfo(_user);
      return _user;
    }
  }

  logout(BuildContext context) async {
    _deleteUserInfo();
    await API.logout(context);
  }

  _saveUserInfo(User user) {
    _loggedIn = true;
    _user = user;
    Application.sp.setString('user', json.encode(user.toJson()));
  }

  _deleteUserInfo() {
    _loggedIn = false;
    Application.sp.remove('user');
  }

  getRefreshToken() {
    if (_user != null && _user.refreshToken != null) {
      return _user.refreshToken;
    } else {
      return "";
    }
  }

  getAccessToken() {
    if (_user != null && _user.accessToken != null) {
      return _user.accessToken;
    } else {
      return "";
    }
  }

  isLoggedIn() {
    return _loggedIn;
  }

  reset() {
    _user = null;
    _deleteUserInfo();
  }

}
