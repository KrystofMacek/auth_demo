import 'package:auth_demo/common/providers/async_state.dart';
import 'package:auth_demo/screens/auth/providers/input_form_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Stream of UserChanges from Firebase - listens to events like sign in / sign out
final userChangesProvider = StreamProvider.autoDispose<User>((ref) {
  return FirebaseAuth.instance.userChanges();
});

// authetication controller variable
final firebaseAuthProvider =
    StateNotifierProvider<FirebaseAuthProvider, FirebaseAuth>(
  (ref) => FirebaseAuthProvider(
    ref.watch(emailInputProvider.notifier),
    ref.watch(passwordInputProvider.notifier),
    ref.watch(confirmPasswordInputProvider.notifier),
    ref.watch(asyncStateProvider.notifier),
    ref.watch(authErrorProvider.notifier),
  ),
);

class FirebaseAuthProvider extends StateNotifier<FirebaseAuth> {
  FirebaseAuthProvider(
    this._emailInputProvider,
    this._passwordInputProvider,
    this._confirmPasswordInputProvider,
    this._isInAsync,
    this._authError,
  ) : super(FirebaseAuth.instance);

  final EmailInputProvider _emailInputProvider;
  final PasswordInputProvider _passwordInputProvider;
  final ConfirmPasswordInputProvider _confirmPasswordInputProvider;
  final AsyncState _isInAsync;
  final AuthErrorProvider _authError;

  // Sign In using Email+Password provided in form
  Future<void> signIn() async {
    _authError.update('');

    // check if email and password are provided
    if (_emailInputProvider.state.isNotEmpty &&
        _passwordInputProvider.state.isNotEmpty) {
      try {
        _isInAsync.toggle();
        // try signing in with provided info
        await state.signInWithEmailAndPassword(
          email: _emailInputProvider.state,
          password: _passwordInputProvider.state,
        );
        // clear state when successful
        _emailInputProvider.clear();
        _passwordInputProvider.clear();
        _authError.update('');
        _isInAsync.toggle();
      } catch (e) {
        _isInAsync.toggle();
        // catch error from signInWithEmailAndPassword
        // update auth error widget provider
        _authError.update('${e.message}');
      }
    } else {
      // update auth error widget provider
      _authError.update('Provide: Email & Password');
    }
  }

  // Create New Account

  // send email to users address verify account
  Future<void> sendEmailVerification(User user) => user.sendEmailVerification();

  // Sign Up using Email+Password provided in form
  Future<void> signUp() async {
    _authError.update('');
    // check if  email and password are provided
    if (_emailInputProvider.state.isNotEmpty &&
        _passwordInputProvider.state.isNotEmpty) {
      // check if  provided passwords are matching
      if (_passwordInputProvider.state != _confirmPasswordInputProvider.state) {
        _authError.update('Passwords do not match');
      } else {
        try {
          _isInAsync.toggle();
          // create account with provided information and send verification email
          await state
              .createUserWithEmailAndPassword(
                email: _emailInputProvider.state,
                password: _passwordInputProvider.state,
              )
              // if future completes with value send verification email
              .then((value) => sendEmailVerification(value.user));

          // when success clear state providers
          _emailInputProvider.clear();
          _passwordInputProvider.clear();
          _confirmPasswordInputProvider.clear();
          _isInAsync.toggle();
        } catch (e) {
          _isInAsync.toggle();

          // catch error from createUserWithEmailAndPassword and update error widget
          _authError.update('${e.message}');
        }
      }
    } else {
      // update auth error widget provider
      _authError.update('Provide: Email & Password');
    }
  }

  //Logout
  Future<void> signOut(BuildContext context) async {
    try {
      _isInAsync.toggle();
      await state.signOut();
      _isInAsync.toggle();
    } catch (e) {
      _isInAsync.toggle();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${e.message}'),
        ),
      );
    }
  }

  // Send password reset email
  Future<void> sendResetPasswordEmail() async {
    try {
      _isInAsync.toggle();
      await state.sendPasswordResetEmail(email: _emailInputProvider.state);
      _passwordInputProvider.clear();
      _isInAsync.toggle();
    } catch (e) {
      _isInAsync.toggle();
      _authError.update('${e.message}');
    }
  }

  // requthenticate user - some firebase methods need recent authentication
  Future<void> reauthenticatingUser(
    String email,
    String password,
  ) async {
    // Create a credential
    final AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    // Reauthenticate
    await state.currentUser.reauthenticateWithCredential(credential);
  }

  // Delete currently sign in users account
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await state.currentUser.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'The user must reauthenticate before this operation can be executed.'),
          ),
        );
      }
    }
  }

  // Create new user using Google account - required SHA1 for android
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount _googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication _googleAuth =
        await _googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: _googleAuth.accessToken,
      idToken: _googleAuth.idToken,
    );
    _isInAsync.toggle();
    // Once signed in, use credential to authenticate with firebaseAuth
    await FirebaseAuth.instance.signInWithCredential(credential);
    _isInAsync.toggle();
  }
}
