import 'dart:convert';

import 'package:chainmore/json/resource_bean.dart';
import 'package:chainmore/json/resource_media_bean.dart';
import 'package:chainmore/mock.dart';
import 'package:chainmore/utils/utils.dart';
import 'package:dio/dio.dart';

import 'api_strategy.dart';
export 'package:dio/dio.dart';


///这里存放所有的网络请求接口
class ApiService {
  factory ApiService() => _getInstance();

  static ApiService get instance => _getInstance();
  static ApiService _instance;

  static final int requestSucceed = 0;
  static final int requestFailed = 1;

  ApiService._internal() {

  }

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
    Map<String, String> params,
    CancelToken token,
  }) {
    if (Utils.isMocking) {
      Mock.getResourceMediaTypeMap().then((value) {
        success(value);
      });

      return;
    }

    ApiStrategy.getInstance().get(
      ApiStrategy.baseUrl,
      (data) {
        if (data["code"] != "20000") {
          failed(data);
        } else {
//          var beans = ResourceBean.fromJson(data);
          List<ResourceMediaBean> beans = [];
          success(beans);
        }
      },
      params: params,
      errorCallBack: (errorMessage) {
        error(errorMessage);
      },
      token: token,
    );
  }

}
