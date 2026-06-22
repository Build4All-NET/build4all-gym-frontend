// lib/features/admin/navigation/presentation/widgets/admin_drawer_header_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/theme/theme_cubit.dart';

/// The header of the Admin Navigation Drawer.
///
/// Layout:
/// ┌─────────────────────────────────────────┐  ← gradient background
/// │  [Gym Icon]  B-Pro              [X]     │  ← Row 1: gym + close
/// │              • Main Branch              │
/// ├─────────────────────────────────────────┤
/// │  [Avatar]  Admin                        │  ← Row 2: user card
/// │            admin@admin.com              │
/// └─────────────────────────────────────────┘
///
/// DARK THEME IMPROVEMENTS:
///   • Gradient goes from a darkened primary (lerp to black 0.30) at top
///     to the primary colour at bottom — creates more depth in dark mode.
///   • The user card container uses white 0.12 opacity (was 0.15) with a
///     subtle white border at 0.10 opacity — adds a glass-morphism feel.
///   • Bottom edge has a 0.5px dark border to cleanly separate the header
///     from the nav list.
///   • The gym icon square now has a slightly more visible white overlay
///     (0.25 vs 0.20) so it reads clearly on the gradient in dark mode.
class AdminDrawerHeaderWidget extends StatelessWidget {
  final String  gymName;
  final String  branchName;
  final String  adminName;
  final String  adminEmail;
  final String? avatarUrl;
  final VoidCallback onClose;
  final VoidCallback onProfileTap;

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
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Gradient ──────────────────────────────────────────────────────────
    // In dark mode we darken the top more aggressively (0.30 vs 0.18)
    // so the gradient has real contrast and doesn't look like a flat band.
    final gradientDarken = isDark ? 0.30 : 0.18;
    final headerBgStart  = Color.lerp(c.primary, Colors.black, gradientDarken)!;
    final headerBgEnd    = c.primary;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin:  Alignment.topCenter,
          end:    Alignment.bottomCenter,
          colors: [headerBgStart, headerBgEnd],
        ),
        // Subtle bottom border separates header from the nav list
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.12),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 12, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── ROW 1: Gym icon + name + branch + close button ───────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gym logo square — frosted glass style
                  Container(
                    width:  44,
                    height: 44,
                    decoration: BoxDecoration(
                      // Slightly more opaque in dark mode so it reads clearly
                      color:        Colors.white.withOpacity(isDark ? 0.25 : 0.20),
                      borderRadius: BorderRadius.circular(10),
                      // Glass edge highlight
                      border: Border.all(
                        color: Colors.white.withOpacity(0.20),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.white,
                      size:  24,
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
                            color:      Colors.white,
                            fontSize:   16,
                            fontWeight: FontWeight.bold,
                            height:     1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            // Online / active dot — uses success token colour
                            Container(
                              width:  7,
                              height: 7,
                              decoration: BoxDecoration(
                                color:  c.success,
                                shape:  BoxShape.circle,
                                // Tiny glow effect behind the dot
                                boxShadow: [
                                  BoxShadow(
                                    color:       c.success.withOpacity(0.6),
                                    blurRadius:  4,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                branchName,
                                style: TextStyle(
                                  // Slightly more visible in dark mode (70% vs 70%)
                                  color:    Colors.white.withOpacity(0.72),
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
                      width:     28,
                      height:    28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // Slightly visible background on the close button
                        color:        Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white70,
                        size:  18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ── ROW 2: User card (glass morphism style) ───────────────────
              // IMPROVED: added a very subtle border so the card edge is
              // visible against the gradient, and reduced opacity slightly
              // for a more refined frosted-glass look.
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color:        Colors.white.withOpacity(isDark ? 0.12 : 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.14),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              adminName,
                              style: const TextStyle(
                                color:      Colors.white,
                                fontSize:   14,
                                fontWeight: FontWeight.w600,
                                height:     1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              adminEmail,
                              style: TextStyle(
                                color:    Colors.white.withOpacity(0.58),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Small chevron hint that the card is tappable
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white.withOpacity(0.35),
                        size:  16,
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

  // ── Avatar builder ────────────────────────────────────────────────────────
  // Shows network image if available, otherwise initials.
  Widget _buildAvatar() {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return CircleAvatar(
        radius:          18,
        backgroundImage: NetworkImage(avatarUrl!),
        backgroundColor: Colors.white24,
      );
    }

    // Extract up to 2 initials from the admin name
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
      radius:          18,
      backgroundColor: Colors.white24,
      child: Text(
        initials,
        style: const TextStyle(
          color:      Colors.white,
          fontWeight: FontWeight.bold,
          fontSize:   13,
        ),
      ),
    );
  }
}