import 'package:taskflow/features/task_details/repositories/task_details_repository.dart';
import 'package:get/get.dart';
import 'package:taskflow/core/utils/error_handler.dart';
import 'package:taskflow/features/tasks/models/task.dart';

class TaskDetailsController extends GetxController {
  final TaskDetailsRepository repository = Get.find();

  final Rxn<Task> task = Rxn<Task>();
  final RxBool isToggling = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Task) task.value = Get.arguments as Task;
  }

  Future<void> toggleStatus() async {
    final currentTask = task.value;
    final id = currentTask?.id;
    if (currentTask == null || id == null || isToggling.value) return;

    isToggling.value = true;
    final previousValue = currentTask.completed ?? false;
    currentTask.completed = !previousValue;
    task.refresh();
    try {
      await repository.toggleTask(id);
    } catch (e) {
      currentTask.completed = previousValue;
      task.refresh();
      errorHandler(e);
    } finally {
      isToggling.value = false;
    }
  }
}
