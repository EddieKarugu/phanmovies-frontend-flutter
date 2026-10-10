
import 'package:flutter/material.dart';
import 'package:phan_movies/models/user.dart';
import 'package:phan_movies/pages/Authentication.dart';

class AccountSection extends StatefulWidget {
  final User? user;
  final Future<void> Function() onLogout;
  final bool isLoading;

  const AccountSection({
    super.key,
    required this.user,
    required this.onLogout,
    this.isLoading = false,
  });

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  bool _isLoggingOut = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (widget.isLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else
            Stack(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: Text(
                        widget.user?.initial ?? '?',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    Text(widget.user?.name ?? 'Not signed in',
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(widget.user?.email ?? ''),
                    if (widget.user != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Logged in with ${widget.user!.provider}'),
                      ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                ),
              ],
            ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
            onPressed: _isLoggingOut ? null : _handleLogout,
            child: _isLoggingOut
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isLoggingOut = true);

    await widget.onLogout();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Authentication()),
      (route) => false,
    );
  }
}
