import 'package:flutter/material.dart';
import 'homePage.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void verifyUser() async{
    String data = await DefaultAssetBundle.of(context).loadString("assets/loginDetails.json");
    final loginData = json.decode(data);

    loginData.forEach((User) {
      //print("${User['First Name']}")
      if(User['E-mail'] == userNameController.text){
        print('Email verified');
        if(User['Password'] == passwordController.text){
          print('User Verified');
          //Navigator.of(context).pushNamed(HomePage.tag);
          Navigator.pushNamed(context, HomePage.tag, arguments: ScreenArguments(
            User['First Name'],
            User['E-mail'],
          ));
        }
      }
    });

    //print('Howdy, ${loginData[0]['First Name']}!');
  }

  final userNameController = TextEditingController(text: "dheerajvarghese@gmail.com");
  final passwordController = TextEditingController(text: "admin");

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: userNameController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          verifyUser();
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            Text('Amrita Quizzes',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28.0,
                    color: Colors.lightBlueAccent,
                )
            ),
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}