import 'package:flutter/material.dart';

class CustomSubmitButtonWithIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color loadingColor;
  final double width;
  final double height;

  const CustomSubmitButtonWithIcon({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.text,
    required this.icon,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.loadingColor = Colors.white,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                ),
              )
            : Icon(icon, color: textColor),
        label: isLoading
            ? Text(
                'Submitting...',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
        ),
      ),
    );
  }
}
