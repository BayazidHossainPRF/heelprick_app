import 'package:flutter/material.dart';

class SingleTimePicker extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String? Function(String?)? validator;
  final bool isCleanable;
  final bool isEnable;
  final bool isHidden;
  final void Function()? callback;
  final TimeOfDay? initialTime;

  const SingleTimePicker({
    super.key,
    required this.controller,
    required this.text,
    this.validator,
    this.isCleanable = false,
    this.isEnable = true,
    this.isHidden = false,
    this.callback,
    this.initialTime,
  });

  @override
  State<SingleTimePicker> createState() => _SingleTimePickerState();
}

class _SingleTimePickerState extends State<SingleTimePicker> {
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
                                      ? '**:** **'
                                      : _formatTime(widget.controller.text)
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
                              state.didChange('');
                            });
                          },
                          icon: const Icon(Icons.cancel),
                        ),
                    ],
                  ),
                  onTap: widget.isEnable
                      ? () async {
                          TimeOfDay? selectedTime = widget.initialTime ?? TimeOfDay.now();
                          
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );

                          if (pickedTime != null) {
                            widget.controller.text = _formatTimeOfDay(pickedTime);
                            
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

  String _formatTime(String timeString) {
    try {
      // Parse time string in format "HH:mm"
      final parts = timeString.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);
        return timeOfDay.format(context);
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}