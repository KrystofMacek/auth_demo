import 'package:auth_demo/common/styles/input_decoration.dart';
import 'package:auth_demo/screens/auth/providers/input_form_values.dart';
import 'package:auth_demo/screens/auth/providers/page_controller.dart';
import 'package:auth_demo/screens/auth/providers/user_auth.dart';
import 'package:auth_demo/screens/auth/widgets/form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveAsyncFormWrapper(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Sign In',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, letterSpacing: 2),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => context
                        .read(firebaseAuthProvider.notifier)
                        .signInWithGoogle(),
                    child: const FaIcon(FontAwesomeIcons.google),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                decoration: inputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) =>
                    context.read(emailInputProvider.notifier).update(value),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                textAlign: TextAlign.center,
                decoration: inputDecoration('Password'),
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value) =>
                    context.read(passwordInputProvider.notifier).update(value),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer(
                builder: (context, watch, child) => watch(authErrorProvider),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.amber,
                    ),
                    child: GestureDetector(
                      onTap: () =>
                          context.read(firebaseAuthProvider.notifier).signIn(),
                      child: const Text(
                        'Sign In',
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context
                          .read(authPageViewControllerProvider.notifier)
                          .animeToPage(1);
                      context.read(passwordInputProvider.notifier).clear();
                      context.read(authErrorProvider.notifier).update('');
                    },
                    child: const Text(
                      'Create New Account',
                    ),
                  ),
                ],
              ),
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  context
                      .read(firebaseAuthProvider.notifier)
                      .sendResetPasswordEmail();
                },
                child: const Text(
                  'Forgot password ?',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
