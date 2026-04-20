import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onLogin;

  const AppHeader({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Icon(Icons.show_chart, color: Color(0xFF00C853), size: 28),
          const SizedBox(width: 12),
          const Text(
            'TradeSight',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auto Trade Mode toggled')),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.smart_toy, size: 18),
                SizedBox(width: 8),
                Text('Auto Trade'),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
