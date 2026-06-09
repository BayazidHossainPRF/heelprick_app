import 'package:flutter/material.dart';

void showLoader({
  required BuildContext context,
  String title = 'Please wait...',
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Container(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}
