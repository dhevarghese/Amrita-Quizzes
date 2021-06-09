import 'package:amrita_quizzes/app/sign_in/email_password/email_password_sign_in_model.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/services/firebase_auth_service.dart';
import 'package:amrita_quizzes/services/mock_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:amrita_quizzes/app/sign_in/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  MockAuthService _auth = MockAuthService();
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Empty Email Test', () async{
    var result = EmailPasswordSignInModel(auth: _auth, email: '', password: '12345', submitted: true).emailErrorText;
    expect(result, Strings.invalidEmailEmpty);
  });

  test('Invalid Email Test', () async{
    var result = EmailSubmitRegexValidator().isValid('amrita@gmail.com');
    expect(result, true);
  });

  test('Valid Email Test', () async{
    final validator = NonEmptyStringValidator();
    String e = "quizse2021@gmail.com";
    var result = EmailPasswordSignInModel(auth: _auth, email: e, submitted: true).canSubmitEmail;
    expect(result, validator.isValid(e));
  });

  test('Empty Password Test', () async{
    var result = EmailPasswordSignInModel(auth: _auth, password: '', submitted: true).passwordErrorText;
    expect(result, Strings.invalidPasswordEmpty);
  });

  test('Invalid Password Test', () async{
    String p = "amrita";
    var result = MinLengthStringValidator(8).isValid(p);
    expect(result, false);
    expect(NonEmptyStringValidator().isValid(p), true);
  });

  test('Valid Password Test', () async{
    String p = "amrita2020";
    var result = EmailPasswordSignInModel(auth: _auth, password: p, submitted: true).passwordErrorText;
    expect(result, null);
  });
}