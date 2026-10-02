import 'package:flutter/material.dart';

class AuthRedirect extends StatelessWidget {
  final String description;
  final String redirectPage;
  final VoidCallback onRedirect;
  
  const AuthRedirect({
    super.key,
    required this.description,
    required this.redirectPage,
    required this.onRedirect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(description),
        TextButton(
          onPressed: onRedirect,
          style: TextButton.styleFrom(),
          child: Text(redirectPage),
        ),
      ],
    );
  }
}
