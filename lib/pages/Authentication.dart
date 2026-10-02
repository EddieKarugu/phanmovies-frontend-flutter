import 'package:flutter/material.dart';
import 'package:phan_movies/pages/login.dart';
import 'package:phan_movies/pages/register.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  late final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          LoginPage(onGoToRegister: () => goTo(1)),
          RegisterPage(onGoToLogin: () => goTo(0)),
        ],
      ),
    );
  }
}