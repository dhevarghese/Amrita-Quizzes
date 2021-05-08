import 'dart:async';

import 'package:amrita_quizzes/common_widgets/platform_alert_dialog.dart';
import 'package:amrita_quizzes/common_widgets/platform_exception_alert_dialog.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/screens/home/home_screen.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:amrita_quizzes/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInfo extends StatefulWidget{
  UserInfo({Key key}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();

}

class _UserInfoState extends State<UserInfo> {
  final FocusScopeNode _node = FocusScopeNode();
  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  @override
  void dispose() {
    _node.dispose();
    super.dispose();
  }

  /*
  void _showUpdateError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: "Update failed!",
      exception: exception,
    ).show(context);
  }

  Future<void> _submit(BuildContext context) async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } on PlatformException catch (e) {
      _showUpdateError(context, e);
    }
  }
  */
  Widget getUDetails(BuildContext context){
    final dbs = Provider.of<Database>(context);
    final _formKey = GlobalKey<FormBuilderState>();
    return Container(
      color: Colors.white,
      //padding: new EdgeInsets.all(32.0),
      padding: new EdgeInsets.fromLTRB(32,16,32,16),
      child: Column(
        children: [
          FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(name: 'uName',
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle, color: Colors.lightBlueAccent,),
                    labelText: 'Name',
                    hintText: 'Ron',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(context),
                ),
                SizedBox(height: 16),
                FormBuilderTextField(name: 'uDept',
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_balance_outlined, color: Colors.lightBlueAccent,),
                    labelText: 'Department',
                    hintText: 'CSE',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(context),
                ),
                SizedBox(height: 16),
                FormBuilderTextField(name: 'uSect',
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_tree, color: Colors.lightBlueAccent,),
                    labelText: 'Section',
                    hintText: 'A',
                    border: OutlineInputBorder(),
                  ),
                  validator: FormBuilderValidators.required(context),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
          RoundedLoadingButton(
            key: Key('form-user-info-button'),
            child: Text("Let's start", style: TextStyle(color: Colors.white, fontSize: 20.0)),
            height: 44.0,
            color: Colors.lightBlueAccent,
            controller: _btnController,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              final validationSuccess = _formKey.currentState.validate();
              if(validationSuccess){
                _formKey.currentState.save();
                final formData = _formKey.currentState.value;
                print(formData);
                print(_formKey.currentState.value['uName']);
                return dbs.updateUserData(formData['uName'], formData['uDept'], formData['uSect']).then((value){
                  _btnController.success();
                  Timer(Duration(seconds: 1), () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(),
                        )
                    );
                  });
                  /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(),
                      )
                  );*/
                });
              }
              return _btnController.reset();
              //Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return FocusScope(
      node: _node,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          Text("Tell us a bit about yourself!", textAlign: TextAlign.center,
            style: TextStyle(
              //color: Colors.lightBlueAccent,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          getUDetails(context),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Widget _uInfo(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.lightBlueAccent,
        elevation: 2.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _confirmSignOut(context);
          },
        ),
        title: Text("One small step",
            style: TextStyle(
                color: Colors.white
            )
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbs = Provider.of<Database>(context);
    return FutureBuilder<String>(
        future: dbs.getUserName(),
        builder: (BuildContext context, AsyncSnapshot<String> uNameSnapshot) {
          if(!uNameSnapshot.hasData){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          else {
            final uName = uNameSnapshot.data;
            if(uName == ""){
              return _uInfo(context);
            }
            else {
              return HomeScreen();
            }
          }
        }
    );
  }
}
