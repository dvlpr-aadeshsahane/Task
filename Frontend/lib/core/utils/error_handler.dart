import 'package:taskflow/core/consts/services.dart';
import 'package:taskflow/core/network/api_exception.dart';
import 'package:taskflow/core/utils/app_snackbar.dart';
import 'package:flutter/foundation.dart';

void errorHandler(
  Object e, {
  StackTrace? stackTrace,
  bool snackbar = true,
  bool log = false,
}) {
  if (e is AppException) {
    if (kDebugMode && log) {
      logger.e(e.message, stackTrace: stackTrace);
    }
    if (snackbar) {
      AppSnackbar.error(e.message);
    }
  } else {
    if (kDebugMode && log) {
      logger.e(e.toString(), stackTrace: stackTrace);
    }
    if (snackbar) {
      AppSnackbar.error(e.toString());
    }
  }
}
