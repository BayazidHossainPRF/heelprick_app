import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.asset(
                'assets/app_logo.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
            // Text(
            //   'Welcome to FieldScan',
            //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }

  void _getUser() async {
    //   // final accessToken = await Prefs.get(key: UserEnum.access_token.name);
    Future.delayed(Duration(seconds: 3), () {
      //     // Navigate to HomeScree
      //     if (accessToken == '' || accessToken == 'null') {
      Get.offAllNamed(AppRoutes.SIGNINSCREEN); // Navigate to HomeScreen
      //     } else {
      //       Get.offAllNamed(AppRoutes.HOMESCREEN);
      //     }
      //     // Get.offAllNamed(AppRoutes.PHONENUMBERSETSCREEN); // Navigate to HomeScreen
    });
  }
}
