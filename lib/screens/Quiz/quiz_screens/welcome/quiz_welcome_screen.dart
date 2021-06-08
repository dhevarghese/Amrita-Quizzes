import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/Quiz/quiz_screens/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({
    Key key,
    @required this.quizInfo,
  }) : super(key: key);

  final Quiz quizInfo;

  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: ,
      body: Stack(
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
                  Navigator.of(context, rootNavigator: true).pop(context);
                }
            ),
          ),
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

                  FormBuilder(
                    key: _formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(name: "qPass",
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0x272041),
                            hintText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            )
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  Spacer(), // 1/6
                  InkWell(
                    //onTap: () => Get.to(QuizScreen()),
                    onTap: () {
                      _formKey.currentState.save();
                      final formData = _formKey.currentState.value;
                      if(formData["qPass"] == quizInfo.password) {
                        Get.to(QuizScreen());
                      }
                      else {
                        print("wrong password");
                        _formKey.currentState.reset();
                        //FocusScope.of(context).unfocus();

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialog(context),
                        );
                      }

                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient:  LinearGradient(
                          colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
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
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Sorry!'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Wrong Password"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Colors.white70,
          child: const Text('Close'),
        ),
      ],
    );
  }
}