import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amrita_quizzes/common_widgets/form_submit_button.dart';

void main() {
  testWidgets('Renders', (WidgetTester tester) async {
    var pressed = true;
    await tester.pumpWidget(MaterialApp(home: FormSubmitButton(
      onPressed: () => pressed = true,)),
    );
    expect(pressed, true);
  });
}