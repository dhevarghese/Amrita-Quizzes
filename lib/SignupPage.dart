import 'package:amrita_quizzes/loginPage.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  //static String tag = 'sipnup-page';
  Widget _buildTextFied(
      BuildContext context, String labelText, bool isPassowrd) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Theme(
        data: Theme
            .of(context)
            .copyWith(primaryColor: Colors.white.withOpacity(0.5)),
        child: TextField(
          obscureText: isPassowrd,
          focusNode: FocusNode(),
          style: TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.body1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            //child: Image.asset('assets/logo.png'),
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).accentColor,
              size: 30.0,
            )
        ),
      ),
      body: Container(
        height: double.infinity,
        //color: Theme.of(context).accentColor,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: double.infinity),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 85.0,
                  width: 85.0,
                ),

              ),
              SizedBox(height: 10.0),
              //Text(' Register', style: Theme.of(context).textTheme.display3),
              Text('Register',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35.0,
                    color: Colors.lightBlueAccent,
                  )
              ),
              _buildTextFied(context, 'First Name', false),
              _buildTextFied(context, 'Last Name', false),
              _buildTextFied(context, 'Email', false),
              _buildTextFied(context, 'Password', true),
              SizedBox(height: 30.0),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                        'Create Account',
                        style: TextStyle(color: Colors.white)

                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginPage()),
                    );
                  },
                  padding: EdgeInsets.all(12),
                  //padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  color: Colors.lightBlueAccent,
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}