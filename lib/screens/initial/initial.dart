import 'package:auth_demo/screens/auth/authentication.dart';
import 'package:auth_demo/screens/auth/providers/user_auth.dart';
import 'package:auth_demo/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return watch(userChangesProvider).when(
      data: (userData) {
        if (userData != null) {
          return HomeScreen(user: userData);
        } else {
          return AuthScreen();
        }
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text('$error'),
        ),
      ),
    );
  }
}
