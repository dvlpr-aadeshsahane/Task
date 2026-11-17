abstract class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class NoInternetException<T> extends AppException {
  const NoInternetException({this.response})
    : super(message: 'No internet connection. Please try again.');

  final T? response;
}

class ApiException extends AppException {
  const ApiException({
    required super.message,
    super.statusCode,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;
}
