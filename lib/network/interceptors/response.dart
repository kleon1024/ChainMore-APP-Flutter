
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ResponseInterceptors extends InterceptorsWrapper {

  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    try {
      if (response.statusCode >= 200 && response.statusCode < 600) {
        return response;
      }
    } catch (e) {
      print(e.toString() + option.path);
      return response;
    }
  }
}