import 'package:auth_demo/screens/auth/widgets/sign_in.dart';
import 'package:auth_demo/screens/auth/widgets/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_demo/screens/auth/providers/page_controller.dart';

class AuthScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      body: PageView(
        controller: watch(authPageViewControllerProvider),
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          SignIn(),
          SignUp(),
        ],
      ),
    );
  }
}
