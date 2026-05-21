// lib/features/admin/navigation/presentation/widgets/admin_drawer_item_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/theme_cubit.dart';
import '../../config/navigation_item.dart';

/// A single navigation row in the drawer.
///
/// DARK THEME IMPROVEMENTS:
///   • Active item gets a LEFT accent bar (2 px, brand colour) — a strong
///     visual signal that's common in pro dark-mode apps (VS Code, Linear).
///   • Active item background uses a more saturated primary tint (0.12 opacity
///     instead of 0.07) so it pops against the dark surface.
///   • Default (inactive) text colour is now darkBody (#8B949E) instead of
///     body.withOpacity(0.65) — much more readable on dark backgrounds.
///   • Active icon + text use full primary colour (no opacity fade).
///   • Destructive (Logout) keeps the red/danger colour in both modes.
///   • Ink splash respects brand colour in dark mode.
///
/// Layout:
///   [▌ accent] [Icon]  Label text
///               ← 14px →
class AdminDrawerItemWidget extends StatelessWidget {
  final NavigationItem item;
  final bool isActive;
  final VoidCallback onTap;

  const AdminDrawerItemWidget({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n   = AppLocalizations.of(context)!;
    final theme  = Theme.of(context);
    final tokens = context.read<ThemeCubit>().state.tokens;
    final c      = tokens.colors;
    final isDark = theme.brightness == Brightness.dark;

    // ── Colour resolution ──────────────────────────────────────────────────
    // Destructive (Logout) is always red. Active item is brand primary.
    // Inactive items use onSurface so they adapt correctly in dark mode —
    // this gives us #8B949E in dark vs #374151 in light.
    final Color itemColor = item.isDestructive
        ? c.danger
        : isActive
        ? c.primary
        : theme.colorScheme.onSurface.withOpacity(isDark ? 0.55 : 0.60);

    // Active background tint — stronger in dark mode for better visibility
    final Color? activeBg = (isActive && !item.isDestructive)
        ? c.primary.withOpacity(isDark ? 0.12 : 0.07)
        : null;

    final String label = _resolveLabel(l10n, item.labelKey);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        // Ink splash uses brand colour in dark mode, default in light
        splashColor: isDark
            ? c.primary.withOpacity(0.08)
            : theme.colorScheme.primary.withOpacity(0.06),
        highlightColor: isDark
            ? c.primary.withOpacity(0.05)
            : theme.colorScheme.primary.withOpacity(0.04),
        child: Stack(
          children: [
            // ── Row background tint ────────────────────────────────────────
            if (activeBg != null)
              Positioned.fill(child: Container(color: activeBg)),

            // ── Left accent bar (active only, dark mode only) ──────────────
            // A 3px vertical strip on the left edge — clear "you are here"
            // signal without overwhelming the layout. Only shown in dark mode
            // because the background tint alone is clear enough in light mode.
            if (isActive && !item.isDestructive && isDark)
              Positioned(
                left:   0,
                top:    4,
                bottom: 4,
                child: Container(
                  width:                3,
                  decoration: BoxDecoration(
                    color:              c.primary,
                    borderRadius: const BorderRadius.only(
                      topRight:    Radius.circular(3),
                      bottomRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),

            // ── Main content row ───────────────────────────────────────────
            Padding(
              // Extra left padding when accent bar is showing so content
              // doesn't collide with the 3px strip.
              padding: EdgeInsets.fromLTRB(
                (isActive && !item.isDestructive && isDark) ? 23 : 20,
                11,
                20,
                11,
              ),
              child: Row(
                children: [
                  // Icon — full brand colour when active, dimmed when not
                  Icon(
                    item.iconData,
                    size:  20,
                    color: itemColor,
                  ),
                  const SizedBox(width: 14),

                  // Label text
                  Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:      itemColor,
                      fontWeight: (isActive && !item.isDestructive)
                          ? FontWeight.w600
                          : FontWeight.w400,
                      // Slightly tighter tracking on active items for emphasis
                      letterSpacing: (isActive && !item.isDestructive)
                          ? -0.1
                          : 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Label resolver ──────────────────────────────────────────────────────
  // Maps translation keys to l10n strings. Kept identical to the original.
  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'navDashboard':          return l10n.navDashboard;
      case 'navMembers':            return l10n.navMembers;
      case 'navPlans':              return l10n.navPlans;
      case 'navTrainers':           return l10n.navTrainers;
      case 'navReceptionStaff':     return l10n.navReceptionStaff;
      case 'navGymProfile':         return l10n.navAiAssistant;
      case 'navBranches':           return l10n.navBranches;
      case 'navCheckins':           return l10n.navCheckins;
      case 'navPayments':           return l10n.navPayments;
      case 'navMembershipRequests': return l10n.navMembershipRequests;
      case 'navInvoices':           return l10n.navInvoices;
      case 'navClassesPt':          return l10n.navClassesPt;
      case 'navNotifications':      return l10n.navNotifications;
      case 'navPtSessions':         return l10n.navPtSessions;
      case 'navTrainingVideos':     return l10n.navTrainingVideos;
      case 'navSettings':           return l10n.navSettings;
      case 'navLogout':             return l10n.navLogout;
      default:                      return key;
    }
  }
}