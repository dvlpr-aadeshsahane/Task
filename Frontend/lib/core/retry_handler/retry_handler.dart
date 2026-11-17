import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:taskflow/core/consts/services.dart';
import 'package:get/state_manager.dart';

abstract class RetryGetxController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final List<Future<void> Function()> _pendingRequests = [];

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isRetrying = false;

  @override
  void onInit() {
    super.onInit();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      results,
    ) {
      logger.d('Connectivity changed: $results');

      if (_hasConnection(results)) {
        retryPendingRequests();
      }
    });

    _retryIfConnected();
  }

  void addFunctionToRetryQueue(Future<void> Function() callback) {
    if (_pendingRequests.contains(callback)) {
      return;
    }

    _pendingRequests.add(callback);
    logger.d('Adding function to retry queue');

    _retryIfConnected();
  }

  Future<void> retryPendingRequests() async {
    if (_isRetrying || _pendingRequests.isEmpty) return;

    _isRetrying = true;

    try {
      if (!await _isConnected()) return;

      final requests = List<Future<void> Function()>.from(_pendingRequests);
      _pendingRequests.clear();

      for (final request in requests) {
        try {
          await request();
        } catch (e, s) {
          logger.e('Retry request failed', error: e, stackTrace: s);
          addFunctionToRetryQueue(request);
        }
      }

      logger.d('All pending requests retried');
    } finally {
      _isRetrying = false;
    }
  }

  Future<void> _retryIfConnected() async {
    if (await _isConnected()) {
      await retryPendingRequests();
    }
  }

  Future<bool> _isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }
}
