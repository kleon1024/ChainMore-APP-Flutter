import 'dart:convert';

import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'api_strategy.dart';
export 'package:dio/dio.dart';

///这里存放所有的网络请求接口
class ApiService {
  factory ApiService() => _getInstance();

  static ApiService get instance => _getInstance();
  static ApiService _instance;

  static final int requestSucceed = 0;
  static final int requestFailed = 1;

  ApiService._internal() {}

  static ApiService _getInstance() {
    if (_instance == null) {
      _instance = new ApiService._internal();
    }
    return _instance;
  }

  void getResourceMediaType({
    Function(List<ResourceMediaBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceMediaTypeMap().then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/type',
      (data) {
        final List items = data["items"];
        final List<ResourceMediaBean> beans =
            items.map((e) => ResourceMediaBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void checkResourceUrlExists({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) async {
    if (Utils.isMocking) {
      final r = await Mock.getResourceBeans(1);
      success(r);
      return;
    }

    ApiStrategy.getInstance().post(
      '/resource/exist',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void getCollectedResources({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/collected',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void getCreatedResources({
    Function(List<ResourceBean>) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(3).then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource/created',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void getResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void updateResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().put(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void createResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/resource',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void collectResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().post(
      '/resource/star',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

  void unCollectResource({
    Function(ResourceBean) success,
    Function failed,
    Function error,
    Map<String, dynamic> params,
    CancelToken token,
    Options options,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceBeans(1).then((value) {
        success(value[0]);
      });

      return;
    }

    ApiStrategy.getInstance().delete(
      '/resource/star',
      (data) {
        final List items = data["items"];
        final List<ResourceBean> beans =
            items.map((e) => ResourceBean.fromJson(e)).toList();
        success(beans[0]);
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
      options: options,
    );
  }

}
