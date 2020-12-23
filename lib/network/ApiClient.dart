import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'Constant.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class ApiClient {
  static const int CONNECT_TIMEOUT_TIME = 30000;
  static const int RECEIVE_TIMEOUT_TIME = 30000;

  static Dio client;

  static Dio getInstance() {
    if (client == null) {
      client = Dio();
      client.options.baseUrl = Constant.BASE_URL;
      client.options.connectTimeout = CONNECT_TIMEOUT_TIME;
      client.options.receiveTimeout = RECEIVE_TIMEOUT_TIME;
      client.interceptors.add(CookieManager(CookieJar()));
    }
    return client;
  }
}
