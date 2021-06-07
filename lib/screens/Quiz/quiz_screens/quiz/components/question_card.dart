import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/controllers/question_controller.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'option.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    Key key,
    // it means we have to pass this
    @required this.question,
  }) : super(key: key);

  final Question question;
  List<Question> questionsList = [];


  @override
  Widget build(BuildContext context) {
    //final dbs = Provider.of<Body>(context);
    //print("hey in line 25 q_card");
    //print(question);
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: kBlackColor),
          ),
          SizedBox(height: kDefaultPadding / 2),
          SingleChildScrollView(
              child: Column(
                children: [
                  ...List.generate(
                    question.options.length,
                        (index) => Option(
                      index: index,
                      text: question.options[index],
                      press: () => _controller.checkAns(question, index),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}