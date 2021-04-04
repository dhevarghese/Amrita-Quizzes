import 'package:flutter/material.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz_info.dart';

import 'take_up_quiz_button.dart';
import 'StartTime_and_faculty.dart';
//import 'counter_with_fav_btn_temp.dart';
import 'description.dart';
import 'quiz_title_with_image.dart';

class Body extends StatelessWidget {
  final Quiz_info quiz_info;

  const Body({Key key, this.quiz_info}) : super(key: key);
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
                      ColorAndSize(quiz_info: quiz_info),
                      SizedBox(height: kDefaultPaddin / 2),
                      Description(quiz_info: quiz_info),
                      SizedBox(height: kDefaultPaddin / 2),
                      //CounterWithFavBtn(),
                      SizedBox(height: kDefaultPaddin / 2),
                      AddToCart(quiz_info: quiz_info)
                    ],
                  ),
                ),
                ProductTitleWithImage(quiz_info: quiz_info)
              ],
            ),
          )
        ],
      ),
    );
  }
}
