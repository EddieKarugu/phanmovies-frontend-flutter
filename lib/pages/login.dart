import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/auth_service.dart';
import 'package:phan_movies/pages/navigation.dart';
import 'package:phan_movies/widgets/Input_field.dart';
import 'package:phan_movies/widgets/auth_redirect.dart';
import 'package:phan_movies/widgets/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onGoToRegister;
  const LoginPage({super.key, required this.onGoToRegister});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isLoading = false;

  Future<void> _login() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both username and password')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthService.login(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavigationPage()),
      );
    } on DioException catch (e) {
      final message =
          e.response?.data['message'] ?? e.message ?? 'something went wrong';
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            Positioned(
              top: -150,
              left: -150,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.9), // concentrated center
                      Colors.red.withValues(alpha: 0.4), // fading middle
                      Colors.transparent, // blends into black
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Bottom-right red glow
            Positioned(
              bottom: -150,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.withValues(alpha: 0.9),
                      Colors.red.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    const FittedBox(
                      child: Text(
                        'PhanMovies',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Text('Watch all your favourite movies and Tv shows here'),
                    const SizedBox(height: 150),
                    InputField(
                      hintText: 'Email',
                      controller: _usernameController,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      hintText: 'password',
                      controller: _passwordController,
                      prefixIcon: Icons.security,
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        elevation: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: Size(200, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              color: Colors.white,
                            )
                          : Text('Login'),
                    ),
                    const SizedBox(height: 30),
                    SocialButtons(),
                    const SizedBox(height: 20),
                    AuthRedirect(
                      description: "Don't hava an Account?",
                      redirectPage: "Sign Up",
                      onRedirect: () {
                        widget.onGoToRegister();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
