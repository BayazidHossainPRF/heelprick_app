import 'package:flutter/material.dart';

class QuestionContainerWidget extends StatelessWidget {
  final String question;
  final Widget answer;
  final bool isColumn;
  const QuestionContainerWidget({
    super.key,
    required this.question,
    required this.answer,
    this.isColumn = true,
  });

  @override
  Widget build(BuildContext context) {
    return isColumn
        ? Container(
            margin: EdgeInsets.only(bottom: 16),
            // decoration: BoxDecoration(border: Border.all(width: 2, color: AppPallete.primaryExtraDeep)),
            child: Card(
              // clipBehavior: ,
              color: const Color.fromARGB(255, 238, 248, 248),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const SizedBox(width: 32),
                        Expanded(child: answer),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Card(
              color: const Color.fromARGB(255, 238, 248, 248),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 32),
                          Expanded(child: answer),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
