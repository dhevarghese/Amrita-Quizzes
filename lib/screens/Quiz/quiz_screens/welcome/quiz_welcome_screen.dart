import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/Quiz/quiz_screens/quiz/quiz_screen.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatelessWidget {

  final String password;

   WelcomeScreen ({ Key key, this.password }): super(key: key);


  var _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ,
      body: Form(
        key: _formKey,
        child: Stack(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2), //2/6
                  Text(
                    "Welcome!",
                    style: Theme.of(context).textTheme.headline4.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text("Enter the quiz credentials below"),
                  Spacer(), // 1/6
                  TextFormField(
                    validator: (String value) {
                      if (value.isEmpty || value.isBlank){
                        return Strings.invalidPasswordEmpty;
                      }else if(this.password.compareTo(value) != 0){
                        return Strings.incorrectPassword;
                      }
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      //filled: true,
                      fillColor: Color(0x272041),
                      errorStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  Spacer(), // 1/6
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState.validate()){
                        Get.to(QuizScreen());
                      }
                      },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
                          //colors: [Color(0x1B1429), Color(0x1B1429)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Lets Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}