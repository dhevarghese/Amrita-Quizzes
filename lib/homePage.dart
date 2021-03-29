import 'package:amrita_quizzes/SignupPage.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  final String userName;
  final String eMail;

  ScreenArguments(this.userName, this.eMail);
}

class HomePage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/login_av2.png'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Welcome '+args.userName,
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    //kish temp work space
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => SignUpPage()),
          );
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );
    //temp work space end

    final lorem = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'You are verified',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[alucard, welcome, lorem],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}