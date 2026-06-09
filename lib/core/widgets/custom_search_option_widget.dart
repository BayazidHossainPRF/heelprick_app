import 'package:flutter/material.dart';

class CustomSearchOptionWidget extends StatelessWidget {
  final TextEditingController controller;

  // final Function(String) onFieldSubmitted;
  final Function(String) onChanged;
  final String hintText;

  const CustomSearchOptionWidget({
    required this.controller,
    required this.onChanged,
    // required this.onFieldSubmitted,
    this.hintText = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      margin: EdgeInsets.all(8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(7)),
        border: Border.all(color: Colors.green, width: 1.1),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        onFieldSubmitted: onChanged,
        onChanged: onChanged,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black.withValues(alpha: 0.6),
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black.withValues(alpha: 0.6),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
            bottom: 15,
          ),
        ),
      ),
    );
  }
}
