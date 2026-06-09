import 'package:flutter/material.dart';

class LoaderWidget {
  static void show({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          AlertDialog(
              backgroundColor: Colors.transparent,
              content: Center(child: CircularProgressIndicator())),
    );
  }
}
