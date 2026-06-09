import 'package:flutter/widgets.dart';

class ScaffoldBodyBackground extends StatelessWidget {
  final Widget body;
  const ScaffoldBodyBackground({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 208, 244), // Blue
            Color.fromARGB(255, 6, 0, 90), // Purple
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: body,
    );
  }
}
