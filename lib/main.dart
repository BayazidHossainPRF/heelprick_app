import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heel_prick_blood_collection/controllers/growth_and_outcome_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/infant_controller.dart';
import 'controllers/pending_infant_controller.dart';
import 'controllers/server_query_controller copy.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/theme.dart';

void main() {
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => InfantController(), fenix: true);
  Get.lazyPut(() => PendingInfantController(), fenix: true);
  Get.lazyPut(() => GrowthAndOutcomeController(), fenix: true);
  Get.lazyPut(() => ServerQueryController(), fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Multi-Omics Study',
      theme: AppTheme.darkThemeMode,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
