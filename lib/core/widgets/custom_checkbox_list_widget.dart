import 'package:flutter/cupertino.dart';
import '../utils/data_type/bool_controller.dart';
import 'custom_checkbox_widget.dart';
import 'utils/field_properties.dart';

class CustomCheckboxListWidget extends StatefulWidget {
  final FieldProperties fieldProperties;
  final List<BoolController> controller;
  final bool isEnable;

  const CustomCheckboxListWidget({
    super.key,
    required this.fieldProperties,
    required this.controller,
    this.isEnable=true,
  });

  @override
  State<CustomCheckboxListWidget> createState() =>
      _CustomCheckboxListWidgetState();
}

class _CustomCheckboxListWidgetState extends State<CustomCheckboxListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.fieldProperties.label.toString(),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.fieldProperties.listItems?.length,
            itemBuilder: (context, index) => CustomCheckboxWidget(
              text: widget.fieldProperties.listItems![index].name,
              controller: widget.controller[index],
              isEnable: widget.isEnable,
            ),
          ),
        ],
      ),
    );
  }
}
