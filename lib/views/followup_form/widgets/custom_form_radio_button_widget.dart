import 'package:flutter/material.dart';

import '../../../core/theme/app_pallete.dart';
import '../../../core/utils/data_type/number_controller.dart';
import '../../../core/widgets/custom_text_form_field_with_label_widget.dart';
import '../../user_home/presentation/widgets/question_container_widget.dart';

class MyFormRadoButton extends FormField<int> {
  final String title;
  final Map<int, String> options;
  final NumberController controller;
  final bool? isColumn;
  final bool isColumnOptions;
  final VoidCallback? callback;
  final int? specifyKey;
  final TextEditingController? specifyController;
  final int? specifyMaxLength;
  final String? Function(String?)? specifyValidator;
  final bool isEnable;

  MyFormRadoButton({
    super.key,
    required this.title,
    required this.options,
    required this.controller,
    this.isColumn,
    this.isColumnOptions = false,
    this.callback,
    this.specifyKey,
    this.specifyController,
    this.specifyMaxLength,
    this.specifyValidator,
    this.isEnable = true,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool autovalidate = false,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
  }) : super(
         builder: (FormFieldState<int> field) {
           return _MyRadoButtonWidget(
             field: field,
             title: title,
             options: options,
             controller: controller,
             isColumn: isColumn,
             isColumnOptions: isColumnOptions,
             callback: callback,
             specifyKey: specifyKey,
             specifyController: specifyController,
             specifyMaxLength: specifyMaxLength,
             specifyValidator: specifyValidator,
             isEnable: isEnable,
             autovalidateMode: autovalidateMode,
           );
         },
       );
}

class _MyRadoButtonWidget extends StatefulWidget {
  final FormFieldState<int> field;
  final String title;
  final Map<int, String> options;
  final NumberController controller;
  final bool? isColumn;
  final bool isColumnOptions;
  final VoidCallback? callback;
  final int? specifyKey;
  final TextEditingController? specifyController;
  final int? specifyMaxLength;
  final String? Function(String?)? specifyValidator;
  final AutovalidateMode autovalidateMode;
  final bool isEnable;

  const _MyRadoButtonWidget({
    required this.field,
    required this.title,
    required this.options,
    required this.controller,
    this.isColumn,
    required this.isColumnOptions,
    this.callback,
    this.specifyKey,
    this.specifyController,
    this.specifyMaxLength,
    this.specifyValidator,
    required this.autovalidateMode,
    this.isEnable = true,
  });

  @override
  State<_MyRadoButtonWidget> createState() => __MyRadoButtonWidgetState();
}

class __MyRadoButtonWidgetState extends State<_MyRadoButtonWidget> {
  bool isSpecifySectionShow = false;
  final GlobalKey<FormFieldState<String>> _specifyFieldKey =
      GlobalKey<FormFieldState<String>>();

  @override
  void initState() {
    super.initState();
    // Initialize controller value with initial value from form field
    if (widget.field.value != null) {
      widget.controller.value = widget.field.value ?? -1;

      // Check if we need to show specify section based on initial value
      if (widget.field.value == widget.specifyKey &&
          widget.specifyController != null) {
        isSpecifySectionShow = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return QuestionContainerWidget(
      question: widget.title,
      answer: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isColumnOptions
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: _getChildren(),
                )
              : Wrap(spacing: 8, runSpacing: 8, children: _getChildren()),

          // Specify field (conditionally shown)
          if (isSpecifySectionShow && widget.specifyController != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: FormField<String>(
                key: _specifyFieldKey,
                initialValue: widget.specifyController?.text ?? '',
                validator: (value) {
                  // Only validate if specify field is shown and validator is provided
                  if (widget.specifyValidator != null) {
                    return widget.specifyValidator!(value);
                  }
                  return null;
                },
                autovalidateMode: widget.autovalidateMode,
                builder: (FormFieldState<String> specifyField) {
                  return CustomTextFormFieldWithLabelWidget(
                    hintText: 'specify other.',
                    labelText: 'Specify',
                    controller: widget.specifyController!,
                    maxLength: widget.specifyMaxLength,
                    onChanged: (value) {
                      specifyField.didChange(value);
                      if (widget.autovalidateMode ==
                          AutovalidateMode.onUserInteraction) {
                        specifyField.validate();
                      }
                    },
                    errorText: specifyField.errorText,
                  );
                },
              ),
            ),

          // Show error message from the main form field (radio button)
          if (widget.field.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0),
              child: Text(
                widget.field.errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getChildren() {
    return widget.options.entries.map((e) {
      final isSelected = widget.controller.value == e.key;

      return InkWell(
        onTap: widget.isEnable
            ? () {
                final previousValue = widget.controller.value;

                // Update controller value
                widget.controller.value = e.key;

                // Handle specify section visibility
                if (widget.specifyController != null &&
                    e.key == widget.specifyKey) {
                  setState(() {
                    isSpecifySectionShow = true;
                  });
                } else {
                  if (widget.specifyController != null) {
                    widget.specifyController!.clear();
                    _specifyFieldKey.currentState?.reset();
                  }
                  setState(() {
                    isSpecifySectionShow = false;
                  });
                }

                // Update form field value
                widget.field.didChange(e.key);

                // Validate both fields if auto-validation is enabled
                if (widget.autovalidateMode ==
                    AutovalidateMode.onUserInteraction) {
                  widget.field.validate();
                  if (isSpecifySectionShow) {
                    _specifyFieldKey.currentState?.validate();
                  }
                }

                // Trigger callback if value changed
                if (widget.callback != null && previousValue != e.key) {
                  widget.callback!();
                }
              }
            : null,
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

  @override
  void dispose() {
    // Don't dispose the controller here as it's managed externally
    super.dispose();
  }
}
