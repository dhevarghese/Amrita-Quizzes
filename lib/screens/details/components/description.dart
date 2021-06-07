import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';

class Description extends StatelessWidget {
  const Description({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        quizInfo.description,
        style: TextStyle(height: 1.5),
      ),
    );
  }
}
