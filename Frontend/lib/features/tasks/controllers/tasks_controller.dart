import 'package:taskflow/core/utils/error_handler.dart';
import 'package:taskflow/core/network/api_exception.dart';
import 'package:taskflow/features/tasks/models/task.dart';
import 'package:taskflow/features/tasks/repositories/tasks_repository.dart';
import 'package:get/get.dart';

class TasksController extends GetxController {
  final TasksRepository repository = Get.find();

  RxBool isLoading = false.obs;

  RxList<Task> tasks = <Task>[].obs;

  Rxn<String> assigned = Rxn();
  Rxn<String> status = Rxn();
  RxBool isSubmitting = false.obs;
  RxSet<String> togglingTaskIds = <String>{}.obs;
  RxnString loadError = RxnString();
  RxnString submissionError = RxnString();
  RxMap<String, String> submissionFieldErrors = <String, String>{}.obs;

  int get totalTasks => tasks.length;
  int get completedTasks =>
      tasks.where((task) => task.completed == true).length;
  int get activeTasks => totalTasks - completedTasks;

  @override
  onInit() {
    super.onInit();
    getAllTasks();

    ever(assigned, (value) {
      getAllTasks();
    });

    ever(status, (value) {
      getAllTasks();
    });
  }

  Future<void> getAllTasks() async {
    isLoading.value = true;
    loadError.value = null;
    try {
      final fetchedTasks = await repository.getAllTasks(
        assignee: assigned.value,
        status: status.value,
      );
      fetchedTasks.sort(
        (a, b) =>
            _priorityRank(a.priority).compareTo(_priorityRank(b.priority)),
      );
      tasks.assignAll(fetchedTasks);
    } catch (e) {
      loadError.value = _messageFor(e);
      errorHandler(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addTask({
    required String title,
    String? description,
    String? dueDate,
    required String priority,
    required String assignedId,
  }) async {
    isSubmitting.value = true;
    submissionError.value = null;
    submissionFieldErrors.clear();
    try {
      await repository.addTask(
        title: title,
        description: description,
        dueDate: dueDate,
        priorty: priority,
        assignedID: assignedId,
      );
      await getAllTasks();
      return true;
    } catch (e) {
      if (e is ApiException) {
        submissionFieldErrors.assignAll(e.fieldErrors);
      }
      submissionError.value = _messageFor(e);
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> toggleTask(Task task) async {
    final id = task.id;
    if (id == null || togglingTaskIds.contains(id)) return;
    togglingTaskIds.add(id);
    final previousValue = task.completed ?? false;
    task.completed = !previousValue;
    tasks.refresh();
    try {
      await repository.toggleTask(id);
    } catch (e) {
      task.completed = previousValue;
      tasks.refresh();
      errorHandler(e);
    } finally {
      togglingTaskIds.remove(id);
    }
  }

  void clearFilters() {
    assigned.value = null;
    status.value = null;
  }

  void clearSubmissionError() {
    submissionError.value = null;
    submissionFieldErrors.clear();
  }

  String _messageFor(Object error) {
    if (error is AppException) return error.message;
    return error.toString().replaceFirst('Exception: ', '');
  }

  int _priorityRank(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'high':
        return 0;
      case 'medium':
        return 1;
      case 'low':
        return 2;
      default:
        return 3;
    }
  }
}
