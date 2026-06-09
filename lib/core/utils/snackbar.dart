import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Snackbar {
  static void show({
    required String title,
    required String message,
    Color? backgroundColor,
    int durationInSecond = 3,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSecond),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void show_s({
    required String message,
    Color backgroundColor = Colors.green,
    int durationInSecond = 3,
  }) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSecond),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void show_e({
    required String message,
    Color backgroundColor = Colors.red,
    int durationInSecond = 3,
  }) {
    Get.snackbar(
      'Errpr',
      message,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: durationInSecond),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
