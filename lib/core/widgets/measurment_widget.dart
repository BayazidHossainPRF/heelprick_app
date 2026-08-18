import 'package:flutter/material.dart';
import '../../../core/utils/validators.dart';
import '../../views/user_home/presentation/widgets/question_container_widget.dart';

class MeasurmentWidget extends StatefulWidget {
  final String title;
  final String hintText;
  final int maxLength;
  final TextEditingController reading1Controller;
  final TextEditingController reading2Controller;
  final TextEditingController finalController;
  final VoidCallback? onChanged;
  final double differenceLimit;
  final bool isDouble;
  final String? suffixText;
  const MeasurmentWidget({
    super.key,
    required this.title,
    required this.hintText,
    required this.maxLength,
    required this.reading1Controller,
    required this.reading2Controller,
    required this.finalController,
    this.differenceLimit = 0.5,
    this.onChanged,
    this.isDouble = false,
    this.suffixText,
  });

  @override
  State<MeasurmentWidget> createState() => _MeasurmentWidgetState();
}

class _MeasurmentWidgetState extends State<MeasurmentWidget> {
  @override
  Widget build(BuildContext context) {
    return QuestionContainerWidget(
      question: widget.title,
      answer: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: QuestionContainerWidget(
                  question: 'Reading 1',
                  answer: TextFormField(
                    controller: widget.reading1Controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      suffixText: widget.suffixText,
                    ),
                    maxLength: widget.maxLength,
                    keyboardType: TextInputType.number,
                    onChanged: (value) async {
                      await averageCalculate();
                      setState(
                        () {},
                      ); // Trigger validation of Reading 1 when Reading 2 changes
                      widget.onChanged?.call();
                    },
                    validator: (value) {
                      if (widget.reading1Controller.text.isNotEmpty &&
                          widget.reading2Controller.text.isNotEmpty) {
                        double r1 =
                            double.tryParse(widget.reading1Controller.text) ??
                            0;
                        double r2 =
                            double.tryParse(widget.reading2Controller.text) ??
                            0;
                        if ((r1 - r2).abs() > widget.differenceLimit) {
                          return '${widget.differenceLimit} এর বেশি পার্থক্য গ্রহণযোগ্য নয়';
                        }
                      }
                      return widget.isDouble
                          ? Validators.doubleValidator(value)
                          : Validators.numberValidator(value);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: QuestionContainerWidget(
                  question: 'Reading 2',
                  answer: TextFormField(
                    controller: widget.reading2Controller,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      suffixText: widget.suffixText,
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: widget.maxLength,
                    onChanged: (value) async {
                      await averageCalculate();
                      setState(
                        () {},
                      ); // Trigger validation of Reading 1 when Reading 2 changes
                      widget.onChanged?.call();
                    },
                    validator: widget.isDouble
                        ? Validators.doubleValidator
                        : Validators.numberValidator,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: QuestionContainerWidget(
                  question: 'Final (Auto-calculated)',
                  answer: Text(
                    widget.finalController.text.isEmpty
                        ? '--'
                        : widget.finalController.text,
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      isColumn: true,
    );
  }

  Future<void> averageCalculate() async {
    if (widget.isDouble) {
      widget.finalController.text =
          (((double.tryParse(widget.reading1Controller.text) ?? 0.0) +
                      (double.tryParse(widget.reading2Controller.text) ??
                          0.0)) /
                  2)
              .toStringAsFixed(1);
    } else {
      widget.finalController.text =
          (((double.tryParse(widget.reading1Controller.text) ?? 0.0) +
                      (double.tryParse(widget.reading2Controller.text) ??
                          0.0)) /
                  2)
              .toInt()
              .toString();
    }
  }
}
