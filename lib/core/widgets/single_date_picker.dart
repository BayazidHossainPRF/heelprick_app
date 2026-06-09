import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SingleDateTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  final bool isCleanable;
  final bool isEnable;
  final bool isHidden;
  final void Function()? callback;
  final DateTime? firstDate;

  const SingleDateTimePicker({
    super.key,
    required this.controller,
    required this.text,
    this.validator,
    this.isCleanable = false,
    this.isEnable = true,
    this.isHidden = false,
    this.callback,
    this.firstDate,
  });

  @override
  State<SingleDateTimePicker> createState() => _SingleDateTimePickerState();
}

class _SingleDateTimePickerState extends State<SingleDateTimePicker> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) {
        errorText = state.errorText;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorText != null ? Colors.red : Colors.grey,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.controller.text != ''
                                    ? '${widget.text} :'
                                    : '${widget.text} ?',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              widget.controller.text != ''
                                  ? widget.isHidden
                                        ? '** *** ****'
                                        : ' ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.controller.text))}'
                                  : '',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (widget.isCleanable)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              widget.controller.text = '';
                            });
                          },
                          icon: Icon(Icons.cancel),
                        ),
                    ],
                  ),
                  onTap: widget.isEnable
                      ? () async {
                          DateTime? selectedDate;

                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: widget.firstDate ?? DateTime(2024),
                            lastDate: DateTime(2031),
                          );

                          if (pickedDate != null) {
                            widget.controller.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);

                            setState(() {});
                            if (widget.callback != null) {
                              widget.callback!();
                            }
                            state.didChange(widget.controller.text);
                          }
                        }
                      : null,
                ),
              ),
            ),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
