import 'package:taskflow/features/tasks/controllers/tasks_controller.dart';
import 'package:taskflow/features/tasks/repositories/tasks_repository.dart';
import 'package:get/get.dart';

class TasksBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TasksRepository());
    Get.put(TasksController());
  }
}
