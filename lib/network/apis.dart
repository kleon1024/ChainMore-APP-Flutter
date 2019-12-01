import 'dart:convert';

import 'package:chainmore/application.dart';
import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/network/net_utils.dart';
import 'package:chainmore/route/routes.dart';
import 'package:chainmore/route/navigate_service.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class API {
  static void reLogin() {
    Future.delayed(Duration(milliseconds: 200), () {
      Application.getIt<NavigateService>().popAndPushNamed(Routes.login);
      Utils.showToast('登录失效，请重新登录');
    });
  }

  static login(BuildContext context, String username, String password) async {
    String payload = base64.encode(utf8.encode(username + ":" + password));
    var response = await NetUtils.request("post", '/v1/auth/signin',
        context: context,
        data: {
          'payload': payload,
        }).catchError((e) {
      Utils.showToast('网络错误！');
    });

    if (response != null) {
      return User.fromJson(response.data);
    }
  }

  static logout(BuildContext context) async {
    return await NetUtils.request("get", '/v1/auth/signout', context: context)
        .catchError((e) {
      Utils.showToast('登出失败');
    });
  }

  static refreshLogin(BuildContext context) async {
    return await NetUtils.request("get", '/v1/auth/signin/refresh',
            context: context, isShowLoading: false, refresh: true)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });
  }

  static getTrendingPosts() async {
    var response =
        await NetUtils.request("get", '/v1/post/trendings').catchError((e) {
      Utils.showToast('网络错误，加载失败！');
    });

    if (response != null) {
      return response.data["items"].map((item) => Post.fromJson(item)).toList();
    } else {
      return List();
    }
  }

  static Future<Post> getPost(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/post", params: params, context: context)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });

    print("Get Post");
    if (response != null) {
      return Post.fromJson(response.data['item']);
    }
    return Post();
  }

  static Future<List<Comment>> getPostComments(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response =
        await NetUtils.request("get", "/v1/post/comment", params: params, context: context)
            .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Comment>.from(
          response.data["items"].map((item) => Comment.fromJson(item)));
    } else {
      return List<Comment>();
    }
  }

  static postComment(BuildContext context, String content,
      {Map<String, dynamic> params}) async {
    Map<String, dynamic> data = {"comment": content};

    var response = await NetUtils.request('post', '/v1/post/comment',
            data: data, params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      if (response.data["code"] == 20000) {
        return Comment.fromJson(response.data["item"]);
      } else {
        Utils.showToast(response.data["msg"]);
      }
    }
  }

  static Future<Domain> getDomain(BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain", params: params, context: context)
        .catchError((e) {
          Utils.showToast(e.toString());
    });

    if (response != null) {
      return Domain.fromJson(response.data["item"]);
    }
    return Domain();
  }

  static Future<List<Post>> getDomainPosts(BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/post", params: params, context: context).catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Post>.from(response.data["items"].map((item) => Post.fromJson(item)));
    } else {
      return List<Post>();
    }
  }
}
