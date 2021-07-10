import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authPageViewStateProvider =
    StateNotifierProvider<AuthPageViewState, double>(
        (ref) => AuthPageViewState());

class AuthPageViewState extends StateNotifier<double> {
  AuthPageViewState() : super(0);

  double update(double d) => state = d;
}

// PAGE CONTROLLER

final authPageViewControllerProvider =
    StateNotifierProvider<AuthPageViewController, PageController>(
  (ref) => AuthPageViewController(
    // Passing the Current Page State Provider so we can update it.
    ref.watch(authPageViewStateProvider.notifier),
    // Passing Empty PageController.
    PageController(),
  ),
);

class AuthPageViewController extends StateNotifier<PageController> {
  AuthPageViewController(
    AuthPageViewState authPageViewState,
    PageController pageController,
  ) : super(
          // Initializing AuthPageViewController with passed in PageController and setting up listener to update PageViewState (currentPage value)
          pageController
            ..addListener(
              () => authPageViewState.update(pageController.page),
            ),
        );

  // configuration of transition between pages
  final Duration _duration = const Duration(milliseconds: 500);
  final Curve _curve = Curves.easeOut;

  // calls controllers method to transition to ceratin page
  void animeToPage(int page) =>
      state.animateToPage(page, duration: _duration, curve: _curve);
}
