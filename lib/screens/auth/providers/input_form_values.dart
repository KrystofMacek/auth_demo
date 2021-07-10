import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailInputProvider = StateNotifierProvider<EmailInputProvider, String>(
  (ref) => EmailInputProvider(),
);

class EmailInputProvider extends StateNotifier<String> {
  EmailInputProvider() : super('');

  String update(String value) => state = value;
  void clear() => state = '';
}

final passwordInputProvider =
    StateNotifierProvider<PasswordInputProvider, String>(
  (ref) => PasswordInputProvider(),
);

class PasswordInputProvider extends StateNotifier<String> {
  PasswordInputProvider() : super('');

  String update(String value) => state = value;
  void clear() => state = '';
}

final confirmPasswordInputProvider =
    StateNotifierProvider<ConfirmPasswordInputProvider, String>(
  (ref) => ConfirmPasswordInputProvider(),
);

class ConfirmPasswordInputProvider extends StateNotifier<String> {
  ConfirmPasswordInputProvider() : super('');

  String update(String value) => state = value;
  void clear() => state = '';
}

// AUTH ERROR
final authErrorProvider = StateNotifierProvider<AuthErrorProvider, Widget>(
    (ref) => AuthErrorProvider());

class AuthErrorProvider extends StateNotifier<Widget> {
  AuthErrorProvider() : super(const SizedBox());

  Widget update(String value) {
    return state = value.isEmpty
        ? const SizedBox()
        : Text(
            value,
            textAlign: TextAlign.center,
          );
  }
}
