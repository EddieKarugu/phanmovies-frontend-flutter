import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/auth_service.dart';
import 'package:phan_movies/widgets/Input_field.dart';
import 'package:phan_movies/widgets/auth_redirect.dart';
import 'package:phan_movies/widgets/social_login_buttons.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onGoToLogin;

  const RegisterPage({super.key, required this.onGoToLogin});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Username is required')));
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Email is required'),
        ),
      );
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Password is required'),
        ),
      );
      return;
    }
    if (_confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Confirm password is required'),
        ),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.register(
        name: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        passwordConfirmation: _confirmPasswordController.text.trim(),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration successful')));
      widget.onGoToLogin();
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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            // top-left glow (unchanged)
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
                      Colors.red.withValues(alpha: 0.9),
                      Colors.red.withValues(alpha: 0.4),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // bottom-right glow (unchanged)
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
                    // stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const FittedBox(
                      child: Text(
                        'PhanMovies',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Watch all your favourite movies and TV shows here',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 60),

                    InputField(
                      hintText: 'Username',
                      controller: _usernameController,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      hintText: 'Email',
                      controller: _emailController,
                      prefixIcon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      prefixIcon: Icons.security,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      hintText: 'Confirm password',
                      controller: _confirmPasswordController,
                      prefixIcon: Icons.security,
                      obscureText: true,
                    ),
                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        elevation: 20,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 50),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              color: Colors.white,
                            )
                          : const Text('Register'),
                    ),
                    const SizedBox(height: 24),
                    SocialButtons(),
                    const SizedBox(height: 20),
                    AuthRedirect(
                      description: 'Already have an account?',
                      redirectPage: 'Login',
                      onRedirect: () {
                        widget.onGoToLogin();
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
