import 'package:taskflow/core/bindings/initial_bindings.dart';
import 'package:taskflow/core/consts/theme.dart';
import 'package:taskflow/core/router/app_pages.dart';
import 'package:taskflow/core/services/current_user.dart';
import 'package:taskflow/core/services/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDb().init();
  CurrentUser().init();

  runApp(const Taskflow());
}

class Taskflow extends StatelessWidget {
  const Taskflow({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        getPages: AppPages.pages,
        initialRoute: AppPages.initialRoute,
        initialBinding: InitialBindings(),
        theme: AppThemes.lightMode,
      ),
    );
  }
}
