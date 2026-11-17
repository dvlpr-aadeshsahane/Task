import 'package:dio/dio.dart';

import 'api_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      handler.next(response);
      return;
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.unknown) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NoInternetException(),
        ),
      );
      return;
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const ApiException(
            message: 'Connection timeout. Please try again.',
            statusCode: 408,
          ),
        ),
      );
      return;
    }

    if (err.response != null) {
      final data = err.response?.data;

      if (data is Map<String, dynamic>) {
        final status = err.response?.statusCode ?? 500;
        final message = data['message'] ?? 'Something went wrong';
        final rawErrors = data['errors'];
        final fieldErrors = <String, String>{};
        if (rawErrors is Map) {
          for (final entry in rawErrors.entries) {
            fieldErrors[entry.key.toString()] = entry.value.toString();
          }
        }

        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            response: err.response,
            error: ApiException(
              message: message.toString(),
              statusCode: status,
              fieldErrors: fieldErrors,
            ),
          ),
        );
        return;
      }
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: const ApiException(
          message: 'Unexpected error occurred',
          statusCode: 500,
        ),
      ),
    );
  }
}
