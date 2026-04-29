// lib/features/admin/navigation/presentation/widgets/admin_navigation_drawer.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../l10n/app_localizations.dart';

import '../../config/admin_drawer_config.dart';
import '../../config/navigation_item.dart';
import '../cubit/drawer_cubit.dart';
import '../cubit/drawer_state.dart';
import 'admin_drawer_header_widget.dart';
import 'admin_drawer_item_widget.dart';

/// The Admin Navigation Drawer — matches Figma design exactly.
///
/// Structure:
/// ┌──────────────────────────────┐
/// │  AdminDrawerHeaderWidget     │  ← Gym row + User card (primary bg)
/// ├──────────────────────────────┤
/// │  CORE OWNER          (label) │  ┐
/// │    Dashboard                 │  │
/// │    Members                   │  │
/// │    ...                       │  │ Scrollable
/// │  OPERATIONS / RECEPTION      │  │ ListView
/// │    Check-ins                 │  │
/// │    Payments                  │  │
/// │    ...                       │  │
/// │  TRAINING / PT               │  │
/// │    PT Sessions               │  │
/// │    Training Videos           │  ┘
/// ├──────────────────────────────┤
/// │  Settings                    │  ┐ Fixed bottom
/// │  Log Out            (red)    │  ┘
/// └──────────────────────────────┘
///
/// Usage:
/// ```dart
/// Scaffold(
///   drawer: AdminNavigationDrawer(
///     gymName: 'Build4All Gym',
///     branchName: 'Downtown',
///     adminName: 'Mounir',
///     adminEmail: 'mounir@gym.com',
///   ),
/// )
/// ```
class AdminNavigationDrawer extends StatelessWidget {
  final String gymName;
  final String branchName;
  final String adminName;
  final String adminEmail;
  final String? avatarUrl;

  const AdminNavigationDrawer({
    super.key,
    required this.gymName,
    required this.branchName,
    required this.adminName,
    required this.adminEmail,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DrawerCubit>(
      create: (_) => DrawerCubit(),
      child: _DrawerBody(
        gymName: gymName,
        branchName: branchName,
        adminName: adminName,
        adminEmail: adminEmail,
        avatarUrl: avatarUrl,
      ),
    );
  }
}

// ─── Internal body — separate widget so BlocBuilder can access DrawerCubit ───

class _DrawerBody extends StatelessWidget {
  final String gymName;
  final String branchName;
  final String adminName;
  final String adminEmail;
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
    final theme = Theme.of(context);

    return Drawer(
      width: 255,
      backgroundColor: theme.colorScheme.surface,
      // Remove default Material elevation shadow — matches the flat design
      elevation: 8,
      child: BlocBuilder<DrawerCubit, DrawerState>(
        builder: (context, state) {
          return Column(
            children: [
              // ── HEADER ────────────────────────────────────────────────
              AdminDrawerHeaderWidget(
                gymName: gymName,
                branchName: branchName,
                adminName: adminName,
                adminEmail: adminEmail,
                avatarUrl: avatarUrl,
                onClose: () => Navigator.of(context).pop(),
                onProfileTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/admin/settings');
                },
              ),

              // ── SCROLLABLE NAV SECTIONS ───────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  children: [
                    for (final section in adminDrawerSections) ...[
                      // Section label (e.g. "CORE OWNER")
                      if (section.labelKey != null)
                        _SectionLabel(labelKey: section.labelKey!),

                      // Section items
                      for (final item in section.items)
                        AdminDrawerItemWidget(
                          item: item,
                          isActive: state.activeItemId == item.id,
                          onTap: () => _navigate(context, item),
                        ),
                    ],
                  ],
                ),
              ),

              // ── FIXED BOTTOM (Settings + Logout) ─────────────────────
              const Divider(height: 1, thickness: 1),
              for (final item in adminDrawerBottomItems)
                AdminDrawerItemWidget(
                  item: item,
                  isActive: state.activeItemId == item.id,
                  onTap: () => item.isDestructive
                      ? _confirmLogout(context)
                      : _navigate(context, item),
                ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, NavigationItem item) {
    context.read<DrawerCubit>().selectItem(item.id);
    Navigator.of(context).pop(); // close drawer
    Navigator.of(context).pushReplacementNamed(item.route);
  }

  void _confirmLogout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Navigator.of(context).pop(); // close drawer first

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.general_cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // TODO: context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (_) => false);
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

class _SectionLabel extends StatelessWidget {
  final String labelKey;

  const _SectionLabel({required this.labelKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      // Top padding larger to separate from previous section
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Text(
        _resolveLabel(l10n, labelKey),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.40),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  String _resolveLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'sectionCoreOwner':             return l10n.sectionCoreOwner;
      case 'sectionOperationsReception':   return l10n.sectionOperationsReception;
      case 'sectionTrainingPt':            return l10n.sectionTrainingPt;
      default:                             return key;
    }
  }
}