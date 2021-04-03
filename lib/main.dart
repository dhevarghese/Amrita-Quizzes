import 'package:amrita_quizzes/app/auth_widget.dart';
import 'package:amrita_quizzes/app/auth_widget_builder.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:amrita_quizzes/services/auth_service_adapter.dart';
import 'package:amrita_quizzes/services/email_secure_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp(
      {Key key,
        this.initialAuthServiceType = AuthServiceType.firebase})
      : super(key: key);

  final AuthServiceType initialAuthServiceType;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthServiceAdapter(
                initialAuthServiceType: initialAuthServiceType),
            dispose: (_, AuthService authService) => authService.dispose()),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<MyAppUser> userSnapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.lightBlue,
              fontFamily: 'Nunito',
            ),
            home: AuthWidget(userSnapshot: userSnapshot,
            ),
          );
        },
      ),
    );
  }
}
