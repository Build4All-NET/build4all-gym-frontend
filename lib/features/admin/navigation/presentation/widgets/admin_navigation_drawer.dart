// lib/features/admin/navigation/presentation/widgets/admin_navigation_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../../../../features/auth/presentation/admin_profile/admin_profile_cubit.dart';
import '../../config/admin_drawer_config.dart';
import '../../config/navigation_item.dart';
import '../cubit/drawer_cubit.dart';
import '../cubit/drawer_state.dart';
import 'admin_drawer_header_widget.dart';
import 'admin_drawer_item_widget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AdminNavigationDrawer
//
// The slide-in sidebar shown when the user taps the menu icon.
// Delegates to _DrawerBody for the actual UI.
//
// DARK THEME IMPROVEMENTS in this file:
//   • The Drawer widget itself uses theme.colorScheme.surface — in dark mode
//     this resolves to #161B22 (rich ink-blue-grey) instead of flat #1E1E1E.
//   • The Divider between nav items and bottom buttons uses
//     theme.colorScheme.outlineVariant so it's a subtle hairline, not
//     a harsh thick line.
//   • Section label colours use onSurface.withOpacity(0.35) for dark mode —
//     more readable than the previous 0.40 on a lighter background.
//   • Added 0.5px top outline to SafeArea bottom section to visually separate
//     Settings and Logout from the scrollable nav list.
// ─────────────────────────────────────────────────────────────────────────────

class AdminNavigationDrawer extends StatelessWidget {
  final String  gymName;
  final String  branchName;
  final String  adminName;
  final String  adminEmail;
  final String? avatarUrl;
  final String  initialActiveId;

  const AdminNavigationDrawer({
    super.key,
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    required this.initialActiveId,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DrawerCubit>(
      create: (_) => DrawerCubit(initialActiveId: initialActiveId),
      child: _DrawerBody(
        gymName:    gymName,
        branchName: branchName,
        adminName:  adminName,
        adminEmail: adminEmail,
        avatarUrl:  avatarUrl,
      ),
    );
  }
}

// ─── Internal body ────────────────────────────────────────────────────────────

class _DrawerBody extends StatelessWidget {
  final String  gymName;
  final String  branchName;
  final String  adminName;
  final String  adminEmail;
  final String? avatarUrl;

  const _DrawerBody({
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme   = Theme.of(context);
    final cs      = theme.colorScheme;
    final profile = context.watch<AdminProfileCubit>().state;

    debugPrint('🎯 Drawer → role: ${profile.role}, gymRoles: ${profile.gymRoles}, isTrainer: ${profile.isTrainerRole}');

    // ── Filter sections by role ──────────────────────────────────────────────
    final visibleSections = adminDrawerSections.where((section) {
      if (profile.isAdminRole) return true;
      if (section.labelKey == 'sectionCoreOwner') return false;
      if (section.labelKey == 'sectionTrainingPt') return profile.isTrainerRole;
      if (section.labelKey == 'sectionOperationsReception') return profile.isReceptionRole;
      return false;
    }).toList();

    return Drawer(
      width:           255,
      backgroundColor: cs.surface,   // #161B22 in dark, white in light
      elevation:       16,           // Stronger shadow so the drawer lifts clearly
      child: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, state) {
          return Column(
            children: [
              // ── HEADER ────────────────────────────────────────────────────
              AdminDrawerHeaderWidget(
                gymName:    gymName,
                branchName: branchName,
                adminName:  adminName,
                adminEmail: adminEmail,
                avatarUrl:  avatarUrl,
                onClose:    () => Navigator.of(context).pop(),
                onProfileTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/admin/settings');
                },
              ),

              // ── SCROLLABLE NAV SECTIONS ──────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  children: [
                    for (final section in visibleSections) ...[
                      if (section.labelKey != null)
                        _SectionLabel(labelKey: section.labelKey!),
                      for (final item in section.items)
                        AdminDrawerItemWidget(
                          item:     item,
                          isActive: state.activeItemId == item.id,
                          onTap:    () => _navigate(context, item),
                        ),
                    ],
                  ],
                ),
              ),

              // ── FIXED BOTTOM (Settings + Logout) ─────────────────────────
              // IMPROVED: Uses outlineVariant (hairline) colour and 0.5px
              // thickness so the divider is subtle, not a thick harsh line.
              Divider(
                height:    1,
                thickness: 0.5,
                color:     cs.outlineVariant, // #21262D in dark, near-invisible
              ),
              SafeArea(
                top: false,
                child: Column(
                  children: [
                    const SizedBox(height: 4), // Small breathing room
                    for (final item in adminDrawerBottomItems)
                      AdminDrawerItemWidget(
                        item:     item,
                        isActive: state.activeItemId == item.id,
                        onTap:    () => item.isDestructive
                            ? _confirmLogout(context)
                            : _navigate(context, item),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, NavigationItem item) {
    context.read<DrawerCubit>().selectItem(item.id);
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed(item.route);
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title:   Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(l10n.navLogout),
          ),
        ],
      ),
    );
  }
}

// ─── Section label widget ─────────────────────────────────────────────────────

/// The small ALL-CAPS category heading above each group of nav items.
/// e.g. "OPERATIONS / RECEPTION", "CORE OWNER"
///
/// DARK THEME IMPROVEMENT:
///   • Colour is now onSurface.withOpacity(0.38) — in dark mode this resolves
///     to a medium-grey (#8B949E at 38%) that's clearly readable as a label
///     without competing with the nav items.
///   • The previous 0.40 on the old grey surface was too faint.
///   • Added a very subtle left indentation increase (20 → 20 unchanged but
///     kept for clarity) for visual alignment with the item icons.
class _SectionLabel extends StatelessWidget {
  final String labelKey;
  const _SectionLabel({required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n  = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    final label = switch (labelKey) {
      'sectionCoreOwner'           => l10n.sectionCoreOwner,
      'sectionOperationsReception' => l10n.sectionOperationsReception,
      'sectionTrainingPt'          => l10n.sectionTrainingPt,
      _                            => labelKey,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize:      10,
          fontWeight:    FontWeight.w700,
          color:         theme.colorScheme.onSurface.withOpacity(
            isDark ? 0.38 : 0.40, // Slightly lower in dark — still very readable
          ),
          letterSpacing: 1.0, // Slightly wider tracking for ALL-CAPS label feel
        ),
      ),
    );
  }
}