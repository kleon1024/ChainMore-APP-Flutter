import 'dart:convert';

import 'package:chainmore/models/user_info.dart';
import 'package:chainmore/network/apis.dart';
import 'package:flutter/material.dart';
import 'package:chainmore/application.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/utils/utils.dart';

class UserModel with ChangeNotifier {
  User _user;
  UserInfo _userInfo;

  bool _loggedIn;

  User get user => _user;
  UserInfo get userInfo => _userInfo;

  void initUser() {
    _loggedIn = false;
    if (Application.sp.containsKey('user')) {
      var state = json.decode(Application.sp.getString('user'));
      _user = User.fromJson(state['user']);
      _userInfo = UserInfo.fromJson(state['user_info']);
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
    var userInfo = await API.getUserInfo(context, username: username);
    if (userInfo == null) {
      Utils.showToast('登录失败，未能获取用户信息');
      return null;
    }
    Utils.showToast('登录成功');
    _loggedIn = true;
    _user = user;
    _userInfo = userInfo;
    _saveUserInfo();
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

  refreshLogin({BuildContext context}) async {
    _loggedIn = false;
    var response = await API.refreshLogin(context : context);

    var userInfo = await API.getUserInfo(context, username: _user.username);
    if (userInfo == null) {
      Utils.showToast('未能获取用户信息');
      return null;
    }
    _userInfo = userInfo;

    if (response != null) {
      _user.accessToken = response.data["accessToken"];
      _user.refreshToken = response.data["refreshToken"];
      _loggedIn = true;
      _saveUserInfo();
      return _user;
    }
  }

  logout(BuildContext context) async {
    reset();
    await API.logout(context);
  }

  _saveUserInfo() {
    var state = {
      'user' : _user,
      'user_info' : _userInfo,
    };
    Application.sp.setString('user', json.encode(state));
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
    _loggedIn = false;
    _user = null;
    _userInfo = null;
    _deleteUserInfo();
  }

}
