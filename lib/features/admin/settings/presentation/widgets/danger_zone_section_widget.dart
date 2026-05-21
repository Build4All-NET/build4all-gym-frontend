// ─────────────────────────────────────────────────────────────────────────────
// lib/features/admin/settings/presentation/widgets/danger_zone_section_widget.dart
//
// PURPOSE:
//   Renders the "Danger Zone" section with Log Out and Delete Account actions.
//   BOTH actions require a confirmation dialog before executing.
//   These are IMMEDIATE actions — they do NOT go through the "Save Changes" button.
//
// AUTH BACKEND SCOPE:
//   Log Out      → local token clear only (no API call).
//   Delete Account → DELETE Env.apiBaseUrl + '/api/v1/users/me' (build4all platform).
//
// DESIGN (matches Figma):
//   Red/pink tinted container (tokens.colors.danger.withOpacity(0.08))
//   Red circle ! icon header. Two white-bordered action buttons.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:build4allgym/common/widgets/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../../app/app_router.dart';
import '../../../../../core/config/env.dart';
import '../../../../../core/network/globals.dart';
import '../../../../../core/theme/theme_cubit.dart';
import 'package:dio/dio.dart';

class DangerZoneSectionWidget extends StatelessWidget {
  const DangerZoneSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = context.watch<ThemeCubit>().state.tokens;
    final c = tokens.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // Red/pink tinted background — matches Figma danger zone
        color: c.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(tokens.card.radius),
        border: Border.all(color: c.danger.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.danger,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Danger Zone',
                      style: tokens.typography.titleMedium.copyWith(
                          color: c.danger.withOpacity(0.8),
                          fontWeight: FontWeight.w700)),
                  Text('Irreversible actions',
                      style: tokens.typography.bodySmall.copyWith(color: c.danger)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Log Out button ────────────────────────────────────────────────
          _DangerButton(
            icon: Icons.logout_rounded,
            label: 'Log Out',
            onTap: () => _confirmLogOut(context, c, tokens),
          ),
          const SizedBox(height: 10),

          // ── Delete Account button ─────────────────────────────────────────
          _DangerButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Account',
            onTap: () => _confirmDeleteAccount(context, c, tokens),
          ),
        ],
      ),
    );
  }

  // ── Log Out confirmation + execution ────────────────────────────────────────

  void _confirmLogOut(BuildContext context, dynamic c, dynamic tokens) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Log Out',
            style: tokens.typography.titleMedium),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop(); // Close dialog first
              await _performLogOut(context);
            },
            style: TextButton.styleFrom(foregroundColor: c.danger),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogOut(BuildContext context) async {
    const storage = FlutterSecureStorage();
    // Clear the JWT — user is now unauthenticated
    await storage.delete(key: 'jwt_token');

    if (!context.mounted) return;
    // Navigate to login and remove ALL screens from the stack (no back button)
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.logout,
          (_) => false,
    );
  }

  // ── Delete Account confirmation + execution ─────────────────────────────────

  void _confirmDeleteAccount(BuildContext context, dynamic c, dynamic tokens) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Account',
            style: tokens.typography.titleMedium),
        content: const Text(
          'This will permanently delete your account. '
              'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await _performDeleteAccount(context);
            },
            style: TextButton.styleFrom(foregroundColor: c.danger),
            child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteAccount(BuildContext context) async {
    try {
      // TODO: Confirm endpoint with build4all team before enabling.
      // Call DELETE Env.apiBaseUrl + '/api/v1/users/me' (build4all platform backend)
      // final dio = appDio ?? Dio(BaseOptions(baseUrl: Env.apiBaseUrl));
      // await dio.delete('${Env.apiBaseUrl}/api/v1/users/me');

      // Clear ALL local storage
      const storage = FlutterSecureStorage();
      await storage.deleteAll();

      if (!context.mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.logout,
            (_) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  }
}

// ─── Danger action button ─────────────────────────────────────────────────────

class _DangerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DangerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }
}
