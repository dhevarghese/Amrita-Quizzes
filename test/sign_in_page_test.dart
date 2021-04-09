import 'dart:async';
import 'package:amrita_quizzes/app/sign_in/sign_in_page.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'mocks.dart';

void main() {
  MockAuthService mockAuthService;
  MockNavigatorObserver mockNavigatorObserver;
  StreamController<MyAppUser> onAuthStateChangedController;

  setUp(() {
    mockAuthService = MockAuthService();
    mockNavigatorObserver = MockNavigatorObserver();
    onAuthStateChangedController = StreamController<MyAppUser>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });


  void stubOnAuthStateChangedYields(Iterable<MyAppUser> onAuthStateChanged) {
    onAuthStateChangedController
        .addStream(Stream<MyAppUser>.fromIterable(onAuthStateChanged));
    when(mockAuthService.onAuthStateChanged).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  Future<void> pumpSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => mockAuthService,
          ),
        ],
        child: MaterialApp(
          home: SignInPageBuilder(),
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
    // didPush is called once when the widget is first built
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  }

  testWidgets('email & password navigation', (WidgetTester tester) async {
    await pumpSignInPage(tester);

    final emailPasswordButton = find.byKey(SignInPage.emailPasswordButtonKey);
    expect(emailPasswordButton, findsOneWidget);

    await tester.tap(emailPasswordButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}