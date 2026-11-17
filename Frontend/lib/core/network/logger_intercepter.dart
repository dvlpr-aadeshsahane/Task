import 'package:dio/dio.dart';
import 'package:taskflow/core/consts/services.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final data = {
      'API': '[${options.method}] -> ${options.uri}',
      'payload': options.data ?? {},
    };

    logger.d(data);
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = {
      'API':
          '[${response.statusCode}] <- ${response.requestOptions.method} ${response.requestOptions.uri}',
      'data': response.data,
    };

    logger.d(data);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = {
      'API':
          '[${err.response?.statusCode ?? 'NO_STATUS'}] <- ${err.requestOptions.method} ${err.requestOptions.uri}',
      "RESPONSE": err.response?.data ?? {},
    };

    logger.d(data);

    handler.next(err);
  }
}
