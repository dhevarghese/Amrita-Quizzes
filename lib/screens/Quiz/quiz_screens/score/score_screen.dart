import 'package:amrita_quizzes/controllers/question_controller.dart';
import 'package:amrita_quizzes/models/Questions.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ScoreScreen extends StatelessWidget {
  QuestionController _qnController = Get.put(QuestionController());
  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return Scaffold(
      //appBar: buildAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          //SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Center(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.purple, Colors.blue])))),
          Positioned(
            left: 25,
            top: 50,
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/back.svg',
                color: Colors.white,
              ),
              onPressed: () {
                int count = 0;
                Navigator.of(context, rootNavigator: true).popUntil((route) {
                  return count++ == 2;
                });
              }
            ),
          ),
          Column(
            children: [

              Spacer(flex: 3),
              Text(
                "Score",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Colors.white),
              ),
              Spacer(),
              updateAndShow(dbs),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );
  }

  Widget updateAndShow(Database dbs) {
    return FutureBuilder<void> (
        future: dbs.uploadQuizScore(quizId, quizName, _qnController.marksObtained, _qnController.totalMarks, _qnController.numOfCorrectAns, answerIndexes),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          else {
            return Text(
                "${_qnController.marksObtained}/${_qnController.totalMarks}",
                style: Theme
                    .of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Colors.white),
            );
          }
        }
    );
  }
}