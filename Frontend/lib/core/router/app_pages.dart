import 'package:taskflow/features/task_details/views/task_details_screen.dart';
import 'package:taskflow/features/task_details/bindings/task_details_bindings.dart';
import 'package:taskflow/features/tasks/views/tasks_screen.dart';
import 'package:taskflow/features/tasks/bindings/tasks_bindings.dart';
import 'package:taskflow/core/router/app_routes.dart';

import 'package:taskflow/features/splash/views/splash_screen.dart';
import 'package:get/get.dart';

class AppPages {
  const AppPages._();

  static const initialRoute = Routes.splashScreen;

  static final List<GetPage> pages = [
    GetPage(name: Routes.splashScreen, page: () => const SplashScreen()),

    GetPage(
      name: Routes.tasksScreen,
      page: () => const TasksScreen(),
      binding: TasksBindings(),
    ),
    GetPage(
      name: Routes.taskDetailsScreen,
      page: () => TaskDetailsScreen(),
      binding: TaskDetailsBindings(),
    ),
  ];
}
