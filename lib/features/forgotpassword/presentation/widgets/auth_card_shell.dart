import 'package:flutter/material.dart';

// The card wrapper used by ALL 3 screens.
// Shows: icon → title → subtitle → card with the form inside.
class AuthCardShell extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final IconData icon;

  const AuthCardShell({
    super.key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.icon = Icons.lock_reset,
  });

  // Your backend's teal color — same as the API docs
  static const Color _primary = Color(0xFF1D9E75);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EFE8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circle icon at the top
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _primary.withOpacity(0.12),
                  child: Icon(icon, color: _primary, size: 30),
                ),
                const SizedBox(height: 14),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF085041),
                  ),
                ),
                const SizedBox(height: 6),

                // Subtitle
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF5F5E5A),
                  ),
                ),
                const SizedBox(height: 24),

                // The white card that wraps the form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}