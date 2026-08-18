import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPinInputWidget extends StatefulWidget {
  const CustomPinInputWidget({super.key});

  @override
  CustomPinInputWidgetState createState() => CustomPinInputWidgetState();
}

class CustomPinInputWidgetState extends State<CustomPinInputWidget> {
  final int pinLength = 5;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(pinLength, (_) => TextEditingController());
    _focusNodes = List.generate(pinLength, (i) {
      return FocusNode(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[i].text.isEmpty &&
              i > 0) {
            _focusNodes[i - 1].requestFocus();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
      );
    });
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  void _onChanged(String value, int index) {
  //  print('+-+ $value, ____ $index +-+');
    if (value.isNotEmpty && index < pinLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (index == pinLength - 1 && value.isNotEmpty) {
      FocusScope.of(context).unfocus(); // all filled
    }
  }

  String getPin() {
    return _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pinLength, (index) {
        return Expanded(
          child: Container(
            // width: 50,
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: InputDecoration(
                counterText: '',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                try {
                  int.parse(value);
                } catch (e) {
                  // if (value.isNotEmpty) {
                  //   showSnackBar(
                  //     context: context,
                  //     text: '$value is not a number. Pin should be numbers.',
                  //     color: AppPallete.dangerColor,
                  //   );
                  // }
                  _controllers[index].text = '';
                  return;
                }
                _onChanged(value, index);
              },
            ),
          ),
        );
      }),
    );
  }
}
