import 'package:amrita_quizzes/models/Quiz.dart';
//import 'package:quiz_app/screens/welcome/welcome_screen.dart';
import 'package:amrita_quizzes/screens/Quiz/quiz_screens/welcome/quiz_welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';

//void main() {
//runApp(MyApp());
//}

class QuizMain extends StatelessWidget {
  const QuizMain({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;
  // This widget is the root of your application.
  /*
  Provider<Data>(
      create: (_) => Something(),
      child: Level2 (
         // stuff of level 2
      ),
    ),
   */
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      //title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home:  Provider<Quiz>(
        create: (_) => quizInfo,
        child: WelcomeScreen (quizInfo: quizInfo),
      ),
    );
  }
}