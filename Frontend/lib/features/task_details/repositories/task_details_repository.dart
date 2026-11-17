import 'package:taskflow/core/network/api_client.dart';
import 'package:get/get.dart';

class TaskDetailsRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<void> toggleTask(String taskId) async {
    await apiClient.patch('/tasks/$taskId/toggle');
  }
}
