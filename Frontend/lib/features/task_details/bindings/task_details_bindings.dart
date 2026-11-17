import 'package:taskflow/features/task_details/controllers/task_details_controller.dart';
import 'package:taskflow/features/task_details/repositories/task_details_repository.dart';
import 'package:get/get.dart';

class TaskDetailsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(TaskDetailsRepository());
    Get.put(TaskDetailsController());
  }
}
