import 'dart:async';
import 'package:amrita_quizzes/app/home_page.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mocks.dart';

void main() {
  MyAppUser myApp;
  MockNavigatorObserver mockNavigatorObserver;
  StreamController<MyAppUser> onAuthStateChangedController;

  setUp(() {
    myApp = MyAppUser(uid: '');
    mockNavigatorObserver = MockNavigatorObserver();
    onAuthStateChangedController = StreamController<MyAppUser>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });


  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<MyAppUser>(
            create: (_) => myApp,
          ),
        ],
        child: MaterialApp(
          home: HomePage(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
    // didPush is called once when the widget is first built
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  }

  testWidgets('Sign Out Button Test', (WidgetTester tester) async {
    await pumpHomePage(tester);
    // ignore: deprecated_member_use
    final SignOutButton = find.byType(FlatButton);
    expect(SignOutButton, findsOneWidget);
    await tester.tap(SignOutButton);
    await tester.pumpAndSettle();
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}