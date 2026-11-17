import 'package:dio/dio.dart' show Response;
import 'package:get/instance_manager.dart';
import 'package:taskflow/core/network/api_client.dart';
import 'package:taskflow/features/tasks/models/task.dart';

class TasksRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<Task>> getAllTasks({String? assignee, String? status}) async {
    final Map<String, dynamic> queryParams = {};

    if (assignee != null) {
      queryParams['assignee'] = assignee;
    }

    if (status != null) {
      queryParams['status'] = status;
    }

    final Response response = await apiClient.get(
      "/tasks",
      queryParameters: queryParams,
    );
    final List tasks = response.data['data'];
    return tasks.map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> addTask({
    required String title,
    String? description,
    String? dueDate,
    String? priorty,
    String? assignedID,
  }) async {
    final payload = {
      "title": title,
      "description": description,
      "due_date": dueDate,
      "priority": priorty,
      "assignedId": assignedID,
    };
    final Response response = await apiClient.post("/tasks", data: payload);
    final task = response.data['data'];
    return Task.fromJson(task);
  }

  Future<void> toggleTask(String taskId) async {
    await apiClient.patch("/tasks/$taskId/toggle");
  }
}
