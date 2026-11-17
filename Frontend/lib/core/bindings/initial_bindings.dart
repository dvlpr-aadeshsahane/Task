import 'package:taskflow/core/network/api_client.dart';
import 'package:get/get.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiClient());
  }
}
