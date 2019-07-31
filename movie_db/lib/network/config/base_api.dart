import 'package:dio/dio.dart';
import 'package:movie_db/app_config/app_config.dart';

import 'api_config.dart';

class BaseApi {
  Dio dio;
  String _baseUrl;

  BaseApi() {
    _baseUrl = ApiConfig.createConnectionDetail(AppConfig.connectType).baseUrl;
    BaseOptions options = BaseOptions(
        receiveTimeout: 5000, connectTimeout: 5000, baseUrl: _baseUrl);
    dio = Dio(options);
    _setupLoggingInterceptor();
  }

  void _setupLoggingInterceptor() {
    int maxCharactersPerLine = 200;

    dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      print("--> ${options.method} ${options.path}");
      print("Content type: ${options.contentType}");
      print("<-- END HTTP");
      return options; //continue
    }, onResponse: (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response.request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
            (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP"); // continue
    }, onError: (DioError e) {
      // Do something with response error
      return e; //continue
    }));
  }
}
