// lib/features/admin/navigation/presentation/widgets/admin_drawer_header_widget.dart

import 'package:flutter/material.dart';

/// The header of the Admin Navigation Drawer.
///
/// Design (matches Figma):
/// ┌───────────────────────────────────────┐  ← primary gradient background
/// │  [Gym Icon]  FitZone Gym          [X] │  ← Row 1: gym info + close button
/// │              • Mumbai Central         │
/// ├───────────────────────────────────────┤
/// │  [Avatar]  Rajesh Sharma              │  ← Row 2: user card (semi-transparent)
/// │            owner@fitzone.com          │
/// └───────────────────────────────────────┘
class AdminDrawerHeaderWidget extends StatelessWidget {
  final String gymName;
  final String branchName;
  final String adminName;
  final String adminEmail;
  final String? avatarUrl;
  final VoidCallback onClose;         // tapping X
  final VoidCallback onProfileTap;    // tapping the user card

  const AdminDrawerHeaderWidget({
    super.key,
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    this.avatarUrl,
    required this.onClose,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Replace hardcoded colors with tokens from ThemeCubit:
    // final tokens = context.read<ThemeCubit>().state.tokens;
    const headerBgStart = Color(0xFF3B5BDB); // tokens.primary dark
    const headerBgEnd   = Color(0xFF4263EB); // tokens.primary

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [headerBgStart, headerBgEnd],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── ROW 1: Gym icon + name + branch + close button ─────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gym logo square
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Gym name + branch
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gymName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            // Green online dot
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFF51CF66),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                branchName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Close (X) button
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── ROW 2: User card ───────────────────────────────────────
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      _buildAvatar(),
                      const SizedBox(width: 10),
                      // Name + email
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adminName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              adminEmail,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: Colors.white24,
      );
    }
    // Initials fallback
    final initials = adminName.isNotEmpty
        ? adminName
        .trim()
        .split(' ')
        .where((w) => w.isNotEmpty)
        .map((w) => w[0])
        .take(2)
        .join()
        .toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white24,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}