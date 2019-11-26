
import 'dart:convert';

import 'package:dio/dio.dart';

class ResponseInterceptors extends InterceptorsWrapper {

  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    print("************************");
    print(response);
    try {
//      if (option.contentType != null &&
//          option.contentType.primaryType == "text") {
//        return Result(response.data, true, Code.SUCCESS);
//      }
      if (response.statusCode >= 200 && response.statusCode < 600) {
        return response;
      }
    } catch (e) {
      print(e.toString() + option.path);
      return response;
    }
  }
}