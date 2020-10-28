import 'package:dio/dio.dart';

class ApiStrategy {
  static ApiStrategy _instance;

  static final String baseUrl = "https://api.chainmore.fun/v1";
  static const int connectTimeOut = 10 * 1000; // Connection Timeout 10s
  static const int receiveTimeOut = 15 * 1000; // Response Timeout 15s

  Dio _client;

  static ApiStrategy getInstance() {
    if (_instance == null) {
      _instance = ApiStrategy._internal();
    }
    return _instance;
  }

  ApiStrategy._internal() {
    if (_client == null) {
      BaseOptions options = BaseOptions();
      options.connectTimeout = connectTimeOut;
      options.receiveTimeout = receiveTimeOut;
      options.baseUrl = baseUrl;
      _client = Dio(options);
      _client.interceptors.add(LogInterceptor(
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        request: false,
      )); //开启请求日志
    }
  }

  Dio get client => _client;
  static const String GET = "get";
  static const String POST = "post";
  static const String PUT = "put";
  static const String DELETE = "delete";

  static String getBaseUrl() {
    return baseUrl;
  }

  get(
    String url,
    Function callBack, {
    Map<String, dynamic> params,
    Function errorCallBack,
    CancelToken token,
    Options options,
  }) async {
    await _request(
      url,
      callBack,
      method: GET,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
      options: options,
    );
  }

  delete(
    String url,
    Function callBack, {
    Map<String, dynamic> params,
    Function errorCallBack,
    CancelToken token,
    Options options,
  }) async {
    await _request(
      url,
      callBack,
      method: DELETE,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
      options: options,
    );
  }

  post(
    String url,
    Function callBack, {
    Map<String, dynamic> params,
    Function errorCallBack,
    CancelToken token,
    Options options,
  }) async {
    await _request(
      url,
      callBack,
      method: POST,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
      options: options,
    );
  }

  put(
    String url,
    Function callBack, {
    Map<String, dynamic> params,
    Function errorCallBack,
    CancelToken token,
    Options options,
  }) async {
    await _request(
      url,
      callBack,
      method: PUT,
      params: params,
      errorCallBack: errorCallBack,
      token: token,
      options: options,
    );
  }

  postUpload(
    String url,
    Function callBack,
    ProgressCallback progressCallBack, {
    FormData formData,
    Function errorCallBack,
    CancelToken token,
    Options options,
  }) async {
    await _request(
      url,
      callBack,
      method: POST,
      formData: formData,
      errorCallBack: errorCallBack,
      progressCallBack: progressCallBack,
      token: token,
      options: options,
    );
  }

  _request(
    String url,
    Function callBack, {
    String method,
    Map<String, dynamic> params,
    FormData formData,
    Function errorCallBack,
    ProgressCallback progressCallBack,
    CancelToken token,
    Options options,
  }) async {
    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }
    if (options == null) options = Options();

    int statusCode;
    try {
      Response response;
      if (method == GET) {
        options.method = "GET";
        if (params != null && params.isNotEmpty) {
          response = await _client.get(
            url,
            queryParameters: params,
            cancelToken: token,
            options: options,
          );
        } else {
          response = await _client.get(
            url,
            cancelToken: token,
            options: options,
          );
        }
      } else if (method == POST) {
        options.method = "POST";
        if (params != null && params.isNotEmpty) {
          response = await _client.post(
            url,
            data: formData ?? params,
            onSendProgress: progressCallBack,
            cancelToken: token,
            options: options,
          );
        } else {
          response = await _client.post(
            url,
            cancelToken: token,
            options: options,
          );
        }
      } else if (method == PUT) {
        options.method = "PUT";
        if (params != null && params.isNotEmpty) {
          response = await _client.put(
            url,
            data: formData ?? params,
            onSendProgress: progressCallBack,
            cancelToken: token,
            options: options,
          );
        } else {
          response = await _client.post(
            url,
            cancelToken: token,
            options: options,
          );
        }
      } else if (method == DELETE) {
        options.method = "DELETE";
        if (params != null && params.isNotEmpty) {
          response = await _client.delete(
            url,
            queryParameters: params,
            cancelToken: token,
            options: options,
          );
        } else {
          response = await _client.delete(
            url,
            cancelToken: token,
            options: options,
          );
        }
      }

      statusCode = response.statusCode;

      if (statusCode != 200) {
        _handError(errorCallBack, statusCode.toString());
        return;
      }

      if (callBack != null) {
        callBack(response.data);
      }
    } catch (e) {
      _handError(errorCallBack, e.toString());
    }
  }

  //处理异常
  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }
}
