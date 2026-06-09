import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatefulWidget {
  final List<String> options;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final String? Function(String?)? validator; // 👈 ADD THIS
  final Function()? onChanged;

  const CustomDropdownWidget({
    super.key,
    required this.options,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomDropdownWidget> createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          isExpanded: true,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          value: widget.options.contains(widget.controller.text)
              ? widget.controller.text
              : null,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          style: const TextStyle(fontSize: 13),

          // ✅ VALIDATOR HERE
          validator: widget.validator,

          onChanged: (String? newValue) {
            setState(() {
              widget.controller.text = newValue ?? '';
            });

            if (widget.onChanged != null) {
              widget.onChanged!();
            }
          },
          items: widget.options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value.split('(').first,
                style: TextStyle(fontSize: 18, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
