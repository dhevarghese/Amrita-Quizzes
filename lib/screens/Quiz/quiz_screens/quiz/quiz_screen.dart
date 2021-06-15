
import 'package:amrita_quizzes/controllers/question_controller.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:get/get.dart';

import 'components/body.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  QuestionController _controller = Get.put(QuestionController());
  bool alreadyShown = false;

  void showNotif() {
    if (((int.parse(quizDuration) -
        ((_controller.animation.value) * double.parse(quizDuration))) /
        int.parse(quizDuration)) < 0.90) {
      AlertController.show("Time's almost up",
          "You have ${(int.parse(quizDuration) -
              ((_controller.animation.value) * double.parse(quizDuration)))
              .toStringAsFixed(2)} minutes left!", TypeAlert.warning);
      alreadyShown = true;
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (!alreadyShown) showNotif();
    });
  }


  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    showNotif();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Flutter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          FlatButton(
              onPressed: _controller.prevQuestion, child: Text("Previous")),
          FlatButton(onPressed: _controller.nextQuestion, child: Text("Next")),
        ],
      ),
      body: Stack(
        children: [
          Body(),
          DropdownAlert(position: AlertPosition.BOTTOM,)
        ],
      ),
    );
  }
}