
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class ErrorInterceptors extends InterceptorsWrapper {
  final Dio _dio;

  ErrorInterceptors(this._dio);

  @override
  onRequest(RequestOptions options) async {
    // Out of service
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      print("Network Error");
      return _dio.resolve(Response(data: -1));
    }
    return options;
  }
}