import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.quiz_info,
  }) : super(key: key);

  final Quiz quiz_info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        quiz_info.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
