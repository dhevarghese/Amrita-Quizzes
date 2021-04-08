
import 'package:amrita_quizzes/app/sign_in/sign_in_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks.dart';

class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = <T>[];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuthService mockAuthService;
  SignInManager manager;
  MockValueNotifier<bool> isLoading;

  setUp(() {
    mockAuthService = MockAuthService();
    isLoading = MockValueNotifier<bool>(false);
    manager = SignInManager(auth: mockAuthService, isLoading: isLoading);
  });

  tearDown(() {
    mockAuthService = null;
    manager = null;
    isLoading = null;
  });
}
