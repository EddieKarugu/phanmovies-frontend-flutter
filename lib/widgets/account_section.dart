import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phan_movies/apiServices/auth_service.dart';
import 'package:phan_movies/models/user.dart';
import 'package:phan_movies/pages/Authentication.dart';

class AccountSection extends StatefulWidget {
  final User? user;
  bool isLoading;
  bool isLoggingOut;
  AccountSection({
    super.key,
    this.user,
    this.isLoading = false,
    this.isLoggingOut = false,
  });

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          widget.isLoading
              ? CircularProgressIndicator()
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          child: Text(
                            widget.user?.name[0] ?? '',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Text(
                          widget.user?.name ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(widget.user?.email ?? ''),
                        if (widget.user?.provider != null &&
                            widget.user != null)
                          Row(
                            children: [
                              Text('Logged in with ${widget.user?.provider}'),
                            ],
                          ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
            child: widget.isLoggingOut
                ? CircularProgressIndicator()
                : Text('Logout'),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    TextButton(
                      child: Text('Logout'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                ),
              );
              if (confirmed != true) return;

              if (!mounted) return;
              setState(() {
                widget.isLoggingOut = true;
              });
              try {
                await AuthService.logout();
              } catch (_) {
                if (!mounted) return;
              }
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Authentication()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
