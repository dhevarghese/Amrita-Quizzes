import 'package:amrita_quizzes/SignupPage.dart';
import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'homePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    //SignUpPage.tag: (context) => SignUpPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amrita Quizzes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: LoginPage(),
      routes: routes,
    );
  }
}
