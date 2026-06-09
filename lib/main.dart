import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/infant_controller.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/theme.dart';

void main() {
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => HomeController(), fenix: true);
  Get.lazyPut(() => InfantController(), fenix: true);
  // Get.lazyPut(() => ScreeningController(), fenix: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Multi-Omics for Mothers and Infants(MOMI)',
      theme: AppTheme.darkThemeMode,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}