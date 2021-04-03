import 'package:amrita_quizzes/app/sign_in/email_password/email_password_sign_in_page.dart';
import 'package:amrita_quizzes/app/sign_in/sign_in_manager.dart';
import 'package:amrita_quizzes/app/sign_in/social_sign_in_button.dart';
import 'package:amrita_quizzes/common_widgets/platform_exception_alert_dialog.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPageBuilder extends StatelessWidget {
  // P<ValueNotifier>
  //   P<SignInManager>(valueNotifier)
  //     SignInPage(value)
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'Amrita Quizzes',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage._({Key key, this.isLoading, this.manager, this.title})
      : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;

  static const Key googleButtonKey = Key('google');
  static const Key emailPasswordButtonKey = Key('email-password');

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /**appBar: AppBar(
        elevation: 2.0,
        title: Text(title),
      ),*/
      // Hide developer menu while loading in progress.
      // This is so that it's not possible to switch auth service while a request is in progress
      //drawer: isLoading ? null : DeveloperMenu(),
      //backgroundColor: Colors.grey[200],
      body: _buildSignIn(context),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Text(Strings.AmritaQuizzes,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 28.0,
          color: Colors.lightBlueAccent,
        )
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
              Hero(
                tag: 'hero',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 48.0,
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              SizedBox(height: 48.0),
              SizedBox(
                height: 50.0,
                child: _buildHeader(),
              ),
              SizedBox(height: 32.0),
              SocialSignInButton(
                key: googleButtonKey,
                assetName: 'assets/go-logo.png',
                text: Strings.signInWithGoogle,
                onPressed: isLoading ? null : () => _signInWithGoogle(context),
                color: Colors.white,
              ),
              SizedBox(height: 18),
              SignInButton(
                key: emailPasswordButtonKey,
                text: Strings.signInWithEmail,
                onPressed:
                isLoading ? null : () => _signInWithEmailAndPassword(context),
                textColor: Colors.white,
                color: Colors.lightBlueAccent,
              ),
            ],
          ),
        ),
      );
  }
}
