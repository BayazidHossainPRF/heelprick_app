import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_pallete.dart'; // for time formatting

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({super.key});

  @override
  State<RealTimeClock> createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock> {
  late String _timeString;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _timeString = _formatTime(DateTime.now());
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm:ss a').format(time); // 12-hour format with AM/PM
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _timeString,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppPallete.primary,
          ),
        ),
        Text(
          DateFormat('EEEE, MMMM d, y').format(DateTime.now()), // e.g., "Monday, January 1, 2024"
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppPallete.primaryDeep,
          ),
        ),
      ],
    );
  }
}
