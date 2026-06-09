
import 'package:flutter/material.dart';
import '../theme/app_pallete.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color leftColor;
  final Color rightColor;
  final EdgeInsetsGeometry? padding;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.leftColor = AppPallete.primaryDeep,
    this.rightColor = AppPallete.primaryExtraDeep,
    this.padding = const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [leftColor, rightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        // style: ElevatedButton.styleFrom(
        //   backgroundColor: Colors.transparent,
        //   shadowColor: Colors.transparent,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(8.0),
        //   ),
        // ),
        onTap: onPressed,
        child: Container(
          padding: padding,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              color: AppPallete.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
