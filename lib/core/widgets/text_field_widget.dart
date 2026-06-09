import 'package:flutter/cupertino.dart';

import 'utils/field_properties.dart';

class TextFieldWidget extends StatelessWidget {
  final FieldProperties properties;
  final TextEditingController controller;

  const TextFieldWidget({
    super.key,
    required this.properties,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              properties.label.toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 4),
          Expanded(child: Text(controller.text.trim())),
        ],
      ),
    );
  }
}
