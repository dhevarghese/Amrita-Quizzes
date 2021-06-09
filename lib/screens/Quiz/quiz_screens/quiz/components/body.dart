import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/controllers/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // So that we have acccess our controller
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
        //SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        Center(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.purple, Colors.blue])))),

        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                      () => Text.rich(
                    TextSpan(
                      text:
                      "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "/${_questionController.questions.length} (${_questionController.questions[_questionController.questionNumber.value - 1].mark} marks)",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questionController.questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                      question: _questionController.questions[index]),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}