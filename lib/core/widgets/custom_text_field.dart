import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final int? maxLines;
  final String? imagePath;
  final bool isOptional;
  final Function(String)? onFormSubmitted;
  final Function()? onTap;
  final Function(String)? onChanged;
  final bool enabled;
  final TextStyle? textStyle;
  final TextInputType? keybordType;
  final String? prefixText;
  final Widget? prefixIcon;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isOptional = false,
    this.maxLines,
    this.imagePath,
    this.onFormSubmitted,
    this.onTap,
    this.onChanged,
    this.enabled = true,
    this.textStyle,
    this.keybordType,
    this.prefixText,
    this.prefixIcon,
    
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines ?? 1,
          onTap: onTap,
          onChanged: onChanged,
          enabled: enabled,
          style: textStyle,
          keyboardType: keybordType,
          // obscureText: false,
          
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            // labelText: labelText,
            hintText: hintText,
            // hintStyle: null,
            prefixIcon: prefixIcon,
            focusColor: AppPallete.primary,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.8),
            prefixText: prefixText,
            // filled: true,
            // fillColor: AppPallete.white,
          ),

          validator: (value) {
            if (isOptional) {
              return null;
            }
            if (value!.isEmpty) {
              return '$labelText is required.';
            }
            return null;
          },
          onFieldSubmitted: onFormSubmitted,
        ),
      ],
    );
  }
}
