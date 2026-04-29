// lib/features/admin/navigation/presentation/widgets/admin_drawer_item_widget.dart

import 'package:flutter/material.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../config/navigation_item.dart';

/// A single navigation row in the drawer.
///
/// Design (matches Figma):
///   [Icon]  Label text
///
/// - No left indicator bar (unlike the previous version)
/// - Subtle grey background tint on active item
/// - Red color for destructive items (Logout)
/// - Icon + text both change color when active
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
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // TODO: swap with tokens.primary from ThemeCubit
    const activeColor = Color(0xFF3B5BDB);
    final destructiveColor = theme.colorScheme.error;
    final defaultColor = theme.colorScheme.onSurface.withOpacity(0.65);

    final Color itemColor = item.isDestructive
        ? destructiveColor
        : isActive
        ? activeColor
        : defaultColor;

    final String label = _resolveLabel(l10n, item.labelKey);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          // Subtle active background — exactly like the design
          color: isActive && !item.isDestructive
              ? activeColor.withOpacity(0.07)
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: Row(
            children: [
              Icon(
                item.iconData,
                size: 20,
                color: itemColor,
              ),
              const SizedBox(width: 14),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: itemColor,
                  fontWeight: isActive && !item.isDestructive
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'navDashboard':         return l10n.navDashboard;
      case 'navMembers':           return l10n.navMembers;
      case 'navPlans':             return l10n.navPlans;
      case 'navTrainers':          return l10n.navTrainers;
      case 'navReceptionStaff':    return l10n.navReceptionStaff;
      case 'navGymProfile':        return l10n.navGymProfile;
      case 'navBranches':          return l10n.navBranches;
      case 'navCheckins':          return l10n.navCheckins;
      case 'navPayments':          return l10n.navPayments;
      case 'navClassesPt':         return l10n.navClassesPt;
      case 'navNotifications':     return l10n.navNotifications;
      case 'navPtSessions':        return l10n.navPtSessions;
      case 'navTrainingVideos':    return l10n.navTrainingVideos;
      case 'navSettings':          return l10n.navSettings;
      case 'navLogout':            return l10n.navLogout;
      default:                     return key;
    }
  }
}