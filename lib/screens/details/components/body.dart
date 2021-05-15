import 'package:amrita_quizzes/constants/color_constants.dart';
//import 'package:amrita_quizzes/models/Quiz_info.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:flutter/material.dart';

import 'creator_and_timings.dart';
//import 'counter_with_fav_btn_temp.dart';
import 'description.dart';
import 'quiz_title_with_image.dart';
import 'take_up_quiz_button.dart';

class Body extends StatelessWidget {
  final Quiz quizInfo;

  const Body({Key key, this.quizInfo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // It provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: size.height * 0.3),
                  padding: EdgeInsets.only(
                    top: size.height * 0.12,
                    left: kDefaultPaddin,
                    right: kDefaultPaddin,
                  ),
                  // height: 500,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      CreatorAndTimings(quizInfo: quizInfo),
                      SizedBox(height: kDefaultPaddin / 2),
                      Description(quizInfo: quizInfo),
                      SizedBox(height: kDefaultPaddin / 2),
                      TakeUpQuiz(quizInfo: quizInfo)
                    ],
                  ),
                ),
                QuizTitleWithImage(quizInfo: quizInfo)
              ],
            ),
          )
        ],
      ),
    );
  }
}
