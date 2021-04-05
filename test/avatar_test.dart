import 'package:amrita_quizzes/common_widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Avatar', (WidgetTester tester) async {
    Avatar c = new Avatar();
    var pressed = false;
    await tester.pumpWidget(
      MaterialApp(home: CircleAvatar(
        radius: c.radius,
      )),
    );
    final avatar = find.byType(CircleAvatar);
    expect(avatar, findsOneWidget);
  });
}