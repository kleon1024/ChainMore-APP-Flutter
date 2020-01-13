import 'dart:convert';

import 'package:chainmore/application.dart';
import 'package:chainmore/models/category.dart';
import 'package:chainmore/models/category_group.dart';
import 'package:chainmore/models/certify_rule.dart';
import 'package:chainmore/models/comment.dart';
import 'package:chainmore/models/domain.dart';
import 'package:chainmore/models/domain_tree.dart';
import 'package:chainmore/models/hot_search_data.dart';
import 'package:chainmore/models/post.dart';
import 'package:chainmore/models/sparkle.dart';
import 'package:chainmore/models/update.dart';
import 'package:chainmore/models/user.dart';
import 'package:chainmore/models/user_info.dart';
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

  static login(BuildContext context, {String username, String password}) async {
    var response = await NetUtils.request("post", '/v1/auth/signin',
        context: context,
        data: {
          'username': username,
          'password': password,
        }).catchError((e) {
      Utils.showToast('网络错误！');
    });

    if (response != null) {
      return User.fromJson(response.data);
    }
  }

  static signup(BuildContext context,
      {String username, String nickname, String password, String email}) async {
    var response = await NetUtils.request("post", '/v1/auth/signup',
        context: context,
        data: {
          'username': username,
          'nickname': nickname,
          'password': password,
          'email': email,
        }).catchError((e) {
      Utils.showToast('网络错误！');
    });

    return response;
  }

  static logout(BuildContext context) async {
    return await NetUtils.request("delete", '/v1/auth/signout',
            context: context)
        .catchError((e) {
      Utils.showToast('登出失败');
    });
  }

  static refreshLogin({BuildContext context}) async {
    return await NetUtils.request("get", '/v1/auth/signin/refresh',
            context: context, isShowLoading: false, refresh: true)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });
  }

  static getTrendingPosts({Map<String, dynamic> params}) async {
    var response =
        await NetUtils.request("get", '/v1/post/trendings', params: params)
            .catchError((e) {
      Utils.showToast('网络错误，加载失败！');
    });

    if (response != null) {
      return response.data["items"].map((item) => Post.fromJson(item)).toList();
    } else {
      return List();
    }
  }

  static getPost(BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/post",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });

    if (response != null) {
      return Post.fromJson(response.data['item']);
    }
  }

  static getPostUnSign(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/post",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast('网络错误！');
    });

    if (response != null) {
      return Post.fromJson(response.data['item']);
    }
  }

  static Future<List<Comment>> getPostComments(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/post/comment",
            params: params, context: context, isShowLoading: false)
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

  static Future<Domain> getDomain(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return Domain.fromJson(response.data["item"]);
    }
    return Domain();
  }

  static Future<Domain> getDomainUnSign(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/unsign",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return Domain.fromJson(response.data["item"]);
    }
    return Domain();
  }

  static Future<List<Post>> getDomainPosts(
      BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/post",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Post>.from(
          response.data["items"].map((item) => Post.fromJson(item)));
    }

    return List<Post>();
  }

  static Future<HotSearchData> getHotSearchData(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/search/hot",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return HotSearchData.fromJson(response.data["item"]);
    }

    return HotSearchData(queries: []);
  }

  static Future<List> getSearch(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/search",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      if (response.data["type"] == "domain") {
        return List<Domain>.from(
            response.data["items"].map((item) => Domain.fromJson(item)));
      }
    }

    return List();
  }

  static Future<List<Domain>> getHotDomainData(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/hot",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      print("error");
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Domain>.from(
          response.data["items"].map((item) => Domain.fromJson(item)));
    }
    return List<Domain>();
  }

  static Future<List<Domain>> searchDomain(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/search/domain",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Domain>.from(
          response.data["items"].map((item) => Domain.fromJson(item)));
    }
    return List<Domain>();
  }

  static getUpdateInfo() async {
    var response = await NetUtils.request("get", "/v1/update")
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return Update.fromJson(response.data["item"]);
    }
  }

  static postSparkle(BuildContext context, {Map<String, dynamic> data}) async {
    var response = await NetUtils.request("post", "/v1/sparkle",
            data: data, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static replySparkle(BuildContext context, {Map<String, dynamic> data}) async {
    var response = await NetUtils.request("post", "/v1/sparkle/reply",
        data: data, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response!=null) {
      return Sparkle.fromJson(response.data["item"]);
    }
  }

  static postPost(BuildContext context, {Map<String, dynamic> data}) async {
    var response =
        await NetUtils.request("post", "/v1/post", data: data, context: context)
            .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static Future<List<Sparkle>> getTrendingSparkles(
      {Map<String, dynamic> params}) async {
    var response =
        await NetUtils.request("get", "/v1/sparkle/trendings", params: params)
            .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Sparkle>.from(
          response.data["items"].map((item) => Sparkle.fromJson(item)));
    }
    return List<Sparkle>();
  }

  static Future<List<CertifyRule>> getDomainCertify(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/certify",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<CertifyRule>.from(
          response.data["items"].map((item) => CertifyRule.fromJson(item)));
    }

    return List<CertifyRule>();
  }

  static postCertify(BuildContext context, {Map<String, dynamic> data}) async {
    var response = await NetUtils.request("post", "/v1/domain/certify",
            data: data, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static createDomain(BuildContext context, {Map<String, dynamic> data}) async {
    var response = await NetUtils.request("post", "/v1/domain",
            data: data, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static watchDomain(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("post", "/v1/domain/watch",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static unwatchDomain(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("delete", "/v1/domain/watch",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static getUserInfo(BuildContext context,
      {String username, Map<String, dynamic> params}) async {
    if (username == null) {
      username = params["username"];
    }
    var response = await NetUtils.request("get", "/v1/user/" + username,
            context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return UserInfo.fromJson(response.data["user"]);
    }
  }

  static getUserInfoUnSign(BuildContext context,
      {String username, Map<String, dynamic> params}) async {
    if (username == null) {
      username = params["username"];
    }
    var response = await NetUtils.request("get", "/v1/user/unsign" + username,
            context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return UserInfo.fromJson(response.data["user"]);
  }

  static followUser(BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("post", "/v1/user/follow",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static unFollowUser(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("delete", "/v1/domain/follow",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static collectPost(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("post", "/v1/post/collect",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static unCollectPost(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("delete", "/v1/post/collect",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response;
  }

  static getDomainAggregateTree(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/aggregate",
            params: params, context: context)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return DomainTree.fromJson(response.data["aggregate"]);
    }
  }

  static getDomainDependentTree(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/domain/dependent",
        params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return DomainTree.fromJson(response.data["dependent"]);
    }
  }

  static getSparkleReplies(BuildContext context,
      {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/sparkle/reply",
            params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<Sparkle>.from(response.data["items"].map((item) => Sparkle.fromJson(item)).toList());
    }
  }

  static addEmojiReply(BuildContext context, {Map<String, dynamic> params}) async {
    var response = await NetUtils.request("post", "/v1/post/emoji",
        params: params, context: context, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    return response != null;
  }

  static getCategoryGroup({Map<String, dynamic> params}) async {
    var response = await NetUtils.request("get", "/v1/category_groups",
        params: params, isShowLoading: false)
        .catchError((e) {
      Utils.showToast(e.toString());
    });

    if (response != null) {
      return List<CategoryGroup>.from(response.data["items"].map((item) => CategoryGroup.fromJson(item)));
    }
    return List<CategoryGroup>();
  }
}
