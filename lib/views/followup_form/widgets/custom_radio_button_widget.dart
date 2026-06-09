import 'package:flutter/material.dart';
import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/data_type/number_controller.dart';
import '../../../core/widgets/custom_text_form_field_with_label_widget.dart';
import '../../user_home/presentation/widgets/question_container_widget.dart';

class MyRadoButton extends StatefulWidget {
  final String title;
  final Map<int, String> options;
  final NumberController controller;
  final bool? isColumn;
  final VoidCallback? callback;
  final int? specifyKey;
  final TextEditingController? specifyController;
  final int? specifyMaxLength;

  const MyRadoButton({
    super.key,
    required this.title,
    required this.options,
    required this.controller,
    this.isColumn,
    this.callback,
    this.specifyKey,
    this.specifyController,
    this.specifyMaxLength,
  });

  @override
  State<MyRadoButton> createState() => _MyRadoButtonState();
}

class _MyRadoButtonState extends State<MyRadoButton> {
  bool isSpecifySectionShow = false;
  @override
  Widget build(BuildContext context) {
    return QuestionContainerWidget(
      question: widget.title,
      answer: Column(
        children: [
          Wrap(spacing: 8, runSpacing: 8, children: _getChildren()),
          if (isSpecifySectionShow)
            CustomTextFormFieldWithLabelWidget(
              hintText: 'specify other.',
              labelText: 'Specify',
              controller: widget.specifyController ?? TextEditingController(),
              maxLength: widget.specifyMaxLength,
            ),
        ],
      ),
    );
  }

  List<Widget> _getChildren() {
    return widget.options.entries.map((e) {
      final isSelected = widget.controller.value == e.key;

      return InkWell(
        onTap: () {
          if (widget.specifyController != null && e.key == widget.specifyKey) {
            isSpecifySectionShow = true;
          } else {
            if (widget.specifyController != null) {
              widget.specifyController!.clear();
            }
            isSpecifySectionShow = false;
          }
          setState(() {
            widget.controller.value = e.key;
          });

          if (widget.callback != null) {
            widget.callback!();
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppPallete.primaryExtraDeep.withValues(alpha: 0.1)
                : AppPallete.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppPallete.primaryExtraDeep
                  : AppPallete.grey.withValues(alpha: 0.3),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppPallete.primaryExtraDeep
                        : AppPallete.grey.withValues(alpha: 0.5),
                    width: 2,
                  ),
                  color: AppPallete.white,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppPallete.primaryExtraDeep,
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  e.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppPallete.primaryExtraDeep
                        : AppPallete.black,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
