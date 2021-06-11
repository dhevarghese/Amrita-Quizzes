import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/controllers/question_controller.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Option extends StatelessWidget {
  const Option({
    Key key,
    this.text,
    this.index,
    this.press,
  }) : super(key: key);
  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          Color getTheRightColor() {
            if (qnController.isAnswered) {
              //print("answered");
              if (index == answerIndexes[qnController.questionNumber.value-1]) {
                //print("index ansindex");
                //return Colors.lightBlueAccent;
              } if (index == qnController.selectedAns ) {
                return Colors.lightBlueAccent;
              }
            }
            //return kGrayColor;
            return kBlackColor;
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
          }

          return InkWell(
            onTap: press,
            child: Container(
              margin: EdgeInsets.only(top: kDefaultPadding),
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor()),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${index + 1}. $text",
                      style: TextStyle(color: getTheRightColor(), fontSize: 16),
                    ),
                  ),
                  Container(
                    height: 26,
                    width: 26,
                    decoration: BoxDecoration(
                      //color: getTheRightColor() == kGrayColor
                      color: getTheRightColor() == kBlackColor
                          ? Colors.transparent
                          : getTheRightColor(),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: getTheRightColor()),
                    ),
                    //child: getTheRightColor() == kGrayColor
                    child: getTheRightColor() == kBlackColor
                        ? null
                        : Icon(getTheRightIcon(), size: 16),
                  )
                ],
              ),
            ),
          );
        });
  }
}